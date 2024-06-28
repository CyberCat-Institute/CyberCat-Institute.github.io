---
layout: post
title: The Yoga of Contexts I
author: Jules Hedges
date: 2024-06-28
categories: [category theory]
excerpt: "Suppose we have some category, whose morphisms are some kind of processes or systems that we care about. We would like to be able to talk about contexts (or environments) in which these processes or systems can be located."
usemathjax: true
---

Suppose we have some category $\mathcal C$, whose morphisms are some kind of *processes* or *systems* that we care about. We would like to be able to talk about *contexts* (or *environments*) in which these processes or systems can be located.

This post is to finally write part of the lore of categorical cybernetics that I've been working out on the backburner for a few years, and I've talked about in front of various audiences a few times. I never thought it was quite compelling enough to write a paper about it, but it's been part of my bag of tricks for a while, for example playing a central role in my [lecture series on compositional game theory](https://julesh.com/videos/). In the meantime, similar ideas have been invented a few times in applied category theory, most notably being taken further for talking about [quantum supermaps](https://arxiv.org/abs/2402.02997).

## Contexts in a category

Topologically, we draw morphisms of our category as nodes, which have a hole *outside* but no hole *inside* (that is to say they are really point-like, despite how we conventionally draw them) - and dually, we draw contexts as diagram elements that have a hole *inside* but no hole *outside*.

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img1.png)

Being good category theorists, we choose not to say what a context *is* but how it *transforms*, which will lead to being able to define them via additional structure we can equip our categories with. If we have a context for morphisms $X \to Y$, and we have morphisms $f : X \to X'$ and $g : Y' \to Y$, we should be able to *demote* these morphisms into being part of an extended environment for morphisms $X' \to Y'$:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img2.png)

By asking that demoting twice gives the same result as demoting a composite, and the order of demoting on the domain and codomain doesn't matter, we end up inventing the following definition: A *system of contexts* for a category $\mathcal C$ is a functor $\overline{\mathcal C} : \mathcal C \times \mathcal C^{\mathrm{op}} \to \mathbf{Set}$, and a context for morphisms $X \to Y$ is an element of $\overline{\mathcal C} (X, Y)$.

Things get much more interesting when $\mathcal C$ is not just a category but a symmetric monoidal category, as is virtually always the case in any applied domain. Our first guess might be to replace the functor $\mathcal C$ with some kind of monoidal functor. *Lax* monoidal (for the cartesian monoidal product on $\mathbf{Set}$) turns out to be probably what we want - this says that if we have a context for morphisms $X \to Y$ and one for morphisms $X' \to Y'$ we can compose them to get a context for morphisms $X \otimes X' \to Y \otimes Y'$, but this operation is not necessarily reversible. Topologically this is a bit subtle, and says we can *bridge* 2 holes with a single morphism:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img3.png)

We probably get away with this because we are assuming everything is symmetric monoidal. I sometimes think of holes as *anti-nodes* that we can slide around as though they are nodes. This part of the definition has an odd status right now: it seems that we can virtually always get it in practice, and it plays a role in the theory, but I have never actually deployed the lax monoidal structure of contexts while doing any applied work.

In any case, this is not enough to describe contexts in a symmetric monoidal category, so we need to go back to first principles.

## The yoga of contexts

Suppose we have a symmetric monoidal category and we have a context for morphisms $X \otimes X' \to Y \otimes Y'$, and suppose we have a morphism $f : X \to Y$. Similarly to before, we should be able to *demote* $f$ into the context, obtaining a context for morphisms $X' \to Y'$:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img4.png)

I wrote this definition in section 9 of [The Game Semantics of Game Theory](https://arxiv.org/abs/1904.11287). But it turns out this isn't the best way to write it: it's enough to be able to demote an identity morphism, with an operation $\overline{\mathcal C} (Z \otimes X, Z \otimes Y) \to \overline{\mathcal C} (X, Y)$:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img5.png)

A category theorist would call this a (monoidal) *costrength* for $\overline{\mathcal C}$, although I find it useful to think of it as a kind of *tensor contraction*.

But there's another way to think about this whole thing. Given a symmetric monoidal category $\mathcal C$, a *comb* in $\mathcal C$ is a diagram element with 1 hole on the inside and 1 hole on the outside:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img6.png)

(Note, drawing them with this "comb" shape is enough because our ambient category is symmetric. In a planar setting, we would actually have to puncture a box with a hole.)

Concretely, a comb consists of a pair of morphisms coupled through a "residual" wire - but by drawing a box around it, we lose the ability to distinguish combs that differ by sliding a morphism between the front and back along the residual wire:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img7.png)

This turns out to be exactly the the definition of an *optic* in $\mathcal C$ - I think of combs as one *syntactic* presentation (among several others) of the *semantic* concept of an optic in a category. There is a category $\mathbf{Optic} (\mathcal C)$ whose objects are pairs of objects of $\mathcal C$, and whose morphisms are combs. Whereas string diagrams in $\mathcal C$ compose left-to-right, these "comb diagrams" in $\mathcal C$ compose *outside-in*, like an operad:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img8.png)

We also get a symmetric monoidal product on $\mathbf{Optic} (\mathcal C)$ that encompasses what I said earlier about sliding holes around. Now we get an alternative definition of context: it's a *generalised state* of optics. That is to say, it's an *ultimate outside*, which can be transformed by attach a comb to the inside of the hole:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img9.png)

If we do this, the properties we had to demand of the co-strength map get absorbed into the quotient defining optics.

What is a "generalised state"? A *state* in a monoidal category $\mathcal C$ is a morphism from the monoidal unit, and a *generalised* state is something that transforms like a state: an element of some lax monoidal functor $\mathcal C \to \mathbf{Set}$. That is to say: if we have a generalised state $x$ of $X$ and a morphism $f : X \to Y$, we get a pushforward state $f_* (x)$; and if we have generalised states $x$ of $X$ and $y$ of $Y$, we get a state $x \otimes y$ of $X \otimes Y$.

So now we have 2 different definitions of a system of contexts: as a lax monoidal functor $\mathcal C \times \mathcal C^{\mathrm{op}} \to \mathbf{Set}$ equipped with a co-strength map, or as a lax monoidal functor $\mathbf{Optic} (\mathcal C) \to \mathbf{Set}$. Fortunately, these definitions turn out to be equivalent: it's a dual of the [profunctor representation theorem](https://arxiv.org/abs/2001.07488). The normal version of this theorem says that *Tambara modules* - endo-profunctors on $\mathcal C$ equipped with a strength map - are equivalent to functors $\mathbf{Optic} (\mathcal C)^{\mathrm{op}} \to \mathbf{Set}$. It turns out that a Tambara module on $\mathcal C^{\mathrm{op}}$ is the same thing as a Tambara module, which conveniently frees up the name *Tambara co-module* to be used for this thing.

(A word of warning: the paper I linked defines "$\mathbf{Optic} (\mathcal C)$" to be $\mathbf{Optic} (\mathcal C)^\mathrm{op}$, which means they say $\mathbf{Optic} (\mathcal C) \to \mathbf{Set}$ when they mean $\mathbf{Optic} (\mathcal C)^{\mathrm{op}} \to \mathbf{Set}$ and vice versa.)

As a personal anecdote, at different points I've convinced myself that both of these definitions were the correct definition of "system of contexts", before realising that they were equivalent by the profunctor representation theorem - this led to me getting some quite good, graphical intuition for this otherwise notoriously abstract theorem.

Some time after working out the last part of this, I learned about the existence of [this paper](https://www.sciencedirect.com/science/article/pii/S0304397512000163) by Hermida and Tennent, which finally backed up my intuition behind my definition of generalised states by formulating a universal construction forcing them to become actual states. Incredibly this construction itself also falls squarely in the small cluster of methods we call categorical cybernetics, which caps off the whole thing very nicely. I touched on this construction in [this blog post](https://cybercat.institute/2024/02/22/iteration-optics/), and perhaps I'll have more to say about it later too.

## Conclusion

Often we don't need generalised states, and ordinary states are enough: that's when we take the representable functor $\mathcal C (I, -) : \mathcal C \to \mathbf{Set}$, which is indeed lax monoidal. (General representable functors on a monoidal category are *not* lax monoidal in general!)

This leads to what I call the "representable system of contexts" for a symmetric monoidal category $\mathcal C$: it's the one described by $\mathbf{Optic} (\mathcal C) (I, -)$, where the monoidal unit of $\mathbf{Optic} (\mathcal C)$ is $(I, I)$. What this ends up saying is that a context for morphisms $X \to Y$ in $\mathcal C$ is an equivalence class of pairs of a state and a costate in $\mathcal C$, coupled through a residual:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img10.png)

This turns out (in a non-trivial way) to be equivalent to the definition of context used for both [deterministic](https://arxiv.org/abs/1603.04641) and [Bayesian](https://compositionality-journal.org/papers/compositionality-5-9/) open games. In those cases, $\mathcal C$ is itself a category of optics, making systems of contexts examples of *double optics*. Iterating the $\mathbf{Optic} (-)$ construction can be usefully depicted in 2 different ways: as 1-hole combs in a bidirectional category:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img11.png)

or as 3-hole combs:

![String diagram](/assetsPosts/2024-06-28-yoga-contexts/img12.png)

Moving back and forth between these equivalent views of the iterated optic construction is a key part of the yoga of contexts as it applies to categorical cybernetics.

An example of a non-representable system of contexts is the "iteration functor" I talked about in [this post](https://cybercat.institute/2024/02/22/iteration-optics/). It's closely related to the *algebra of Moore machines* which plays a major role in David Jaz Myers' book on [categorical systems theory](http://davidjaz.com/Papers/DynamicalBook.pdf).

But, the actual reason this is a blog post and not a paper is that I don't have any really compelling examples outside of categorical cybernetics. But I'll talk more about my struggles with that in part II, where I'll build a category of "behaviours in context" given a system of contexts, generalising the construction of open games.
