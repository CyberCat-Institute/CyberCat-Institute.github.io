---
layout: post
title: "Foundations of Bidirectional Programming III: The Logic of Lenses"
author: Jules Hedges
date: 2024-09-12
categories: [programming languages]
excerpt: "In this post we will make probably the single most important step from a generic type theory to one specialised to bidirecional programming."
---

See parts [I](https://cybercat.institute/2024/08/26/bidirectional-programming-i/) and [II](https://cybercat.institute/2024/09/05/bidirectional-programming-ii/) of this series. There is also now a [source repo](https://github.com/CyberCat-Institute/Aptwe)!

In this post we will make probably the single most important step from a generic type theory to one specialised to bidirecional programming.

In a bidirectional language there are 2 kinds of variables: ones travelling forwards in time, and ones travelling backwards in time. I will refer to the types of these variables *covariant* and *contravariant* for short (or at least shorter). Variables of covariant type are the ones we are used to: they behave according to ordinary *cartesian* scoping rules, which means they can be implicitly deleted (referred to zero times) and implicitly copied (referred to more than once).

Variables of *cocartesian* type are the weird ones. They can also be implicitly copied and deleted, but because they are going backwards, from the forwards perspective it looks like they can be implicitly *merged* and *spawned*. By *spawned* I mean they can be bound zero times and still referred to; and by *merged* I mean they can be bound twice without the later binding shadowing the earlier binding. On the other hand they can *not* be implicitly copied or deleted. Their scoping rules are *cocartesian*.

I can now reveal that my *party trick* in the last section of my [first post](https://cybercat.institute/2024/08/26/bidirectional-programming-i/) where I built a cocartesian language was secretly not in fact a party trick after all, but was all along in preparation for this exact moment.

Now suppose we take a tensor product of a covariant type and a contravariant type. Now we have a variable referring to a bundle of a cartesian value, which can be deleted and copied but not spawned or merged, and a cocartesian value, which can be spawned and merged but not deleted or copied. Since doing any of these operations to a pair means doing it to both, our variable cannot be deleted or copied or spawned or merged, which means it is a *linear* variable. I will refer to such a tensor product type as *invariant*. Secretly, all of the types in my [second post](https://cybercat.institute/2024/09/05/bidirectional-programming-ii/) were invariant, since that language was linear.

There is a secret fourth thing, which is variables with *bicartesian* scoping rules, so they can be deleted and copied and spawned and merged. I will refer to these types as *bivariant*. It would be entirely reasonable to not include these, but I have a secret plan for them that will be revealed in the next post. For now, the only bivariant type will be the monoidal unit.

## The 4 kinds of things

Just as terms are classified by types, types are classified by *kinds*, which means I have been talking about kinds the whole time. But these are not kinds as we know them from languages like Haskell. We have the added complication that kinds control the scoping rules of variables of the types they classify; but on the other hand we have the added simplification that there are *exactly* 4 kinds, rather than an infinite supply of them. I have to thank [Michael Arntzenius](https://www.rntz.net/index.html), who visited Zanzi and me a few weeks ago, for planting the idea of a 4-element lattice of kinds.

Let's start with the easy parts:

```haskell
Kind : Type
Kind = (Bool, Bool)

data Ty : Kind -> Type where
  Unit : Ty (True, True)
  Ground : Ty (True, False)
  Not : Ty (cov, con) -> Ty (con, cov)
```

I implement the 4-element lattice as the product `(Bool, Bool)`, where the first flag tracks whether the type is covariant and the second whether it is contravariant. I anticipate that much later, probably when I add type polymorphism, it will become necessary to take seriously that there are subkind relationships here, but I will cross that particular bridge when it is in front of me. `Unit` is a bivariant type, `Ground` is a covariant type (it is still a placeholder, and in the next post will be replaced with a proper system for base types). The `Not` operator acts on the underlying kind by interchanging the covariant and contravariant capabilities; so strictly covariant types become strictly contravariant and vice versa, whereas the bivariant and invariant kinds are both stable under negation.

There is an alternative way of implementing it, but it is much more tedious: instead of representing kinds explicitly, have 4 different versions of `Ty` for each of the 4 kinds. That leads to a proliferation of type operators - 4 operators for `Not` and 16 for `Tensor`  (which we're coming to next), 1 for each combination of kinds of the 2 inputs. I really hope that won't be necessary, but it's something I'm keeping in my back pocket just in case I run into an insurmountable problem with this encoding.

Now we come to the hard part: tensor products. A tensor product is covariant if both parts are covariant, and is contravariant if both parts are contravariant. In a world with a sufficiently smart typechecker we would simply write this:

```haskell
  Tensor : Ty (covx, conx) -> Ty (covy, cony)
        -> Ty (covx && covy, conx && cony)
```

But we already know how to handle this situation, it's the same idea as for list concatenation in the [first post](https://cybercat.institute/2024/08/26/bidirectional-programming-i/). We define the relation corresponding to the boolean conjunction function, and a section of it:

```haskell
data And : Bool -> Bool -> Bool -> Type where
  True  : And True b b
  False : And False b False

(&&) : (a : Bool) -> (b : Bool) -> (c : Bool ** And a b c)
True  && b = (b ** True)
False && b = (False ** False)
```

(Here's I'm having fun with Idris' ability to disambiguate names based on typing information, something I really wish I could do in Haskell.)

Now we can write the actual definition of tensor products, which is much more complicated looking than it should be, but this is just what we have to deal with until the day when somebody builds a typechecker that can handle trivial equational reasoning:

```haskell
  Tensor : {covx, covy, conx, cony : Bool}
        -> {default (covx && covy) cov : _} -> {default (conx && cony) con : _}
        -> Ty (covx, conx) -> Ty (covy, cony) -> Ty (cov.fst, con.fst)
```

## The scoping rules

Now we come to the main topic of this post: how kinds influence scoping rules. In the [first post](https://cybercat.institute/2024/08/26/bidirectional-programming-i/) we saw how to implement context morphisms for planar, linear, cartesian and cocartesian languages. Those definitions were all polymorphic over arbitrary lists. Then in the [second post](https://cybercat.institute/2024/09/05/bidirectional-programming-ii/) we defined context morphisms that could introduce and elimination double negations, which was no longer polymorphic but specialised to a particular language of types, and this will continue.

Now that types are indexed by kinds, everything else becomes more complicated: everything we do from now on becomes additionally indexed by kinds, starting with this.

(Note, I decided to reuse the name `Structure`, since this should be the last one we ever need.)

Let's start with the linear rules:

```haskell
data Structure : All Ty kas -> All Ty kbs -> Type where
  Empty  : Structure [] []
  Insert : {a, b : Ty (cov, con)} -> {as : All Ty kas} -> {bs : All Ty kbs}
        -> Parity a b -> IxInsertion a as as' -> Structure as bs -> Structure as' (b :: bs)
```

Here `IxInsertion` is an indexed version of the `Insertion` datatype from the previous post, relationally defining insertions into an `All` type indexed by an underlying list:

```haskell
data IxInsertion : {0 x : a} -> p x 
                -> {0 xs : List a} -> All p xs 
                -> {0 ys : List a} -> All p ys -> Type where
  Z : IxInsertion {x} a {xs} as {ys = x :: xs} (a :: as)
  S : IxInsertion {x} a {xs} as {ys} bs 
   -> IxInsertion {x = x} a {xs = y :: xs} (b :: as) {ys = y :: ys} (b :: bs)
```

I'm not going to explain all of the syntax and semantics of Idris happening here because it would take us too far afield, and despite appearances this is not intended to be a tutorial series on Idris programming. Suffice to say, defining indexed versions of standard datatypes is *significantly* harder than defining the originals.

The definition of `Parity`, which handles double negations, is unchanged from the previous post besides adding the kind indexes:

```haskell
data Parity : Ty (cov, con) -> Ty (cov, con) -> Type where
  Id    : Parity a a
  Raise : Parity a b -> Parity a (Not (Not b))
  Lower : Parity a b -> Parity (Not (Not a)) b
```

The Idris typechecker is, at least, smart enough to figure out that double negation leaves the kind unchanged. This is one reason that I write out kinds as pairs of booleans everywhere rather than defining a function `swap : Kind -> Kind`, since that causes Idris to get stuck here.

One thing to note is that I reversed the polarity of the `Insert` constructor from the previous post, so that it now conses on the codomain and inserts on the domain rather than the other way round. The previous post was "supply driven", saying where everything in the domain goes in the codomain, whereas this version is "demand driven", saying where everything in the codomain came from in the domain. This was a late change after I experienced manually defining terms in this core syntax and found that this way makes manual proof search much easier. If it later turns out that the original supply driven version makes writing elaborators easier, it's an easy change to turn it back.

Next we have the rules for delete and copy, which can be applied only to covariant types. We don't care whether the type is also contravariant, ie. we can use it for both strictly covariant types and bivariant types. This is the other reason I define kinds to be pairs of booleans rather than their own dedicated language, because otherwise we would have twice as many constructors here.

```haskell
  Delete : {a : Ty (True, con)} -> Structure as bs -> Structure (a :: as) bs
  Copy   : {a : Ty (True, con)} -> {as : All Ty xs} 
        -> IxElem a as -> Structure as bs -> Structure as (a :: bs)
```

Here `IxElem` is, of course, an indexed version of the `Elem` datatype, which I won't bother to write here but was also painful to define. (If you want to you can find it in the [IxUtils](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/IxUtils.idr) module of the source repo.)

With that, defining the constructors for spawn and merge is easy, and completes our definition of `Structure` once and for all.

```haskell
  Spawn  : {b : Ty (cov, True)} -> Structure as bs -> Structure as (b :: bs)
  Merge  : {b : Ty (cov, True)} -> {bs : All Ty ys} 
        -> IxElem b bs -> Structure as bs -> Structure (b :: as) bs
```

## The full logic of lenses

We can now put the pieces together and make the first real definition of our kernel language. I hope that nothing here will change, only be added to in the future.

Of course everything is kind indexed:

```haskell
data Term : All Ty ks -> Ty k -> Type where
  Var : Term [x] x
  Rename : Structure as bs -> Term bs x -> Term as x
```

I renamed `Act` to `Rename` since the last post, since somebody pointed out that's what it is.

Unit introduction and elimination rules work as they did before:

```haskell
  UnitIntro : Term [] Unit
  UnitElim : {as : All Ty kas} -> {bs : All Ty kbs} -> {default (ixSimplex as bs) cs : _}
          -> Term as Unit -> Term bs x -> Term (cs.snd.fst) x
```

Here `ixSimplex` is the tactic corresponding to a datatype `IxSimplex` which is the relational version of the indexed version of `++`, operating on `All` rather than `List`. This one is worth writing down because it returns a twice-iterated Sigma type, so we have to extract the part we need with `.snd.fst`:

```haskell
data IxSimplex : {0 xs : List a} -> All p xs 
              -> {0 ys : List a} -> All p ys 
              -> {0 zs : List a} -> All p zs -> Type where
  Z : IxSimplex [] bs bs
  S : IxSimplex {xs} as {ys} bs {zs} cs 
   -> IxSimplex {xs = x :: xs} (a :: as) {ys = ys} bs {zs = x :: zs} (a :: cs)

ixSimplex : {xs : List a} -> (as : All p xs)
         -> {ys : List a} -> (bs : All p ys)
         -> (zs : List a ** cs : All p zs ** IxSimplex as bs cs)
ixSimplex {xs = []} [] {ys} bs = (ys ** bs ** Z)
ixSimplex {xs = x :: xs} (a :: as) {ys} bs 
  = let (zs ** cs ** n) = ixSimplex {xs = xs} as {ys = ys} bs 
     in (x :: zs ** a :: cs ** S n)
```

Now we come to the negation rules, and the final twist of this post. In the language we reached at the end of the [previous post](https://cybercat.institute/2024/09/05/bidirectional-programming-ii/), which amounts to the fragment of this language for only invariant types, there was no not-introduction rule - correctly so. As I speculated there, there are indeed some valid instances of not-introduction, but they are not sufficient to prove general double negation introduction or elimination - and they can't even be expressed without the kind system we developed in this post.

It turns out that we have two not-introduction rules, one that is valid for covariant types and one that is valid for contravariant types. This introduces a sort of incompatibility between negation and tensor, since the tensor product of two variables with a valid not-introduction rule can fail to have one.

```haskell
  NotIntroCov : {a : Ty (True, con)} -> Term (a :: as) Unit -> Term as (Not a)
  NotIntroCon : {a : Ty (cov, True)} -> Term (a :: as) Unit -> Term as (Not a)
  NotElim : {as : All Ty kas} -> {bs : All Ty kbs} -> {default (ixSimplex as bs) cs : _}
         -> Term as (Not x) -> Term bs x -> Term (cs.snd.fst) Unit
```

I would say that this is the first case where my well typed by construction methodology enabled me to do something that I think I would have failed at otherwise. I figured out these rules at the same time as the corresponding cases of the well typed evaluator (which will be the topic of the next post). Although they look like they are among the simplest rules in the language, they are the ones I understand by far the least.

If we have a bivariant type then both of these rules can be applied to produce the same result. It seems tempting to try to roll these two rules into one, which can be applied when *either* `cov` or `con` is `True`. This is a bit tricky to do, but it turns out to also be a bad idea: although these rules are *logically* equivalent, they are not *type-theoretically* equivalent: they have completely different operational semantics! And by that I don't mean something like different evaluation strategies, I mean that they actually output different results.

Now there's only the tensor rules, and for once there is nothing to say about them, they are the indexed versions of the tensor rules from the last 2 posts.

```haskell
  TensorIntro : {as : All Ty kas} -> {bs : All Ty kbs} -> {default (ixSimplex as bs) cs : _}
             -> Term as x -> Term bs y -> Term (cs.snd.fst) (Tensor x y)
  TensorElim : {as : All Ty kas} -> {bs : All Ty kbs} -> {default (ixSimplex as bs) cs : _}
            -> Term as (Tensor x y) -> Term (x :: y :: bs) z -> Term (cs.snd.fst) z
```

And that's it!

Like I said, in the next post we will build a well typed evaluator, which means we will also write and run our first programs - and we can already do some interesting things, like basic automatic differentiation. The only small thing that will need to be added to the language from this post is a mechanism for adding basic types and basic terms, such as arithmetic operators between doubles.
