---
layout: post
title: "Compositional Game Theory for Revenue Management: A Case Study"
author: Jules Hedges
date: 2025-03-02
categories: economics
usemathjax: false
excerpt: "For the past 6 months we have been working together with a major airline on a pilot research project on dynamic pricing. Specifically we have been working on prototyping a way to do dynamic pricing in a competitor-aware way using game theory. For this we have been using compositional game theory and its natural connections to optimal control and reinforcement learning, and building on the Open Game Engine."
---

For the past 6 months we have been working together with a major airline on a pilot research project[^1] on dynamic pricing. Specifically we have been working on prototyping a way to do dynamic pricing in a competitor-aware way using game theory. For this we have been using compositional game theory and its natural connections to optimal control and reinforcement learning, and building on the Open Game Engine.

[^1]: (pun unintentional but unavoidable)

## A short introduction to revenue management

I expect that most readers of this blog have never heard of revenue management (RM), so I will give a quick introduction, some of which I learned from [this paper](https://pubsonline.informs.org/doi/abs/10.1287/educ.1053.0019).

Every business needs to balance supply and demand. The two main things you can control are how much you produce (supply) and how much you charge for it (demand). Although there are endless complicating factors, in the end you want to sell as much as possible and then produce exactly that amount, with no leftovers. So far so simple.

The airline industry is an example of an industry that has very inflexible supply. You can't just add one extra seat to a plane, and it's not much easier to just add one more flight to your schedule. This means that the balance of supply and demand has to happen mostly from the demand side, through *dynamic pricing*. Although dynamic pricing is now widespread (and increasingly controversial as a result of, let's say, ill-advised application by certain companies), it has been mainstream in the airline industry since the 1980s. The resulting field of how to measure and steer customer demand is known as *revenue management* (RM).

One limitation of the standard RM methodology is that it in a sense treats the user as a monopolist. The existence of competitors manifests in the data, since measured sales are lower than they would be for an actual monopolist, but the theory itself is not really aware of this. This works perfectly well as an approximation as long as the market is relatively static, but when something changes (for example when predicting the effects of adding a new route), RM methods will typically not *ancitipate* the effect on demand of the competitor's actions, only react to it after-the-fact. Of course RM practitioners know this perfectly well, but applied game theory is hard and these markets are very complex, so actually doing RM in a game-theoretic way is easier said than done.

## Enter categorical cybernetics

Our research brings two things to the table. Firstly, market models with competition are not only games but often very large and complex games - and compositional game theory (and our implementation of it, the [Open Game Engine](https://github.com/CyberCat-Institute/open-game-engine)) is far and away the state of the art for implementing large and complex games. Secondly, optimising models in a way that is aware of their compositional structure gives us a distinct advantage over just brute forcing the solution, an advantage that only gets bigger as the market model gets more complex.

Flights operate on essentially a graph whose nodes are airports, and that makes ticket pricing into a kind of graph game. A typical question that arises is how to price a ticket for a single-leg customer vs that leg's contribution to the price of a ticket for a customer with a connecting flight. A much harder question is to predict how prices will react to a structural change, such as adding or removing a route from the network.

Of course we know very well that theory is not the same thing as practice, and the goal of our pilot project was to bridge the gap. The model we built so far is just for a single route, and its only compositional structure is the (comparatively uninteresting) temporal one from selling tickets over a period of time. Although this model is very far from trivial, it was still somewhat overkill to use compositional game theory, and we did so as a very intentional investment in the future to show that it can be done in principle.

For solving the model we used a form of dynamic programming, specifically generalised policy iteration for an action-value function. This kind of method is also often referred to as reinforcement learning, at least when the model is not known (having a model with compositional structure makes the line between dynamic programming and RL even more blurry than usual). When the model is known (and satisfies the right conditions, which ours does), we get various behavioural guarantees that are important for this kind of application.

The reason we use these methods over others is that they "play nice" with compositional structure in general, and especially with the kind that compositional game theory is about. For RL we recently wrote up the beginnings of the theory perspective in [this paper](https://arxiv.org/abs/2404.02688). But we have known that the link from compositional game theory to dynamic programming works in practice since 2019, when I replicated a model from [Barfuss' PhD thesis](https://edoc.hu-berlin.de/items/6c25f536-3c26-4fda-86db-0fe82bd896e9) using the Open Game Engine.

In practice the hardest part to get right was the data that feeds the model. We spent some time making various faulty assumptions about the data our partners gave us, all of which our optimiser would happily exploit resulting in unrealistic behaviour. (Speaking as someone with a theory background, I found it a slightly sobering experience to learn that most of what I knew about software correctness could not help me with this.) But once we got all the assumptions right, we got a model that behaved in realistic ways, and in some cases gave results that suggested policy changes.

## Conclusion

Revenue management and algorithmic pricing are becoming increasingly widespread in an increasing number of industries. It seems to be widely recognised that competitor-aware methods are the next step forwards. This is a clear instance of what Oliver wrote about in [The blurry boundary between economics and operations research](https://cybercat.institute/2024/05/17/economics-operations-research/), that as markets become more complex and interconnected, the approximation of single-principal models starts to break down. Compositional game theory breaks through possibly the biggest barrier to this, that traditional game theory just is not made to handle large and complex models. On the flip side, the biggest barrier to applicability of compositional game theory is the limited applicability of game theory itself, so as a problem that is inherently game-theoretic this is a perfect match.
