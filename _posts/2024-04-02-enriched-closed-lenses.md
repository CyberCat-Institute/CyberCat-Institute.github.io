---
layout: post
title: Enriched Closed Lenses
author: Jules Hedges
date: 2024-04-02
categories: [category theory]
usemathjax: true 
excerpt: 
---

I'm going to record something that I think is known to everyone doing research on categorical cybernetics, but I don't think has been written down somewhere: an even more general version of mixed optics that replaces the backwards actegory with an enrichment.

# Actegories and enrichments

An **actegory** consists of a monoidal category $\mathcal M$, a category $\mathcal C$ and a functor $\bullet : \mathcal M \times \mathcal C \to \mathcal C$ that behaves like an "external product": namely that it's equipped with coherent isomorphisms $I \bullet X \cong X$ and $(M \otimes N) \bullet X \cong M \bullet (N \bullet X)$.

An **enriched category** consists of a category $\mathcal C$, a monoidal category $\mathcal M$ and a functor $[-, -] : \mathcal C^\mathrm{op} \times \mathcal C \to \mathcal M$ that behaves like an "external hom" (I'm not going to write down what this means because it's more complicated).

There's a very close relationship between actegories and enrichments, to the point that I consider them different perspectives on the same idea. This is the *final form* of the famous tensor-hom adjunction, aka. currying. (I learned this incredible fact from Matteo Capucci, and I have no idea where it's written down, although it's definitely written down somewhere.)

A **tensored enrichment** is one where every $[Z, -] : \mathcal C \to \mathcal M$ has a left adjoint $- \bullet X : \mathcal M \to \mathcal C$. Allowing $Z$ to vary results in a functor $\bullet$ which (nontrivial theorem) is always an actegory.

A **closed actegory** is one where every $- \bullet Z : \mathcal M \to \mathcal C$ has a right adjoint $[Z, -] : \mathcal C \to \mathcal M$. Allowing $Z$ to vary results in a functor $[-, -]$ which (nontrivial theorem) is always an enrichment.

So, closed actegories and tensored enrichments are equivalent ways of defining the same thing, namely a monoidal category $\mathcal M$ and category $\mathcal C$ equipped with $\bullet$ and $[-, -]$ related by a tensor-hom adjunction $\mathcal C (X \bullet Z, Y) \cong \mathcal M (Z, [X, Y])$.

# Parametrisation

Given an actegory, we can define a bicategory $$\mathbf{Para}_\mathcal M (\mathcal C)$$, whose objects are objects of $\mathcal C$ and 1-cells are pairs of $M : \mathcal M$ and $f : \mathcal C (M \bullet X, Y)$. We can also define a bicategory $$\mathbf{Copara}_\mathcal M (\mathcal C)$$, whose objects are objects of $\mathcal C$ and 1-cells are pairs of $M : \mathcal M$ and $f : \mathcal C (X, M \bullet Y)$.

Given an enriched category, we can define a bicategory $$\mathbf{Para}_\mathcal M (\mathcal C)$$, whose objects are objects of $\mathcal C$ and morphisms are pairs of $M : \mathcal M$ and $f : \mathcal M (M, [X, Y])$. If this is a tensored enrichment then the two definitions of $$\mathbf{Para}_\mathcal M (\mathcal C)$$ are equivalent.

In all of these cases we are locally fibred over $\mathcal M$, and I will write $$\mathbf{Para}_\mathcal M (\mathcal C) (X, Y) (M)$$, $$\mathbf{Copara}_\mathcal M (\mathcal C) (X, Y) (M)$ for the set of co/parametrised morphisms with a fixed parameter type.

It's not possible to define $\mathbf{Copara}_\mathcal M (\mathcal C)$ for an enrichment. There's a very slick common generalisation of actegories and enrichments called a [locally graded category](https://ncatlab.org/nlab/show/locally+graded+category), which is a category enriched in presheaves with Day convolution. There's also a very slick definition of $\mathbf{Para}$ for a locally graded category. I'd like to know, for exactly which locally graded categories is possible to define $\mathbf{Copara}$?

# Mixed optics

If we have two actegories $\mathcal C, \mathcal D$ that share the same acting category $\mathcal M$ then we can define **mixed optics**, which first apperaed in [Profunctor Optics: A Categorical Update](https://compositionality-journal.org/papers/compositionality-6-1/). This is a 1-category $$\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$$ whose objects are pairs $\binom{X}{X'}$ of an object of $\mathcal C$ and an object of $\mathcal D$, and a morphism $\binom{X}{X'} \to \binom{Y}{Y'}$ is an element of the coend 

$$\int^{M : \mathcal M} \mathbf{Copara}_\mathcal M (\mathcal C) (X, Y) (M) \times \mathbf{Para}_\mathcal M (\mathcal D) (Y', X') (M)$$

There's a slightly more general definition called "weighted optics" that appears in [Bruno's thesis](https://arxiv.org/abs/2403.13001), which replaces $\mathcal M$ and was used very productively there, which replaces $\mathcal M$ with two monoidal categories related by a Tambara module. I think that it's an orthogonal generalisation to the one I'm about to do here.

# Enriched closed lenses

Putting together everything I've just said, the next step is clear. If we have categories $\mathcal C, \mathcal D$ and a monoidal category $\mathcal M$, with $\mathcal M$ acting on $\mathcal C$ and $\mathcal D$ enriched in $\mathcal C$, then we can still define $$\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$$ in exactly the same way, replacing $$\mathbf{Para}_\mathcal M (\mathcal D)$$ with its enriched version. But now, unlike before, we can use the ninja Yoneda lemma to eliminate the coend and get

$$\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D) \left( \binom{X}{X'}, \binom{Y}{Y'} \right) \cong \mathcal C (X, [Y', X'] \bullet Y)$$

In general I refer to optics that can be defined without type quantification as *lenses*, and so this is an **enriched closed lens**. It's the *final form* of "linear lenses", the version of lenses that is defined like `Lens s t a b = s -> (a, b -> t)`.

# Into the compiler forest

