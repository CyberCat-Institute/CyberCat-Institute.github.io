
A big part of programming language design is in feedback delivery. One aspect of feedback is parse errors. Parsing is a very large area of research and there are new development from industry that make it easier and faster than ever to parse files. This post is about an application of dependent lenses which facilitate the job of reporting error location from a parsing pipeline.

## What is parsing & Error reporting

A simple parser could be seen as a function with the signature

```
parse : String -> Maybe output
```

where `output` is a parsed value. 

In that context, an error is represented with a value of `Nothing` and a successful value is represented with `Just`. However, in the error case, we don't have enough information to create a helpful diagnostic, we can only say "parse failed" but we cannot say why or where the error came from. One way to help with that is to make the type aware of its context and carry the error location in the type:

```
parseLoc : string -> Either Loc output
```

Where `Loc` holds the file, line and column of the state of the parser. 
This is a very successful implementation of parser with locations and many languages deployed today use a similar architecture where the parser, and its error-reporting mechanism, keep track of the context in which they are parsing files and use it to produce helpful diagnostic.

I believe that there is a better way, one which does not require a tight integration between the error-generating process (here parsing) and the error-reporting process (here, location tracking). For this, I will be using container morphisms, or dependent lenses, to represent parsing and error reporting.

## Dependent lenses

Dependent lenses are a generalisation of lenses where the backward part makes use of dependent types in order to keep track of the origin and destination of arguments. For reference the type of a lens `Lens a a' b b'` is given by the two functions:

- `get : a -> b`
- `set : a -> b' -> a'`

Dependent lenses follow the same pattern, but their types are indexed:
```
record DLens : (a : Type) -> (a' : a -> Type) -> (b : Type) -> (b' : b -> Type) where
  get : a -> b
  set : (x : a) -> b' (get x) -> a' x
```

The biggest difference with lenses is the second argument of `set`: `b' (get x)`. It means that we always get a `b'` that is indexed over the result of `get`, for this to typecheck, we _must know_ the result of `get`.

This change in types allows a change in perspective. Instead of treating lenses as ways to convert between data types, we use lenses to convert between query/response APIs. 

```tikz
\begin{document}
\begin{tikzpicture}

\draw (5.0,0) rectangle (8.0,2);
\draw[->] (8, 1.5) -- (8.5,1.5) node [right] {B (query)};
\draw[<-] (8, 0.5) -- (8.5,0.5) node [right] {B' (response)};
\draw[->] (4.5, 1.5) node [left] {A (query)}  -- (5.0,1.5) ;
\draw[<-] (4.5, 0.5) node [left] {A' (response)}  -- (5.0,0.5) ;
\end{tikzpicture}
\end{document}
```

On each side `A` and `B` are queries and `A'` and `B'` are _corresponding responses_. The two functions defining the lens have type `get : A -> B`, and `set : (x : A) -> A' (get x) -> B' x`, that is, a way to convert queries together, and a way to _rebuild_ responses given a query. A lens is therefore a mechanism to map between one API to another.

If the goal is to find what line did an error occur, then what the `get` function can do is split our string into multiple lines, each of which will be parsed separately.

```
splitLines : String -> List String
```

Once we have a list of string, we can call a parser on each line, this will be a function like above `parseLine : String -> Maybe output`. By composing those two functions we have the signature `String -> List (Maybe output)`. This gives us a hint as to what the response for `splitLine` should be, it should be a list of potential output. If we draw our lens again we have the following types:

```tikz
\begin{document}
\begin{tikzpicture}

\draw (5.0,0) rectangle (8.0,2);
\draw[->] (8, 1.5) -- (8.5,1.5) node [right] {List (String)};
\draw[<-] (8, 0.5) -- (8.5,0.5) node [right] {List (Maybe output)};
\draw[->] (4.5, 1.5) node [left] {String}  -- (5.0,1.5) ;
\draw[<-] (4.5, 0.5) node [left] {String}  -- (5.0,0.5) ;
\end{tikzpicture}
\end{document}
```

We are using `(String, String)` on the left to represent "files as inputs" and "messages as outputs" both of which are plain strings.

There is a slight problem with this, given a `List (Maybe output)` we actually have no way to know which of the values refer to which line. For example, if the output are numbers and we the input is the file
```
23

24
3
```

And we are given the output `[Nothing, Nothing, Just 3]` we have no clue how to interpret the `Nothing` and how it's related to the result of splitting the lines, they're not even the same size. We can "guess" some behaviors but that's really flimsy reasoning, ideally, the API translation system should keep track of that so that we don't have to guess what's the correct behavior. And really, it should be telling us what the relationship is, we shouldn't even be thinking about this.

So instead of using plain lists, we are going to keep the information _in the type_ by using dependent types. The following type keeps track of an "origin" list and its constructors store values which fulfill a predicate in the origin list along with their position in the list:

```
data Some : (a -> Type) -> List a -> Type where
  None : Some p xs
  This : p x -> Some p xs -> Some p (x :: xs)
  Skip :        Some p xs -> Some p (x :: xs)
```

We can now write the above situation with the type `Some (const Unit) ["23", "", "24", "3"]` with the value `Skip $ Skip $ Skip $ This () None` which says only the last element is relevant to us. This ensure that we always have responses which take into account every single element from the query and explain how the response relates to the query.

Once we are given a value like the above we can convert our response into a string that says `"only 3 parsed correctly"`.

## A Simple parser

Equipped with dependent lenses, and a type to keep track of partial errors, we can start writing a parsing pipeline that keeps track of locations without interfering with the actual parsing. For this, we start with a simple parsing function:

```
containsEven : String -> Maybe Int
containsEven str = parseInteger >>= \i => fromBool i (even i)
```

This will return a number if its even, otherwise it will fail. From this we want to write a parser that will parse an entire file, and return errors where the file does not parse. We do this by writing a lens that will split a file into lines and then rebuild responses into a string such that the string contains the line number:

```
splitFile : (String :- String) =%> SomeM (String :- Int)
splitFile = MkMorphism unlines rebuild
  where
    rebuild : (x : String) -> (Some (const Int) (unlines x)) -> String
```

The `rebuild` implementation is eluded for brevity but its type is important. It says that given some input string, and some subset of succeeding responses, we can build a response string. In particular our response string must look like:

```
At line 3: could not parse "test"
At line 10: could not parse "-0.012"
At line 12: could not parse ""
```

We are now ready to put the parts together, the parser, and the line tracker. We do this by composing them into a larger lens via lens composition, and then extracting the procedure from the larger lens. First we need to convert our parser into a lens.

Any function `a -> b` can also be written as `a -> () -> b` and any function of that type can be embedded in a lens `(a :- b) =%> (() :- ())`. That's what we do with our parser and we end up with this lens:

```
parserLens : (String :- Maybe Int) =%> CUnit
parserLens = embed parser
```

We can lift any lens with a failible result into one that keeps track of the origin of the failure:

```
lineParser : SomeC (String :- Int) =%> CUnit
lineParser = liftSome parserLens
```

We can now compose this lens with the one above that adjusts the error message using the line number:

```
composedParser : (String :- String) =%> CUnit
composedParser = splitFile |> lineParser
```


Knowing that a function `a -> b` can be converted into a lens `(a :- b) =%> CUnit` we can do the opposite, we can convert any lens with a unit codomain into a simple function, which gives use a very simple `String -> String` program:

```
mainProgram : String -> String
mainProgram = extract composedParser
```

which we can run as part of a command-line program

```
main : IO ()
main = do putStrLn "give me a file name"
          fn <- readLine
          fileContent <- readFile fn
          let output = mainProgram fileContent
          putStrLn output
          main 
```

And given the file:

```
0
2

-4
20
04
1.2
```

We see: 

```
At line 3: Could not parse ""
At line 4: Could not parse "-4"
At line 7: Could not parse "1.2"
```

## Handling multiple files

The program we've seen is great but it's not super clear why we would bother with such level of complexity if we just want to keep track of line numbers. Here we see how to approach scales by adding support for multiple file locations.

If you wrote a parser that keeps track of the line number, it might not keep track of what file the line came from. Again, the thesis of this post is that the parse should not concern itself with that issue. It should only parse and error reporting is deferred to an external process.

We do just that, by writing a lens that will take a list of files, and their content, and keep track of where errors emerged using the same infrastructure as above.

First we define a filesystem as a mapping of file names to a file content:

```
Filename = String
Content = String
Filesystem = List (Filename * Content)
```

A lens that splits problems into files and rebuilds errors from them will have the following type:

```
handleFS : Interpolation output => 
    (Filesystem :- String) =%> SomeC (Content :- output)
handleFS = MkMorphism (map π2) handleResponses
  where
    handleResponses : (x : Filesystem) -> Some (const output) (map π2 x) -> String
```

Again, we don't write down the implementation of handleResponse, but its type says it all: given a filesystem, and some partial results, generate a string which represents the errors given for each file.

Combining this lens with the previous parser is as easy as before:

```
filesystemParser : (Filesystem :- String) =%> CUnit
filesystemParser = handleFS |> map splitFile |> join |> lineParser

fsProgram : Filesystem -> String
fsProgram = extract filesystemParser
```

We can now write a new main function that will take a list of files and return the errors for each files:

```
main2 : IO ()
main2 = do files <- askList
           fileContents <- traverse (\fn => (fn,) <$> readFile fn) files
           let result = fsProgram fileContents
           putStrLn result
```

we can now write two files:
file1

```
0
2

-4
20
04
1.2
```

file2:

```
7
77
8
```

and obtain the error message:

```
In file 'file1':
At line 3: Could not parse ""
At line 4: Could not parse "-4"
At line 7: Could not parse "1.2"

In file 'file2':
At line 1: Could not parse "7"
At line 2: Could not parse "77"
```

All that without touching our original parser, nor our line tracking system.

## Conclusion

We've only touched the surface of what dependent lenses can do for software engineering by providing a toy example. Yet, this example is simple enough to be introduced, and resolved in one post, but also shows a solution to a complex problem that is affecting parsers and compilers across the spectrum of programming languages. In truth, dependent lenses can to much more than what is presented here, they can deal with effects, non-deterministic systems, machine learning, and more. One of the biggest barrier to mainstream adoption is the availability of dependent types in programming languages. The above was written in [idris](https://www.idris-lang.org/) a language with dependent types, but if your language of choice adopts dependent types one day, then you should be able to write the same program as we did just now, but for large-scale production software.
