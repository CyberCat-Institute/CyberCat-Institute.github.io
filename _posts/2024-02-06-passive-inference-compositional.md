---
layout: post
title: Passive Inference is Compositional, Active Inference is Emergent 
author: Jules Hedges
categories: 
usemathjax: true 
excerpt: 
---

This post is a writeup of a talk I gave at the [Causal Cognition in Humans and Machines](https://amcs-community.org/events/causal-cognition-humans-machines/) workshop in Oxford, about some work in progress I have with [Toby Smithe](https://tsmithe.net/). To a large extent this is my take on the theoretical work in Toby's PhD thesis, with the emphasis shifted from category theory and neuroscience to numerical computation and AI. In the last section I will outline my proposal for how to build AGI.

## Markov kernels

The starting point is the concept of a [Markov kernel](https://en.wikipedia.org/wiki/Markov_kernel), which is a synonym for [conditional probability distribution](https://en.wikipedia.org/wiki/Conditional_probability_distribution) that sounds unnecessarily fancy but, crucially, contains only 30% as many syllables. If $X$ and $Y$ are some sets then a Markov kernel $\varphi$ from $X$ to $Y$ is a conditional probability distribution $\mathbb P_\varphi [y \mid x]$. Most of this post will be agnostic to what exactly "probability distribution" can mean, but in practice it will *probably* eventually mean "Gaussian", in order to [go *brrr*](https://knowyourmeme.com/memes/money-printer-go-brrr), by which I mean *effective in practice at the expense of theoretical compromise*. (I blatantly stole this usage of that meme from [Bruno](https://www.brunogavranovic.com/).)

There are two different perspectives on how Markov kernels can be implemented. They could be *exact*, for example, they could be represented as a stochastic matrix (in the finite support case) or as a tensor containing a mean vector and covariance matrix for each input (in the Gaussian case). Alternatively they could be [Monte Carlo](https://en.wikipedia.org/wiki/Monte_Carlo_method), that is, implemented as a function from $X$ to $Y$ that may call a pseudorandom number generator. If we send the same input repeatedly then the outputs are samples from the distribution we want. Importantly these functions satisfy the [Markov property](https://en.wikipedia.org/wiki/Markov_property): the distribution on the output depends only on the current input and not on any internal state.

An important fact about Markov kernels is that they can be composed. Given a Markov kernel $\mathbb P_\varphi [y \mid x]$ and another $\mathbb P_\psi [z \mid y]$, there is a composite kernel $\mathbb P_{\varphi; \psi} [z \mid x]$ obtained by integrating out $y$:

$$ \mathbb P_{\varphi; \psi} [z \mid x] = \int \mathbb P_\varphi [y \mid x] \cdot \mathbb P_\psi [z \mid y] \, dy $$

This formula is sometimes given the unnecessarily fancy name [Chapman-Kolmogorov equation](https://en.wikipedia.org/wiki/Chapman%E2%80%93Kolmogorov_equation). If we represent kernels by stochastic matrices then this is exactly matrix multiplication; if they are Gaussian tensors then it's a similar but slightly more complicated operation. Doing exact probability for anything more complicated is extremely hard in practice because of the [curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality).

If we represent kernels by Monte Carlo funtions then composition is literally just function composition, which is extremely convenient. That is, we can just send particles through a chain of functions and they'll come out with the right distribution - this fact is basically what the term "Monte Carlo" actually means.

A special case of this is an ordinary (non-conditional) probability distribution, which can be usefully thought of as a Markov kernel whose domain is a single point. Given a distribution $\mathbb P_\pi [x]$ and a kernel $\mathbb P_\varphi [y \mid x]$ we can obtain a distribution $\pi; \varphi$ on $y$, known as the *pushforward distribution*, by integrating out $x$:

$$ \mathbb P_{\pi; \varphi} [y] = \int \mathbb P_\pi [x] \cdot \mathbb P_\varphi [y \mid x] \, dx $$

## Bayesian inversion

Suppose we have a Markov kernel $\mathbb P_\varphi [y \mid x]$ are we are shown a sample of its output, but we can't see what the input was. What can we say about the input? To do this, we must start from some initial belief about how the input was distributed: a *prior* $\mathbb P_\pi [x]$. After observing $y$, [Bayes' law](https://en.wikipedia.org/wiki/Bayes%27_theorem) tells us how we should modify our belief to a *posterior distsribution* that accounts for the new evidence. The formula is

$$ \mathbb P [x \mid y] = \frac{\mathbb P_\varphi [y \mid x] \cdot \mathbb P_\pi [x]}{\mathbb P_{\pi; \varphi} [y]} $$

The problem of computing posterior distributions in practice is called [Bayesian inference](https://en.wikipedia.org/wiki/Bayesian_inference), and is very hard and very well studied.

If we fix $\pi$, it turns out that the previous formula for $\mathbb P [x \mid y]$ defines a Markov kernel from $Y$ to $X$, giving the posterior distribution for each possible observation. We call this the *Bayesian inverse* of $\varphi$ with respect to $\pi$, and write $\mathbb P_{\varphi^\dagger_\pi} [x \mid y]$. 

The reason we can have $y$ as the input of the kernel but we had to pull out $\pi$ as a parameter is that the formula for Bayes' law is *linear* in $y$ but *nonlinear* in $\pi$. This nonlinearity is really the thing that makes Bayesian inference hard.

Technically, Bayes' law only considers *sharp* evidence, that is, we observe a particular point $y$. Considering inverse Markov kernels also gives us a way of handling *noisy* evidence, such as stochastic uncertainty in a measurement, by pushing forward a distribution $\mathbb P_\rho [y]$ to obtain $\mathbb P_{\rho; \varphi^\dagger_\pi} [x]$. This way of handling noisy evidence is sometimes called a *Jeffreys update*, and contrasted with a different formula called a *Pearl update* - see [this paper](https://arxiv.org/abs/1807.05609) by [Bart Jacobs](https://www.cs.ru.nl/B.Jacobs/). Pearl updates have very different properties and I don't know how they fit into this story, if at all. Provisionally, I consider the story of this post as evidence that Jeffreys updates are "right" in some sense.

## Deep inference

So far we've introduced 2 operations on Markov kernels: composition and Bayesian inversion. Are they related to each other? The answer is a resounding *yes*: they are related by the formula

$$ (\varphi; \psi)^\dagger_\pi = \psi^\dagger_{\pi; \varphi}; \varphi^\dagger_\pi $$

We call this the *chain rule* for Bayesian inversion, because of its extremely close resemblance to the chain rule for transpose Jacobians that underlies backpropagation in neural networks and differentiable programming:

$$ J^\top_x (f; g) = J^\top_{f (x)} (g) \cdot J^\top_x (f) $$

The Bayesian chain rule is *extremely* folkloric. I conjectured it in 2019 while talking to Toby, and he proved it a few months later, writing it down in his unpublished preprint [Bayesian Updates Compose Optically](https://arxiv.org/abs/2006.01631). It's definitely not new - *some* people already know this fact - but extremely few, and we failed to find it written down in a single place. (I feel like it should have been known by the 1950s at the latest, when things like dynamic programming were being worked out. Perhaps it's one of the things that was well known in the Soviet Union but wasn't discovered in the West until much later.) The first place Toby *published* this fact was in [The Compositional Structure of Bayesian Inference](https://arxiv.org/abs/2305.06112) with [Dylan Braithwaite](https://dylanbraithwaite.github.io/about.html) and me, which fixed a minor problem to do with zero-probability observations in a nice way.

What this formula tells us is that if we have a Markov kernel with a known factorisation, we can compute Bayesian posteriors efficiently if we already know the Bayesian inverse of each factor. Since this is exactly the same form as differentiable programming, we have good evidence that it can go *brrr*. At first I thought it was completely obvious that this must be how compilers for probabilistic programming languages work, but it turns out this is not the case at all, probabilistic programming languages are monolithic. I've given this general methodology for computing posteriors compositionally the catchy name *deep inference*, by its very close structural resemblance to deep learning.

## Variational inference

I wrote "we can compute Bayesian posteriors efficiently if we already know the Bayesian inverse of each factor", but this is still a big *if*: computing posteriors even of simple functions is still hard if the dimensionality is high. Numerical methods are used in practice to approximate the posterior, and we would like to make use of these while still exploiting compositional structure.

The usual way of approximating a Bayesian inverse $\varphi^\dagger_\pi$ is to cook up a functional form $\varphi^\prime_\pi (p)$ that depends on some parameters $p \in \mathbb R^N$. Then we find a loss function on the parameters with the property that minimising it causes the approximate inverse to converge to the exact inverse, ie. $\varphi^\prime_\pi (p) \longrightarrow \varphi^\dagger_\pi$. This is called *variational inference*.

There are many ways to do this. Probably the most common loss function in practice is [KL divergence](https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence) (aka *relative entropy*),

$$\mathbf{KL} (\varphi^\dagger_\pi, \varphi^\prime_\pi (p)) = \int \mathbb P_{\varphi^\dagger_\pi} [x \mid y] \log \frac{\mathbb P_{\varphi^\dagger_\pi} [x \mid y]}{\mathbb P_{\varphi^\prime_\pi (p)} [x \mid y]} \, dx $$

This expression is a function of $y$, which can optionally also be integrated over (but the next paragraph reveals a better way to use it). A closely related alternative is [variational free energy](https://en.wikipedia.org/wiki/Evidence_lower_bound), which despite being more complicated to define is more computationally tractable.

Ideally, we would like to use a functional form for which we can derive an analytic formula that tells us exactly how we should update our parameters to decrease the loss, given (possibly batched) Monte Carlo samples that are assumed to be drawn from a distribution in a certain class, such as Gaussians.

Of course in 2024 if you are *serious* then the functional form you use is a deep neural network, and you replace your favourite loss function by its derivative. I refer to this version as *deep variational inference*. There is no fundamental difference in theory, but in practice deep variational inference is necessary in order to go *brrr*.

## Passive inference is compositional

Now, suppose we have two Markov kernels $\mathbb P_\varphi [y \mid x]$ and $\mathbb P_\psi [z \mid y]$ which we compose. Suppose we have a prior $\mathbb P_\pi [x]$ for $\varphi$, which pushes forward to a prior $\mathbb P_{\pi; \varphi} [y]$ for $\psi$. We pick a functional form for approximating each Bayesian inverse, which we call $\mathbb P_{\varphi^\prime_\pi (p)} [x \mid y]$ and $\mathbb P_{\psi^\prime_{\pi; \varphi} (q)} [y \mid z]$.

Doing this requires a major generalisation of our loss function. This was found by Toby Smithe in [Compositional active inference 1](https://arxiv.org/abs/2109.04461). The method he developed comes straight from [compositional game theory](https://arxiv.org/abs/1603.04641), and this appearance of virtually identical structure in game theory and Bayesian inference is absolutely one of the most core ideas of [categorical cybernetics](https://cybercat-institute.github.io/2022/05/29/what-is-categorical-cybernetics/) as I envision it.

The idea is to define the loss of an approximate inverse to a kernel $\varphi : X \to Y$ in a *context* that includes not only a prior distribution on $X$, but also a (generally nonlinear) function $k$ called the *continuation*, that transforms probability distributions on $Y$. The continuation is a black box that describes how predictions transform into observations. Then when $y$ appears free in the expressions for KL divergence and variational free energy, we integrate it over the distribution $k (\pi; \varphi)$.

So for our composite kernel $\varphi; \psi$, as well as the prior $\pi$ on $X$ we also have a continuation $k$ that transforms distributions on $Z$. In order to optimise the parameters $(p, q)$ in this context, we divide into two sub-problems:

- Optimise the parameters $p$ for $\varphi$ in the context given by the prior $\pi$ on $X$ and the continuation $k'$ on $Y$ given by $k' (\sigma) = k (\sigma; \psi); \psi'_\sigma (q)$
- Optimise the parameters $q$ for $\psi$ in the context given by the prior $\pi; \varphi$ on $Y$ and the continuation $k$ on $Z$

Notice that the optimisation step for $p$ involves the current value of $q$, but not vice versa. It is easy to prove that this method correctly converges to the total Bayesian inverse by a dynamic programming argument, if we first optimise $q$ to convergence and then optimise $p$. However, Toby and me conjecture that this procedure also converges if $p$ and $q$ are optimised asynchronously, which means the procedure can be parallelised.

## Active inference is emergent

The convergence conjecture in the previous section crucially relies on the fact that the prediction kernels $\varphi$ and $\psi$ are fixed, and we are only trying to approximate their Bayesian inverses. That is why I referred to it as *passive inference*. The term *active inference* means several different things (more on this in the next section) but one thing it should mean is that we simultaneously learn to do both prediction and inference.

Toby and me think that if we do this, the compositionality result breaks. In particular, if we also have a parametrised family of prediction kernels $\varphi (p)$ which converge to our original kernel $\varphi$, it is *not* the case that

$$ \psi^\prime_{\pi; \varphi (p)} (q); \varphi^\prime_\pi (p) \longrightarrow (\varphi; \psi)^\dagger_\pi $$

Specifically, we think that the nonlinear dependency of $\psi^\prime_{\pi; \varphi (p)} (q)$ on $\varphi^\prime (p)$ causes things to go wrong.

One way of saying this negative conjecture is: *compositional active inference can fail to converge to true beliefs, even in a stationary environment*. The main reason you'd want to do this anyway, even at the expense of getting the wrong answer, is that it might go *brrr* - but whether this is really true remains to be seen.

We can, however, put a positive spin on this negative result. I am known for the idea that *the opposite of compositionality is emergence*, from [this blog post](https://julesh.com/2017/04/22/on-compositionality/). A compositional active inference system does not behave like the sum of its parts. The interaction between components can prevent them from learning true beliefs, but can it do anything positive for us? So far we know nothing about how this emergent learning dynamics behaves, but our optimistic hope is that it could be responsible for what is normally called things like *intelligence* and *creativity* - on the basis that there aren't many other places that they could be hiding.

## How to build a brain

Boosted by the last paragraph, we now fully depart the realm of mathematical conjecture and enter the outer wilds of hot takes, increasing in temperature towards the end.

So far I've talked about active inference but not mentioned what is probably the most important thing in the cloud of ideas around the term: conflating *prediction* and *control*. Ordinarily, we would think of $\mathbb P_{\pi; \varphi} [y]$ as *prediction* and $\mathbb P_{\varphi^\dagger_\pi} [x \mid y]$ as *inference*. However it has been proposed (I believe the idea is due to [Karl Friston](https://www.fil.ion.ucl.ac.uk/~karl/)) that in the end $\mathbb P_{\pi; \varphi} [y]$ is interpreted as a command: at the end of a chain of prediction-inference devices comes an actuator designed to act on the external environment in order to (try to) make the prediction true. That is, a prediction like "my arm will rise" is *the same thing* as the command "lift my arm" when connected to my arm muscles.

This lets us add one more piece to the puzzle, namely *reinforcement learning*. A deep active inference system can interact with an environment (either the real world or a simulated environment), by interpreting its ultimate predictions as commands, effecting those commands into the environment, and responding with fresh observations. Over time, the system should learn to predict the response of the environment, that is to say, it will learn an *internal model* of its environment. If several different active inference systems interact with the same environment, then we should consider the environment of each to contain the others, and expect each to learn a model of the others, recursively.

I am not a neuroscientist, but I understand it is at least plausible that the compositional structure of the mammalian cortex exactly reflects the compositional structure of deep active inference. The cortex is shaped (in the sense of connectivity) approximately like a pyramid, with both sensory and motor areas at the bottom. In particular, the brain is *not* a [series of tubes](https://en.wikipedia.org/wiki/Series_of_tubes) with sensory signals going in at one end and motor signals coming out at the other end. Obviously the basic pyramid shape must be modified with endless ad-hoc modifications at every scale developed by evolution for various tasks. So following Hofstadter's [Ant Fugue](http://bert.stuy.edu/pbrooks/fall2014/materials/HumanReasoning/Hofstadter-PreludeAntFugue.pdf), I claim *the cortex is shaped like an anthill*.

The idea is that the hierarchical structure is roughly an *abstraction* hierarchy. Predictions (aka commands) $\mathbb P_\varphi [y \mid x]$ travel down the hierarchy (towards sensorimotor areas), transforming predictions at a higher level of abstraction $\mathbb P_\pi [x]$ into predictions at a lower level of abstraction $\mathbb P_{\pi; \varphi} [y]$. Inferences $\mathbb P_{\varphi^\dagger_\pi} [x \mid y]$ travel up the hiererachy (away from sensorimotor areas), transforming observations at a lower level of abstraction $\mathbb P_\rho [y]$ into observations at a higher level of abstraction $\mathbb P_{\rho; \varphi^\dagger_\pi} [x]$.

Given this circularity, with observations depending on predictions recursively through many layers, I expect that the system will learn to predict *sequences* of inputs (as any recursive neural network does, and notably *transformers* do extremely successfully) - and also *sequences of sequences* and so on. I predict that stability will increase up the hierarchy - that is, updates will usually be smaller at higher levels - so that at least conceptually, higher levels run on a slower timescale than lower levels. This comes back to ideas I first read almost 15 years ago in the book [On Intelligence](https://us.macmillan.com/books/9780805078534/onintelligence) by Jeff Hawkins and Sandra Blakeslee.

Conceptually, this is exactly the same idea I wrote about in [chapter 9](https://link.springer.com/chapter/10.1007/978-3-031-08020-3_9) of [The Road to General Intelligence](https://link.springer.com/book/10.1007/978-3-031-08020-3) - the main difference is that now I think I have a good idea how to actually compute commands and observations in practice, whereas back then I hand-crafted a toy proof of concept.

If both sensory and motor areas are at the bottom of the hierarchy, this raises the obvious question of what is at the *top*. It probably has something to do with long term memory formation, but it is almost impossible to not be thinking about *consciousness* at this point. I'm going to step back from this so that the hot takes in this post don't reach their ignition temperature before the next paragraph.

The single hottest take that I geuinely believe is that *deep variational reinforcement learning is all you need*, and is the only conceptually plausible route to what is sometimes sloppily called "AGI" and what I refer to in private as "true intelligence".

I should mention that none of my collaborators is as optimistic as me that *deep variational reinforcement sequence learning is all you need*. Uniquely among my collaborators, I am a hardcore connectionist and I believe good old fashioned symbolic methods have no essential role to play. Time will tell.

My long term goal is *obviously* to build this, if it works. My short term goal is to build some baby prototypes starting with passive inference, to verify and demonstrate that what works in theory also works in practice. So watch this space, because the future might be wild...
