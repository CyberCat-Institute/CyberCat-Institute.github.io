---
layout: post
title: The Blurry Boundary between Economics and Operations Research
author: Oliver Beige
date: 2024-05-17
categories: 
excerpt: In which we bring back together the estranged fraternal disciplines of economics and operations research and map out how we can combine them to design cybernetic economies.
usemathjax: false
---

Cross-posted from [Oliver's EconPatterns blog](https://econpatterns.substack.com/p/machine-replacement-machine-scheduling)

The [last EconPatterns post](https://econpatterns.substack.com/p/designing-economic-mechanisms-the) traced the history of economic design, focusing on the operations research group at Stanford’s business school and its role in developing auction design and market design. In this post I want to take this a bit further and describe the overlapping roles of operations research and economic design in more detail, anchoring on typical "operations research" domains, and how they quickly cross over into "economic" domains.

But a short definition of terms first: operations research is an applied branch of mathematics, mostly focusing on optimization (or "programming" in the original sense of linear programming, dynamic programming, combinatorial programming, etc.): orchestrating inputs to optimize (minimize or maximize) an output in the form of an objective variable. 

The canonical result is a constrained programming or optimization problem expressed as one objective function and any number of inequalities expressing constraints or limits. 

In the [first post](https://cybercat.institute/2024/03/08/stocks-flows-transformations/) on the cybernetic economy I already stressed the role of these limits: available stocks can ran out or warehouses can overflow, machines can only transform so many pieces in an hour, pipelines, roads, conveyor belts can reach their capacity and get congested. 

"Orchestration" means putting tasks into their correct order, balancing loads and flows, minimizing stocks without risking stockouts, avoiding congestions, disruptions, or volatility in the flow of goods, people, information, targeting objectives like fastest time to completion, minimal slack times, or lowest cost of inventory.

Operations research is the formal mathematical tool used by industrial engineers to design production plants, supply chains, workforce deployment plans, transport schedules and sundry other things that require juggling many parts under tight and often volatile conditions.

Even if it’s steeped in industrial (and military) lore, it’s also used in areas like microchip design, financial engineering, and all over the place in the digital economy. It’s pretty much everywhere in those parts of the economy that typically remain invisible to the casual observer: the engine room of a modern economy.

The hallmark of operations research is that it’s set up to serve one principal, focusing mostly on operations within an organization. This distinguishes it from economics proper, which focuses on exchange between and the resulting tension in objectives, motivations, and desires of multiple principals. 

Operations research cuts over to (mathematical) economics at the same juncture where decision theory crosses over to game theory: when the diverging interests of the participants move to the forefront of the analysis.

EconPatterns deliberately straddles the boundary between the disciplines for a number of reasons: operations research has much closer ties to both computer science and industrial design, offers a much richer toolset to aggregate and disaggregate processes within a hierarchical structure, has a closer connection between theory and practice, is a much better design paradigm to model complex longitudinal interactions with many specialized components, and ultimately has more tangible and straightforward objectives, typically those that can be measured with a stopwatch or a yardstick, rather than abstractions such as the idea of an equilibrium as a stable state where conflicts are resolved.

On the other hand operations research works from a paradigm of central planning, a paradigm that is losing analytical heft the more the connected process under scrutiny — the value chain — involves interaction, goal and resource conflicts between principals rather than between machines, tools, parts, information, and labor. 

So roughly speaking, as soon as the tension between principals becomes the driving factor, we cross over to economics. As soon as the need to concatenate activities or to disaggregate higher-level processes into tasks and subtasks dominates, we’ll lean more on operations research. 

But the core message is still that from the EconPatterns vantage point, where the value chain is the analytical starting point for any design endeavor, that all but the most trivial value chains have multiple crossings not only between machines but also between organizations, jurisdictions, and even belief systems, and that not only efficiency but also accountability is relevant to the integrity of that value chain, the formal aspects of economic design will inevitably be on the cusp between the disciplines.

Let’s put this to use in two examples.

## Machine replacement and coordinated machine replacement

Machine replacement is one of the core problems in industrial engineering. In its simplest form, it means finding the ideal time of putting an existing machine or process out of use and replacing it with another, presumably superior one. 

The calculus, easy enough for bachelor-level exams, requires comparing the cost of the new machine (minus scrap value of the old machine) to the performance differential, most likely in a net present value calculation. If the performance benefit is higher than the cost of replacement, it’s a go.

From this starting point we can make the problem arbitrarily complex. What if the performances of the machines are not constant over time? What if the old one becomes gradually less efficient, with lower throughput and more frequent outages, or the new machine needs time to ramp up? What if the replacement itself doesn’t only include the purchasing cost of the new machine but also a work stoppage? What if the machine is part of a production facility? Does the whole production line have to be closed down, or are other similar machines on a different line able to take on the shortfall? What if the new machine is only able to perform better in conjunction with other replacements? What if uncertainty is involved?

Even if it’s useful to think of industrial engineering in terms of real industrial machines for milling, turning, or drilling, in an industrial machine shop, these "machines" could be pretty much everything. If a bank considers a new process for checking creditworthiness or if a college department contemplates restructuring its degree curriculum, they encounter similar planning and orchestrating problems. The introduction of video assist in sports is an example of machine replacement.

Today, in most cases the "machine" is simply a computer. More abstractly, a "machine" is simply any workplace where a defined transformation is taking place.

All of this happens, if nothing goes wrong, according a meticulously planned program, and if something goes wrong, hopefully according to a meticulously crafted contingency plan — the hallmark of central planning.

If we remove that requirement, and allow two new stakeholders in — competitors and customers — we get something we might call coordinated machine replacement, or in a more succinct and better known term: innovation.

Innovation in its most technical definition is the increase in [total factor productivity](https://en.wikipedia.org/wiki/Total_factor_productivity), or aggregate outputs produced by aggregate input factors (in economics, famously labor, capital, and soil, but I’ll devote another post to that). In other words: the collective replacement of machines, processes, activities, to make resource use more efficient, in a (more or less) competitive economy.

In a "textbook" model of the economy, where firms are seen as singular and solitary production functions, replacement happens by Schumpeterian competition: companies which improve their efficiency by optimizing their production will gain a competitive advantage which lets them capture value, "Schumpeterian rents" in the innovation economics nomenclature, for as long as that efficiency advantage persists. 

This economic pressure: technologically disadvantaged competitors see their margins evaporate until they either catch up or give up and leave the industry, is the driver of economic innovation and, in turn, economic growth.

So much for the textbook treatment.

The era of Henry Ford shutting down production for five months to replace the Model T with the Model A being decisively over, the problem of keeping interdependencies uninterrupted while interrupting a single step in a complex value chain moves to the forefront. 

Research and development for new car generations now starts long before the existing car generation gets taken off the market. There is no more reason to lay off workers, cancel orders for parts, keep dealerships waiting for new vehicles, or hope that customers are willing to wait a few months rather than wandering off to the competition. 

Some of this still falls under a competitive bracket. Laid-off workers and stranded dealers might also defect to the competition. In other cases, outright coordination might become necessary such as in the adoption of shared technology standards or auditing rules. Value chains might become reintegrated such as electric vehicle manufacturers, recognizing that market competition does not supply enough charging stations, reluctantly entering the market for charging infrastructure. 

The less we think about technological disruption of value chain as a purely competitive event of isolated actors, the more we need to reach into the toolbox of operations research methods.

## Machine scheduling and coordinated machine scheduling

Machine scheduling is at the heart of operations research, and even if one of its synonyms, "[job shop scheduling](https://en.wikipedia.org/wiki/Job-shop_scheduling)", betrays its origin on the shop floors of the industrial era, it's still at the heart of most algorithmic processes that try to direct inputs toward productive outputs. 

The underlying idea is that jobs have to be allocated to machines on which they can performed. In its simplest form, these jobs consist of a sequence of steps, similar to Adam Smith's pin factory, where a prior step has to be finished before a subsequent job can be started.

This setup can be made more complicated in many ways. Machines (and their operators) might be specialized to perform only certain tasks. Jobs might require setup times which either have to wait until prior jobs are finished or can be started while the prior job is still running. Uncertainty can come into play in many ways. 

The objective is typically to minimize time to completion, maximize machine utilization, or some related measure.

Machine scheduling has successfully crossed over from the shop floor to the digital economy, especially when it comes to platform operations where the “machines” can be vehicles: taxicabs, scooters, coaches, and the “jobs” can be passengers trying to get from A to B in a timely, cheap, and secure manner.

This is again a scenario where the worlds of economics and operations research intersect. We can think of a platform as a central conductor trying to move people from A to B, which inevitably requires operations research knowledge, but we also have passengers (and in some cases, drivers) as participants with diverging interests, which requires economic and especially game theoretic knowledge.

The boundary is blurry and the scale might tip whenever we realize that we're better off assigning a modicum of autonomy to the many interlocking parts, that the machines might find a better solution if we let them compete for scarce resources and avoid congestions rather than insisting that coordination requires central control.

But it also helps to think of operations research as the discipline that operates bottom-up, assembling economic engines from universal elementary operations, while economics tend to operate top-down, from a highly aggregated macroeconomic perspective to individual microperspectives. But it also helps to think of operations research as the discipline that moved from the shop floors to academia while economics is still trying to move in the opposite direction.

![Trees](/assetsPosts/2024-05-17-economics-operations-research/img1.webp)

## The blurry boundary between economics and operations research

Design is ultimately about breaking complex problems down into their constituent parts, solving them in isolation and reassembling them in the hope that the partial solutions fit together. This requires, almost regardless of the application domain, that we start with a rough outline of the potential solution and decide step by step which partial problems require particular attention to detail.

This can be done in a methodical or in a haphazard fashion. In particular, the opposing risks of not enough attention to detail or too much attention to detail loom large over failed design projects. This is certainly not restricted to economic design, but economics as a discipline suffers from a lack of conceptual rigor and increasingly an overflow of formal rigor. 

This isn't only the case for the part of the design process where we go from a “rough outline” (a conceptual understanding of the overall problem) to a fully fleshed out formal model, but also, once we understand that we need to apply a formal toolset, a lack of understanding which toolset applies to the problem at hand.

In this post, we're in the latter part of that process. Both operations research and mathematical economics are highly formalized frameworks which share a common history in the evolution of constrained optimization but which for at least two generations (roughly from the inception of the Econ Nobel and the deliberate choice by the Nobel committee to reward the economists but not the operations researchers working on the same problem) barely talked to each other.

Over the last ten years or so, we've seen a gradual rapprochement between the disciplines, in large part because the new players of the digital economy started to realize that their machinery is often economic in nature — auctions, matching markets, information and risk aggregators — even if they deal in abstract information goods rather than in physical objects assembled on the shop floors of the industrial economy.

In the process they've also recognized that the academic paper exercises which constitute the main output of modern economics aren't sufficient to assemble production-ready economic engines. For this you also need scalability, modularity, interoperability, and an understanding of human interaction that bows as much to drab realism as it does to formal aesthetics.

To offer a simple example: in the push to succeed in the global coordinated machine replacement problem known as the transition from fossil to renewable sources of energy, we can't just assume that we're fine and markets clear if aggregate supply matches aggregate demand. 

We also have to take into account that energy is rarely ever produced where and when it's needed, neither in place nor in time. So we have to apply a model of an energy economy that pays attention to stocks and flows — in other words, a [cybernetic economy](https://cybercat.institute/2024/03/08/stocks-flows-transformations/).
