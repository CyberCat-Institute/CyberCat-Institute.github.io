---
layout: post
title: A Nice Category of Selection Functions 
author: Jules Hedges
categories: [category theory]
usemathjax: true 
excerpt: 
---

In [Towards Foundations of Categorical Cybernetics]() we built a category whose objects are selection functions and whose morphisms are lenses. It was a key step in how we *justified* open games in that paper: they're *just* parametrised lenses "weighted" by selection functions. In this post I'll show that by adding dependent types and stirring, we can get a nicer category that does the same job but has all limits and colimits.

Besides being a nice thing to do in itself, we have a very specific motivation for this. In a [recently released position paper]() by [Bruno]() and [a whole lot of fancy people from DeepMind](), they proposed using initial algebras and final coalgebras in categories of parametrised morphisms to build neural networks with learning invariants designed to operate on complex data structures, in a huge generalisation of [geometric deep learning](). We think this idea is incredibly exciting, and this post is the first step to replicating the same structure in compositional game theory. This is probably the first case where a class of deep learning architectures has a game-theoretic analogue right from the beginning (ok, GANs are probably the exception to that) - something that is absolutely key to our vision of AI safety.

# Dependent lenses

In this post I'm going work over the category of sets, to make my life easy. A **container** (also known as a **polynomial functor**) is a pair $\binom{X}{X'}$ where $X$ is a set and $X'$ is an $X$-indexed family of sets.

Given a pair of containers, a **dependent lens** $f : \binom{X}{X'} \to \binom{Y}{Y'}$ is a pair of a function $f : X \to Y$ and a function $f' : (x : X) \times Y' (f (x)) \to X' (x)$. There's a category $\mathbf{DLens}$ whose objects are containers and whose morphisms are dependent lenses.

The category $\mathbf{DLens}$ has all limits and colimits, distinguishing it from the category of simply-typed lenses which is missing many of both. In this post I want to just take that as a given fact, because calculating them is not always so easy. The slick way to prove it is by constructing $\mathbf{DLens}$ as a fibration $\int_{X : \mathbf{Set}} \mathbf{Set} / X$, and using the fact that a fibred category has all co/limits if every fibre does and reindexing preserves them.

# Dependent selection functions

Write $I$ for the tensor unit of dependent lenses: it's made of the set $1 = \{ * \}$ and the $1$-indexed set $* \mapsto 1$. A dependent lens $I \to \binom{X}{X'}$ is an element of $X$, and a dependent lens $\binom{X}{X'} \to I$ is a *section* of the container: a function $k : (x : X) \to X' (x)$. For shorthand I'll write $H = \mathbf{DLens} (I, -) : \mathbf{DLens} \to \mathbf{Set}$ and $K = \mathbf{DLens} (-, I) : \mathbf{DLens}^\mathrm{op} \to \mathbf{Set}$ for these representable functors.

By analogy to [what happens in the simply-typed case](https://julesh.com/2021/03/30/selection-functions-and-lenses/), a **dependent selection function** for a container $\binom{X}{X'}$ should be a function $\varepsilon : K \binom{X}{X'} \to H \binom{X}{X'}$ - that is, a thing that turns costates into states.

But I think we're going to need things to be multi-valued in order to get all co/limits (and we need it to do much game theory anyway), so let's immediately forget that and define a **dependent multi-valued selection function** of type $\binom{X}{X'}$ to be a binary relation $\varepsilon \subseteq H \binom{X}{X'} \times K \binom{X}{X'}$.

To be honest, I don't really have any serious examples of these things to hand, I think they'll arise from taking co/limits of things that are simply-typed. For game theory the main one we care about is still $\arg\max$, which *is* a "dependent" multi-valued selection function but only in a boring way that doesn't use the dependent types.

For each container $\binom{X}{X'}$, write $E \binom{X}{X'} = \mathcal P \left( H \binom{X}{X'} \times K \binom{X}{X'} \right)$ for the set of multi-valued selection functions for it. Since it's a powerset it inherits a posetal structure from subset inclusion, which is a boolean algebra. That means that as a thin category, it has all limits and colimits, something that will come in useful later.

Given $\varepsilon \subseteq H \binom{X}{X'} \times K \binom{X}{X'}$ and a dependent lens $f : \binom{X}{X'} \to \binom{Y}{Y'}$ we can define a "pushforward" selection function $f_* (\varepsilon) \subseteq H \binom{Y}{Y'} \times K \binom{Y}{Y'}$ by $f_* (\varepsilon) = \{ (hf, k) \mid (h, fk) \in \varepsilon \}$. Defining it this way means we get functoriality for free, and it's also monotone, so we have a functor $E : \mathbf{DLens} \to \mathbf{Pos}$.

The fact that we could just as easily have defined a contravariant action on dependent lenses means that the fibration we're about to get is a bifibration, something that will *definitely* come in useful one day, but not today.

# A nice category of selection functions

The next thing we do is take the category of elements of $E$. Objects of $\int E$ are pairs $\left( \binom{X}{X'}, \varepsilon \right)$ of a container and a selection function for it. A morphism $f : \left( \binom{X}{X'}, \varepsilon \right) \to \left( \binom{Y}{Y'}, \delta \right)$ is a dependent lens $f : \binom{X}{X'} \to \binom{Y}{Y'}$ with the property that $f_* (\varepsilon) \leq \delta$ - which is to say, for any $h : H \binom{X}{X'}$ and $k : K \binom{Y}{Y'}$ such that $(h, fk) \in \varepsilon$, it follows that $(hf, k) \in \delta$.

So, $\int E$ is a category whose objects are dependent multi-valued selection functions and morphisms are dependent lenses. This is *almost* exactly the same as the original category of selection functions from [Towards Foundations](), just with simply-typed lenses replaced with dependent lenses. I claim that this is enough to make it have all limits and colimits.

The good way to prove this (see [this paper](Streicher)) is to show that (1) the base category has all co/limits, (2) every fibre has all co-limits, and (3) reindexing preserves co/limits. We already know (1) and (2) (remember the fibres are all boolean algebras), so we just need to prove (3). Since limits and colimits in the fibres are basically unions and intersections, this is not too hard.

For some container $\binom{X}{X'}$, suppose we have some family $\varepsilon_i \subseteq E \binom{X}{X'}$ indexed by $i : I$. We can define the meet and join $\bigwedge_{i : I} \varepsilon_i, \bigvee_{i : I} \varepsilon_i : E \binom{X}{X'}$ by intersection and union. What we need to prove is that for any dependent lens $f : \binom{X}{X'} \to \binom{Y}{Y'}$, $f_* \left( \bigwedge_{i : I} \varepsilon_i \right) = \bigwedge_{i : I} f_* (\varepsilon_i)$ and $f_* \left( \bigvee_{i : I} \varepsilon_i \right) = \bigvee_{i : I} f_* (\varepsilon_i)$.

