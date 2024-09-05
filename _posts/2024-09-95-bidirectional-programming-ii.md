---
layout: post
title: "Foundations of Bidirectional Programming II: Negative Types"
author: Jules Hedges
date: 2024-09-05
categories: [programming languages]
usemathjax : true
excerpt: In this post we'll begin designing a kernel language in which all programs are optics. What I mean by a "kernel language" is that it will serve as a compiler intermediate representation, with a surface language compiling down to it. I intend the surface language to be imperative style like the current Open Game Engine (with an approximately Python-like syntax), but the kernel language will reflect the category theory as closely as possible. I plan the kernel language to be well typed by construction, something that seems like overkill until I think about the problem of figuring out how pattern matching should work in a bidirectional language.
---

See [part I](https://cybercat.institute/2024/08/26/bidirectional-programming-i/) of this series

In this post we'll begin designing a kernel language in which all programs are optics. What I mean by a "kernel language" is that it will serve as a compiler intermediate representation, with a surface language compiling down to it. I intend the surface language to be imperative style like the current Open Game Engine (with an approximately Python-like syntax), but the kernel language will reflect the category theory as closely as possible. I plan the kernel language to be well typed by construction, something that seems like overkill until I think about the problem of figuring out how pattern matching should work in a bidirectional language.

My first design choice is that *object language types denote pairs of metalanguage types*, with one denoting the forward part (sometimes I might call it the *covariant denotation*) and the other denoting the backward part (the *contravariant denotation*).

```haskell
Cov : Ty -> Type
Con : Ty -> Type
```

The interpretation of a term will be a lens:
```haskell
eval : Term xs y -> All Cov xs -> (Cov y, Con y -> All Con xs)
```
Here `All` is an Idris standard library function that combines a type-level map with cartesian product:
```haskell
data All : (a -> Type) -> List a -> Type where
  Nil : All p []
  (::) : p x -> All p xs -> All p (x :: xs)
```
(Idris has what in Haskell would be called rebindable syntax switched on by default, so we can use the usual syntactic sugar for lists to refer to elements of `All`.)

`eval` is a *well typed interpreter*, and is a placeholder while we prototype: much later, this is where the backend of the compiler will begin.

## The logic of lenses

My second design choice is that I want the basic product former to be interpreted as the *tensor product* of lenses, which is pairwise cartesian product on the covariant and contravariant parts. This is an uncontroversial choice, but importantly this product is symmetric monoidal but not cartesian, so it means that we are designing some kind of *linear type theory*.

My third design choice is that I want negation to be interpreted as swapping the covariant and contravariant parts. This sounds uncontroversial at first - many well known semantic categories do the same thing - until we notice that it is not functorial. That is to say, if we have a lens $(X, X') \to (Y, Y')$ then in general we can't make a lens between $(X', X)$ and $(Y', Y)$ in either direction. Years ago I wrote a paper called [Coherence for lenses and open games](https://arxiv.org/abs/1704.02230) in which this non-functorial pair swapping featured heavily, and I still stake everything on the claim that it is the right way to go.

At this point we have enough to build a term language and its interpretation. I will add a single ground type which will be interpreted as purely covariant.

```haskell
data Ty : Type where
  Unit : Ty
  Ground : Ty
  Not : Ty -> Ty
  Tensor : Ty -> Ty -> Ty

mutual
  Cov : Ty -> Type
  Cov Unit = Unit
  Cov Ground = Nat
  Cov (Not x) = Con x
  Cov (Tensor x y) = (Cov x, Cov y)

  Con : Ty -> Type
  Con Unit = Unit
  Con Ground = Unit
  Con (Not x) = Cov x
  Con (Tensor x y) = (Con x, Con y)
```

Let's think through the consequences of these choices. We think of `Tensor` as linear conjunction, so its neutral element `Unit` is linear truth. The interpretation of `Unit` is the pair $(1, 1)$, and so `Not Unit` - which we would think of as linear falsity - has the same interpretation. So we have a linear logic where falsity and truth coincide semantically. Similarly, the de Morgan dual of `Tensor`, which we would call linear disjunction, coincides with it semantically. So we have an inconsistent interpretation of linear logic. This is nowhere near as bad as it sounds, since many reasonable semantic categories do the same, but we need to keep it in mind.

Since `Tensor` is a perfectly cromulent symmetric monoidal product, its introduction and elimination rules will be exactly the same as the ones in my [previous post](https://cybercat.institute/2024/08/26/bidirectional-programming-i/). But the negation rules are going to be quite a puzzle.

Our interpretation of negation is strictly involutive - swapping twice is a no-op - something we can call a *classical* linear negation. This means our semantics validates the principles of double negation introduction and double negation elimination: both of them are interpreted as an identity lens.

The *principle of explosion* says that $p$ and $\neg p$ together entail falsity, for every proposition $p$. Since falsity and truth coincide, for us the principle of explosion says that $p$ and $\neg p$ together entail truth. This is a valid principle in our semantics. Suppose $p$ is interpreted as $(X, X')$, then $p \otimes \neg p$ is interpreted as $(X \times X', X' \times X)$. There is indeed a canonical lens $(X \times X', X' \times X) \to (1, 1)$, namely the "turnaround" lens, which I normally call a *counit*.

In Idris, suppose we have
```haskell
explosion : {a : Ty} -> Term [a, Not a] Unit
```
Then we must have
```haskell
eval explosion : {a : Ty} -> All Cov [a, Not a] -> (Unit, Unit -> All Con [a, Not a])
```
which up to isomorphism reduces to
```haskell
eval explosion : {a : Ty} -> (Cov a, Con a) -> (Con a, Cov a)
```
Of course, we want to implement `eval` so that this gives us the swap function.

The de Morgan dual of the principle of explosion is the *principle of excluded middle*, which says that truth entails $p$ or $\neg p$. Remembering that our conjunction and disjunction coincide, if $p$ has interpretation $(X, X')$ then excluded middle would denote a lens $(1, 1) \to (X \times X', X' \times X)$. In general there is no lens of this type, so our semantics does not validate excluded middle.

In Idris, suppose we had
```haskell
lem : {a : Ty} -> Term [] (Tensor a (Not a))
```
Then we must have
```haskell
eval lem : {a : Ty} -> All Cov [] -> ((Cov a, Con a), (Con a, Cov a) -> All Con [])
```
which up to isomorphism reduces to
```haskell
eval lem : {a : Ty} -> (Cov a, Con a)
```
which is impossible as soon as we introduce any types that are not pointed.

## A logic puzzle

This suggests a *logic puzzle*: can we design a proof system for negation that validates double negation introduction, double negation elimination and the principle of explosion, but does not validate excluded middle?

After some tinkering I did indeed invent a system with these properties. Sadly it turned out to be a red herring, since it ended up proving these principles that are valid for lenses in terms of more primitive principles that are not valid for lenses. But I still think it's an interesting enough sideline to report here.

The system I designed was a 2-sided hybrid of a natural deduction calculus and a sequent calculus, with general right-elimination, and both left-elimination and right-introduction restricted to empty sequents on the right. In standard proof theory syntax I would write it like this:

$$ \frac{\Gamma, \varphi \vdash}{\Gamma \vdash \neg \varphi} (RI) \qquad \frac{\Gamma, \neg \varphi \vdash}{\Gamma \vdash \varphi} (LE) \qquad \frac{\Gamma \vdash \varphi, \Delta \qquad \Gamma' \vdash \neg \varphi, \Delta'}{\Gamma, \Gamma' \vdash \Delta, \Delta'} (RE) $$

In Idris:
```haskell
data Term : List Ty -> List Ty -> Type where
  Var : Term [x] [x]
  LAct : Symmetric xs' xs -> Term xs ys -> Term xs' ys
  RAct : Term xs ys -> Symmetric ys ys' -> Term xs ys'
  NotIntroR : Term (x :: xs) [] -> Term xs [Not x]
  NotElimL : Term (Not x :: xs) [] -> Term xs [x]
  NotElimR : Simplex xs1 xs2 xs3 -> Simplex ys1 ys2 ys3
          -> Term xs1 (y :: ys1) -> Term xs2 (Not y :: ys2) -> Term xs3 ys3
```

`Symmetric` is the structure for permutations that I introduced in the [previous post](https://cybercat.institute/2024/08/26/bidirectional-programming-i/).

Here are what our principles look like, together with some non-proofs that are ruled out by the restrictions on right-introduction and left-elimination:
```haskell
dni : {a : Ty} -> Term [a] [Not (Not a)]
dni = NotIntroR (LAct (Insert (There Here) (Insert Here Empty)) 
                      (NotElimR (Left Right) Right Var Var))

dne : {a : Ty} -> Term [Not (Not a)] [a]
dne = NotElimL (NotElimR (Left Right) Right Var Var)
-- ruled out by NotIntroR restriction
-- dne = NotElimR Right (Left Right) (NotIntroR Var) Var

explosion : {a : Ty} -> Term [a, Not a] []
explosion = NotElimR (Left Right) Right Var Var

lem : {a : Ty} -> Term [] [Not a, a]
-- ruled out by NotIntroR restriction
-- lem = NotIntroR Var
-- ruled out by NotElimL restriction
-- lem = NotElimL (NotElimL (NotElimR (Left Right) Right Var Var))
```

Unfortunately, although my restricted left-elimination and right-introduction rules can be used to prove the semantically valid principles of double negation introduction and elimination, they are themselves not semantically valid. The problems start to appear once we add back in the rules for tensor, which in this 2-sided calculus are
```haskell
  TensorIntro : Simplex xs1 xs2 xs3 -> Simplex ys1 ys2 ys3
             -> Term xs1 (y1 :: ys1) -> Term xs2 (y2 :: ys2) 
             -> Term xs3 (Tensor y1 y2 :: ys3)
  TensorElim : Simplex xs1 xs2 xs3 -> Simplex ys1 ys2 ys3
            -> Term xs1 (Tensor x y :: ys1) -> Term (x :: y :: xs2) ys2 
            -> Term xs3 ys3
```

Now we can write a bad term:
```haskell
bad : {a : Ty} -> Term [] [Not (Tensor a (Not a))]
bad = NotIntroR (TensorElim (Left Right) Right Var explosion)
```
Although these rules don't seem to be strong enough to prove the distributive law between tensor and negation, semantically this is the same shape as excluded middle. I think it would be possible to restrict left-elimination and right-introduction differently to rule out this kind of thing, but only at the expense of leaving us with unprovable instances of double negation introduction and elimination.

## Structurally involutive negation

Although I would love to come up with a calculus that fulfills my requirements using pure logic, I currently believe that it's impossible. So instead I will bring out the big guns, and use a `Structure`. The methodology I introduced in the previous post yields a clean conceptual separation into *syntax* and *logic*. If we want to say that two things are syntactically identical, for example permutations of contexts, we use a `Structure` to encode that. So what we are about to do is to encode a principle that $p$ and $\neg \neg p$ are not merely *logically equivalent* but *syntactically identical*.

This is how we do it:
```haskell
data Parity : Ty -> Ty -> Type where
  Id : Parity x x
  Raise : Parity x y -> Parity x (Not (Not y))
  Lower : Parity x y -> Parity (Not (Not x)) y

data Involutive : Structure Ty where
  Empty : Involutive [] []
  Insert : Parity x y -> Insertion y ys zs -> Involutive xs ys -> Involutive (x :: xs) zs
```

An element of `Involutive xs ys` is a witness that `ys` is a permutation of `xs` but with an arbitrary number of double negatives inserted or removed.

With double negation introduction and elimination taken care of, all we have to do is to make a logic that validates the principle of explosion and not excluded middle, which is easy: it's an ordinary 1-sided natural deduction calculus with the negation introduction rule omitted.

```haskell
data Term : List Ty -> Ty -> Type where
  Var : Term [x] x
  Act : Involutive xs ys -> Term ys t -> Term xs t
  NotElim : {xs, ys : List Ty} -> {default (simplex xs ys) prf : _}
         -> Term xs t -> Term ys (Not t) -> Term prf.fst Unit
  TensorIntro : {xs, ys : List Ty} -> {default (simplex xs ys) prf : _}
             -> Term xs t -> Term ys t' -> Term prf.fst (Tensor t t')
  TensorElim : {xs, ys : List Ty} -> {default (simplex xs ys) prf : _}
            -> Term xs (Tensor x y) -> Term (x :: y :: ys) z -> Term prf.fst z
```

We can write exactly the terms that we want to:
```haskell
dni : {a : Ty} -> Term [a] (Not (Not a))
dni = Act (Insert (Raise Id) Here Empty) Var

dne : {a : Ty} -> Term [Not (Not a)] a
dne = Act (Insert (Lower Id) Here Empty) Var

explosion : {a : Ty} -> Term [a, Not a] Unit
explosion = NotElim Var Var

lem : {a : Ty} -> Term [] (Tensor a (Not a))
-- impossible
```

And it's now possible to write a well typed interpreter for this definition of terms, although I'll skip it here because it involves several pages of mostly tedious boilerplate code. In the next post we'll add the missing scoping rules to our language, so that by the time we come back to the well typed interpreter in post number 4, we'll be able to use it to do a little bit of differentiable programming.
