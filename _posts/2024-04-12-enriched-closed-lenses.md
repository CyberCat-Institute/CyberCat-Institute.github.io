---
layout: post
title: Enriched Closed Lenses
author: Jules Hedges
date: 2024-04-12
categories: [category theory, categorical cybernetics]
usemathjax: true 
excerpt: "I'm going to record something that I think is known to everyone doing research on categorical cybernetics, but I don't think has been written down somewhere: an even more general version of mixed optics that replaces the backwards actegory with an enrichment. With it, I'll make sense of a curious definition appearing in The Compiler Forest."
---

I'm going to record something that I think is known to everyone doing research on categorical cybernetics, but I don't think has been written down somewhere: an even more general version of mixed optics that replaces the backwards actegory with an enrichment. With it, I'll make sense of a curious definition appearing in [The Compiler Forest](https://homepages.inf.ed.ac.uk/gdp/publications/compiler-forest.pdf).

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

In all of these cases we are locally fibred over $\mathcal M$, and I will write $$\mathbf{Para}_\mathcal M (\mathcal C) (X, Y) (M)$$, $$\mathbf{Copara}_\mathcal M (\mathcal C) (X, Y) (M)$$ for the set of co/parametrised morphisms with a fixed parameter type.

It's not possible to define $\mathbf{Copara}_\mathcal M (\mathcal C)$ for an enrichment. There's a very slick common generalisation of actegories and enrichments called a [locally graded category](https://ncatlab.org/nlab/show/locally+graded+category), which is a category enriched in presheaves with Day convolution. There's also a very slick definition of $\mathbf{Para}$ for a locally graded category. I'd like to know, for exactly which locally graded categories is possible to define $\mathbf{Copara}$?

# Mixed optics

If we have two actegories $\mathcal C, \mathcal D$ that share the same acting category $\mathcal M$ then we can define **mixed optics**, which first appeared in [Profunctor Optics: A Categorical Update](https://compositionality-journal.org/papers/compositionality-6-1/). This is a 1-category $$\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$$ whose objects are pairs $\binom{X}{X'}$ of an object of $\mathcal C$ and an object of $\mathcal D$, and a morphism $\binom{X}{X'} \to \binom{Y}{Y'}$ is an element of the coend 

$$\int^{M : \mathcal M} \mathbf{Copara}_\mathcal M (\mathcal C) (X, Y) (M) \times \mathbf{Para}_\mathcal M (\mathcal D) (Y', X') (M)$$

There's a slightly more general definition called "weighted optics" that appears in [Bruno's thesis](https://arxiv.org/abs/2403.13001) and was used very productively there, which replaces $\mathcal M$ with two monoidal categories related by a Tambara module. I think that it's an orthogonal generalisation to the one I'm about to do here.

# Enriched closed lenses

Putting together everything I've just said, the next step is clear. If we have categories $\mathcal C, \mathcal D$ and a monoidal category $\mathcal M$, with $\mathcal M$ acting on $\mathcal C$ and $\mathcal D$ enriched in $\mathcal C$, then we can still define $$\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D)$$ in exactly the same way, replacing $$\mathbf{Para}_\mathcal M (\mathcal D)$$ with its enriched version. But now, unlike before, we can use the ninja Yoneda lemma to eliminate the coend and get

$$\mathbf{Optic}_\mathcal M (\mathcal C, \mathcal D) \left( \binom{X}{X'}, \binom{Y}{Y'} \right) \cong \mathcal C (X, [Y', X'] \bullet Y)$$

In general I refer to optics that can be defined without type quantification as *lenses*, and so this is an **enriched closed lens**. It's the *final form* of "linear lenses", the version of lenses that is defined like `Lens s t a b = s -> (a, b -> t)`.

# Into the compiler forest

Section 5 of [The Compiler Forest](https://homepages.inf.ed.ac.uk/gdp/publications/compiler-forest.pdf) by Budiu, Galenson and Plotkin has a *very* interesting definition in it. They have a cartesian closed category $\mathcal C$ (whose internal hom I'll write as $\to$) and a strong monad $T$ on it, and they define a category whose objects are pairs of objects of $\mathcal C$ whose morphisms $f : \binom{X}{X'} \to \binom{Y}{Y'}$ are morphisms $f : X \to T (Y \times (Y' \to T X'))$ of $\mathcal C$.

They also nail an intuition for lenses that I use constantly and I haven't seen written down anywhere else: problems go forwards, solutions go backwards.

Me and this definition have quite a history. It came to my attention while polishing [Bayesian Open Games](https://compositionality-journal.org/papers/compositionality-5-9/) for submission. For a while, I thought that it was equivalent to optics in the kleisli category of $T$, and we'd wasted a years of our lives trying to understand optics (this being around 2018, when optics were still a niche idea). Then, for a while I thought that the paper made a mistake and these things don't compose associatively. Now I've made peace: I think their definition is *conceptually* subtly wrong in a way that makes no difference in practice, and I can say very precisely how it relates to kleisli optics.

There is an action of $\mathcal C$ on $\mathrm{Kl} (T)$ given by $M \bullet X = M \otimes X$, where $\otimes$ is the tensor product of $\mathrm{Kl} (T)$ which on objects is given by the product $\times$ of $\mathcal C$. That's the actegory generated by the strong monoidal embedding $\mathcal C \hookrightarrow \mathrm{Kl} (T)$. There is also an enrichment of $\mathrm{Kl} (T)$ in $\mathcal C$, given by $[X, Y] = X \to T Y$. This action and enrichment are adjoint to each other: $\mathrm{Kl} (T) (M \otimes X, Y) \cong \mathcal C (X, M \to TY)$.

The category defined in Compiler Forest turns out to be equivalent to

$$\mathrm{Optic}_\mathcal C (\mathrm{Kl} (T), \mathrm{Kl} (T))$$

whose forwards pass is given by the action of $\mathcal C$ on $\mathrm{Kl} (T)$ and whose backwards pass is given by the enrichment of $\mathrm{Kl} (T)$ in $\mathcal C$. Its hom-sets are given by

$$\mathrm{Optic}_\mathcal C (\mathrm{Kl} (T), \mathrm{Kl} (T)) \left( \binom{X}{X'}, \binom{Y}{Y'} \right)$$

$$ = \int^{M : \mathcal C} \mathcal C (X, T (M \times Y)) \times \mathcal C (M, Y' \to T X')$$

which Yoneda-reduces to the definition in the paper.

Even though the action and enrichment are adjoint, this is *not* the same as optics in the klesli category:

$$\mathrm{Optic}_\mathcal C (\mathrm{Kl} (T), \mathrm{Kl} (T)) \not\cong \mathrm{Optic}_{\mathrm{Kl} (T)} (\mathrm{Kl} (T), \mathrm{Kl} (T))$$

where the hom-sets of the latter are defined by

$$\mathrm{Optic}_{\mathrm{Kl} (T)} (\mathrm{Kl} (T), \mathrm{Kl} (T)) \left( \binom{X}{X'}, \binom{Y}{Y'} \right)$$

$$ = \int^{M : \mathrm{Kl} (T)} \mathcal C (X, T (M \times Y)) \times \mathcal C (M \times Y', T X')$$

This equivalence, between optics whose backwards passes are an adjoint action or enrichment, would be a completely reasonable-looking lemma but it just isn't true! 

The difference between them is extremely subtle, though. The "proper" definition of kleisli optics identifies morphisms that agree up to sliding any kleisli morphism, whereas the definition in Compiler Forest only identifies morphisms that agree up to sliding pure morphisms of $\mathcal C$. So hom-sets of coend optics are a quotient of the hom-sets defined in Compiler Forest. While writing this up, I realised that most of this conclusion actually appears in section 4.9 of [Riley's original paper](https://arxiv.org/abs/1809.00738).

As long as you don't care about equality of morphisms - which in practice is never, because they are made of functions - the difference between them can be safely ignored. The only genuine reason to prefer kleisli optics is [their better runtime performance](https://arxiv.org/abs/2209.09351).
