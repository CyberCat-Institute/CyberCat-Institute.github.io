# Blog post on UI frameworks using Para(Optic)

Lenses model a new paradigm of programming based on bidirectional processses. Recently Andre Videla has figured out how use them to implement RESTful servers [link], and as we will see in this blog post, they can also capture UIs. 

In this blog post we will look at UI frameworks like React and The Elm Architecture[link] and see how to express them using parametrised lenses. 

This is not the first time that lenses were applied to UIs (link to purescript lib), however there's been a lot more work on understanding the category theory of lenses since then, especially parametrised lenses, and we will see how this new understanding gives us even more expressive power than before.  

Bidirectional programming for component-based architectures follows a simple design pattern - information flows from parent to child components, and actions flow back from child to parent. 

This is already different to how older top-down software architectures worked, but is in line with how modern React-based UI frameworks mediate between parent and child components. 

In React terminology the signals flowing from parent to child are called "props", and we can use callbacks to pass the response from a child to parent. 

In addition to props, React components have a notion of internal state, which remains hidden from other components. The key idea is that rather than exposing the state itself, a component will only expose props *derived* from the state, which is what the child components will use in their logic. 

If we take a stateless view, our picture would look somewhat like this lens. 

<Pic1>
[WebApp component -> List component -> List item    --- Props 
 WebApp Action   <-  list action    <- list clicked] -- Actions/Callbacks

Looking at it this way, we can see that this describes a bidirectional process. 
A web-app component will have access to the top-level prop, it will then pass a list to the list component, and the list component will pass each individual item to its own child component. 
Whenever an item is clicked, it will then pass on an action upwards up the hierarchy. 

In lens terms, we would have something like this: 

(AppProps, AppAction) -> (ListComponent, ListAction) -> (ItemComponent, ClickAction) 

Lens (x, dx) (y, dy) = (x -> y, x -> dy -> dx)

The forwards pass is determined by the flow of information from the parent prop, and the backwards pass is determined by the child responding to the parent. 

Of course in a functional world, with neither state nor effects, this becomes rather trivial. Props are immutable signals, so a child component can't ask the parent to actually *change* a prop. We would either need to make the information contained in the props mutable, or add some kind of notion of effect. 

Because this picture is rather limiting, languages like Elm take an entirely different approach and take state as primitive. A basic component in Elm would have a view function and an update function, and it's not hard that the two form a lens:

view : Model -> Html Msg 
update : Model -> Msg -> Model 

In fact, because the update function takes a model to a model, we can see that this is actually a special kind of a lens, known as a Moore machine.  

Moore : (state, state) (output, input)

state -> output 
state -> input -> state

Moore machines give you a lot of expressivity, but they also have a significant limitation - they don't compose by lens composition. This means that if we have two separate components it's easy to put them side-by-side using parallel composition, but there's no way to talk about sub-components of a bigger component. 

(Moore machines *can* compose with lenses to the left- and right- though, something we'll talk about in a future blog post on reparametrisation). 

So taking immutable props as primitive causes the framework to trivialise, and taking encapsulated state as primitive causes it to lose compositionality. Is there any way out? 

Early experiments with [optic-based UI frameworks](https://github.com/zrho/purescript-optic-ui/tree/master) tried to answer this question by weakening the requirement that state must remain encapsulated within a component. Instead, a parent components would expose parts of its state to its children, which would then be able to act on it. 

This means that we would get a picture much like before, but now the state will be mutable. 
(AppState, AppAction) -> (ListState, ListAction) -> (ItemState, ClickAction)

The nice thing about this approach is that components can now be composed using lens composition. 

Let's say we have the following interfaces 

App = (AppState, AppUpdate) 
List = (ListState, ListUpdate)
Item = (ItemState, ItemUpdate)

This gives us the following lenses

App => List, List => Item 

with the corresponding getters and setters
Lens App => List 
fwd1 : AppState -> ListState 
bwd1 : AppState -> ListUpdate -> AppUpdate 

Lens List => Item 

fwd2 : ListState -> ItemState 
bwd2 : ListState -> ItemUpdate -> ListUpdate 

Their composition will give you the lens
(fwd1, bwd1) . (fwd2, bwd2) : (AppState -> ItemState, AppState -> ItemUpdate -> AppUpdate)

In other words, knowing how to propagate information from one parent to a child, we get the propagation along a hierarchy. 

Unlike the Elm model, this gives you hierarchical composition of components. But now we've lost one of the core principles of software development by exposing state across the entire application. 

Is there a way to get the best of both worlds, to retain hierarchical composition of components while encapsulating state? 

As we've seen so far, we want components to compose like lenses, but retain internal state. Is there a notion of "Lens with an internal state"? This is exactly what the Para construction does.

It turns out that there is, using the Para(Optic) construction that we've seen in a [previous blog post](https://cybercat.institute/2024/04/15/neural-network-first-principles/). What's more surprising, is that this construction gives you back exactly the React model. 

### React was right all along

How should state be organized? This is one of the fundamental questions of UI development. React takes this question further and asks "How should information flow within an application be structured?" 

So far the models we've looked at have *either* worked with immutable props or mutable state. But what if we work with both? 

React's big insight was that a component has access to its own props and state, and the information it passes to its children is immutably derived from these:

fwd : (ParentProp, ParentState) -> ChildProp 

On the other hand, when a component receives an update from a child, it now does two things: it can pass along a request to its own parent, or it can update its internal state. 

bwd : (ParentProp, ParentState, ChildAction) -> GrandParentAction 

update : (ParentProp, ParentState, ChildAction) -> ParentState 

If we combine backwards and update into a single function, 

(ParentProp, ParentState, ChildAction) -> (GrandParentAction, ParentState)

We will see that this is exactly the same as the Para construction over lenses, which gives us the morphisms:

fwd : (a, p) -> b 
bwd : (a, dp, db) -> (da, dp)

<image of one Para(Lens) component>

More importantly, composition of parametric lenses gives us composition of stateful components:

<image of composition in Para(Lens)>

## Conclusion

We've looked at how we can use lenses to model several popular UI frameworks, as well as seen how the lens-based approach has evolved over the years. Our main takeaway is that lenses by themselves have always had something missing that kept them from being a truly powerful approach to UIs. And the claim that will be made in the subsequent posts in this series is that Para is exactly the structure that we've been missing. In the next few posts we will also see that Para is not only good for modelling state boundaries, but can be applied to modeling the boundaries of user input/output as well as async calls.


- State needs to be granular and statically specified
- State should be optional in any component
- State shouldn't leak to other components
- State should not be updated directly, it should be handled by action handlers (redux).
- It should be easy to see exactly what state is required by a component, regardless of where the state is stored. 
- Whether the state is stored fully locally inside the component or fully globally inside a giant redux store (find react lib) or anywhere inbetween should be seen as an implementation detail and not affect the logic inside the component. 

The first four are fairly easy to achieve, but the last two is tantamount to the holy grail of state management - and as we will see in the next section, it is entirely achievable. 

It's worth mentioning why exactly that's such an important point, and anyone whose worked on a truly large React application will have encountered it. I first came across it back when working for the Health and Safety Lab of the UK Civil service. 

When working on a small to medium sized application most state management applications will do the trick. But as the application starts getting *large*, you need to start being a lot more principled. Frameworks like (redux store library) allow you to centralize the state, and make it a lot more easy to manage. 

But as the program grows even larger, and the component graph even deeper, this too starts showing its cracks. If the decision was made to centralize *all* state, then what about purely local state like a counter for how many times a button was clicked? Does it really need to be centralized and then threaded through the entire app? Each time it passes through the component it needs to be explicitly declared on the boundaries. But keeping local state *occasionally* means that we lose the main benefit of centralization - single source of truth - and it will be a lot harder to tell where some particular piece of state comes from. As we shall soon see, this problem is indeed solvable with our approach. 

