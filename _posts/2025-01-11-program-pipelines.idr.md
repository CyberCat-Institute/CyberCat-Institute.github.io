---
layout: post
title: "Programming Pipelines Using Dependent Types"
author: Andre Videla
date: 2025-01-11
categories: [software engineering, dependent types, compiler]
usemathjax: false
excerpt: "Sometimes, writing a large program is conceptually as simple as translating from a big unstructured input into a more and more structured output. In this post, we present a data structure to talk about such programs and demonstrate its use and flexbility using a single-pass compiler as case-study."

---
<!-- idris

module Data.PipelinePart1

import Data.Vect
import Data.Vect.Quantifiers
import Debug.Trace

data Tree : Type where
data Token : Type where
data Sema : Type where

-->

Sometimes, writing a large program is conceptually as simple as translating from a big unstructured input into a more and more structured output. A good example is a single-pass compiler:

- First we perform lexical analysis on a big string, this gives us a list of tokens.
- Then we parse the tokens into a tree.
- Then we do some semantic analysis on the tree, usually this involves some typechecking and error reporting
- Once we know what the program is, we generate code for it.

## Introducing the pipeline

![Pipeline illustration](/assetsPosts/2025-01-11-program-pipelines/pipeline_illust_mid.png)

This structure is purely linear, and functional programmers will be delighted to point out that you can implement an entire compiler pipeline using nothing but function composition:

```haskell
codegen :: Sema -> String
typecheck :: Tree -> Sema
parsing :: [Token] -> Tree
lexing :: String -> [Token]

compiler :: String -> String
compiler = codegen . typecheck . parsing . lexing
```

Of course this is pure fantasy, there is no error reporting, no way to debug it, and no command line tool. But the core idea is compelling: what if there was a way to implement a compiler as a single pipeline of operation that clearly describes what each step achieves?
For this, we're going to define _pipelined programs_ using Idris, because it uses dependent types, and it is reasonably fast and production ready. We define a _pipeline_ as a list of _Types_, each type represents an intermediate layer.

```idris
Pipeline : Nat -> Type
Pipeline length = Vect length Type

CompilerPipeline : Pipeline ?
CompilerPipeline =
  [ String
  , List Token
  , Tree
  , Sema
  , String
  ]
```

With it, we define a _compiler pipeline_ as the list of types `String`, `List Token`, `Tree`, `Sema`, and `String`, representing all the stages of our compiler.

The pipeline is indexed by it length, to ensure that our pipeline is valid this length needs to be at least 2, since we need a type from which we start, and a type to which we arrive. Using this fact we can define the _implementation_ for a pipeline.

```idris
-- Well formed pipelines have at least 2 elements, the start and the end type
Impl : Pipeline (2 + n) -> Type
Impl (x :: y :: []) = x -> y
Impl (x :: y :: z :: xs) = Pair (x -> y) (Impl (y :: z :: xs))
```

We can test our implementation by asking in the REPL what is a valid implementation of out compiler pipeline.

```
> Impl CompilerPipeline
< (String -> List Token, (List Token -> Tree, (Tree -> Sema, Sema -> String)))
```

This is a 4-tuple of functions `String -> List Token`, `List Token -> Tree`, `Tree -> Sema` and `Sema -> String`, exactly what we wanted, each of those function represents a stage in our compiler.

Now that `Impl` correctly gives us the type of an appropriate implementation for a pipeline, we still need to _run_ the pipeline. Running the pipeline should amount to using function composition on each of the functions. Unfortunately it's not that easy because each intermediate step uses a different type and we can't just blindly apply a function without knowing its type.

Like before, to run a `Pipeline`, it needs at least two elements. Running a pipeline should result in a simple function from the first layer of the pipeline to the last one. To write this we use the function `head` and `last` from `Data.Vect` those functions do exactly what you expect from their name but here we call them to define the type of the function that will result from running the pipeline.

```idris
-- When we run the pipeline `p` we expect to get out a function `head p -> last `p`,
-- that is, the first stage of the pipeline as the argument of the function and the
-- last stage as the result of it.
Run : (p : Pipeline (2 + n)) -> Impl p -> head p -> last p
-- In the base case, the pipeline contains only one stage x -> y so we return it
Run [x, y] f = f
-- In the inductive case, we compose `f` with the rest of the pipeline
Run (s :: t :: x :: xs) (f, cont) = Run (t :: x :: xs) cont . f
```

The base case runs the single stage we have with the argument we're given. The inductive case run the remaining of the pipeline after running the current stage represented by the function `f`.

We can test this idea by assuming we have functions `lex`, `parse`, `typecheck` and `codegen` like in the haskell example and see what happens:

```idris
lex : String -> List Token
parse : List Token -> Tree
typecheck : Tree -> Sema
codegen : Sema -> String

runCompiler : String -> String
runCompiler = Run CompilerPipeline (lex, parse, typecheck, codegen)
```

And it typechecks! We cannot run this code because we don't have an implementation for `lex`, `parse`, etc, but we've at least reached our goal: to build a datastructure that help us keep track of what are the stages in our pipeline.

## Handling effects

This is quite cool, but it's not the end. Remember that compiler need to perform a lot of side effects, returning errors, sometime print out intermediate trees for debugging, how does the pipeline help for that?

Well the great benefit from the pipeline is that we've separated the information about the stages from the information about the runtime implementation of the stages. This information is created by `Impl` which create the type of an implementation given a pipeline, but this current version only places the types end-to-end without changes. What if we add an extra `Monad` around the types such that instead of functions `a -> b`, each stage is now an effectful function `a -> m b`.

First we define `m : Type -> Type`, our monad, we use a parameter block because we will use it for running our programs too.

```idris
parameters {0 m : Type -> Type}
```

Then, in the implementation, we use the same type signature, but in the base-case, instead of returning `x -> y`, we return `x -> m y`. And similarly with the inductive case.
```idris
  0
  ImplM : Pipeline (2 + n) -> Type
  ImplM [x, y] = x -> m y
  ImplM (x :: y :: z :: xs) = Pair (x -> m y) (ImplM (y :: z :: xs))
```

Like before, we now test `ImplM` in the repl with a monad `Maybe` and we get:

```
> ImplM {m = Maybe} CompilerPipeline
< (String -> Maybe (List Token), (List Token -> Maybe Tree, (Tree -> Maybe Sema, Sema -> Maybe String)))
```

Now every stage runs in a `Maybe` monad, and we could replace this monad by anything else and obtain all sorts of effects.
It remains to run a pipeline with effects using our effectful implementation. We implement a function just like `Run` but we make use of _kleisli_ composition instead of function composition.

```idris
  RunM : (mon : Monad m) => (p : Pipeline (2 + n)) -> ImplM p -> Vect.head p -> m (Vect.last p)
  RunM [x, y]  f = f
  RunM (x :: y :: z :: xs) (f, c) = f >=> RunM (y :: z :: xs) c
```

To run the compiler, each stage needs to perform an effect, here we're using `Either String` to represent errors:

```idris
namespace EffectfulCompiler
  lex : String -> Either String (List Token)
  parse : List Token -> Either String Tree
  typecheck : Tree -> Either String Sema
  codegen : Sema -> Either String String

  runCompiler : String -> Either String String
  runCompiler = RunM CompilerPipeline (lex, parse, typecheck, codegen)
```

Crucially, we've not changed the pipeline at all! We've only changed how to interpret it as a runtime program.

## Debugging programs

Finally, using the same datastructure we can run our pipeline in _debug mode_. This mode will print in the terminal all the intermediate steps so that you can see what is happening at each stage. For this to work, we need to make sure that, for all layers in the pipeline, we have a way to _print_ the result of the computation, we achieve this with the `All : (ty -> Type) -> Vect n ty -> Type` type which takes a list of elements and a predicate over that list, and describes a list of proofs that ensure the predicate hold for every value of `ty` given. In our case, the predicate given is the `Show` interface, and so for each type there must exist a `Show` instance.

The rest of the function is the same as before, except we compose each `f` with `pure . traceValBy show` to print the value we just computed.

```idris
RunTraceM : Monad m => (p : Pipeline (2 + n)) -> (print : All Show p) => ImplM {m} p -> Vect.head p -> m (Vect.last p)
RunTraceM [x, y] {print = [p1, p2]} f = f >=> pure . traceValBy show
RunTraceM (x :: y :: z :: xs) {print = p :: q :: ps} (f, c) =
  f >=> pure . traceValBy show >=> RunTraceM (y :: z :: xs) c
```

Calling our pipeline with `RunTraceM` will print out every intermediate value produced by the pipeline, It won't print the first argument given to it but since we already have it, we can print it when we call the pipeline.

## Conclusion

There is much more to say about this but is already more than we can usually do without dependent types. We can take the pipeline and build multiple runtimes for it, and run it in multiple modes as well. I've not shown it here but we can also implement operations on the pipeline like concatenation, splicing, etc. Those operations should reflect what happens at runtime: Concatenating two pipeline should compose two programs that run them. This framework can be extended in many other ways but that will serve as a solid base for now, see you in the next one.

The code is available as a library: https://gitlab.com/glaive-research/pipelines

