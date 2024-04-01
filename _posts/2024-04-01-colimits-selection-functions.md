---
layout: post
title: Colimits of Selection Functions
author: Jules Hedges
date: 2024-04-01
categories: [category theory, game theory]
usemathjax: true 
excerpt: "In Towards Foundations of Categorical Cybernetics we built a category whose objects are selection functions and whose morphisms are lenses. It was a key step in how we justified open games in that paper: they're just parametrised lenses weighted by selection functions. In this post I'll show that by adding dependent types and stirring, we can get a nicer category that does the same job but has all colimits, and comes extremely close to having all limits. Fair warning: this post assumes quite a bit of category-theoretic background."
---

In [Towards Foundations of Categorical Cybernetics](https://arxiv.org/abs/2105.06332) we built a category whose objects are selection functions and whose morphisms are lenses. It was a key step in how we *justified* open games in that paper: they're *just* parametrised lenses "weighted" by selection functions. In this post I'll show that by adding dependent types and stirring, we can get a nicer category that does the same job but has all colimits, and comes extremely close to having all limits. Fair warning: this post assumes quite a bit of category-theoretic background.

Besides being a nice thing to do in itself, we have a very specific motivation for this. The recently realised paper [Categorical deep learning: An algebraic theory of architectures](https://arxiv.org/abs/2402.15332) proposed using initial algebras and final coalgebras in categories of parametrised morphisms to build neural networks with learning invariants designed to operate on complex data structures, in a huge generalisation of [geometric deep learning](https://geometricdeeplearning.com/). This post is the first step to replicating the same structure in compositional game theory, and is probably the first case where a class of deep learning architectures has a game-theoretic analogue right from the beginning (ok, the first other than [GANs](https://en.wikipedia.org/wiki/Generative_adversarial_network)) - something that is absolutely key to our vision of AI safety, as I described in [this previous post](https://cybercat.institute/2024/03/18/learning-invariant-preferences/).

# Dependent lenses

In this post I'm going work over the category of sets, to make my life easy. A **container** (also known as a **polynomial functor**) is a pair $\binom{X}{X'}$ where $X$ is a set and $X'$ is an $X$-indexed family of sets.

Given a pair of containers, a **dependent lens** $f : \binom{X}{X'} \to \binom{Y}{Y'}$ is a pair of a function $f : X \to Y$ and a function $f' : (x : X) \times Y' (f (x)) \to X' (x)$. There's a category $\mathbf{DLens}$ whose objects are containers and whose morphisms are dependent lenses (also known as the *category of containers* $\mathbf{Cont}$ and the *category of polynomial functors* $\mathbf{Poly}$ by different authors).

The category $\mathbf{DLens}$ has all limits and colimits, distinguishing it from the category of simply-typed lenses which is missing many of both (see my old paper [Morphisms of Open Games](https://arxiv.org/abs/1711.07059)). In this post I want to just take that as a given fact, because calculating them is not always so easy. The slick way to prove it is by constructing $\mathbf{DLens}$ as a fibration $\int_{X : \mathbf{Set}} \left( \mathbf{Set} / X \right)^\mathrm {op}$, and using the fact that a fibred category has all co/limits if every fibre does and reindexing preserves them (a fact that we'll be seeing again later).

# Dependent selection functions

Write $I$ for the tensor unit of dependent lenses: it's made of the set $1 = \\{ * \\}$ and the $1$-indexed set $* \mapsto 1$. A dependent lens $I \to \binom{X}{X'}$ is an element of $X$, and a dependent lens $\binom{X}{X'} \to I$ is a *section* of the container: a function $k : (x : X) \to X' (x)$. For shorthand I'll write $H = \mathbf{DLens} (I, -) : \mathbf{DLens} \to \mathbf{Set}$ and $K = \mathbf{DLens} (-, I) : \mathbf{DLens}^\mathrm{op} \to \mathbf{Set}$ for these representable functors.

By analogy to [what happens in the simply-typed case](https://julesh.com/2021/03/30/selection-functions-and-lenses/), a **dependent selection function** for a container $\binom{X}{X'}$ should be a function $\varepsilon : K \binom{X}{X'} \to H \binom{X}{X'}$ - that is, a thing that turns costates into states.

But I think we're going to need things to be multi-valued in order to get all colimits (and we need it to do much game theory anyway), so let's immediately forget that and define a **dependent multi-valued selection function** of type $\binom{X}{X'}$ to be a binary relation $\varepsilon \subseteq H \binom{X}{X'} \times K \binom{X}{X'}$.

To be honest, I don't really have any serious examples of these things to hand, I think they'll arise from taking colimits of things that are simply-typed. For game theory the main one we care about is still $\arg\max$, which *is* a "dependent" multi-valued selection function but only in a boring way that doesn't use the dependent types - it's a binary relation $\arg\max \subseteq H \binom{X}{\mathbb R} \times K \binom{X}{\mathbb R}$, where $\mathbb R$ here means the $X$-indexed set that is constantly the real numbers.

For each container $\binom{X}{X'}$, write $E \binom{X}{X'} = \mathcal P \left( H \binom{X}{X'} \times K \binom{X}{X'} \right)$ for the set of multi-valued selection functions for it. Since it's a powerset it inherits a posetal structure from subset inclusion, which is a boolean algebra. That means that as a thin category, it has all limits and colimits, something that will come in useful later.

Given $\varepsilon \subseteq H \binom{X}{X'} \times K \binom{X}{X'}$ and a dependent lens $f : \binom{X}{X'} \to \binom{Y}{Y'}$ we can define a "pushforward" selection function $f_* (\varepsilon) \subseteq H \binom{Y}{Y'} \times K \binom{Y}{Y'}$ by $f_* (\varepsilon) = \\{ (hf, k) \mid (h, fk) \in \varepsilon \\}$. Defining it this way means we get functoriality for free, and it's also monotone, so we have a functor $E : \mathbf{DLens} \to \mathbf{Pos}$.

The fact that we could just as easily have defined a contravariant action on dependent lenses means that the fibration we're about to get is a bifibration, something that will *definitely* come in useful one day, but not today.

# Colimits of selection functions

The next thing we do is take the category of elements of $E$. Objects of $\int E$ are pairs $\left( \binom{X}{X'}, \varepsilon \right)$ of a container and a selection function for it. A morphism $f : \left( \binom{X}{X'}, \varepsilon \right) \to \left( \binom{Y}{Y'}, \delta \right)$ is a dependent lens $f : \binom{X}{X'} \to \binom{Y}{Y'}$ with the property that $f_* (\varepsilon) \leq \delta$ - which is to say, any $h : H \binom{X}{X'}$ and $k : K \binom{Y}{Y'}$ satisfying $(h, fk) \in \varepsilon$ must also satisfy $(hf, k) \in \delta$.

So, $\int E$ is a category whose objects are dependent multi-valued selection functions and morphisms are dependent lenses. The only difference to the original category of selection functions from [Towards Foundations](https://arxiv.org/abs/2105.06332) is that we replaced simply typed lenses with dependent lenses. This is enough to get all limits, and I'd call $\int E$ a "nice category of selection functions".

The good way to prove that a fibred category has all co/limits (see [this paper](https://arxiv.org/abs/1801.02927)) is to show that (1) the base category has all co/limits, (2) every fibre has all co/limits, and (3) reindexing preserves co/limits. We already know (1) and (2) (remember the fibres are all boolean algebras), so we just need to prove (3). Since limits and colimits in the fibres are unions and intersections, this should not be too hard.

For some container $\binom{X}{X'}$, suppose we have some family $\varepsilon_i \subseteq E \binom{X}{X'}$ indexed by $i : I$. We can define the meet $\bigwedge_{i : I} \varepsilon_i$ and join $\bigvee_{i : I} \varepsilon_i : E \binom{X}{X'}$ by intersection and union. To get all colimits in $\int E$, what we need to prove is that for any dependent lens $f : \binom{X}{X'} \to \binom{Y}{Y'}$, $f_* \left( \bigvee_{i : I} \varepsilon_i \right) = \bigvee_{i : I} f_* (\varepsilon_i)$. Let's do it:

Going forwards, suppose $(h, k) \in f_* \left( \bigvee_i \varepsilon_i \right)$, so by definition of $f_* $ there must be $h'$ such that $h = h'f$ and $(h', fk) \in \bigvee_i \varepsilon_i$. So there is some $i : I$ such that $(h', fk) \in \varepsilon_i$, so $(h'f, k) = (h, k) \in f_* (\varepsilon_i)$, therefore $(f, k) \in \bigvee_i f_* (\varepsilon_i)$.

The other direction, suppose $(h, k) \in \bigvee_i f_* (\varepsilon_i)$, so $(h, k) \in f_* (\varepsilon_i)$ for some $i : I$. So we must have $h'$ such that $h = h'f$ and $(h', fk) \in \varepsilon_i$. So $(h', fk) \in \bigvee_i \varepsilon_i$, therefore $(h'f, k) = (h, k) \in f_* \left( \bigvee_i \varepsilon_i \right)$.

Note, this is intentionally a pure existence proof. Actually calculating these things can be quite a pain, and I'm going to put it off until later, specifically until a paper we're cooking up on *branching* open games.

# Limits of selection functions

If we also had $f_* \left( \bigwedge_{i : I} \varepsilon_i \right) = \bigwedge_{i : I} f_* (\varepsilon_i)$ then $\int E$ would also have all limits, but sadly in general the best we can do is $f_* \left( \bigwedge_{i : I} \varepsilon_i \right) \subseteq \bigwedge_{i : I} f_* (\varepsilon_i)$. I'd guess this probably means that $\int E$ has some kind of lax limits or something, but I'll deal with that another day.

It's instructive to look at what goes wrong. If $(h, k) \in \bigwedge_i f_* (\varepsilon_i)$, then for all $i : I$ we have $(h, k) \in f_* (\varepsilon_i)$. So, for every $i$ we have $h'_i$ such that $h = h'_i f$ and $(h'_i, fk) \in \varepsilon_i$. We can make progress if $f$ is a monomorphism, in which case all of the $h'_i$ are equal because $h'_i f = h = h'_j f$ implies $h'_i = h'_j$. In fact, while I don't know what general monomorphisms in $\mathbf{DLens}$ look like, in this case it's enough that the forwards pass of $f$ is an injective function. This probably gives us a decent subcategory of $\int E$ that has all limits as well as all colimits, but I don't know whether that category will be useful for anything.

