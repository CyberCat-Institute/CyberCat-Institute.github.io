---
layout: post
title: "Dependent optics II: Optics via forcing costates"
author: Jules Hedges
date: 2025-10-16
categories: [category theory]
usemathjax: true
excerpt: "I've been putting this series of posts off for a long time, although nowhere near as long as we've been putting off the corresponding paper. For anyone who knows anything about my research between 2021 and 2024, dependent optics need no introduction. A team consisting of (in alphabetical order) Dylan Braithwaite, Matteo Capucci, Bruno Gavranović, Eigil Rischel and me put everything we had into the problem of unifying dependent lenses and monoidal optics, for 2 years. We had so many false solutions that \"we solved dependent optics!\" became a meme, and then we solved it."
---

I've been putting this series of posts off for a long time, although nowhere near as long as we've been putting off the corresponding paper.

For anyone who knows anything about my research between 2021 and 2024, dependent optics need no introduction. A team consisting of (in alphabetical order) Dylan Braithwaite, Matteo Capucci, Bruno Gavranović, Eigil Rischel and me put everything we had into the problem of unifying dependent lenses and monoidal optics, for 2 years. We had so many false solutions that "we solved dependent optics!" became a meme, and then we solved it. But by then, time had caught up with us and between us we did not collectively have the ability, energy and motivation to write the paper.

The construction became obscure folklore because we talked about it in various places, for example in [this seminar](https://www.youtube.com/watch?v=yhxwUnWKK2I) I gave early this year. I am writing this series of posts to upgrade it from folklore to merely grey literature. The reason I put off starting the series for so long is one of the same reasons blocking the writing of the paper: some of the introductory material is some of the most difficult to write. It has been such a long time that I no longer know how to adequately explain why the problem is *so* difficult. Additionally, one of the current blockers to a paper is figuring out how our construction relates to the one in [Vertechi's paper](https://arxiv.org/abs/2204.09547). So, I have made the outrageous choice to *start* this blog series with part II, and put off writing part I until the end.

The goal of this post is to reconstruct simple optics in the way that turned out to generalise correctly.

## A refresher on optics

So that we are all starting from the same place I will give the standard construction of optics, from [this paper](https://arxiv.org/abs/1809.00738) and [this paper](https://compositionality.episciences.org/13530).

If we have a symmetric monoidal category $\mathcal C$, its category of optics $\mathbf{Optic} (\mathcal C)$ has as objects pairs of objects of $\mathcal C$, and morphisms given by elements of the coend
$$ \mathbf{Optic} (\mathcal C) \left( \binom{X'}{X}, \binom{Y'}{Y} \right) = \int^{M : \mathcal C} \mathcal C (X, M \otimes Y) \times \mathcal C (M \otimes Y', X') $$

A couple of notes on this:

1. If the assumption that $\mathcal C$ is symmetric is dropped this construction still does something, but it does the wrong thing (I may write a future blog post on this point). Symmetry turns out to be necessary for what follows anyway, so I am assuming it here.
2. I am writing my objects with the backwards pass over the forwards pass, for consistency with the fibrational notation for dependent lenses.

If $\mathcal C$ is cartesian monoidal, then $\mathbf{Optic} (\mathcal C)$ is isomorphic to the category $\mathbf{Lens} (\mathcal C)$ of simply-typed lenses. This fact will be important in later posts.

More generally, if we have a span of strong symmetric monoidal functors $\mathcal C \overset{L}\leftarrow \mathcal M \overset{R}\rightarrow \mathcal D$ (or equivalently symmetric monoidal actions of $\mathcal M$ on $\mathcal C$ and $\mathcal D$ - I may also write a future post on this point) then the category of mixed optics $\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$ has as objects pairs of objects of $\mathcal C$ and $\mathcal D$, and morphisms given by elements of the coend
$$ \mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D) \left( \binom{X'}{X}, \binom{Y'}{Y} \right) = \int^{M : \mathcal M} \mathcal C (X, L (M) \otimes Y) \times \mathcal D (R (M) \otimes Y', X') $$

In both cases, the category of optics is itself a symmteric monoidal category, given on objects by pairwise monoidal product of the underlying categories.

## The bicategory of optics

Categories of optics arise naturally as quotients of bicategories, and this gives a more refined view that will be crucial. With the same setup for mixed optics, we build a symmetric monoidal bicategory $\mathbf{2Optic}_\mathcal M (\mathcal C, \mathcal D)$. Its 0-cells are again pairs of objects of $\mathcal C$ and $\mathcal D$, its 1-cells $\binom{X'}{X} \to \binom{Y'}{Y}$ are triples
$$ \left( M : \mathcal M, f : X \to L (M) \otimes Y, f' : R (M) \otimes Y' \to X' \right) $$
and its 2-cells are morphisms $M \to M'$ of $\mathcal M$ making the resulting diagrams commute.

There are 2 universal ways to turn a bicategory into a category. By far the more common way is to quotient out invertible 2-cells, which turns out to be the same thing (at least for an appropriately weak notion of enrichment) as change of enrichment basis $U^* : \mathbf{Cat}-\mathbf{Cat} \to \mathbf{Set}-\mathbf{Cat}$ along the functor $U : \mathbf{Cat} \to \mathbf{Set}$ that takes each category to its set of isomorphism classes.

There is another functor $\pi_0 : \mathbf{Cat} \to \mathbf{Set}$ that instead takes each category to its set of *connected components*, quotienting out *reachability*, or equivalently adding all formal inverses before quotienting out isomorphism. (They are related by a string of adjunctions between $\mathbf{Set}$ and $\mathbf{Cat}$, but I don't remember the details of that right now.) This is not often seen because most categories encountered in practice - for example any category with either an initial or a terminal object - are *connected* and sent to the 1-element set by $\pi_0$. But the hom-categories of $\mathbf{2Optic}_\mathcal M (\mathcal C, \mathcal D)$ are not connected, and in fact:

**Lemma**: There is an isomorphism of symmetric monoidal categories $\pi_0^* \left( \mathbf{2Optic} (\mathcal C) \right) \cong \mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$.

Proving that all of this actually coheres with the symmetric monoidal structure is a very minor part of what still needs to be done, that will probably take weeks of effort.

## Parametrisation

Given a strong symmetric monoidal functor $F : \mathcal M \to \mathcal C$ (or more generally an action of $\mathcal M$ on $\mathcal C$), we can form a symmetric monoidal bicategory $\mathbf{Para}_\mathcal M (\mathcal C)$ of $\mathcal M$-parametrised morphisms of $\mathcal C$. Its 0-cells are the 0-cells of $\mathcal C$, its 1-cells $X \to Y$ are pairs
$$ (M : \mathcal M, f : F (M) \otimes X \to Y) $$
and its 2-cells are morphisms $M \to M'$ making the resulting diagram commute.

$$\mathbf{Para}_{\mathcal M} (\mathcal C)$$ is locally fibred over $\mathcal M$: every hom-category is equipped with a fibration $\mathbf{Para}_\mathcal M (\mathcal C) (X, Y) \to \mathcal M$ compatible with the other structure.

There is a dual construction $$\mathbf{Copara}_\mathcal M (\mathcal C)$$ whose 1-cells are pairs of $M$ and $X \to F (M) \otimes Y$. This has a local opfibration structure $\mathbf{Copara}_\mathcal M (\mathcal C) (X, Y) \to \mathcal M$.

Here is a construction of optics that is a major contributor to the feeling of how close-knit the foundations of categorical cybernetics are, but is not the construction we are looking for: the hom-category $\mathbf{2Optic}_\mathcal M (\mathcal C, \mathcal D) \left( \binom{X'}{X}, \binom{Y'}{Y} \right)$ is the pullback in $\mathbf{Cat}$ of this opfibration and fibration:
$$ \mathbf{Copara}_\mathcal M (\mathcal C) (X, Y) \rightarrow \mathcal M \leftarrow \mathbf{Para}_\mathcal M (\mathcal D) (Y', X') $$

## Forcing costates

Suppose we have a symmetric monoidal category $\mathcal C$ and a lax symmetric monoidal presheaf $K : \mathcal C^\mathrm{op} \to \mathbf{Set}$ to the cartesian monoidal category of sets. The lax monoidal structure is given by a unit $e : K (I)$ and a laxator
$$ \nabla : K (X) \times K (Y) \to K (X \otimes Y) $$
We want to formally adjoin, or *force*, all of the elements $x : K (X)$ to $\mathcal C$ as costates $x : X \to I$, modulo all of the evident equations arising from the structure of $K$.

We take the category of elements $\int K$, whose objects are pairs $(X : \mathcal C, x : K (X))$ and whose morphisms are morphisms $X \to Y$ making the resulting diagram commute. $\int K$ is a symmetric monoidal category with the monoidal unit $(I, e)$ and the monoidal product $(X, x) \otimes (Y, y) = (X \otimes Y, x \nabla y)$, and is equipped with a strong symmetric monoidal fibration $\int K \to \mathcal C$.

We form the symmetric monoidal bicategory $\mathbf{Copara}_{\int K} (\mathcal C)$ for this functor. Its 0-cells are objects of $\mathcal C$, its 1-cells $X \to Y$ are triples
$$ (M : \mathcal C, m : K (M), f : X \to M \otimes Y) $$
and its 2-cells are morphisms $M \to M'$ of $\mathcal M$ making the resulting diagrams commute.

The hom-categories $\mathbf{Copara}_{\int K} (\mathcal C) (X, Y)$ are once again not connected. Here is the sledgehammer theorem:

**Theorem** ([Hermida & Tennent](https://www.sciencedirect.com/science/article/pii/S1571066109003053), dualised and reformulated). $\mathcal C [K] = \pi_0^* \left( \mathbf{Copara}_{\int K} (\mathcal C) \right)$ is the smallest symmetric monoidal category that contains $\mathcal C$ and contains a morphism $x : X \to I$ for each element $x : K (X)$ modulo the evident equations.

I've talked about this construction before in its original dual form for forcing states from a copresheaf rather than costates from a presheaf, in [this post](/posts/2024-02-22-iteration-optics.html), to add iteration to categories of optics. The pictures in that post are helpful for understanding how this construction works.

## From adaptors to optics

We will now apply this theorem to construct categories of optics.

Given a symmetric monoidal category $\mathcal C$, we can form the symmetric monoidal category $\mathbf{Adt} (\mathcal C) = \mathcal C \times \mathcal C^\mathrm{op}$ with the pairwise monoidal product. We call the morphisms of this category *adaptors*, and think of them as optics whose backwards pass does not use its forwards input. There is an embedding $\mathbf{Adt} (\mathcal C) \to \mathbf{Optic} (\mathcal C)$ that is identity on objects and always chooses $M = I$.

The hom functor of $\mathcal C$ is a presheaf $\hom : \mathbf{Adt} (\mathcal C)^\mathrm{op} = \mathcal C^\mathrm{op} \times \mathcal C \to \mathbf{Set}$, and it is lax symmetric monoidal. (It is strong monoidal if and only if $\mathcal C$ is cartesian monodial.) It turns out that if we take $\mathrm{Adt} (\mathcal C)$ and adjoin a morphism $\binom{X'}{X} \to \binom{I}{I}$ for every underlying morphism $X \to X'$, we get exactly the category of optics:

**Lemma**: There is an isomorphism of symmetric monoidal bicategories $\mathbf{Copara}_{\int \hom} (\mathbf{Adt} (\mathcal C)) \cong \mathbf{2Optic} (\mathcal C)$, and therefore an isomorphism of symmetric monoidal categories $\mathbf{Adt} (\mathcal C) [\hom] \cong \mathbf{Optic} (\mathcal C)$.

This also works for general mixed optics. Suppose we have a span of strong symmetric monoidal functors $\mathcal C \overset{L}\leftarrow \mathcal M \overset{R}\rightarrow \mathcal D$. We form a lax symmetric monoidal functor $K : \mathcal C^\mathrm{op} \times \mathcal D \to \mathbf{Set}$ by
$$ K \binom{X'}{X} = \int^{M : \mathcal M} \mathcal C (X, L (M)) \times \mathcal D (R (M), Y) $$
Then:

**Lemma**: There is an isomorphism of symmetric monoidal bicategories $$\mathbf{Copara}_{\int K} (\mathcal C \times \mathcal D^\mathrm{op}) \cong \mathbf{2Optic}_\mathcal M (\mathcal C, \mathcal D)$$, and therefore an isomorphism of symmetric monoidal categories $(\mathcal C \times \mathcal D^\mathrm{op}) [K] \cong \mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$.

If $\mathcal C$ is cartseian monoidal then of course we also have an isomorphism $\mathbf{Lens} (\mathcal C) \cong \mathbf{Adt} (\mathcal C) [\hom]$. It will be useful to write a direct proof of this fact instead of cutting the equations $\mathbf{Adt} (\mathcal C)[\hom] \cong \mathbf{Optic} (\mathcal C) \cong \mathbf{Lens} (\mathcal C)$, but I will put this off until a later post as a practice run for the main theorem of dependent optics.

Now we can reformulate the dependent optics question: given appropriate structure on $\mathcal C$ we need to construct a symmetric monoidal category $\mathbf{DAdt} (\mathcal C)$ of *dependent adaptors* and a lax symmetric monoidal presheaf $K : \mathbf{DAdt} (\mathcal C)^\mathrm{op} \to \mathbf{Set}$ with the property that $\mathbf{DAdt} (\mathcal C) [K] \cong \mathbf{DLens} (\mathcal C)$ is the category of *dependent* lenses in $\mathcal C$. (Of course we have to rule out trivial solutions like taking $K$ to be the terminal presheaf.) This is what we will do over this series of posts.
