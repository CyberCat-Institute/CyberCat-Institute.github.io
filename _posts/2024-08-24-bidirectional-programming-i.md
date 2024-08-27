---
layout: post
title: "Foundations of Bidirectional Programming I: Well-Typed Substructural Languages"
author: Jules Hedges
date: 2024-08-26
categories: [programming languages]
excerpt: "This is the first post in a new series documenting my work developing a bidirectional programming language, in which all programs are interpreted as optics. This is something I've been thinking about for a long time, and eventually I became convinced that there were enough subtle issues that I should take things extremely slowly and actually learn some programming language theory. As a result, this post will not be about categorical cybernetics at all, but is a foundation to a huge tower of categorical cybernetics machinery that I will build later."
---

Cross-posted from [Zanzi's blog](https://zanzix.github.io/posts/4-substructural.html)

This is the first post in a new series documenting my work developing a bidirectional programming language, in which all programs are interpreted as optics. This is something I've been thinking about for a long time, and eventually I became convinced that there were enough subtle issues that I should take things extremely slowly and actually learn some programming language theory. As a result, this post will not be about categorical cybernetics at all, but is a foundation to a huge tower of categorical cybernetics machinery that I will build later.

The first issue is that because the tensor product of optics is not cartesian, a language for optics is necessarily substructural. So this post is about a way to implement substructural languages in a way that avoids hidden pitfalls. The code in this post is Idris2, a dependently typed language.

We begin with a tiny language for types, with monoidal products (a neutral name because later we will be making it behave like different kinds of product), a unit type to be the neutral element of the monoidal product, and a "ground" type that is intended to contain some nontrivial values.
```haskell
data Ty : Type where
  Unit : Ty
  Ground : Ty
  Tensor : Ty -> Ty -> Ty
```

## Cartesian terms

Although we have used the name "tensor", suppose we want to make an ordinary cartesian language where variables can be implicitly copied and discarded. Here is a standard way to do it: it is an intuitionistic natural deduction calculus.
```haskell
data Term : List Ty -> Ty -> Type where
  -- A variable is a term if we can point to it in scope
  Var : Elem x xs -> Term xs x
  -- Unit is always a term in every scope
  UnitIntro : Term xs Unit
  -- Pattern matching on Unit, redunant here but kept for comparison to later
  UnitElim : Term xs Unit -> Term xs x -> Term xs x
  -- A pair is a term if each side is a term
  TensorIntro : Term xs x -> Term xs y -> Term xs (Tensor x y)
  -- Pattern matching on a pair, adding both sides to the scope
  TensorElim : Term xs (Tensor x y) -> Term (x :: y :: xs) z -> Term xs z
```

The constructor for `Var` uses `Elem`, a standard library type that defines pointers into a list:
```haskell
data Elem : a -> List a -> Type where
  Here : Elem x (x :: xs)
  There : Elem x xs -> Elem x (x' :: xs)
```

Here are some examples of programs we can write in this language:
```haskell
-- \x => ()
delete : CartesianTerm [a] Unit
delete = UnitIntro

-- \(x, y) => x
prjl : CartesianTerm [a, b] a
prjl = Var Here

-- \(x, y) => y
prjr : CartesianTerm [a, b] b
prjr = Var (There Here)

-- \x => (x, x)
copy : CartesianTerm [a] (Tensor a a)
copy = TensorIntro (Var Here) (Var Here)

-- \(x, y) => (y, x)
swap : CartesianTerm [a, b] (Tensor b a)
swap = TensorIntro (Var (There Here)) (Var Here)
```

The thing that makes this language cartesian and allows us to write these 3 terms is the way that the context `xs` gets shared by the inputs of the different term constructors. In the next section we will define terms a different way, and then none of these examples will typecheck.

## Planar terms

Next let's go to the opposite extreme and build a fully substructural language, in which we cannot delete or copy or swap. I learned how to do this from Conor Mc Bride and Zanzi. Here is the idea:

```haskell  
data Term : List Ty -> Ty -> Type where
  -- A variable is a term only if it is the only thing in scope
  Var : Term [x] x
  -- Unit is a term only in the empty scope
  UnitIntro : Term [] Unit
  -- Pattern matching on Unit consumes its scope
  UnitElim : Term xs Unit -> Term ys y -> Term (xs ++ ys) y
  -- Constructing a pair consumes the scopes of both sides
  TensorIntro : Term xs x -> Term ys y -> Term (xs ++ ys) (Tensor x y)
  -- Pattern matching on a pair consumes its scope
  TensorElim : Term xs (Tensor x y) -> Term (x :: y :: ys) z -> Term (xs ++ ys) z
```

This is a semantically correct definition of planar terms and it would work if we had a sufficiently smart typechecker, but for the current generation of dependent typecheckers we can't use this definition because it suffers from what's called *green slime*. The problem is that we have types containing terms that involve the recursive function `++`, and the typechecker will get stuck when this function tries to pattern match on a free variable. (I have no idea how you learn this if you don't happen to drink in the same pubs as Conor. Dependently typed programming has a catastrophic lack of books that teach it.)

The fix is that we need to define a datatype that witnesses that the concatenation of two lists is equal to a third list - a witness that the composition of two things is equal to a third thing is called a *simplex*. The key idea is that this datatype exactly reflects the recursive structure of `++`, but as a relation rather than a function:
```haskell
data Simplex : List a -> List a -> List a -> Type where
  Right : Simplex [] ys ys
  Left : Simplex xs ys zs -> Simplex (x :: xs) ys (x :: zs)
```

Now we can write a definition of planar terms that we can work with:
```haskell
data Term : List Ty -> Ty -> Type where
  Var : Term [x] x
  UnitIntro : Term [] Unit
  UnitElim : Simplex xs ys zs 
          -> Term xs Unit -> Term ys y -> Term zs y
  TensorIntro : Simplex xs ys zs 
             -> Term xs x -> Term ys y -> Term zs (Tensor x y)
  TensorElim : Simplex xs ys zs 
            -> Term xs (Tensor x y) -> Term (x :: y :: ys) z -> Term zs z
```

This language is so restricted that it's hard to show it doing anything, but here is one example of a term we can write:
```haskell
-- \(x, y) => (x, y)
foo : Term [a, b] (Tensor a b)
foo = TensorIntro (Left Right) Var Var
```

Manually defining simplicies, which cut a context into two halves, is very good as a learning exercise but eventually gets irritating. We can direct Idris to search for the simplex automatically:

```haskell
data Term : List Ty -> Ty -> Type where
  Var : Term [x] x
  UnitIntro : Term [] Unit
  UnitElim : {auto prf : Simplex xs ys zs} 
          -> Term xs Unit -> Term ys y -> Term zs y
  TensorIntro : {auto prf : Simplex xs ys zs} 
             -> Term xs x -> Term ys y -> Term zs (Tensor x y)
  TensorElim : {auto prf : Simplex xs ys zs} 
            -> Term xs (Tensor x y) -> Term (x :: y :: ys) z -> Term zs z

foo : Term [a, b] (Tensor a b)
foo = TensorIntro Var Var
```

This works, but I find that the proof search gets confused easily (although it works fine for the baby examples in this post), so let's pull out the big guns and write a tactic:
```haskell
concat : (xs, ys : List a) -> (zs : List a ** Simplex xs ys zs)
concat [] ys = (ys ** Right)
concat (x :: xs) ys = let (zs ** s) = concat xs ys in (x :: zs ** Left s)
```

This function takes two lists and returns their concatenation together with a simplex that witnesses this fact. Here `**` is Idris syntax for both the type former and term former for dependent pair (aka. Sigma) types. 

```haskell
data Term : List Ty -> Ty -> Type where
  Var : Term [x] x
  UnitIntro : Term [] Unit
  UnitElim : {xs, ys : List Ty} 
          -> {default (concat xs ys) prf : (zs : List Ty ** Simplex xs ys zs)}
          -> Term xs Unit -> Term ys y -> Term prf.fst y
  TensorIntro : {xs, ys : List Ty} 
              -> {default (concat xs ys) prf : (zs : List Ty ** Simplex xs ys zs)}
              -> Term xs x -> Term ys y -> Term prf.fst (Tensor x y)
  TensorElim : {xs, ys : List Ty} 
            -> {default (concat xs ys) prf : (zs : List Ty ** Simplex xs ys zs)} 
            -> Term xs (Tensor x y) -> Term (x :: y :: ys) z -> Term prf.fst z

foo : {a, b : Ty} -> Term [a, b] (Tensor a b)
foo = TensorIntro Var Var
```

I find Idris' `default` syntax to be a bit awkward, but it feels to me like a potentially very powerful tool, and something I wish Haskell had for scripting instance search.

## Context morphisms

Unfortunately, going from a planar language to a linear one - that is, ruling out copy and delete but allowing swaps - is much harder. I figured out a technique for doing this that turns out to be very powerful and give very fine control over the scoping rules of a language.

The idea is to isolate a category of context morphisms (technically a coloured [pro](https://ncatlab.org/nlab/show/PRO), that is a strict monoidal category whose monoid of objects is free). Then we will parametrise a planar language by an action of this category. The good news is that this is the final iteration of the definition of `Term`, and we'll be working with it for the rest of this blog post.

```haskell
Structure : Type -> Type
Structure a = List a -> List a -> Type

data Term : Structure Ty -> List Ty -> Ty -> Type where
  Var : Term hom [x] x
  Act : hom xs ys -> Term hom ys x -> Term hom xs x
  UnitIntro : Term hom [] Unit
  UnitElim : {xs, ys : List Ty} 
          -> {default (concat xs ys) prf : (zs : List Ty ** Simplex xs ys zs)}
          -> Term hom xs Unit -> Term hom ys y -> Term hom prf.fst y
  TensorIntro : {xs, ys : List Ty}
             -> {default (concat xs ys) prf : (zs : List Ty ** Simplex xs ys zs)}
             -> Term hom xs x -> Term hom ys y -> Term hom prf.fst (Tensor x y)
  TensorElim : {xs, ys : List Ty} 
            -> {default (concat xs ys) prf : (zs : List Ty ** Simplex xs ys zs)} 
            -> Term hom xs (Tensor x y) -> Term hom (x :: y :: ys) z 
            -> Term hom prf.fst z
```

First, let's recover planar terms. To do this, we want to define a `Structure` where `hom xs ys` is a proof that `xs = ys`:
```haskell
data Planar : Structure a where
  Empty : Planar [] []
  Whisker : Planar xs ys -> Planar (x :: xs) (x :: ys)
```

Now let's deal with linear terms. For that, we want to define a `Structure` where `hom xs ys` is a proof that `ys` is a permutation of `xs`. We can do this in two steps:
```haskell
-- Insertion x xs ys is a witness that ys consists of xs with x inserted somewhere
data Insertion : a -> List a -> List a -> Type where
  -- The insertion is at the head of the list
  Here : Insertion x xs (x :: xs)
  -- The insertion is somewhere in the tail of the list
  There : Insertion x xs ys -> Insertion x (y :: xs) (y :: ys)

data Symmetric : Structure a where
  -- The empty list has a unique permutation to itself
  Empty : Symmetric [] []
  -- Extend a permutation by inserting the head element into the permuted tail
  Insert : Insertion x ys zs -> Symmetric xs ys -> Symmetric (x :: xs) zs
```

(Incidentally, this is the point where I realised that although Idris *looks* like Haskell, programming in it feels a lot closer to programming in Prolog.)

Now we write swap as term:
```haskell
swap : {a, b : Ty} -> Term Symmetric [a, b] (Tensor b a)
swap = Act (Insert (There Here) (Insert Here Empty)) (TensorIntro Var Var)
```

## Explicitly cartesian terms

Now we can come full circle and redefine cartesian terms in a way that uniformly matches the way we do substructural terms.

```haskell
data Cartesian : Structure a where
  -- Delete everything in scope
  Delete : Cartesian xs []
  -- Point to a variable in scope and make a copy on top
  Copy : Elem y xs -> Cartesian xs ys -> Cartesian xs (y :: ys)
```

With this, we can rewrite all the terms we started with:
```haskell
delete : {a : Ty} -> Term Cartesian [a] Unit
delete = Act Delete UnitIntro

prjl : {a, b : Ty} -> Term Cartesian [a, b] a
prjl = Act (Copy Here Delete) Var

prjr : {a, b : Ty} -> Term Cartesian [a, b] b
prjr = Act (Copy (There Here) Delete) Var

copy : {a : Ty} -> Term Cartesian [a] (Tensor a a)
copy = Act (Copy Here (Copy Here Delete)) (TensorIntro Var Var)

swap : {a, b : Ty} -> Term Cartesian [a, b] (Tensor b a)
swap = Act (Copy (There Here) (Copy Here Delete)) (TensorIntro Var Var)
```

Let's end with a party trick. What would a *cocartesian* language look like - one where we can't delete or copy, but we can spawn and merge?

```haskell
Co : Structure a -> Structure a
Co hom xs ys = hom ys xs

-- spawn : Void -> a
-- spawn = \case {}
spawn : {a : Ty} -> Term (Co Cartesian) [] a
spawn = Act Delete Var

-- merge : Either a a -> a
-- merge = \case {Left x => x; Right x => x}
merge : {a : Ty} -> Term (Co Cartesian) [a, a] a
merge = Act (Copy Here (Copy Here Delete)) Var

-- injl : a -> Either a b
-- injl = \x => Left x
injl : {a, b : Ty} -> Term (Co Cartesian) [a] (Tensor a b)
injl = Act (Copy Here Delete) (TensorIntro Var Var)

-- injr : b -> Either a b
-- injr = \y => Right y
injr : {a, b : Ty} -> Term (Co Cartesian) [b] (Tensor a b)
injr = Act (Copy (There Here) Delete) (TensorIntro Var Var)
```

Since at the very beginning we added a single generating type `Ground`, and the category generated by one object and finite coproducts is finite sets and functions, this language can define exactly the functions between finite sets. For example, there are exactly 4 functions from booleans to booleans:
```haskell
id, false, true, not : Term (Co Cartesian) [Ground, Ground] (Tensor Ground Ground)
id = Act (Copy Here (Copy (There Here) Delete)) (TensorIntro Var Var)
false = Act (Copy Here (Copy Here Delete)) (TensorIntro Var Var)
true = Act (Copy (There Here) (Copy (There Here) Delete)) (TensorIntro Var Var)
not = Act (Copy (There Here) (Copy Here Delete)) (TensorIntro Var Var)
```

That's enough for today, but next time I will continue using this style of term language to start dealing with the difficult issues of building a programming language for optics.
