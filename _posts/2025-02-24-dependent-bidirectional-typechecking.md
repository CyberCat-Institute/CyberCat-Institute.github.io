---
layout: post
title: "Bidirectional Typechecking with Dependent Lenses"
author: Andre Videla
date: 2025-02-24
categories:
usemathjax: true
excerpt: "Bidirectional Type checking as a lens is possible, and makes use of monadic traversals. Can we do the same with dependent lenses? We sure can! It turns out the equivalent representation is the Kleene star on containers and we are going to use it to rebuild the same bidirectional typechecker using dependent lenses only."
---

<!-- idris
module Blog.Bidirectional

import Data.Product
import Data.Coproduct
import Data.Either
import Data.Container
import Data.Container.Kleene
import Data.Container.Pipeline
import Data.Container.Descriptions.Maybe
import Data.Container.Morphism.Closed
import Data.Container.Morphism.Effect
import Data.Sigma
import Pipeline.Category
import Control.Category
import Deriving.Show

import Derive.Prelude
import Debug.Trace

%language ElabReflection
private infixr 9 *
%hide Prelude.Ops.infixl.(*)
%hide Language.Reflection.TTImp.Mode

data S : String -> Type where
  MkS : (name : String) -> S name

fromString : (s : String) -> S s
fromString = MkS

%default total
-->

In this post, I will reproduce [Jules' implementation][BLOGPOST]
of bidirectional
type checking using _dependent lenses_ instead of van Laarhoven (VLH) lenses. We are going to see how
to build and adapt a program build from the ground up using lenses and how to manipulate the types
involved to achieve our goal. The previous blog post did that and uncovered _monadic traversals_.
We are going through a similar journey, showing off different monads and functors on containers
along the way.

## Finding the right types

The first step is to reproduce the same language structure in Idris,
we define the types for the lambda calculus, and its two classes of terms
checkable terms and synthesizable terms.


```idris
data Ty = TVar String | Unit | Function Ty Ty

%runElab derive "Ty" [Eq]

data Mode = Synthesizable | Checkable

data Term : Mode -> Type where
  Var : String -> Term Synthesizable
  App : (fn : Term Synthesizable) -> (arg : Term Checkable) -> Term Synthesizable
  Down : Ty -> Term Checkable -> Term Synthesizable
  Lambda : (name : String) -> Term Checkable -> Term Checkable
  Up : Term Synthesizable -> Term Checkable

```

<!-- idris
Show Ty where
  show (TVar x) = x
  show (Function x y) = show x ++ " -> " ++ show y
  show Unit = "1"

parens : String -> String
parens x = "(" ++ x ++ ")"

pIf : Bool -> String -> String
pIf True = parens
pIf False = id

printTerm : (parens : Bool) -> Term m -> String
printTerm b (Var str) = str
printTerm b (App x@(App _ _) z) = pIf b "\{printTerm False x} \{printTerm True z}"
printTerm b (App x y) = pIf b "\{printTerm True x} \{printTerm True y}"
printTerm b (Down ty term) = pIf b "\{printTerm False term} : \{show ty}"
printTerm b (Lambda str x) = pIf b "λ\{str}. \{printTerm False x}"
printTerm b (Up x) = printTerm b x


Show (Term m) where
  show = printTerm False
-->

A context is a list of names and their associated types.

```idris
Context : Type
Context = List (String, Ty)
```

Questions are either "can we synthesize the type of this term" or
"can we check that this term has this type".

```idris
data Question =
  Syn Context (Term Synthesizable) | Check Context Ty (Term Checkable)
```

<!-- idris
%runElab derive "Question" [Show]
-->

An answer is either a synthesized type, or a confirmation that the
check went through.

```idris
data Answer = Synthesized Ty | Checked
```

The boundary of each lens is a question-answer pair, we represent this as
a container with a constant fibre. The `(:-)` operator is a smart constructor
for such containers.

```idris
TC : Container
TC = Question :- Answer
```

The first attempt is to model our type checker with a morphism
from question-answer pairs to other question-answer pairs:
`TC =%> TC`.


### The $Up$ Rule

With it we can  start implementing each rule, let's start with
the $Up$ rule. We're going to use [closed lenses][CLOSED] to more
accurately represent the _continuation_ nature of lenses.

<!-- idris
partial
-->
```idris
upRule : Closed TC TC
upRule = MkClosed $ \case
  (Check ctx ty (Up term)) =>
     (Syn ctx term) ##
       (\case (Synthesized ty') =>
                if ty == ty' then Checked else ?error1
              _ => ?error2)
```

Looking at `error1` we see that we are required to return an `Answer`
even when it does not make sense to do so. In that case, whenever
the types do not match, we should not return an answer but an error
instead.

```
   term : TermSyn
   ty : Ty
   ctx : List (String, Ty)
   ty' : Ty
------------------------------
error1 : Answer
```

Because the error occurs only when returning answers, we can use
the _lift_ operation on containers to wrap responses in a monad.

The corrected type is

<!-- idris
partial
-->
```idris
upRuleOk : Closed (Either String • TC) TC
upRuleOk = MkClosed $ \case
  (Check ctx ty (Up term)) =>
     (Syn ctx term) ##
       (\case (Synthesized ty') =>
                if ty == ty' then pure Checked else Left "type mismatch"
              _ => ?error)
```
This is a small win in expressivity because we do not need to
pollute our `Answer` type with a dummy error value.

We're not done however, the `error` hole requires us to return an answer or an error,
but really, neither
should happen. This branch will only be taken if we receive an answer that is not
a `Synthesized` answer, but because we asked a `Syn` question, we should only
ever obtain `Synthesized` answer.
We could fill the hole with a value `Left "should never happen"` but
surely we can do better.

```
   term : TermSyn
   ty : Ty
   ctx : List (String, Ty)
------------------------------
error : Either String Answer
```

To address this, we change the type of
`Answer` to be indexed over the type of questions such that we
always get the answer we expect from the question we asked.

```idris
data SafeAnswer : Question -> Type where

  -- For any synthesized type there is a type and the details of its syn question
  SynAnswer : Ty -> SafeAnswer (Syn ctx term)

  -- For any checked answer there is a `Check` question
  CheckAnswer : SafeAnswer (Check ctx ty term)
```

<!-- idris
%hint
showSafe : Show (SafeAnswer q)
showSafe = %runElab Show.derive
-->


Our new container of question-answers makes use of safe answers
to avoid the additional ambiguity introduced in the backward
part of each lens.

```idris
Typecheck : Container
Typecheck = (q : Question) !> SafeAnswer q
```

With this we can review our up-rule and remove the need for
throwing an error when the answer is not the one expected.

We also define `TCErr = Either String` to simplify our type signature.

<!-- idris
TCErr : Type -> Type
TCErr = Either String
%default partial
-->

```idris
upRuleFinal : Closed (TCErr • Typecheck) Typecheck
upRuleFinal = MkClosed $ \case
  (Check ctx ty (Up term)) =>
     (Syn ctx term) ##
       (\case (SynAnswer ty') =>
                if ty == ty' then Right CheckAnswer else Left "type mismatch")
```

### The $Var$ Rule

Moving on to the $Var$ rule, it looks up
the type in context and returns it. If the variable is not found, an error is emitted.

```idris
varRule : Closed (TCErr • Typecheck) Typecheck
varRule = MkClosed $ \case
  (Syn ctx (Var str)) =>
     ?noQuestion ## \_ => case lookup str ctx of
                   Just ty => pure (SynAnswer ty)
                   Nothing => Left "unbound variable \{str}"
```

The problem with this rule is that it does not ask any
more questions, it ends immediately and returns the answer.
If we look at the hole `noQuestion`, we see that it requires a
question but there is no way to say "we're done here, no more questions"

```
   str : String
   ctx : List (String, Ty)
------------------------------
noQuestion : Question
```

To express the fact that we might run out of question, the type
will need to be a `Maybe` monad on _container_ such that
if there is a question, then there will also be an answer. Otherwise
there is no answer comming back and we're expected to produce one
ourselves, which is exactly what the $var$ rule does.

The maybe monad on containers is written `MaybeAll` and so the
function becomes:

```idris
varRule2 : Closed (TCErr • Typecheck) (MaybeAll Typecheck)
varRule2 = MkClosed $ \case
  (Syn ctx (Var str)) =>
     Nothing ## \_ => case lookup str ctx of
                   Just ty => pure (SynAnswer ty)
                   Nothing => Left "unbound variable \{str}"
```

The argument of the continuation is a unit value so we can safely ignore it.

### The $App$ Rule

Next we implement the $App$ rule, for it to work, we need to
synthesize the type of the function, then check that its domain
matches the type of the argument, and return the type of the
codomain.

```idris
appRule : Closed (TCErr • Typecheck) (MaybeAll Typecheck)
appRule = MkClosed $ \case
   (Syn ctx (App fn arg)) =>
     Just (Syn ctx fn) ##
       (\case { (Aye (SynAnswer (Function a b))) => ?checkTypes
              ; (Aye arg) => Left "not a function"
              })
```

However, we get stuck on `checkType`. We're asked to produce a value
of type `Either String (SafeAnswer (Syn ctx (App fn arg)))` but this can
only be produced by another call to the type checker.

```
   arg : TermChk
   fn : TermSyn
   ctx : List (String, Ty)
   b : Ty
   a : Ty
------------------------------
checkTypes : Either String (SafeAnswer (Syn ctx (App fn arg)))
```

To represent the fact that rules can sequence multiple question-answers
we use the _kleene star on containers_. This construction is equivalently
known as the free monoid on $\circ$ where $\circ$ is the composition of containers.
The Kleene star is called
`Star : Container -> Container` here, and with it, the app rule can be written as
follows.

```idris
appRule2 : Closed (TCErr • Typecheck) (Star Typecheck)
appRule2 = MkClosed $ \case
   (Syn ctx (App fn arg)) =>
     More (Syn ctx fn)
       (\case { (SynAnswer (Function a b)) =>
                 More (Check ctx a arg)
                      (const Done)
              ; y => Done
              })
       ## \case (StarM (SynAnswer (Function a b)) (StarM CheckAnswer StarU)) => pure (SynAnswer b)
                (StarM (SynAnswer _) _) => Left "not a function"
```

The question part of this lens is the most interesting so we'll go through it line by line:

- `More (Syn ctx fn)`: First ask a question `Syn ctx fn` to synthezise the type of the
  function.
- `(\case { (SynAnswer (Function a b)) =>`: Match on the answer and ensure we got a function back
  - `More (Check ctx a arg)`: Knowing that it is a function, check the type of the argument agains
    the type `a`.
  - `(const Done)`: After that, we're done, no more questsions.
- `; y => Done`: In case the synthesized type wasn't a function, no more questions.

When handling responses, we merely decompose the response, ensure that we get a function
and return an error if we do not.

## Putting It All Together

Other rules pose no additional challenge, therefore the final rules of the simply typed lambda calculus
can be written using a lens `TCErr • Typecheck =%> Star Typecheck`.

<!-- idris
%default total
-->

```idris
rules : TCErr • Typecheck =%> Star Typecheck
rules = fromClosed $ MkClosed $ lamRules
  where
    lamRules : (x : Question) -> Σ (StarShp Typecheck) (\y => StarPos Typecheck y -> Either String (SafeAnswer x))
    -- Var rule
    lamRules (Syn ctx (Var str))
      = case lookup str ctx of
             Just ty => Done ## (const (pure (SynAnswer ty)))
             Nothing => Done ## (const (Left "Undeclared variable \{str}"))

    -- App rule
    lamRules (Syn ctx (App fn arg))
      = More (Syn ctx fn)
          (\case { (SynAnswer (Function a b)) =>
                    More (Check ctx a arg)
                         (const Done)
                 ; y => Done
                 })
          ## \case (StarM (SynAnswer (Function a b)) (StarM CheckAnswer StarU)) =>
                       pure (SynAnswer b)
                   (StarM (SynAnswer t) _) =>
                       Left "Expecting \{show fn} to be a function, instead it has type \{show t}"

    -- Up rule
    lamRules (Check ctx ty (Up term))
     = singleton (Syn ctx term) ##
       (\case (StarM (SynAnswer ty') _)
              => if ty == ty'
                    then pure CheckAnswer
                    else Left """
                      Expecting \{show term} to have the type \{show ty}
                      instead I found it has type \{show ty'}
                      """)
    -- Down rule
    lamRules (Syn ctx (Down ty val))
      = singleton (Check ctx ty val) ## \(StarM CheckAnswer StarU) => pure (SynAnswer ty)
    -- Lambda rule
    lamRules (Check ctx (Function a b) (Lambda nm term))
      = singleton (Check ((nm, a) :: ctx) b term) ## \(StarM CheckAnswer StarU) => pure CheckAnswer
    lamRules _ = Done ## const (Left "oops")
```

To run the typechecker we need to make
sure it has the shape `a =%> Star a`. We do this by first defining an appropriate
type alias `TCF = TCErr • Typecheck` which stands for "TypeCheckFail". Then
we use the fact that the `•` operator forms a _comonad_ and use the comultiplication
to build the lens `TCF =%> Star TCF`. Additionally, `TCErr • _` commutes with `Star` so
by going from `TCF` to `TCErr • TCF` via a comultiplication, and then mapping across our typechecker to obtain
`TCErr • Star Typecheck` and then distributing around `TCErr` we end up
with `Star (TCErr • Typecheck)` which is the same as `Star TCF`.

```idris
TCF : Container
TCF = TCErr • Typecheck

typecheck' : TCF =%> Star TCF
typecheck' = comultM {a = Typecheck}
    |%> mapLift' {a = TCF, b = Star Typecheck} rules
    |%> commuteEitherStar
```

With this, we can loop our typechecker using the `loop : a =%> Star a -> Star a =%> CUnit` combinator.
This function takes a lens `a =%> Star a` and will run itself as long as it is fed some input,
as soon as the input is spent, it will stop with the final result.

```idris
covering
typechecker : TCF =%> CUnit
typechecker = typecheck' |%> loop typecheck'
```

Finally, this lens gives rise to a function `(q : Question) -> Either String (SafeAnswer q)` by means of a _costate_.

```idris
covering
runTypechecker : (q : Question) -> Either String (SafeAnswer q)
runTypechecker = runCostate typechecker

covering
printTypechecker : Question -> String
printTypechecker q = show (runTypechecker q)
```

`printTypechecker` makes the output readable, and with it we can start typechecking programs.
Here is $(\lambda y. y : a \to a) x$ with `[x : a]` in the context.

```idris
program1 : Question
program1 = Syn [("x", TVar "a")]
             $ App (Down (Function (TVar "a") (TVar "a")) (Lambda "y" (Up (Var "y"))))
                   (Up (Var "x"))
```

We call the typechecker in the repl and obtain the reponse immediately

```
$ :exec putStrLn (printTypechecker program1)
> Right (SynAnswer a)
```

Checking an incorrect program $(x\ x)$ produces the appropriate error.

```idris
program2 : Question
program2 = Syn [("x", TVar "a")]
             $ App (Var "x")
                   (Up (Var "x"))
```

```
$ :exec putStrLn (printTypechecker program2)
> Left "Expecting x to be a function, instead it has type a"
```

## Conclusion

Just like the non-dependent version, we need to worry about how to sequence operations
in our typechecker. Instead of _monadic traversals_ we use the Kleene star on container
to achieve the same thing. This suggests that there is an additional relationship in the
correspondance between VLH lenses and dependent lenses:

| VLH lenses        | Dependent lenses  |
| ----------------- | ----------------- |
| Traversal         | List monad        |
| Affine Traversal  | Maybe monad       |
| Monadic Traversal | Kleene star       |

[CLOSED]: https://gitlab.com/avidela/types-laboratory/-/blob/main/src/Data/Container/Morphism/Closed.idr?ref_type=heads#L17
[BLOGPOST]: https://cybercat.institute/2025/01/28/bidirectional-typechecking/
