---
layout: post
title: "On Modelling"
author: Oliver Beige
date: 2024-09-02
categories: [economics, model]
excerpt: In which we learn why "flat earth" is a perfectly sound scientific proposition and why being wrong two thirds of the time can actually be quite lucrative.
---

Cross-posted from [Oliver's EconPatterns blog](https://econpatterns.substack.com/p/on-modeling)

Despite its bad reputation, "flat earth" is a perfectly scientific, mathematically grounded, and highly useful model of reality.

Indeed, it might be the perfect example to illustrate George Box’s famous aphorism about how [all models are wrong, but some are useful](https://apps.dtic.mil/sti/pdfs/ADA070213.pdf).

We confirm its usefulness every time we open a map, on paper or on a screen, and manage to get from A to B thanks to its guidance, nevermind that it (and we) completely ignored the curvature of the earth all along the way. 

Of course we could’ve consulted a globe, but for most everyday pairings of A and B, a travel-sized globe won’t help us much in navigating the route, and a globe that’s big enough to provide us with sufficient detail about our particular route would be much too big to carry around.

Indeed, if we push this forward, of the hierarchy of simplifying abstractions:
1. earth is flat
1. earth is spherical (a ball)
1. earth is a rotational oblate ellipsoid (a pill)
1. earth is a rotational oblate ellipsoid with a variance in surface elevation never exceeding 0.2% of its diameter.
the last one — hills and valleys — matters much more in everyday life than the knowledge that earth is spherical or even an ellipsoid.

That doesn’t mean it’s entirely useless knowledge. Nobelist Ken Arrow’s very first academic publication, about [optimizing flight paths](https://journals.ametsoc.org/view/journals/atsc/6/2/1520-0469_1949_006_0150_otuowi_2_0_co_2.xml) just after World War 2, pushed the envelope, so to speak, from a planar world to a spherical world.


> "All the literature assumed that the world was flat, that everything was on a plane, which may be germane if you're flying a hundred miles. But we were already flying planes across the Atlantic, from Newfoundland to Scotland. It turned out to be an interesting mathematical problem to change these results to be applicable to the sphere — and that was my contribution." — Kenneth Arrow, [1995](https://www.minneapolisfed.org/article/1995/interview-with-kenneth-arrow).

Indeed today, Arrow's contribution is used in any long-distance flight planning software, and its effect is visible every time we fly from Frankfurt to New York and are surprised looking out the window to find ourselves above Greenland.

But we shouldn’t be led into thinking that before Arrow scientists believed that the earth is flat. They just recognized that for their task it didn’t matter that it wasn’t, and at a time when "computers" were still human professionals rather than electronic devices, simplifying the calculations mattered.

## Unobservables and counterfactuals

One reason why "flat earth" is such a great example for proper modeling is that it gets the point about scope across, simply because modeling scope matches geographic scope: for short hops, flat earth is perfectly fine, but for transatlantic flights, you're bound to run into trouble. Somewhere inbetween is a fuzzy boundary where the simple model gradually fails and complication becomes necessary.

Another reason is that it's a perfect little ploy to expose a particular type of academic conceit, simply because it goes against the Pavlovian reflex by certain academics to roll out "flat earth" as the synecdoche for conclusively disproven pseudoscience. 

But there is a critical difference between claiming earth is flat (an empirical hypothesis without support) and proposing a deliberate counterfactual of a flat earth (a modeling design choice), and it strikes at the heart of George Box's aphorism, which we could amend to say that models are useful because they are wrong. 

A map is useful *because* it’s not the territory.

This distinction is crucial, because so many people, including and maybe especially academics get it wrong: a counterfactual is not the same as an unobservable. 

Unobservables are hidden truths. Counterfactuals are openly expressed falsehoods. 

In model design, counterfactuals — things we invoke even if we know they're wrong — play an important role in the form of assumptions, which is why making assumptions explicit is a crucial but oft-ignored exercise in model design.

## From flat to round

Graduate students in econometrics often get the advice (or at least used to) to pick up Peter Kennedy's A Guide to Econometrics in addition to whichever weighty and forbidding tome is assigned as the official textbook (typically Greene's [doorstop](https://archive.org/details/econometricanaly0000gree)), with the undertone that [Kennedy's book](https://archive.org/details/guidetoeconometr0005kenn) might provide a cheat code to unlock the arcane secrets encloistered in its more voluminous peer.

Kennedy succeeds in doing this not because he dilutes the mathematical heft of the official textbooks, but because he offers a very succinct exposé of how we should approach ordinary least squares (OLS), the workhorse of econometric modeling. Step by step:
- This is the original OLS setup
- Here are the five major assumptions that undergird it
- Because of these assumptions, the scope of OLS in its original form is quite limited
- But we can, one by one, test if each assumption is violated and implement a fix
-  And if everything fails, here are a few alternatives…

This is so lucid that it’s surprising (and somewhat disheartening) to see it rarely ever expressed in this succinct — and compositional — form. 

Assumptions are counterfactuals that limit the scope, and to expand the scope we have to investigate and potentially drop some of the assumptions, but this always involves a tradeoff between parsimony and universality.

Models are by design complexity-reducing conceits. But for this to be successful the modeler has to be willing to start by ruthlessly reducing complexity to expose the underlying mechanism, and academia isn’t always an environment where Occam’s razor is sharp.

Stereotypically speaking, academia is incentivized to err on the side of giving convoluted answers, including giving convoluted answers to simple questions, or even the worst of all words: convoluted wrong answers to simple questions. 

Pretty much everyone in academia who laughed about large language models getting very simple questions horribly wrong (["9.11>9.9"](https://x.com/goodside/status/1812977352085020680), ["how to ferry a goat"](https://chatgpt.com/share/fc0a96a4-bba8-45e4-b5f6-f6b0b4a03915), ["countries with 'mania'"](https://chatgpt.com/share/2cd103c9-2e02-476a-a22d-c345eec49acf)) should’ve felt a pang of recognition. Trying to get the big questions right often comes at the cost of getting the simple questions wrong. That might be an acceptable tradeoff in academia, in design it can be fatal.

> "Since all models are wrong the scientist cannot obtain a "correct" one by excessive elaboration. On the contrary following [William of Occam](https://en.wikipedia.org/wiki/William_of_Ockham) he should seek an economical description of natural phenomena. Just as the ability to devise simple but evocative models is the signature of the great scientist so overelaboration and overparameterization is often the mark of mediocrity." — George Box, [1976](https://www-sop.inria.fr/members/Ian.Jermyn/philosophy/writings/Boxonmaths.pdf).

The point Box tries to drive home is not only that there are decreasing returns to upping model complexity and pursuing correctness is an elusive goal, but that returns are indeed quite often negative.

## Models and the cybernetic economy

The scene-setting assumption of EconPatterns, expressed in the very [first post](https://cybercat.institute/2024/03/08/stocks-flows-transformations/), is that we operate in a cybernetic economy were macroeconomic aggregates are often deceptive. 

[Economic engines](https://econpatterns.substack.com/p/governance-mechanisms-and-economic) — take for example a dynamic pricing model for an airline or an energy provider — are elaborate beasts by necessity. If we want to capture time, portfolio, geography, bundling, and other consumer preferences in price finding, we are quickly confronted with a staggering number of variables we have to juggle to produce anything coherent, nevermind accurate, which seems to go counter to Box's remonstrances about beauty in simplicity. 

But the seeming contradiction is easily resolved. Even the newsletter emphasized that "economics usually skips this operational layer for the sake of expositional expediency, *and for the most part it does ok doing so*."

The skill in modeling rests first and foremost in the ability to ruthlessly pursue parsimony, but also in the ability to recognize when and where parsimony fails us. 

Translated into a design strategy, this means both to have a mental model of the ultimate end product when starting with the first sketches, but also to recognize the underlying fundamental mechanisms — the primitives — in the end product. 

The only way to resolve this is to modularize the design process, not only to make it composable (we can assemble the system from the modules), but also compositional (we can infer system behavior from module behavior). 

## What if models are wrong?

Anyone who has ever spent any time in the engine rooms of capitalism knows how ubiquitous quantitative modeling is to predict anything at all. Even smalltown bakeries predict sales to decide how much flour to buy and how many loaves of bread to bake. Insurances run massive predictive operations staffed by actuaries. Even the microchips in our smart phones use prediction to allocate tasks. 

We are surrounded by model-based predictions in our everyday lives, indeed one might claim our livelihoods depend on them. We just choose to ignore them because they’re mostly operating quite well until we're confronted with the consequences of them breaking down — the negative surprise that gets our attention.

Undergrad microeconomic classes at business schools teach expected value of imperfect information ([EVII](https://treeplan.com/wp-content/uploads/value-of-imperfect-information.pdf)) as a simple "managerial" framework to explain Bayesian updating from a decision-theoretic perspective. 

If you as a decision maker have a 20% chance of being right in your predictions, how much would you pay someone who has a track record of being right 30% of the time for a particular prediction? Not much, you’d think.

Narrowly speaking, that's a pretty good mental model about how the consulting industry works, but a bit more philosophically speaking, the idea that models have to be perfect to be useful is a (very common) fallacy — usually expressed as "we don't have enough data to model anything" or "the model made a wrong prediction so the model must be wrong". Indeed models can often be especially useful even if they are far from accurate. 

Strictly economically speaking, models are useful if they shift the probability of being right about the future upward, even if it's only by a small delta. We only have to compare the salaries of baseball players who hit a .200 batting average (the proverbial [Mendoza line](https://en.wikipedia.org/wiki/Mendoza_Line)) with those who hit at [a .300 clip](https://www.espn.com/mlb/history/leaders). Getting it wrong 70 percent of the time can be a pretty lucrative skill under the right circumstances.

The purpose of modeling is to reduce the propensity of negative surprise, which is why we usually only notice when they do the opposite. 

To update Max Planck’s famous dictum that [science progresses one funeral at a time](https://en.wikipedia.org/wiki/Planck%27s_principle), formal modeling helps us to speed up science so that it progresses one public embarrassment at a time — which happens every time a confidently made prediction is stumped by reality.[^1]

[^1]: It should be noted here that Planck’s dictum itself is an astute observation about belief systems and the glacial progress of belief propagation in academia. This might be worth its own newsletter.

To up the ante, managerially speaking, models are important decision tools even if they don't improve chances of being right at all, simply because they act as tiebreaker tools to overcome decision paralysis, especially in scenarios where "we don't have enough data to model anything". 

It's a simple explanation why soothsaying and bird divining existed throughout history, and why they’re still around. Sometimes people need a device — any device — to prune the branches of their personal decision trees, to overcome the form of decision paralysis we know as "procrastination".

Good models, beyond improving predictive accuracy, also help simply by providing a formal grid to map out the structure of the decision scenario. This is what makes [game (and decision) theory](https://econpatterns.substack.com/p/designing-economic-mechanisms-the) relevant: it's a formal tool to map out the interrelatedness of scenarios around the decisions the participants face.

## How to decide if models are wrong

Popular opinions about modeling range from "a modeled prediction establishes a scientific fact" to "models can't predict anything at all since (prominent example where a model went wrong)". Strangely enough, both mental models seem to be especially popular in the natural sciences, sometimes even proposed by the same person.

Neither of these extreme positions have any grounding in reality, and their popularity is likely more the result of ambiguity intolerance and conceptual problems with the idea that improvement can come in the form of an upshift in likelihoods.

As Milton Friedman put it in the context of positive economics as a scientific endeavor:

> "Its task is to provide a system of generalizations that can be used to make correct predictions about the consequences of any change in circumstances. Its performance is to be judged by the precision, scope, and conformity with experience of the predictions it yields." — Milton Friedman, [1953](https://www.wiwiss.fu-berlin.de/fachbereich/bwl/pruefungs-steuerlehre/loeffler/Lehre/bachelor/investition/Friedman_the_methology_of_positive_economics.pdf).

But this is only one side of a coin. We can devise models that are purely predictive (the internal causal mechanism remains opaque to us) or models that are purely causal (they make no claim about predictive accuracy or might even be deliberately wrong in the expectation that how and where they go wrong reveals something about the internal causal mechanics) — like we do with pretty much every financial plan ever.

Most models end up somewhere in-between on that spectrum. The important thing is to be upfront about what the design objective is.

I’ve written about the role of modeling in science, the social sciences, and economics before, but it remains a contested issue, so it felt like devoting a whole post to it might be worth the effort. 

My take is ultimately shaped by my own experience in industry, and in turn shapes what I am trying to achieve with EconPatterns. 

The short version is that formal modeling is a relevant part of economic practice, especially the unobserved part (the "engine room") of economic practice, that a sound understanding of formal modeling tools is necessary for anyone within economics (even if the need for mathematical rigor varies widely between fields). 

The economy is also a data-rich environment, and we have enough experience to know that certain things in the economic realm are bound to follow discernible and generalizable patterns.

But formal modeling has to rest on a sound conceptual understanding, and economic endeavors, especially those that include economic design, should spend enough time on the conceptual architecture to not end up building complicated models that fail at the simple answers.

*On the same topic, see also [Philipp Zahn's perspective](https://cybercat.institute/2024/07/15/usefulness-models/).*
