---
layout: post
title:  "What is categorical cybernetics?"
author: Jules Hedges
categories: "categorical cybernetics"
excerpt: Categorical cybernetics, or CyberCat to its friends, is – no surprise – the application of methods of (applied) category theory to cybernetics. The  "category theory" part is clear enough, but the term "cybernetics" is notoriously fluid, and throughout history has meant more or less whatever the writer wanted it to mean. So, let’s lay down some boundaries.
usemathjax: false
---

**Categorical cybernetics**, or **CyberCat** to its friends, is – no surprise – the application of methods of (applied) category theory to cybernetics. The  "**category theory**" part is clear enough, but the term "**cybernetics**" is notoriously fluid, and throughout history has meant more or less whatever the writer wanted it to mean. So, let’s lay down some boundaries.

I first proposed CyberCat, both as a field and as a term, in [this 2019 blog post](https://julesh.com/2019/11/27/categorical-cybernetics-a-manifesto/) (for which this one is partly an update). There I fixed a definition that I still like: **cybernetics is the control theory of complex systems**. That is, cybernetics is the interaction of control theory and systems theory.

We add to this [applied category theory](https://www.appliedcategorytheory.org/), which has some generic benefits. Most importantly we have [compositionality](https://julesh.com/2017/04/22/on-compositionality/) by default, and a more precise way of talking about it than in fields like machine learning where it is present but informal. Compositionality also gets us half way to computer implementation by default, by making our models similar to programs. Finally category theory gives us a disciplined way to talk about interaction between models in different fields.

It turns out - and this fact is at the heart of CyberCat - that the category-theoretic study of control has a huge amount of overlap with things like **learning** and **strategic analysis**. Those were also historically part of cybernetics, and can be seen as aspects of control theory with a certain amount of squinting, so we also include them.

On top of that definition, a cultural aspect of the historical cybernetics movement that we want to retain is that **cybernetics is inherently interdisciplinary**. Cybernetics is not just the theory but the practice: in engineering, artificial intelligence, economics, ecology, political science, and anywhere else where it might be useful. (Part of the reason we created the Institute – more on that in a future post – is to make this cross-cutting collaboration easier than in a unviersity.)

Cybernetics has been an academic dirty word since many decades now: in the 60s and 70s it went through a hype cycle, things were over-claimed and the field eventually fell apart. As founders of the CyberCat Institute we believe that **the time is right to reclaim the word cybernetics**. Apart from anything else, the word is just too cool to not use. More importantly, the objects of study – and the interdisciplinary approach to studying them – are even more important now than 50 years ago.

Having laid out what CyberCat could potentially be, I will now narrow the scope. At the Institute we are focussing on not just any applications of category theory to cybernetics, but to a small set of very closely interrelated tools. These are, roughly, things that have a family resemblance to **open games**.

This post isn’t the place to go into technical details, but what these things have in common is that they model **bidirectional processes**: they are processes (that is, they have an extent in time) in which some information appears to flow backwards (I described the idea in more detail in [this post](https://julesh.com/2017/09/29/a-first-look-at-open-games/)). The best known of these is **backpropagation**, where the backwards pass goes backwards. A key technical idea behind CyberCat is the observation that many other important processes in cybernetics have a lot in common with backprop, once you take the right perspective. The category-theoretic tool used to model these processes is **optics**.

Besides backprop, the things we have put on a uniform mathematical foundation using optics are value iteration, Bayesian inference, filtering, and the unnamed process that is the secret sauce of compositional game theory.

This is the academic foundation that we start from. The question that comes next is, so what? How can this knowledge be exploited to solve actual problems? This is where the CyberCat Institute comes in, but I want to leave that for a future post. In the meantime, you can look at our [projects page](/projects) to see the kinds of things we are working on right now.
