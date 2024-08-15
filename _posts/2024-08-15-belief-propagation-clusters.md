---
layout: post
title: "Beliefs, Belief Propagation and Belief Clusters"
author: Oliver Beige
date: 2024-08-15
categories: [economics]
excerpt: "In which we try to capture all the ways how beliefs can shape social and economic interaction."
---

Cross-posted from [Oliver's EconPatterns blog](https://econpatterns.substack.com/p/beliefs-belief-propagation-and-belief)

There's a non-zero chance that sometime in the not-so-far future we will think of the "Bayesian Revolution" in the same way we think of the "Marginal Revolution". 

Bayesian beliefs give us the same opportunity to think of expectations as an attribute linked to the observer rather than to the observed object in the same way utilities gave us an opportunity to accept that value is not an attribute intrinsic to an object, but exists only in the eye of the beholder. 

Much of modern economics rests on the recognition that differences in valuation create opportunities for mutually beneficial — and thus voluntary — exchange.

We're still a few steps away from translating that recognition to differences in expectations, in no small part because most of the current effort seems to go into trying to shoehorn [Bayesian statistics](https://en.wikipedia.org/wiki/Bayesian_statistics) into the domains dominated by trad statistics (aka [frequentism](https://en.wikipedia.org/wiki/Frequentist_inference)), but one dimension on which we're inching towards a better understanding of subjective probabilities is that it's slowly dawning on us that there might be perfectly legitimate reasons why different individuals might attach different likelihoods to the same event — and even more, why their estimates might diverge over time.

The operative word being "legitimate" here, since if we start from the idea that whichever event we’re only partially observing was suddenly revealed to us in full, a persistent divergence in beliefs about this event surely means that at least one party must be dead wrong. 

And even if we're allowing that there might be multiple paths to the ultimate objective truth, if one party is wrong, it must surely be shown up in the future. 

Economists love to use sports metaphors when teaching statistics, simply because sport is a realm where the outcome is recorded right at the conclusion of the contest, from a single authoritative source, without ambiguity.

As a teaching device this is perfectly understandable in that it takes away a distraction which seems peripheral to the topic, but ultimately every practitioner will run into the problem that such an occurrence of an unfailing, immediate, and impartial single source of truth is quite rare in the real world.

(Indeed once we’re getting into the nitty-gritty of how the outcomes of sports events are tallied, it’s quickly becoming obvious that the "unfailing, immediate, and impartial" umpire is mostly a figment of our imagination. From photo finishes to disqualifications, not to mention accusations of favoritism, the idea that the true value of a random variable can suddenly be disclosed with finality is a popular ploy in economics that doesn’t even have a realistic foil in sports. Economic theory might get away with such a foreshortening of reality, but economic design doesn’t.)

We can go one step further and claim that for most uncertain events, meaning all events that are only partially observable, there might not be an underlying true value, no ground truth, at all. We’re eternally in limbo about what the underlying "true value" is, simply because there is no moment of truth. 

In most scenarios the truth typically remains elusive, at the end of a lengthy, costly, meandering, and conflicted discovery process, and we tend to swap in "truth" in the computer science meaning of "(single) source of truth": *that which is held to be true at any stage of the discovery process*, as a proxy for the "ground truth": *that which would be held to be true at the end of a fully exhaustive discovery process*.

In either form, whether there's no unimpeachable source of truth or no underlying ground truth, once we make that leap to accepting that the truth is elusive, we suddenly gain access to a far richer world of behaviors, especially collective behaviors. 

As a pattern, it means to start from the assumption that observed values are never perfectly true, true values are never perfectly observed, and truthfinding is an asymptotic reconciliation process between conflicting beliefs that’s not guaranteed to terminate in finite time.

## Organizations as belief clusters

I have previously called [organizations](https://cybercat.institute/2024/03/22/on-organization/) tectonic plates shaped around shared beliefs broken up by fault lines where beliefs — especially beliefs about the future and the likely outcomes of actions taken — are no longer reconcilable. 

In this series I am going to be a bit more precise in working out the question how belief convergence or belief divergence shape the coordinated sequence of activities within and across organizations we call a [value chain](https://cybercat.institute/2024/04/04/value-chain-integrity/). In particular, how these concepts can be applied across domains: social, political, cultural, religious, with the economic realm just a special case.

One of the first lessons of organization theory is that organizations are paradoxes: they can, under best conditions, produce more collectively than the sum of individual efforts of all members, but this requires that individual efforts have to be constrained away from what the individuals would do if left to their own devices. In other words, to achieve an organizational goal (almost) everyone will have to compromise.

The other lesson for organizations is that they take two steps: first, the aggregation of efforts, and second, the disaggregation of gains. Both have to work in the eyes of the beholders making up the organization for it to work, or otherwise — especially in the case of efforts being exerted in the present but rewards only collected and distributed in the future.

If this doesn't hold true: every participant holds the shared belief that individual contributions are being rewarded beyond what they could expect outside the organization, it will either disintegrate or has to be propped up by force. 

Nothing up to this point has limited what type of organization we're talking about here. Simply put, we'll find this type of pattern in any kind of organization: economic, religious, or political, flat or hierarchical, although we expect the kinds of rewards to differ. 

Along with the three underlying sources of [goal conflict](https://cybercat.institute/2024/03/22/on-organization/) (moving forward vs staying together, moving forward vs staying put, moving in which direction), this gives us a grid to think about the sources of conflict between the individual and the group, and later between ingroup and outgroup, to think about why organizations are shaped the way they are (flat or hierarchical, open or closed...) and why which forms of organizations are prevalent in which environment: why firms are organized differently than political parties, sports clubs, or religious congregations.

## Belief propagation and filter bubbles

So far the discussion has looked at shared beliefs from the vantage point of the (formally incorporated) organization. In my previous post, I looked at the question from the perspective of [value chains](https://cybercat.institute/2024/04/04/value-chain-integrity/). But what about starting with the individual?

Rather than asking how organizations fail due to a breakdown of shared beliefs, we might as well ask how organizations emerge as a consequence of shared beliefs.

Luckily, most people have heard of filter bubbles, the subgroups on social media channels created (and algorithmically amplified) by positive interaction with like-minded people, and negative interaction with other-minded people. 

This is a fundamental economic and social mechanism (formalized in my [dissertation](https://oliverbeige.medium.com/microstructure-and-macrocoordination-revisited-b848252bfd13) before social media or filter bubbles were a thing), not only to socialize with like-minded people, especially to filter incoming information based on whether the sender holds shared beliefs on prior issues, but also to adjust the credibility we assign a sender based on how much the newly transmitted information matches our priors.

If you take this filtering-by-affinity mechanism and impose it on the network structure of the [cybernetic economy](https://cybercat.institute/2024/03/08/stocks-flows-transformations/), you get an information flow pattern known as a "gossip network".

It is such an ubiquitous mechanism that we find it everywhere, on all levels of social and economic organization, but it also comes across as slightly unevolutionary. If we want to fully understand the hazards of our environment, we should take in all information from all sides and not just amplify the information that confirms what we think we already know. But we don't. We filter — which makes sense — but we filter out what we don't want to hear, not what we shouldn't hear — which doesn't make sense.

The interesting thing is that we know much more about these mechanisms now thanks to the internet, and especially thanks to recommender systems: Amazon uses them to guess what else we want to buy. Spotify offers new music to discover, Tinder believers matching social preferences translate into a good romantic match. 

The reason why recommender systems emerged in the early days of the internet is also tightly connected to Amazon, and later to the resurgence of machine learning thanks to the [Netflix prize](https://marianamarotob.medium.com/collaborative-filtering-and-some-history-on-the-netflix-prize-63d63c2af22b): the recognition that there is an unsurveyably large number of choice alternatives, and the inevitable corollary that our notion of consumers having well-informed preferences between them — an axiom that undergirds modern microeconomics — is no longer tenable.

Recommender systems have become one of the fundamental economic design templates, and in the process have reshaped economics (and in the case of matchmaking platforms, also our social lives), not only because they provide the raw data for much more fine-tuned consumer choice, but also because they give us a deeper insight into the evolution of preferences.

But there is also a deeper insight which comes from the information good that is being transferred. Preferences are in our economic understanding unimpeachable. They express individual tastes and are as such not rankable by social desirability, as much as we might want to impose our own, undoubtedly (in our minds) more sophisticated, tastes on others, or construct an argument why some tastes are more in tune with a more or less well-defined social good than others.

On the other extreme of the spectrum are mutually agreed-upon ground truths, better known as facts. In-between these extremes preferences (no truth value can be assigned) and facts (undisputed common truth value aligned with ground truth) lies the wide world of counterfactuals: states of the world to which we assign (and, as new knowledge emerges, adjust) truth values between zero and one. This world of counterfactuals inevitably involves the future.

This is a pattern we find everywhere, not only in the economic realm and its various subrealms like entrepreneurship (high individual belief in the success of a venture opportunity countering widespread low beliefs), but also in the political and social realms. We can connect this to Thomas Kuhn's [model of scientific inquiry](https://archive.org/details/structureofscien0000kuhn_v3c5) and Ludwik Fleck's [harmony of illusions](https://archive.org/details/genesisdevelopme0000flec), or to the geographic expansion of religion, language, pottery design, agriculture, or any idea based on shared counterfactuals.

The search pattern: [avoidance of negative surprise](https://cybercat.institute/2024/03/15/attention-seeking-rational-actor/), I've already discussed in a previous newsletter. The canonical conflict resolution mechanisms: [markets or hierarchies](https://econpatterns.substack.com/p/governance-mechanisms-and-economic) in the economic realm, wars or elections in the political realm, are typically tied to the fundamental pattern of exchange in that realm, as I will discuss in a future newsletter.
