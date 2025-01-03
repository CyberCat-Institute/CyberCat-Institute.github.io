---
layout: post
title: "Foundations of Bidirectional Programming IV: Running Forwards and Running Backwards"
author: Jules Hedges
date: 2025-01-03
categories: [programming languages]
usemathjax: true
excerpt: "We are now at the point where we can write an interpreter to run some programs. To be clear, this is mainly for demonstration and debugging purposes, and the eventual goal is to write an optimising compiler. By the end of this post we will be able to demonstrate interpreting some very simple straight-line differentiable programs, and also demonstrate just how horrendous it is to actually write programs in our kernel syntax. This will motivate several follow-up posts where we slowly work upwards towards a human-usable surface language."
---

See parts [I](https://cybercat.institute/2024/08/26/bidirectional-programming-i/), [II](https://cybercat.institute/2024/09/05/bidirectional-programming-ii/) and [III](https://cybercat.institute/2024/09/12/bidirectional-programming-iii/)

We are now at the point where we can write an interpreter to run some programs. To be clear, this is mainly for demonstration and debugging purposes, and the eventual goal is to write an optimising compiler. By the end of this post we will be able to demonstrate interpreting some very simple straight-line differentiable programs, and also demonstrate just how horrendous it is to actually write programs in our kernel syntax. This will motivate several follow-up posts where we slowly work upwards towards a human-usable surface language.

Continuing our well-typed-by-construction methodology we will build a *well typed interpreter*. This means that we first interpret types of our language into Idris types, and then these give the type of the corresponding interpreted program. For languages less weird than ours, such as one of the example languages from the [first post](https://cybercat.institute/2024/08/26/bidirectional-programming-i/), we would interpret terms as Idris functions, resulting in signatures like this:

```haskell
EvalType : Ty -> Type
eval : Term xs x -> All EvalType xs -> EvalType x
```

Instead of interpreting to Idris functions, terms of Aptwe will be interpreted as *lenses*. For this we need to give 2 different interpretations of each type, one covariant and the other contravariant:

```haskell
Cov : Ty -> Type
Con : Ty -> Type
eval : Term xs x -> Lens (All Cov xs) (All Con xs) (Cov x) (Con x)
```

## Base types

We need to start by defining `Cov` and `Con`, which is completely straightforward. This is the point at which we upgrade our type language to have a proper mechanism for base types (source code is [here](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/Builtins/Types.idr) and [here](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/Kernel/Types.idr)):

```haskell
data BaseTy : Kind -> Type where
  Nat : BaseTy (True, False)
  Bool : BaseTy (True, True)
  Real : BaseTy (True, True)

data Ty : Kind -> Type where
  BaseTy : BaseTy (cov, con) -> Ty (cov, con)
```

This gives us 3 base types to play with: naturals (aka. ints), booleans, and reals (aka. doubles). I have made the choice that naturals will be purely covariant, whereas booleans and reals will be bivariant. As we will discover, interpreting a bivariant type amounts to choosing a canonical commutative monoid structure on it, which becomes baked into that type's scoping rules: every time we do something that looks like shadowing, instead the monoid operation will be applied.

These choices come from key applications: for reals it will be addition which is used in autodiff (see the last section of this post), and for booleans it will be conjunction which is used in compositional game theory (see a future post). Of course addition is also an obvious choice for naturals, but since I don't know any application for it in bidirectional programming, I have instead made naturals purely covariant.

Base types are also responsible for the only non-obvious part of our interpreter for types:

```haskell
data Echo : Type where
  X : Echo

mutual
  Cov : Ty k -> Type
  Cov Unit = Unit
  Cov (BaseTy x) = EvalBaseTy x
  Cov (Not x) = Con x
  Cov (Tensor x y) = (Cov x, Cov y)

  Con : Ty k -> Type
  Con Unit = Unit
  Con (BaseTy x) = Echo
  Con (Not x) = Cov x
  Con (Tensor x y) = (Con x, Con y)
```

The type `Echo` is an isomorphic copy of `Unit`. The choice I have made is that base types have a nontrivial interpretation only in the covariant direction. The name *echo* refers to the indescribable thing that is observed when looking at something travelling through time in the opposite direction to the observer. Its value `X` ends up proliferating through interpreted terms, but this is only something we'll have to put up with while using this prototype interpreter.

## Interpreting structure

The next thing we need to do is to interpret *structure*, that is, the data structure [here](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/Kernel/Structure.idr) that is used in the `Rename` case of terms. In principle a renaming could be interpreted as a lens, but it transpires that renamings only ever mean lenses whose backwards pass does not use its forwards input (I call these *adaptors*). This means that we actually need to write 2 functions:

```haskell
structureCov : Structure xs ys -> IxAll Cov xs -> IxAll Cov ys
structureCon : Structure xs ys -> IxAll Con ys -> IxAll Con xs
```

All of the source code from this section can be found in [this file](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/Interpreter/Structure.idr).

The hard part of this is to interpret the 4 operations of *delete*, *copy*, *spawn* and *merge*. Interpreting delete and copy of covariant values is easy, since it ends up being delete and copy of Idris values. Similarly interpreting spawn and merge of contravariant values also ends up being delete and copy of Idris values. So what we need to do is to spawn and merge covariant values, and to delete and copy contravariant values, and this is where we need to make a choice of a monoid structure for each base type:

```haskell
unit : {x : BaseTy (cov, True)} -> Cov (BaseTy x)
unit {x = Bool} = True
unit {x = Real} = 0

multiply : {x : BaseTy (cov, True)} 
        -> Cov (BaseTy x) -> Cov (BaseTy x) -> Cov (BaseTy x)
multiply {x = Bool} p q = p && q
multiply {x = Real} p q = p + q
```

Now we can delete and spawn because `unit` takes care of the missing base case for base types:

```haskell
mutual
  spawnCov : {x : Ty (cov, True)} -> Cov x
  spawnCov {x = Unit} = ()
  spawnCov {x = BaseTy x} = unit
  spawnCov {x = Not x} = deleteCon

  deleteCon : {x : Ty (True, con)} -> Con x
  deleteCon {x = Unit} = ()
  deleteCon {x = BaseTy x} = X
  deleteCon {x = Not x} = spawnCov
```

The case for spawning or deleting a tensor product *should* be

```haskell
  spawnCov {x = Tensor x y} = (spawnCov, spawnCov)
```

But instead this case takes us into a very unfortunate corner case of Idris syntax, which I'm not going to attempt to explain because I only partially understand what's going on:

```haskell
  spawnCov {x = Tensor {con = (True ** and)} x y} with (and)
    spawnCov {x = Tensor {con = (True ** and)} x y} | True 
      = (spawnCov, spawnCov)
```

The cases for copy/merge are almost identical. Now we can write the functions we need, for which the interesting cases are as follows:

```haskell
structureCov : Structure xs ys -> IxAll Cov xs -> IxAll Cov ys
structureCov (Delete f) (x :: xs) = structureCov f xs
structureCov (Copy e f) xs = ixSelect e xs :: structureCov f xs
structureCov (Spawn f) xs = spawnCov :: structureCov f xs
structureCov (Merge e f) (x :: xs) = applyAt e (mergeCov x) (structureCov f xs)

structureCon : Structure xs ys -> IxAll Con ys -> IxAll Con xs
structureCon (Delete f) ys = deleteCon :: structureCon f ys
structureCon (Copy e f) (y :: ys) = applyAt e (copyCon y) (structureCon f ys)
structureCon (Spawn f) (y :: ys) = structureCon f ys
structureCon (Merge e f) ys = ixSelect e ys :: structureCon f ys
```

Observe that the covariant delete case and the contravariant spawn case become a deletion in Idris, meaning that the head of the list does not appear on the right hand side. Similarly the cases for covariant copy and contravariant delete use the helper function `ixSelect`, which in the end is copying a value from the middle of the list to its head. This leaves the remaining cases to call our 4 helper functions: covariant spawning and merging, and contravariant deleting and copying.

## Writing the interpreter

Now we come to the main thing: writing the function

```haskell
eval : Term xs y -> IxAll Cov xs -> (Cov y, Con y -> IxAll Con xs)
```

The complete implementation is [here](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/Interpreter/Terms.idr). Let's start with a couple of very easy cases to warm up:

```haskell
eval (BaseTerm t) xs = evalBaseTerm t xs
eval Var [x] = (x, \y' => [y'])
eval UnitIntro [] = ((), \() => [])
```

The case for renaming is not much harder, since we spent the whole of the previous section writing the helper functions it needs:

```haskell
eval (Rename f t) xs = let (y, k) = eval t (structureCov f xs)
                        in (y, \y' => structureCon f (k y'))
```

Probably the most instructive case is the one for `Let`. When writing an ordinary interpreter of terms into functions `Let` becomes function composition, or slightly more precisely *substitution* into one input of a many-input function. For us, `Let` becomes lens composition. The one complication, which also happens in most of the remaining cases, is that we need to use the simplex carried by the proof rule to tell us how to pull apart the input list into two, and then stitch it back together.

```haskell
eval (Let {cs = (_ ** _ ** s)} t1 t2) xs
  = let (y, k1) = eval t1 (ixUncatL s xs)
        (z, k2) = eval t2 (y :: ixUncatR s xs)
     in (z, \z' => let y' :: ys' = k2 z'
                    in ixConcat s (k1 y') ys')
```

The subtlety of this case is just the subtlety of lens composition: the first output of `t1` in the forwards direction becomes an input of `t2` in the forwards direction, and then the continuations are unwound in reverse order for the backwards direction. The helper functions

```haskell
ixConcat : IxSimplex as bs cs -> IxAll q as -> IxAll q bs -> IxAll q cs
ixUncatL : IxSimplex as bs cs -> IxAll q cs -> IxAll q as
ixUncatR : IxSimplex as bs cs -> IxAll q cs -> IxAll q bs
```

which can be found in [IxUtils](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/IxUtils.idr), respectively stitch or unstitch a pair of indexed lists as directed by a simplex.

Next let's look at the introduction and elimination rules for `Tensor`:

```haskell
eval (TensorIntro {cs = (_ ** _ ** s)} t1 t2) xs 
  = let (y1, k1) = eval t1 (ixUncatL s xs)
        (y2, k2) = eval t2 (ixUncatR s xs)
     in ((y1, y2), \(y1', y2') => ixConcat s (k1 y1') (k2 y2'))
eval (TensorElim {cs = (_ ** _ ** s)} t1 t2) xs 
  = let ((y1, y2), k1) = eval t1 (ixUncatL s xs)
        (y2, k2) = eval t2 (y1 :: y2 :: ixUncatR s xs)
     in (y2, \y' => let x1' :: x2' :: xs' = k2 y'
                     in ixConcat s (k1 (x1', x2')) xs')
```

The case for `TensorIntro` is nothing but the tensor product of two lenses, and the elimination rule is extremely similar to `Let` but binds two variables at once, namely the two halves of the product being eliminated.

This marks the dividing line between the cases I was able to understand before writing them, and the ones for which I really relied on the Idris type checker for help. What remains is the unit elimination rule, and the rules for negation. In an ordinary language the tensor elimination rule is very easy: any term that returns a unit can be completely discarded. But for us, a term that returns a unit can still produce output backwards:

```haskell
eval (UnitElim {cs = (_ ** _ ** s)} t1 t2) xs 
  = let ((), k1) = eval t1 (ixUncatL s xs)
        (y, k2) = eval t2 (ixUncatR s xs)
     in (y, \y' => ixConcat s (k1 ()) (k2 y'))
```

Arguably, the most important rule in the entire language is negation elimination, because it is the only rule that directly allows communication from the forwards pass to the backwards pass. In traditional differentiable programming terminology, the implementation of this rule is to write to the tape. Here is its implementation:

```haskell
eval (NotElim {cs = (_ ** _ ** s)} t1 t2) xs 
  = let (y1, k1) = eval t1 (ixUncatL s xs)
        (y2, k2) = eval t2 (ixUncatR s xs)
     in ((), \() => ixConcat s (k1 y2) (k2 y1))
```

This leaves the 2 negation introdution rules that, as I wrote in the previous post, I discovered while working on these cases for the interpreter. They are truly *sus*, and while writing this post I changed my mind several times about whether they should be in the language or whether they are mistakes. Currently the deciding factor is that one of them, the covariant one, is actually required in practice: we will use it repeatedly in the next section when implementing differentiable functions.

In a sense the negation introduction rules are *scoping* rules rather than computational rules: they use the helper functions we developed for the interpretation of `Rename`, but themselves cannot be expressed in terms of `Rename`. My provisional conclusion is that these rules need to be in the language because I don't have any alternative, but they are very much on thin ice.

Here is the code I wrote:
```haskell
eval (NotIntroCov t) xs 
  = (deleteCon, \x' => let ((), k) = eval t (x' :: xs)
                           y' :: ys = k ()
                        in ys)
eval (NotIntroCon t) xs 
  = let ((), k) = eval t (spawnCov :: xs) 
        y :: ys = k ()
     in (y, \y' => ys)
```

It is worth meditating on these definitions. Both of them delete something "and then" spawn a monoid unit to replace it (in category theory this is called a *zero morphism*), and they use the lack of causal flow from the input to the output to move the scopes around in a way that is impossible to do with the other rules.

## Our first program 

The code for this section and the next can be found [here](https://github.com/CyberCat-Institute/Aptwe/blob/main/src/Examples/Differentiation.idr).

From the start of this blog series until now we have been pretty far down the abstraction ladder, far enough that it is hard to remember what the point is. Now we can finally run programs, let's finally return to near the surface by implementing a baby example of automatic differentiation.

There are essentially two main aspects to automatic differentiation. The first is the reverse chain rule, which is the name in calculus for the fundamental computational model of Aptwe. The other is the purely syntactic procedure that associates each primitive element of a program with its reverse derivative, the starting point from which the reverse chain rule differentiates the entire program compositionally. This second thing is not something we can do yet, and in my opinion it is not a feature that belongs in a kernel language, instead belonging in a surface language specialised to differentiable programming. So, we will write a program where each primitive function is "decorated" with its reverse derivative and then the reverse chain rule takes care of the rest.

For now, I have defined *base terms* to be terms that carry around an Idris lens, and the corresponding interpreter cases simply apply the forward and backward passes of that lens as functions:

```haskell
data BaseTerm : All Ty ks -> Ty k -> Type where
  Builtin : (IxAll Cov xs -> (Cov y, Con y -> IxAll Con xs)) -> BaseTerm xs y
```

This is temporary for as long as we are using the prototype interpreter; eventually something much more subtle will be needed here. Using this, we can for example lift functions between doubles into Aptwe terms:

```haskell
sin : Term [BaseTy Real] (BaseTy Real)
sin = BaseTerm $ Builtin $ \[x] => (sin x, \X => [X])

cos : Term [BaseTy Real] (BaseTy Real)
cos = BaseTerm $ Builtin $ \[x] => (cos x, \X => [X])
```

These functions respectively apply sin and cos in the forward pass, and are trivial in the backward pass. Similarly, we can multiply two doubles in the forward pass with the function

```haskell
times : Term [BaseTy Real, BaseTy Real] (BaseTy Real)
times = BaseTerm $ Builtin $ \[x, y] => (x * y, \X => [X, X])
```

It will be useful to have a shorthand for types of "monomorphic" lenses, ie. whose forwards and backwards types are the same, since autodiff functions all have this form:

```haskell
Mono : Ty (True, True) -> Ty (True, True)
Mono a = Tensor a (Not a)
```

Our main goal is to implement a combinator `diff` which takes a term representing a function $f$ and its ordinary derivative $f'$ and combines them as follows. The forward pass is $$f$$ itself, ie. it takes the forward input $$x$$ to the forward output $$f (x)$$. Now we take the equation $$\frac{dy}{dx} = f' (x)$$ and rearrange it to $$\frac{1}{dx} = f' (x) \cdot \frac{1}{dy}$$. The backward pass implements this equation as a function, ie. it takes the forward input $$x$$ and backward input $$\frac{1}{dy}$$ to the backward output $$f' (x) \cdot \frac{1}{dy}$$.

The problem with the following code is that it's incomprehensible for (at least) 2 different reasons:

```haskell
diff : Term [BaseTy Real] (BaseTy Real) -> Term [BaseTy Real] (BaseTy Real)
    -> Term [Mono (BaseTy Real)] (Mono (BaseTy Real))
diff f df = TensorElim Var
          $ Rename (Copy Z $ Insert Id Z $ Insert Id Z $ Empty)
          $ TensorIntro f
          $ NotIntroCov
          $ Rename (Insert Id (S (S Z)) $ Insert Id (S Z) $ Insert Id Z $ Empty)
          $ NotElim Var
          $ Let df
          $ times
```

The first reason is that variables are referred to by their position rather than by name. The second reason is that programming with elimination forms like `TensorElim` and (especially) `NotElim` is just very unintuitive. To be honest, I don't expect anybody to understand it because I don't exactly understand it myself, but it does work. Some highlights are the `Copy` on line 4 which copies the forward input $$x$$ because it is used by both the forward and backward passes, and the last line which is the multiplication of $$f' (x)$$ by the backward input $$\frac{1}{dy}$$.

It was suffering through writing this function (and debugging it, since on my first try I got the 2 inputs to the backward pass the wrong way round) that made me decide to push towards a human-understandable language faster than I originally intended to.

Now, to write a differentiable sin function we just have to say what its derivative is:

```haskell
dsin : Term [Mono (BaseTy Real)] (Mono (BaseTy Real))
dsin = diff sin cos
```

To run `dsin` we need to call `eval` on it, but also pack and unpack some boxes:

```haskell
dtest : Term [Mono (BaseTy Real)] (Mono (BaseTy Real)) 
     -> Double -> (Double, Double -> Double)
dtest t x = let ((y, X), k) = eval t [(x, X)]
             in (y, \dy => let [(X, dx)] = k (X, dy)
                            in dx)
```

## Autodiff

Before we stop we should write a *slightly* less trivial function, just to make sure that we are doing autodiff correctly when we compose things together. Let's write the function $$x \sin x^2$$. Although Aptwe has the chain rule built in, we need to write a differentiable multiplication that contains the essence of the product rule. If you thought `diff` was painful, this one is worse:

```haskell
dtimes : Term [Mono (BaseTy Real), Mono (BaseTy Real)] (Mono (BaseTy Real))
dtimes = TensorElim Var
       $ Rename (Insert Id (S (S Z)) $ Copy Z $ Insert Id Z $ Insert Id Z $ Empty)
       $ TensorElim Var
       $ Rename (Insert Id (S (S Z)) $ Copy Z $ Insert Id (S (S (S Z))) 
               $ Insert Id Z $ Insert Id Z $ Insert Id Z $ Empty)
       $ TensorIntro times
       $ NotIntroCov
       $ Rename (Insert Id (S Z) $ Insert Id (S (S Z)) $ Copy Z 
               $ Insert Id (S (S Z)) $ Insert Id Z $ Insert Id Z $ Empty)
       $ NotElim Var
       $ UnitElim (NotElim Var $ times)
       $ times
```

This calls `times` (our base term for ordinary, non-autodiff multiplication) 3 different times, once in the forward pass for the actual multiplication, and twice more in the backward pass: remember the product rule contains 2 instances of multiplication $$(f \cdot g)' (x) = f (x) \cdot g' (x) + f' (x) \cdot g (x)$$. But notice, there is no corresponding subterm for addition. Instead, there are 3 instances of `Copy`: in order of appearance, 2 to copy each of the forward inputs which are used once each in the forward and backward passes, and 1 more which is actually merging a negative variable. This last `Copy` is actually the addition in the product rule.

There are two pieces of good news. The first is that this function works (I even got this one right first try, although it took me about an hour), and the second is that we are over the hill, everything after this point should be actually understandable.

We can implement squaring in terms of multiplcation by copying the input:

```haskell
dsquare : Term [Mono (BaseTy Real)] (Mono (BaseTy Real))
dsquare = Rename (Copy Z $ Insert Id Z $ Empty)
         $ dtimes
```

Something important is happening here. This `Copy` is being applied to a variable of type `Mono (BaseTy Real)`, which is the tensor product of the forward input and the backward output. Copying a tensor product is copying each part, but copying the negative part is actually a merge, which is addition. So this single `Copy` is a true autodiff copy, which is simultaneously copying in the forward pass and adding in the backward pass. So we never need to specify that the deriative of $$x^2$$ is $$2x$$, and instead we get it as a consequence of the product rule.

Now we have all the pieces for our slightly more complicated example of $$x \sin x^2$$, whose only difficulty is writing without variable names:

```haskell
example : Term [Mono (BaseTy Real)] (Mono (BaseTy Real))
example = Rename (Copy Z $ Insert Id Z $ Empty)
        $ Let (Let dsquare dsin)
        $ dtimes
```

And it works! We can use our testing function from before to verify that the backward pass gives the correct reverse derivative, which is $$\frac{1}{dx} = (\sin x^2 + 2 x^2 \cos x^2) \cdot \frac{1}{dy}$$.

In conclusion, everything works but is absolutely horrendous to program in. In principle this is fine because Aptwe is explicitly intended to be a kernel language and not to be written by humans. But after this experience I have decided to prioritise working towards a prototype frontend language, for demonstration purposes and for the sake of my own sanity. My plan is to build a series of elaboration passes in reverse order of the compiler pipeline:
- Replace elimination forms with patterns (this is particularly important because Aptwe is substructural, so we can't take the easy option of adding primitives for projection out of products)
- Type inference (which is very straightforward right now because Aptwe is still simply typed)
- Scope checking and kind inference (uniquely to Aptwe, I expect these to be interconnected in an interesting way)
- Parsing a concrete syntax

On the other side of the scope checking pass, we will have a language with names rather than positional variables, and this is the point at which programming should become humanly possible.

Separately to this I also want to add some more primitives to the kernel language, particularly linear function types and linear coproducts (the *par* operator of linear logic). The eventual goal is to support algebraic datatypes, but there is still basic research to be done on the theory of datatypes in categories of lenses. Of course we will also need to build in some non-algebraic datatypes, the most obvious example being tensors. My plan is to work on these features in parallel with working on the frontend language, so expect the next few blog posts to alternate between these topics.
