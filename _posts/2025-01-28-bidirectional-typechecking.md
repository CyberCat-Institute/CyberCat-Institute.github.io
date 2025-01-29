---
layout: post
title: "Bidirectional Typechecking is Bidirectional"
author: Jules Hedges
date: 2025-01-28
categories:
usemathjax: true
excerpt: "For a while I've had an intuition that typechecking should be optical, with subterms going forwards and types (and type errors) for subterms going backwards. In this post I'll make sense of this idea, by implementing a bidirectional typechecker for simply typed lambda calculus as an optic, using Haskell's Control.Lens."
---

For a while I've had an intuition that typechecking should be optical, with subterms going forwards and types (and type errors) for subterms going backwards. In this post I'll make sense of this idea, by implementing a bidirectional typechecker for simply typed lambda calculus as an optic, using Haskell's `Control.Lens`.

There is basically nothing here that is specialised to typechecking, bidirectional or otherwise, it is merely a neat and well-specified example of a tree search problem and makes for a funny title. This is a hammer I've been weighing up for quite a long time for a wide variety of applications. One fun thing I want to work out as a proof of concept is scripting NPC AI for videogames, or as I put it for the meme, "Metal Gear Solid is lenses" (stealth games being an example where the AI behaving realistically is more important than usual).

## Bidirectionally typed STLC

The starting point of bidirectional typechecking is to partition the terms of the language into two classes, the *synthesisable* terms (whose type can be algorithmically inferred) and *checkable* terms (whose type can be algorithmically checked). In STLC, a term that is a variable $x$ is synthesisable, an application $tu$ is synthesisable when $t$ is synthesisable and $u$ is checkable, and an abstraction $\lambda x . t$ is checkable when $t$ is checkable (note that the abstracted variable $x$ does not carry a type annotation, unlike in some presentations of STLC). Also, any synthesisable term can be considered as checkable, and any checkable term can be considered as synthesisable if paired with a type annotation.

In Haskell this is nothing fancy:

```haskell
data Type = TVar String | Unit | Function Type Type
  deriving (Eq, Show)

data TermSyn = Var String | App TermSyn TermChk | Down Type TermChk
  deriving (Show)

data TermChk = Lambda String TermChk | Up TermSyn
  deriving (Show)
```

Let's write the rules of bidirectional STLC in traditional programming languages notation. If $t$ is a synthesisable term and synthesising its type returns the result $a$ then we write $t \in a$. If $t$ is a checkable term and we successfully check that $t$ has type $a$ then we write $a \ni t$. (The symbol $\ni$ is pronounced "ni", and also written that way in LaTeX/MathJax, hence the paper [The Types Who Say Ni](https://github.com/pigworker/TypesWhoSayNi/blob/master/tex/TypesWhoSayNi.pdf) by Conor Mc Bride.) We also say "the type $a$ accepts the term $t$".

$\frac{}{\displaystyle \Gamma, x : a \vdash x \in a}\text{(Var)}$

- To synthesise the type of a variable $x$ we simply look it up in the context and return what the context says its type is

$\frac{\displaystyle \Gamma \vdash t \in a \to b \qquad \Gamma \vdash a \ni u}{\displaystyle \Gamma \vdash tu \in b}\text{(App)}$

- To synthesise the type of an application $tu$, we synthesise the type of $t$, find that the result is a function type $a \to b$, check that $u$ has type $a$, and return $b$

$\frac{\displaystyle \Gamma, x : a \vdash b \ni t}{\displaystyle \Gamma \vdash a \to b \ni \lambda x . t}\text{(Lam)}$

- To check that $\lambda x . t$ has type $a \to b$, we check that $t$ has type $b$ after extending the context with $x : a$

$\frac{\displaystyle \Gamma \vdash a \ni t}{\displaystyle \Gamma \vdash \downarrow t : a \in a}\text{(Down)}$

- To synthesise the type of a coerced checkable term $t$ paired with a type annotation $a$, we check that $t$ has type $a$, then return $a$

$\frac{\displaystyle \Gamma \vdash t \in b \qquad a = b}{\displaystyle \Gamma \vdash a \ni \uparrow t}\text{(Up)}$

- To check that a coerced synthesisable term $t$ has type $a$, we synthesise the type of $t$ and make sure that the result is equal to $a$

## Questions and answers

To arrange all of this into an optic, we need to go back to one of the earliest ideas for using lens-like things in strange ways, in [this classic paper by Blass](https://arxiv.org/abs/math/9309208), which is to have a boundary made of questions and answers. We ask an optic a question, it can in turn ask questions on its opposite boundary, it receives answers, and then finally it answers to us. The questions we can ask here are "what is the type of this synthesisable term?" and "does this checkable term have this type?":

```haskell
type Context = [(String, Type)]

data Question = Synthesise Context TermSyn | Check Context Type TermChk
  deriving (Show)

data Answer = Synthesised Type | Checked | TypeError
  deriving (Show)
```

For now I have here chosen that "type error" carries no additional information, but the question of how best to handle the sad path is one we'll come back to later because it creates a tension between theory and implementation.

Here is an example of how such a "question-and-answer protocol" is implemented using a functor lens in Haskell, illustrated using the (Lam) rule:

```haskell
lam :: forall f. (Functor f) => (Question -> f Answer) -> Question -> f Answer
lam k (Check ctx (Function a b) (Lambda x t)) = k (Check ((x, a) : ctx) b t)
```

I find the CPS-like van Laarhoven representation helpful here (for once!) by reflecting the protocol directly. We ask the lens the question `Check ctx (Function a b) (Lambda x t)`, it asks its continuation the question `Check ((x, a) : ctx) b t`, it gets back the answer, and then it returns the answer to us unchanged.

There is a very obscure but very useful bit of intuition that I learned from Bob Atkey in [this seminar](https://www.youtube.com/watch?v=YpklMn5yNA0), which is that superclasses of Lens differ in the quantity that they have access to their continuation. A lens must call its continuation exactly once, an affine traversal can call its continuation at most once, and a traversal can call its continuation any finite number of times. In the van Laarhoven encoding, a lens must call its continuation at least once because there is no other way to get a value in the unknown functor `f`, and there is also no way to combine the result of two different calls so it can only return one of them. For affine traversals we use pointed functors, which allow us to get into the functor without calling the continuation but still do not allow us to combine the result from two different calls. For traversals we use applicatives, which do both.

All this is to say, I *expected* the (App) rule, which has 2 hypotheses, to be a Traversal, ie. something with type

```haskell
app :: forall f. (Applicative f) => (Question -> f Answer) -> Question -> f Answer
```

But when I came to write it, I reached an unexpected subtlety. Traversals can call their continuation any number of times, but those calls must be *independent*. The (App) rule, which must answer the question "what is the type of $tu$?", first asks the question "what is the type of $t$?", and then upon receiving the answer "$a$", it asks the followup question "does $u$ have type $a$?". That is, the second question depends on the first answer, and this is something that is not possible with a Traversal.

## Monadic traversals

The type signature needed to express the (App) rule is something that, at first sight, looks like an extremely obvious superclass of Traversals:

```haskell
app :: forall f. (Monad f) => (Question -> f Answer) -> Question -> f Answer
app k (Synthesise ctx (App t u)) = do
  Synthesised (Function a b) <- k (Synthesise ctx t)
  Checked <- k (Check ctx a u)
  return (Synthesised b)
```

The appearance of `a` on the second line of the `do` block is exactly the thing that can't be done with an Applicative.

This class of optics apparently has no name, although I few people have suggested the idea. I already use the terms "monadic lens" and "monadic optic" already (respectively for [lenses whose backward pass is in a kleisli category](https://www.cs.ox.ac.uk/jeremy.gibbons/publications/mlenses.pdf) and [monoidal optics entirely in a kleisli category](https://compositionality.episciences.org/13528)) - I like Zanzi's suggestion to call this a *monadic traversal*. [Apparently there are no nontrivial examples of lawful monadic traversals](https://www.reddit.com/r/haskell/comments/cak4kh/missing_lenslike_type_alias/)[^1], that is to say, every monadic traversal satisfying the traversal laws is already an ordinary traversal. Fortunately, my entire career has been spent spitting in the face of the optic laws. More to the point, I'm fairly sure these question-and-answer optics can *never* be meaningfully lawful even in the most generalised sense, because an answer does not determine a canonical followup question, but they are still extremely important for many applications.

[^1]: Thanks to [@effectfully on twitter](https://x.com/effectfully/status/1878963740525162556) for this link

I conjecture that the optic

```haskell
type MonadicTraversal s t a b = forall f. (Monad f) => (a -> f b) -> s -> f t
```

is isomorphic to this concrete implementation:

```haskell
type MonadicTraversal s t a b = s -> Interaction a b t

data Interaction a b t = Done t
                       | More a (b -> Interaction a b t)
```

An `Interaction a b t` can either terminate with an answer of type `t`, or it can ask a question of type `a`, and for each answer (of type `b`) it has a "continuation interaction". This is the equivalent for monadic traversals of what for ordinary traversals is called a [FunList](https://twanvl.nl/blog/haskell/non-regular1) (also known as a Bazaar in its functor encoding).

## Putting it together

With all this setup, here is the full implementation of a typechecker as a monadic traversal:

```haskell
rules :: MonadicTraversal Question Answer Question Answer
rules _ (Synthesise ctx (Var x)) = case lookup x ctx of
    Just a -> return (Synthesised a)
    Nothing -> return TypeError
rules k (Synthesise ctx (App t1 t2)) = k (Synthesise ctx t1) >>= \case
    Synthesised (Function a b) -> k (Check ctx a t2) >>= \case
        Checked -> return (Synthesised b)
        _ -> return TypeError
    _ -> return TypeError
rules k (Synthesise ctx (Down a t)) = k (Check ctx a t) >>= \case
    Checked -> return (Synthesised a)
    _ -> return TypeError
rules k (Check ctx (Function a b) (Lambda x t)) = k (Check ((x, a) : ctx) b t)
rules _ (Check _ _ (Lambda _ _)) = return TypeError
rules k (Check ctx a (Up t)) = k (Synthesise ctx t) >>= \case
    Synthesised b -> if a == b then return Checked else return TypeError
    _ -> return TypeError
```

This optic implements typechecking provided it is post-composed with another optic that implements typechecking for subterms. Any actual lambda term has subterms nested finitely but arbitrarily deep, so what we need to do is to compose this optic with itself and take a fixpoint, remembering that van Laarhoven encoded optics compose by reverse function composition:

```haskell
stlc :: MonadicTraversal Question Answer Question Answer
stlc = rules . stlc
```

Personally I find this infinite composition chain surprisingly similar to the way we implemented [Bellman iteration as optic composition](https://cgi.cse.unsw.edu.au/~eptcs/paper.cgi?ACT2022.24).

Now we can write a typechecker by calling this lenses using standard `Control.Lens` combinators:

```haskell
typecheck :: Question -> Answer
typecheck q = q & stlc .~ TypeError
```

And this works! Here is what it looks like running on the lambda term $(\lambda y . y) x$ in the context $x : a$:

```haskell
ghci> typecheck $ Synthesise [("x", TVar "a")] 
                $ App (Down (Function (TVar "a") (TVar "a")) (Lambda "y" (Up (Var "y")))) 
                      (Up (Var "x"))
Synthesised (TVar "a")
```

The backward input `TypeError` in the function `typecheck`, which comes at the end of the infinite composition chain, is never actually used: we only go as far down the chain as the subterm depth of our lambda term before returning. It can be changed to `undefined` and everything still works correctly. This is almost exactly what happens with Bellman iteration with lenses, where the backward input is an arbitrary real number that gets infinitely discounted to zero.

## Handling the sad path

In theory we are done, but in practice we are handling type errors in a very bad way: about half of the implementation is handling type errors, and despite this we are still collapsing all type errors to a single value instead of returning any useful information to the caller.

Just for fun, here is an idea I had that fixes the first problem while ignoring the second, by heavily abusing how Haskell desugars do-notation. There is a class in Prelude called `MonadFail` that exists for legacy reasons, and adds to the monad signature a function `fail :: String -> m a`. When Haskell encounters certain syntactic forms of possibly-failing pattern match in a `do`-block, it desugars it to `MonadFail`, filling the string with information about the failed match. 

Any reader who was unhappy about monadic traversals should probably skip the next block of code, because I am about to deploy an optic for `MonadFail`. It's fair to say that this is one of the more horrifying things I have ever done in Haskell.

The caveat is that this "feature" appears to be only half finished, or maybe more likely has only been half removed: pattern matches on the left of a `<-` desugar to `fail`, but pattern matches in a `let` form instead desugar to `Prelude.error`. So we have to transform `let x = y` into `x <- return y` for this to work.

```haskell
rules :: forall f. (MonadFail f) => (Question -> f Answer) -> Question -> f Answer
rules _ (Synthesise ctx (Var x)) = do
    Just a <- return (lookup x ctx) 
    return (Synthesised a)
rules k (Synthesise ctx (App t u)) = do
    Synthesised (Function a b) <- k (Synthesise ctx t)
    Checked <- k (Check ctx a u)
    return (Synthesised b)
rules k (Synthesise ctx (Down a t)) = do
    Checked <- k (Check ctx a t)
    return (Synthesised a)
rules k (Check ctx a (Lambda x t)) = do
    Function b c <- return a
    k (Check ((x, b) : ctx) c t)
rules k (Check ctx a (Up t)) = do
    Synthesised b <- k (Synthesise ctx t)
    if a == b then return Checked 
              else fail $ unwords ["Could not match", show a, "and", show b]

stlc :: forall f. (MonadFail f) => (Question -> f Answer) -> Question -> f Answer
stlc = rules . stlc

typecheck :: Question -> Maybe Answer
typecheck = stlc (const Nothing)
```

The last part of this is using the fact that `Maybe` has a builtin instance of `MonadFail` (which ignores the error string).

Back in the world of actual engineering instead of memeing, my best idea for the right way to deal with the unhappy path is to define a `TypeError` type, which can be as informative as we want, and use an optic for [the class](https://hackage.haskell.org/package/mtl-2.3.1/docs/Control-Monad-Except.html) `Control.Monad.Except.MonadError TypeError` from `mtl`. And, obviously, we do the work of explicitly detecting and throwing informative type errors instead of the preceeding silliness. I haven't actually built it because I'm not entirely convinced that optics for a class from `mtl` is *actually* a good idea, but so far I do not have any better ideas.

## Pipelines

Recently [André wrote a post about compiler pipelines](https://cybercat.institute/2025/01/13/program-pipelines.idr/), and is working on a followup post doing the same thing with lenses. For example, typechecking is one stage of a compiler pipeline that is preceeded by scopechecking and is followed by code generation.

What I have done in this post throws a spanner into that, because I am using optics that are infinite composition chains that never actually reach their codomain boundary, so it doesn't make sense to compose them end-to-end.

My gut feeling is that there should be some (asymmetric) monoidal product on traversals that is the one true way of sequencing things defined in this way. But I haven't found it yet, so instead I'm going to show something that works but I don't think is *right*.

Suppose as well as typechecking we have another monadic traversal of this type:

```haskell
data ScopeCheckQuestion = ScopeCheckQuestion
data ScopeCheckAnswer = WellScoped | ScopeError

scopecheck :: MonadicTraversal ScopeCheckQuestion ScopeCheckAnswer 
                               ScopeCheckQuestion ScopeCheckAnswer
```

We need to take the coproduct of the scopechecking and typechecking traversals. Coproducts of optics require dependent types to write correctly, but here is the closest we can get in Haskell, with possibly-failing pattern matches that the type is unable to rule out:

```haskell
plus :: (Functor f)
     => ((a -> f b) -> s -> f t) -> ((a' -> f b') -> s' -> f t')
     -> (Either a a' -> f (Either b b') -> Either s s' -> f (Either t t'))
plus l _ k (Left s) = Left <$> l (\a -> fmap (\(Left s) -> s) (k (Left a))) s
plus _ l' k (Right s') = Right <$> l' (\a' -> fmap (\(Right s') -> s') (k (Right a'))) s' 
```

Now we can precompose this with a monadic traversal that calls the two parts in the right order:

```haskell
data OverallAnswer = ScopeError' | TypeError' | Type Type

pipeline :: MonadicTraversal (Context, TermSyn) 
                             OverallAnswer
                             (Either ScopeCheckQuestion Question) 
                             (Either ScopeCheckAnswer Answer)
pipeline k (ctx, t) = k (Left ScopeCheckQuestion) >>= \case
  Left ScopeError -> return ScopeError'
  Left WellScoped -> k (Right (Synthesise ctx t)) >>= \case
    Right TypeError -> return TypeError'
    Right (Synthesised a) -> return (Type a)
```

I'm not quite happy with this, even after putting the missing dependent types back in, but it does work. I'm going to leave it for the future to find a more canonical way to sequence pipeline steps.
