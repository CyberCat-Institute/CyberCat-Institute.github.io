---
layout: post
title:  "A lens on Nash equilibria"
author: Jules Hedges
categories: 
excerpt: 
usemathjax: true
thanks: Zanzi, Dan Marsden, Eitan Chatav
---

## Introduction

[hook]

Compositional game theory [^cgt] is, as its name suggests, a compositional language for specifying games in the sense of game theory. The topic has been interconnected with functional programming from the very beginning, with a Haskell prototype providing a combinator language for sequential and parallel composition of open games predating even the first mathematical definition [^sdgt]. However the "modern" Haskell implementation of open games, known as the Open Game Engine [^oge], implements a deeply-embedded domain specific language with a verbose name-binding syntax loosely based on arrow notation [^arrows], implemented via Template Haskell macros.

[^cgt]: [Neil Ghani, Jules Hedges, Viktor Winschel & Philipp Zahn. Compositional game theory. Proceedings of LiCS 2018](https://arxiv.org/abs/1603.04641)

[^sdgt]: [Jules Hedges. String diagrams for game theory: a (very) preliminary report. Unpublished manuscript, 2015](https://www.cs.ox.ac.uk/people/julian.hedges/misc/pregames.pdf)

[^oge]: [Jules Hedges, André Videla & Philipp Zahn. The Open Game Engine](https://github.com/CyberCat-Institute/open-game-engine)

[^arrows]: [Ross Paterson. A new notation for arrows. ICFP 2001](https://www.staff.city.ac.uk/~ross/papers/notation.html)

The connection between open games and *lenses*, first suggested out by Jeremy Gibbons, turned out to be an idea that goes deeper and deeper [^mog], [^tfcc], [^bog]. Eventually, Capucci succeeded at presenting compositional game theory using *only* the category-theoretic structure of lenses [^dog]. This paper is a follow-up to Capucci's, presenting the same structure in a slightly different way and focussing on programming rather than mathematics.

[^mog]: [Jules Hedges. Morphisms of open games. Proceedings of MFPS 2018](https://arxiv.org/abs/1711.07059)

[^tfcc]: [Matteo Capucci, Bruno Gavranović, Jules Hedges & Eigil Rischel. Towards foundations of categorical cybernetics. Proceedings of ACT 2021](https://arxiv.org/abs/2105.06332)

[^bog]: [Joe Bolt, Jules Hedges & Philipp Zahn. Bayesian open games. Compositionality, 2023](https://compositionality-journal.org/papers/compositionality-5-9/)

[^dog]: [Matteo Capucci. Diegetic representation of feedback in open games. Proceedings of ACT 2022](https://arxiv.org/abs/2206.12338)

## Backward types

Lenses have 4 legs - that is, 4 type parameters `Lens s t a b` - but they are *really* morphisms in a category from the domain `(s, t)` to the codomain `(a, b)`. It is quite ergonomic to package up a pair of types into a single type, especially later when we define the linearity monad which operates explicitly on pairs of types.

The material in the following sections on lenses could be presented in a more standard way, but we will *eventually* need to use pair types when we come to defining the linearity monad (which operates explictly on pairs), and the story flows better if we use the same style consistently.

We introduce an open type family used to extract the backwards part of a type:

```haskell
type family Reverse x
```

The basic idea is that we wrap all values in a box that carries around its "backward type" as a phantom.

```haskell
data t <| s = A s deriving (Functor)

type (|>) s t = t <| s

type instance Reverse (s |> t) = t
```

We ask that `Reverse` is compatible with products:

```haskell
type instance Reverse () = ()
type instance Reverse (s, s') = (Reverse s, Reverse s')
```

Thanks to this, `(s |> t, s' |> t')` behaves the same as `(s, s') |> (t, t')`: both are isomorphic to `(s, s')` and carry the phantom `(t, t')`. This means that we have tricked Haskell tuples into behaving like the *tensor product* of objects in the category of lenses, which is pairwise product.

It was temping to do this in an equivalent way, by defining a "backward box" that is entirely phantom:

```haskell
data X t = X

type instance Reverse (X t) = t
```

The idea is that the value `X` is the "shadow" as seen from the forwards pass of a value in the backwards pass. Unfortunately, the type `(s, X t)` does not behave like `s |> t` unless we either wrap `s` in a box indicating that it is a forwards value, or use a unification constraint like `(Reverse s ~ ())`. Overall, this works out to be less ergonomic than using `s |> t`.

## A warm-up with linear lenses

Consider a standard definition of linear lenses:

```haskell
type Lens s t a b = s -> (a, b -> t)
```

We can consider this as function that returns the result of the forward pass paired with a *delimited continuation*. It is useful to isolate this as a definition in its own right:

```haskell
type Value a b t = (a, b -> t)

type Lens s t a b = s -> Value a b t
```

The realisation is that *these Values are to lenses as (ordinary) values are to functions*. A more vivid (but questionable) conception is that they are *dialectical strategies*: a pair of a *thesis* and a way of turning any *antithesis* into a *synthesis*. Compare [hegel], [dialectica interpretation], [game semantics of game theory].

We can apply a lens to an input value to produce an output value:

```haskell
(<~) :: Lens s t a b -> Value s t r -> Value a b r
l <~ (s, k) = let (a, k') = l s
               in (a, k . k')
```
[TODO - write this in reverse order to match what happens for vL + monad bind]

This behaves a bit like the bind of a monad, with the corresponding unit:

```haskell
value :: s -> Value s r r
value s = (s, id)
```

(It might be instructive to notice that `s` is isomorphic to `Lens () () s r`.)

This allows us to program with lenses in a name-binding style. For example, sequential composition of lenses can be written like this:

```haskell
(>>>) :: Lens s t a b -> Lens a b o p -> Lens s t o p
(l >>> m) s = let a = l s
               in m <~ a
```
[TODO - come up with a better example]

Of course, writing linear chains of lens compositions point-free is easy. This nominal style comes into its own when we want to split and merge the computation, something that is ubiquitous in compositional game theory. Actually doing it is easier said than done, because a continuation on pairs can't be obviously split into a pair of continuations. Here is a useful way of doing it:

```haskell
unpair :: Value (s, s') (t, t') r -> (Value s t (t' -> r), Value s' t' t')
unpair ((s, s'), k) = ((s, curry k), (s', id))
```

This results in a pair of values which are *entangled* through their continuations. They must eventually be reunited, threading their continuations back together:

[TODO]

## Making lenses less pointless

Of the many isomorphic ways of writing the definition of lenses, some admit the trick from the preceeding section and others do not. The important thing is that a value of type `Lens s t a b` is a *function* from `s` to something. Here are several isomorphic types and whether they can be made less pointless:

- "Concrete": `Lens s t a b = (s -> a, s -> b -> t)` - no
- "Linear": `Lens s t a b = s -> (a, b -> t)` - yes
- "Existential": `Lens s t a b = exists m. (s -> (m, a), m -> b -> t)` - No
- "van Laarhoven": `Lens s t a b = forall f. (Functor f) => (a -> f b) -> s -> f t` - No
- "Transposed van Laarhoven": `Lens s t a b = forall f. (Functor f) => s -> (a -> f b) -> f t` - Yes, provided we are in a language like Haskell with implicit dictionary passing
- "Profunctor": `Lens s t a b = forall p. (Profunctor p, Strong p) => p a b -> p s t` - No

By passing from the van Laarhoven to transposed van Laarhoven encoding, we lose the neat party trick that lens composition is reverse function composition, but we gain the ability to program with names.

An important part of lens-fu (the art of messing with the internals of the `Control.Lens` library) is knowing when the functor should be quantified and when it should be carried around as a parameter. The actual definition of lenses is split into two parts to allow this:

```haskell
type LensLike f s t a b = (a -> f b) -> s -> f t

type Lens s t a b = forall f. (Functor f) => LensLike f s t a b
```

Inspired by this, we split the definition of values into two parts:

```haskell
type ValueLike f a b t = (a -> f b) -> f t

type Value a b t = forall f. (Functor f) => ValueLike f a b t
```

This gives us a new party trick: function composition now binds a value to a lens:

```haskell
(.) :: Value s t r -> Lens s t a b -> Value a b r
```

The corresponding unit operator is:

```haskell
value :: s -> Value s t t
value s k = k s
```

The implementation of unpairing and repairing is quite a puzzle in this encoding. Let's begin with repairing. Its implementation is very similar to the tensor product of lenses, which is called `alongside` in `Control.Lens`. The implementation of both relies on a couple of functor transformers that are exported by `Control.Lens.Internal.Getter`:

```haskell
newtype AlongsideLeft f b a = AlongsideLeft {getAlongsideLeft :: f (a, b)} deriving (Functor)

newtype AlongsideRight f a b = AlongsideRight {getAlongsideRight :: f (a, b)} deriving (Functor)
```

The definition of the repairing operator can now be written:

```haskell
(/\) :: ValueLike (AlongsideLeft f b') a b t 
     -> ValueLike (AlongsideRight f t) a' b' t' 
     -> ValueLike f (a, a') (b, b') (t, t')
(l /\ m) k = getAlongsideRight (m (\a' -> AlongsideRight 
             (getAlongsideLeft (l (\a -> AlongsideLeft (k (a, a')))))))
```

The idea of these functor transformers is that in a couple of places we have a value in scope that we don't need right now, and the transformers allow us to *stash* it inside the functor so that we can retrieve it later when we actually need it. Here we also see an instance of lens-fu: we used `ValueLike` rather than `Value` in order to be explicit about exactly how we are transforming the functor.

At this point we can already write some interesting programs:

[TODO]

Now we come to unpairing. Recall the type we used for linear lenses:

```haskell
unpair :: Value (s, s') (t, t') r -> (Value s t (t' -> r), Value s' t' t')
unpair ((s, s'), k) = ((s, curry k), (s', id))
```

In order to change the outcome type from `r` to either `t' -> r` or `t'` we need two more functor transformers, `Cayley` and `Const`, which play a role dual to `AlongsideLeft` and `AlongsideRight`. The definition of `Cayley` is [TODO references] but is currently missing from standard libraries such as `Data.Functor` and `Control.Lens`: [^kmett]

[^kmett]: At the time of writing the definition has appeared in Kmett's most recent version of `Data.Profunctor` at [https://github.com/ekmett/profunctors/blob/main/src/Data/Profunctor/Cayley.hs], using the `deriving stock instance` mechanism to specialise from profunctors to functors.

```haskell
data Cayley f s x = Cayley {runCayley :: f (s -> x)} deriving (Functor)
```

With this, we can implement the first and second projections from a pair value separately by changing the functor in different ways:

```haskell
first :: (Functor f) => ValueLike (Cayley f t') (s, s') (t, t') r
                     -> ValueLike f s t (t' -> r)
first v k = runCayley (v (\(Forward (x, _)) -> Cayley (fmap (,) (k (Forward x)))))
-- todo get rid of the "forward"

second :: (Functor f) => ValueLike (Const s') (s, s') (t, t') r
                      -> ValueLike f s' t' t'
second v k = k (getConst (v (\(Forward (_, y)) -> Const (Forward y))))
```

Putting them together is extremely nontrivial, requiring both quantifying over functors and switching on `ImpredicativeTypes`:

```haskell
unpair :: Value (s, s') (t, t') r -> (Value s t (t' -> r), Value s' t' t')
unpair v = (first v, second v)
```haskell

## The linearity monad

There is an adjunction between the category of lenses and the category of *adaptors*:

[TODO]

The right adjoint is a forgetful functor, embedding the category of adaptors into the category of lenses as an identity-on-objects functor: given a function `s -> a` and a function `b -> t` we can build a `Lens s t a b` whose backwards pass is constant in its `s` input.

The left adjoint is more interesting: it takes the pair of types `(s, t)` to `(s, s -> t)`. A `Lens s t a b` is exactly a morphism `(s, s -> t) -> (a, b)` in the category of adaptors: the forwards pass is already a function `s -> a` and the backwards pass can be curried to `b -> s -> t`.

The round-trip on the right is a comonad on the category of adaptors, taking the pair `(s, t)` to `(s, s -> t)`. This is well known as the interpretation of the linear logic exponential `!` of a dialectica category, thus it is a *nonlinearity comonad*. Specifically, the adjunction between lenses and adaptors into an example of a *Seely category* - a linear-nonlinear adjunction that is the kleisli resolution of its comonad. [TODO check + ref]

Meanwhile, the round-trip on the left is a monad on the category of lenses, also defined on objects by taking the pair `(s, t)` to `(s, s -> t)`. Dual to the linear logic exponential, it is a *linearity monad* (but should not be confused with the `?` operator, which is the *de Morgan* dual of `!`). We are going to work explicitly with this monad.

In order to encode the definition, we introduce a new box that keeps the forward type the same but modifies the backward type:

```haskell
data I x = I x deriving (Functor)

type instance Reverse (I x) = x -> Reverse x
```

The unit and kleisli extension of the `I` monad are given by:

```haskell
-- TODO check these are correct
returnI :: x ~> I x
returnI k x = fmap ($ x) (k (I x))

extendI :: (x ~> I y) -> (I x ~> I y)
extendI l k (I x) = fmap const (l k x)
```

It will also turn out to be convenient to have a version of the functor instance for `I` specialised to lifting plain functions, to lenses that are constant in the backwards pass - this will be used for writing payoff functions, loss functions etc.

```haskell
liftI :: (x -> y) -> I (x |> r) ~> I (y |> r)
liftI f k x = fmap (. fmap f) (k (fmap (fmap f) x))
-- TODO Zanzi's idea: show this in a language with implicit boxing, ie.
-- liftI f k x = fmap (. f) (k (f x))
```

The central idea of [diegetic open games] is the definition of `I` as a lax monoidal functor, and the recognition of its central importance. The laxator of `I` is called the Nashator [davidad], and it is a lens:

```haskell
nashator :: (I x, I y) ~> I (x, y)
nashator k (I x, I y) = fmap h (k (I (x, y)))
  where h f = (\x' -> fst (f (x', y)), \y' -> snd (f (x, y')))
```

[talk about the nashator]

In order to program ergonomically, we need to redefine the Nashator to operate on named values. The result is an operator that combines the Nashator and the repairing operator `(/\)` into one:

```haskell
(#) :: (Functor f) => ValueLike (AlongsideLeft f s) (I (x |> r)) (s -> t)
                   -> ValueLike (AlongsideRight f ((x |> r) -> r)) (I (y |> r)) s
                   -> ValueLike f (I ((x, y) |> r)) t
(v # w) k = fmap (uncurry ($)) (getAlongsideLeft (v (\(I (A x)) -> AlongsideLeft
  (getAlongsideRight (w (\(I (A y)) -> AlongsideRight
    (fmap (\f -> (\(A x') -> f (A (x', y)), \(A y') -> f (A (x, y'))))
      (k (I (A (x, y)))))))))))
```

