---
layout: post
title: "On Hopfield Networks and Boltzmann Machines"
author: Oliver Beige
date: 2024-10-14
categories: [economics, machine learning]
excerpt: In which we connect the physics Nobel Prize to machine learning and economic design.
---

> "All of this will lead to theories [of computation] which are much less rigidly of an all-or-none nature than past and present logic. They will be of a much less combinatorial, and much more analytical, character.
>
> In fact, there are numerous indications to make us believe that this new system of formal logic will move closer to another discipline which has been little linked in the past with logic. 
>
> This is thermodynamics, primarily in the form it was received from Boltzmann, and is in part theoretical physics which comes nearest in some of its aspects to manipulating and measuring information."
>
> -- John Von Neumann, The General and Logical Theory of Automata, [1948](https://www.vordenker.de/ggphilosophy/jvn_the-general-and-logical-theory-of-automata.pdf).

Allow me a quick excursion from the regular programming to celebrate the [2024 physics Nobel Prize](https://www.nobelprize.org/prizes/physics/2024/summary/) awarded to [John Hopfield](https://www.nobelprize.org/prizes/physics/2024/hopfield/facts/), inventor of the eponymous Hopfield network, and [Geoffrey Hinton](https://www.nobelprize.org/prizes/physics/2024/hinton/facts/), co-inventor (with [Terrence Sejnowski](https://www.salk.edu/scientist/terrence-sejnowski/)) of the Boltzmann machine.

Since this is an economic design series, the question why a physics Nobel, and especially a Nobel Prize awarded for a contribution to machine learning, should be of interest is a fair one.

The long answer is that, having spent a few long years translating the underlying mechanisms of both networks into economic game theory, and in turn into the emergence of consensus (or its opposite, partisanship) in social groups, I think I can offer a fairly unique perspective to discuss the impact of this prize on economics.

The short answer is that these two networks also shape the whole economic outlook presented in EconPatterns.

To recapitulate.

In the first post, I established the economy as a network of a small set of fundamental activities: [stocks, flows, transformations](https://cybercat.institute/2024/03/08/stocks-flows-transformations/), which have to be orchestrated to produce desirable outputs. 

This orchestration requires [agreement on beliefs](https://cybercat.institute/2024/08/15/belief-propagation-clusters/) among participants, first that these activities do indeed lead to these outcomes, and second that these outcomes are indeed desirable. 

This framing mapped a network of economic activities onto a belief network, with the underlying assumption that unless all participants have perfectly homogenous beliefs, goal conflict within the network becomes inevitable as the network becomes larger, until ultimately the network has to crumble into smaller subnetworks (aka clusters) that can hold shared beliefs.

Expressed in the [first law of organization](https://cybercat.institute/2024/03/22/on-organization/): the objective of organization is to resolve the conflict between moving forward (orchestrate activities that produce a desirable output) and staying together (hold the shared belief that these activities do indeed lead to the proposed desirable output).

Where this conflict cannot be resolved within an organization, [competition emerges](https://econpatterns.substack.com/p/a-five-minute-political-economy).

Competition is the starting point of economic inquiry, and it typically treats it as exogenous. In other words, competition has to happen, and by virtue of simply happening (and by drawing attention to surpluses and scarcity in the economic network via price signals) it helps steer the economy in the right direction.

What it skips is the question where exactly the beliefs diverge sufficiently that orchestration within the same organization is no longer possible so that rifts open up and competition emerges.[^1]

[^1]: This is of course extremely truncated. The famous [economic calculation debate](https://en.wikipedia.org/wiki/Economic_calculation_problem) centered on the question of central planning, where “central” was defined as the administrative state also orchestrating economic activity. The perspective EconPatterns takes is of course a different one, as laid out in the newsletters on [organizations as tectonic plates](https://cybercat.institute/2024/03/22/on-organization/) and the [blurry boundary between economics and operations research](https://cybercat.institute/2024/05/17/economics-operations-research/).

This is a question that economics of organization tries to tackle in the form of the make-or-buy decision, but finding an appropriate formalization has been elusive. And this is where Hopfield, Hinton, and Sejnowski come in.

## Hopfield networks and belief clustering

To make that leap we first have to divest ourselves from any expectation that our formalization expresses any kind of tangible economic activity, and accept that we go down to bare-bones expressions of individual beliefs, and the main activity is to both be influenced by and trying to influence the beliefs of ours peers. 

In other words, for any proposition, participants express their beliefs in the simplest possible way as subjective expectations: in simple Boolean logic, zero for "I believe it’s false", one for "I believe it’s true", or in a stochastic setting, any value between zero and one as the expression how probable they consider the proposition to be true. (Alternatively we can consider a wider range from −1 to +1 to express opposing beliefs, which is especially useful in political settings.)

Hopfield’s [first paper](https://www.pnas.org/doi/abs/10.1073/pnas.79.8.2554), published in the midst of the first "[AI winter](https://en.wikipedia.org/wiki/AI_winter)" in 1982, astounds in its brevity. It is only five pages long. 

Up to this juncture, including the emerging connectionist revolution that lead to Rumelhart & McClelland’s famous [two-volume work](https://mitpress.mit.edu/9780262680530/parallel-distributed-processing/) in 1986 (which also included Hinton & Sejnowski’s paper), neural networks where almost exclusively conceived as feedforward networks (information flows from input to output) with backpropagation (feedback flows from output to input) as learning mechanism.

Hopfield’s recognition was to fold the network unto itself: all network nodes can send and receive signals to and from all others, and the designation as input or output nodes is arbitrary. 

In isolation this wouldn’t be particularly interesting, but the marvel of neural networks in general, and Hopfield networks in particular, is that the behaviors of individual nodes are connected, and that this connectivity can be expressed in a weight (or covariate) matrix, where high positive weights translate as "shared beliefs" and high positive weights as "opposing beliefs".

Neural networks function in two modes: training mode (weights are flexible) and execution mode (weights are fixed). Training in this case translates into finding out which nodes hold correlating beliefs, and setting the weights accordingly.

Hopfield’s question is what happens when a connected network with a given set of (symmetric) weights plus a vector of isolated beliefs (aka biases) per node is allowed to converge from a given starting state (the input) to a stable state (the output), when each node tries to agree with all connected neighboring nodes with shared beliefs and disagree with neighboring nodes with opposing beliefs.

Hopfield’s first paper from 1982 tackles this question with a Boolean choice of zero and one for all nodes, and a [second paper](https://www.pnas.org/doi/abs/10.1073/pnas.81.10.3088) from 1984, also five pages long, expands this to allow uncertainty in the form of probabilistic belief values between zero and one, plus a sigmoid function to connect inputs and outputs. 

His conclusion, in the shortest possible form, is that the network exhibits memory, in a form that makes it a "content-addressable memory". 

In other words, the network converges from an input pattern to the nearest pattern it has been trained on — an important feature in pattern recognition with an obvious early application in detecting handwriting. If the input pattern is something that vaguely looks like a 7, the output ideally should identify this as a 7 and not a 3.

Under the right conditions, if the training data set contains a number of shapes that are vaguely 7-ish looking, the network should memorize this as a distinct pattern and when activated, recognize this.

In somewhat more technical language, the network should contain local optima representing the trained-on patterns and basins of attraction that capture all the trained variants (and their interpolations).

## Boltzmann machines and the rationality of erratic behavior

As a physics-inspired mathematical construct, this is extremely neat and its translation into belief-driven collective action expands beyond the metaphorical similarity. Implemented as a feedback network, it has quite a few drawbacks which curbed its widespread adoption in favor of less finicky backpropagation architectures.

One major drawback, in an analogy to what I like to call the "bicycle repair cooperative on Shattuck Ave", is that it doesn't scale particularly well.

Shattuck Avenue is in downtown Berkeley and the bicycle cooperative prided itself on its strong collectivist ethos, where all topics are discussed and decided together. This might work if the collective is small and beliefs are highly aligned, but runs into trouble when the collective gets bigger (adding one new member adds *N* new connections) and beliefs diverge. 

Which is why "fully connected consensus" never translates as a template for large companies.

The other problem is that it produces a whole lot of local optima which don't map to trained patterns, so the network is always at risk of producing meaningless output — a problem that also increases with network size.

One remedy for this comes from Hinton & Sejnowski's [Boltzmann machine](https://www.cs.toronto.edu/~hinton/absps/bmtr.pdf), which introduces "vanishing noise" as a means to avoid local minima.

Vanishing noise just means that as a node is called upon to update its belief (aka state), we introduce a small likelihood that the node accepts a new state even if it is unfavorable, and that this likelihood becomes smaller over time.

This is very much an analogy for shaking up the system, implemented as "distributed [simulated annealing](https://en.wikipedia.org/wiki/Simulated_annealing)" — annealing being the metallurgical procedure to add short spurts of heat in a cooling process to avoid getting trapped in imperfect lattice structures.

The connection to [thermal annealing](https://en.wikipedia.org/wiki/Annealing_(materials_science)) not only creates a connection to physics proper, it also opens another batch of neat features. 

For one, we suddenly have a system that even if behavior happens on the individual level — each node updates its belief individually and only according to its own interests — we can still express the behavior of the whole system in a single macro equation. 

The economic equivalent of this is a [potential game](https://www.sciencedirect.com/science/article/abs/pii/S0899825696900445) (introduced by Dov Monderer and another Nobelist, Lloyd Shapley) where changes in individual utilities can be captured in a single equation for the whole game.

The other intriguing feature is that under vanishing noise, we can characterize the equilibria the system reaches using the eponymous [Boltzmann distribution](https://en.wikipedia.org/wiki/Boltzmann_distribution), which tightly connects the model to statistical mechanics, and in turn to entropy, free energy, and — importantly for us — [surprise](https://cybercat.institute/2024/03/15/attention-seeking-rational-actor/).

This might answer the question why the physics Nobel committee deemed their work worthy of recognition. 

In the early 1980s, at a time when artificial intelligence in general and perceptrons in particular were seemingly going nowhere, a bunch of researchers centered around Princeton and Carnegie Mellon put computation on a physical footing, just as John Von Neumann had predicted.

## Economics of influence, economics of attention

But the goal of this post is not to resolve the befuddlement that befell some physicists at the news that the physics prize was seemingly awarded to a discovery in computer science, but to map out why this matters to economics, and in particular to economic design.

Starting out in this endeavor, I had at best a vague notion of statistical mechanics and mostly considered this kind of feedback network a bare-bones metaphorical model of what would happen in a social group that faces a simple binary choice and influences each other in their choices, couched in the at the time headlines-making problem of technology standard competition, with the major claim to novelty being that if you consider heterogeneous network effects, you’ll get more interesting results — especially that you can get interesting partisan dynamics that go against the then agreed-upon paradigm that positive network effects inevitably lead to monopolization.

The findings were mostly met with indifference at the time, but economics has evolved significantly since then. Graph theory has become a recognized tool in large part because of the emergence of social networks and the "network science" revolution in sociology. Machine learning has arrived in economics some ten years ago and is currently in a state that can only be described as feeding frenzy. 

There is a recognition that the landscape of products is unsurveyable for the consumer, leading to attention dynamics and [herding behavior](https://snap.stanford.edu/class/cs224w-readings/bikhchandani92fads.pdf) (then of little interest outside finance), and to the introduction of two novel [economic engines](https://econpatterns.substack.com/p/governance-mechanisms-and-economic) that found widespread adoption in the internet age: recommender engines and reputation engines.

There is an emerging understanding that preferences are not inscrutable and outside the scope of economic inquiry, but that they are tractable and that they evolve in [predictable ways](https://econpatterns.substack.com/p/a-five-minute-political-economy).

There is now far less discomfort dealing with scenarios that have more than one equilibrium, so existence proofs have gradually given way to convergence and evolutionary dynamics.

[Bayesian inference](https://en.wikipedia.org/wiki/Bayesian_inference), including [Bayesian games](https://en.wikipedia.org/wiki/Bayesian_game) of incomplete information, is slowly making inroads, giving us a richer toolset to thing about belief propagation and the evolution of norms.

And most importantly, very rich interaction data has become available, pushing the "not very interesting" findings of ideological polarization as an outcome of network heterogeneity to the forefront of the academic (and non-academic) debate.

My own position also evolved over time. 

For one, I no longer consider it merely a metaphorical model of human behavior, useful as an illustrative but empirically intractable shorthand for what happens in a social group when traditional preferences and peer influence intersect. 

The evidence that statistical mechanics plays a role not only in human behavior, that thing we call rationality (or even bounded rationality), but also in the [goal-directed behavior of organisms](https://oliverbeige.medium.com/milton-friedman-and-the-surprising-rationality-of-trees-f6b86d144c8d) we don't generally consider rational, keeps mounting, as I mapped out in the post on [surprises for eyeballs](https://cybercat.institute/2024/03/15/attention-seeking-rational-actor/) as the fundamental exchange of (not only) the attention economy.

Mostly outside of economics, much progress has been made at the intersection of statistical mechanics, Bayesian inference, and information theory, and it slowly trickles into economics proper via the translation into [(evolutionary) game theory](https://en.wikipedia.org/wiki/Evolutionary_game_theory).

Cognitive effort is a scarce resource which needs to be allocated towards the activities that promise the highest return. The mechanism by which this allocation happens is attention, a term that, other than a common acceptance that we now live in the attention economy, has gained little traction in economics, even if the administration of scarce resources is at the core of economic theory.

In economic design this is somewhat different, since it ultimately deals with [conceiving structures](https://econpatterns.substack.com/p/governance-mechanisms-and-economic) that facilitate mutually beneficial exchange. So the orthodoxy that befits theory is of little help, as the primary goal is to make the engines work, to make sure they fulfill their designed function. 

This inevitably requires a wider vocabulary, including learning agents, including agents that learn from each other, including agents that form belief clusters as the subset of peers they're willing to learn from. That includes machine learning as a facsimile for learning agents.

This also includes investigating rationally erratic behavior, mutation, or "physiological" annealing, deviation from self-interested behavior that gets more frequent as the temperature increases.

It includes developing an understanding of the emergence of norms as decentralized constraints of individual behavior.

Once we start incorporating these tools into our design handbook, it quickly becomes apparent that they go a long way towards explaining common behaviors, including behavior we don't necessarily consider "economic". 

It also fuels the prospect that we will conclude in due time that the mechanism Hopfield, Hinton, and their peers described is embedded in far more biological systems than we thought, and maybe humans are indeed [lightning calculators of pleasure and pain](https://www.jstor.org/stable/1882952), but not in the way we assumed they were.

## Literature

- John J. Hopfield, "Neural networks and physical systems with emergent collective computational abilities", PNAS, [1982](https://www.pnas.org/doi/abs/10.1073/pnas.79.8.2554).
- John J. Hopfield, "Neurons with graded response have collective computational properties like those of two-state neurons", PNAS, [1984](https://www.pnas.org/doi/abs/10.1073/pnas.81.10.3088).
- Geoffrey E. Hinton, Terrence J. Sejnowski, David H. Ackley, "Boltzmann machines: constraint satisfaction networks that learn", Tech report, CMU, [1984](https://www.cs.toronto.edu/~hinton/absps/bmtr.pdf).
- Geoffrey E. Hinton, Terrence J. Sejnowski, "Learning and relearning in Boltzmann machines", in Rumelhart & McClelland, [1986](https://www.cs.utoronto.ca/~hinton/absps/pdp7.pdf). 
