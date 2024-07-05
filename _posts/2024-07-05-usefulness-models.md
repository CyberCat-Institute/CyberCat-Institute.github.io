---
layout: post
title: Compositionality and the mass customization of economic models
author: Philipp Zahn
categories: [compositionality,model,economics]
excerpt: "Are economic models useful for making decisions? One might expect that
there is clear answer to this simple question. But in fact opinions on
the usefulness or non-usefulness of models as well as what exactly makes
models useful vary widely. In this post, I want to explore the question of usefulness. Even more
so, I want to explore how the usefulness ties into the modelling
process. The reason for doing so is simple: Part of our efforts at
CyberCat is to build software tools to improve and accelerate the
modelling process."
thanks: I thank Oliver Beige for many helpful comments.
--

# Fables or algorithms?

> Economic theory formulates thoughts via what we call "models." The
> word model sounds more scientific than the word fable or tale, but I
> think we are talking about the same thing.
> _(Ariel Rubinstein)_[^1]

Are economic models useful for making decisions? One might expect that
there is clear answer to this simple question. But in fact opinions on
the usefulness or non-usefulness of models as well as what exactly makes
models useful vary widely - within the economic profession and of course
even more so beyond. Sometimes the question feels like a Rorschach
test - telling more about the person than about the subject.

In this post, I want to explore the question of usefulness. Even more
so, I want to explore how the usefulness ties into the modelling
process. The reason for doing so is simple: Part of our efforts at
CyberCat is to build software tools to improve and accelerate the
modelling process.

The importance of this is also evident: If models are useful, and we
improve the process generating useful models, we improve our
decision-making. And in so far as these improvements tie into computing
technology, as they do in our opinion, improvements could be
significant.

# Economic models

My question, \"are economic models useful\", is quite lofty. So, let\'s
first do some unpacking.

What do I mean by economic model? A mathematical, formal model which
relates to the domain of decision-making at hand. A prototypical example
is a model that tells us how to bid in an auction. Such models are often
classified as applied economic models.[^2]

Why do I emphasize \"economic\"? If my question was: Are mathematical
models useful for decision-making, the answer would be a simple yes and
we could call it a day. Operations research models are in production for
a multitude of tasks (job scheduling, inventory management, revenue
management etc.). In fact, many of these models are so pervasive that it
is easy to forget them. Just think about the business models that have
been built on the navigation and prediction functionalities of Google
maps.

The distinction between operations research and economics is obviously
blurry and more due to artificial academic barriers than fundamental
differences ([check out Oliver\'s post on
this](https://cybercat.institute/2024/05/17/economics-operations-research/)).
I am making the crude distinction that economic models are about several
agents interacting - most often strategically - whereas traditional
operations research models are focused on single decision-makers.

Now, this is crude because obviously operations research by now also
includes auctions and other models that are interactive in this way.
Moreover, as [Oliver pointed out in another
post](https://econpatterns.substack.com/p/designing-economic-mechanisms-the)
several leading economists who advanced the practical use of economic
models (which we still come to) have an operations research background.

It is, I think, also not a coincidence that operations research has
moved into the realm of interactive agents: Due to globalization and in
particular the internet, companies have become more interconnected and
also have much more technical leverage. 50 years ago, the idea that a
regular company could be designing their own market probably would have
been quite a thing. Today, it is part of the standard startup toolkit.

Technology and interconnectedness are driving the need for models that
help decide in such a world as well as design the frameworks and
protocols in which decisions take place. Economic models are the natural
candidate for this task.

# Useful?

Let\'s turn to the central part of my question. What do I mean by
useful? Opinions on this vary widely. According to Rubinstein, the
question how a model can be useful is already ill-posed. Models are not
useful. Models might carry a lesson and can transform our thinking. But
they are of little value for concrete decisions.

In economics, Rubinstein\'s position is an extreme point. On the other
side of the extreme, economists and even more importantly computer
scientists are working on market design and mechanism design models.[^3]
Models in this spirit are \"very\" practical: they do affect decisions
in a concrete sense - they get implemented in the form of algorithms and
are embedded in software systems.

We can think of fables and algorithms as two ends of a spectrum - from
basically irrelevant to decisive for a choice we have to make. While it
is hard to precisely locate a given model on this \"usefulness\" line,
we can consider how a model can become more useful when moving along the
spectrum. Of course, what constitutes value and who benefits how from a
model changes along this path as well. The usefulness of a model is a
matter of degree and not an absolute.

Let\'s begin at the fable end and start moving inroads. How can a model
produce value? If we are faced with infinitely many ways to think about
a situation, even a simplistic model can be valuable. It helps to focus
and to select a few key dimensions. This aspect becomes even more
important in an organizational context where people have to collaborate
and it is very easy to get lost in a myriad of possibility and different
interpretations.

Many classic games (in the game theory sense) like the Battle of the
Sexes, Matching Pennies, and of course the Prisoners\' Dilemma help to
focus on key issues - for instance the interdependency between actions
and their consequences. To be clear, the connection how to map a model
into a concrete decision is very lose in this case and the value of the
model lies in the eyes of the analyst.

These games often focus on a few actions (\"defect\" or \"cooperate\").
Moreover, agents have perfect information about the consequences of
their actions and the actions of others. In many situations, e.g. in
business contexts, choices are more fine-grained and information is not
perfect. Models in Industrial Organization routinely incorporate these
aspects. For instance, analyzing competition between companies. From a
practical perspective, these models often resemble the following
pattern: If we had information X, the model would help us make a
decision. Consider strategic pricing: It is standard in these models to
assume demand to be known or at least drawn from a known distribution.
The demand curve will then be typically a smooth, mathematically well
behaved object. Such models can produce insights - no doubt about it.

But they rarely help to make a concrete decision, e.g. what prices to
charge. There are many reasons for this but let me just give an obvious
one as a co-founder of a startup: I would love to maximize a demand
curve and price our services accordingly. But the reality is: I do not
have a curve. Hell, if I am lucky I observe a handful of points
(price-quantity combinations). But these points might not even be on any
actual demand curve in the model\'s sense. So, while useful for
structuring discussions around pricing, in the actual decision to set
prices, the model is only one (possibly small) input. And this is very
typical. Such models provide insights and do help to inform decisions.
But they are only part of a collage of inputs into a decision.

There are economic models which do play a more dominant role in shaping
decisions. Consider auctions. There is a rich theory that helps to
choose a specific auction format to solve a given allocation problem.
Still, even in this case, there are gaps between the model and the
actual implementation, for instance when it comes to multi-unit
auctions.

The examples I gave are obviously not meant to be exhaustive. There are
other ways how a model can be useful. But this is not so important. The
main point is, that all along the usefulness line, economic models can
produce value. The question is not whether a model produces a choice but
whether, at the margin, it helps us make better decisions. And this can
happen all along the spectrum. Moreover, ceteris paribus, the further we
move along the path towards the algorithm end, the more influence the
economic model gains relative to other inputs into a decision and the
more value it produces.

If we accept this, then an immediate question comes up: How can we push
models from the fable side more towards the algorithm side? Let\'s
explore this.

# The process of modelling and the library of models

I first need to discuss how models get located on a specific point on
the usefulness line in the first place. But this requires digging into
the actual modelling process. Note again that I am only interested in
\"instrumental\" modelling - models that are useful for a specific
decision at hand. My exposition will be simplistic and subjective. I do
neither cover the full range of opinions nor be grounded in any
philosophical discussions of economics. This is just me describing how I
see this (and also how I have used models in my work at
[20squares](https://20squares.xyz/)).

Applied models in economics are a mixture of mathematical formalism and
interpretative mapping connecting the internals of the model to the
outside world. Mappings are not exclusive: The same formal structure can
be mapped to different domains. The Prisoner\'s dilemma is such an
example. It has various interpretations from two prisoners in separate
cells to nuclear powers facing each other.

The formal, inner workings of models are \"closed\" objects. What do I
mean by that? Each model describes a typically isolated mechanism, e.g.
connecting a specific market design with some desirable properties. The
formal model has no interfaces to the outside world. And therefore it
cannot be connected to other models at the formal level. In that sense a
model is a self-contained story.

Let me contrast this with a completely different domain: If one thinks
about functional programming, then everything is about the composability
of functions (modulo types). The whole point of programming is that one
program (which is a function) can be composed with another program
(which is a function) to produce a new program (which is a
function).[^4]

Back to economic models. When it comes to applications, the \"right\"
model is not god given. So, how does the process of modelling real world
phenomena look like?

As observed by Dani Rodrik[^5], the evolution of applied models in
economics is different from the evolution of theories in physics. In
physics one theory regularly supersedes another theory. In economics,
the same rarely happens. The practice of modelling is rather about
developing new models, like new stories, that then get added to the
canon.

One can compare this to a library where each book stands for a model
that has been added at some point. Applied modelling then means mapping
a concrete problem into a model among the existing staple or, if
something is missing, develop a new model and add it to the canon.

Inherent in this process is the positioning of a model on a specific
point in the spectrum between fables and algorithms. Models mostly take
on a fixed position on the line and will stay there. There are exogenous
factors that influence the positioning and that can change over time.
For instance, the domain matters. If you build a model of an
intergallactic trading institution, it is safe to assume that this model
will not be directly useful. Of course, this might change.

Like stories, certain models do get less fashionable over time, others
become prominent for a while, and a select few stay ever-greens.
Economists studying financial crises in 2006 were not really standing in
the spotlight of attention. That changed radically one year later.[^6]

Let me emphasize another aspect. I depicted applied models as packages
of internal, formal structure and interpretative map connecting the
internals with some outside phenomenon. This interpretative mapping is
subjective. And indeed discussions in economic policy often do not focus
on the internal consistency of models but instead are more about the
adequateness of the model\'s mapping (and its assumptions) for the
question at hand. Ultimately, this discourse is verbal and it is
structurally not that different from deciding which story in the bible
(or piece of literature, or movie) is the best representation of a
specific decision problem.

The more a model will lean towards the fable side, the more it will be
just one piece in a larger puzzle and the more other sources of
information a decision-maker will seek. This might include other
economic models but of course also sources outside. Different models and
other sources of information need to be integrated.

As a consequence, whatever powers we gain through the formal model,
loads of it are lost the moment we move beyond the model\'s inner
working and need to compare and select between different models as well
as integrate with other sources. A synthesis at the formal level is not
feasible.

Let me summarize so far: A model\'s position on the spectrum of fable to
algorithm is mostly given. There is not much we can do to push a single
model along. Moreover, we have no systematic way of synthesizing
different models - which would be another possibility to advance along
the spectrum.

We have been mostly concerned with the type of output the modelling
process generates. Let\'s also briefly turn to the inputs. Modelling by
and large today is not that different compared to 50 years ago. Sure,
co-authorships have increased, computers are used, and papers circulate
online. But in the end, the modelling process is still a slow,
labor-intensive craft and demands a lot from the modeller. He or she
needs knowledge in the domain, must be familiar with the canon of
models, needs judgment to balance off the tradeoffs involved in
different models, etc.

This makes the modelling process costly. And it means we cannot brute
force our way to push models from fable to algorithm. In fact, in the
context of policy questions many economists like Dani Rodrik[^7]
criticize the fact that discussions focus on a single model whereas a
discussion would be more robust if it could be grounded in a collage of
different models. But generating an adequate model is just very
costly.[^8]

Taken together, the nature of the model generating process as well as
its cost function, are bottlenecks that we need to overcome if we want
to transform the modelling process.

Let\'s go back to our (functional) programming domain to see an
alternative paradigm. Here, we are also relying on libraries. But the
process of using them is markedly different. Sure, one can just simply
choose programs from a library an apply it. But one can also compose
models and form new, more powerful programs. One can synthesize
different programs; and one can find better abstractions through the
patterns of multiple programs which do similar things. Lastly, one can
refine a program by adding details. And of course, if you consider
statistical modelling, this modularity is already present in many
software packages.

It is modularity which gives computing scalability. And it is this
missing modularity which severely limits the scalability of economic
modelling.

Consider the startup pricing example I gave before. Say, I thought about
using a pricing model to compute prices but I am lacking the demand
information. What am I supposed to do? Right now, I am most likely
forced to abandon the model altogether and choose a different framework
instead.

What I would like to do instead is to have my model in a modular shape
so that I could add a \"demand\" module and combine it with my pricing
optimization - maybe a sampling procedure or even just a heuristic. The
feature I want is that I have a coherent path from low to higher
resolution.

The goal behind our research and engineering efforts is to lift economic
modelling to this paradigm. Yet, we do not just want to compose software
packages. We want an actual composition of economic models AND the
software built on top.

# How to get there? Compositionality!

Say, we want to turn the manual modelling process, which mostly relies
on craft, experience and judgement, into a software engineering process.
But not only that. We are aiming for a framework of synthesis in which
formal mathematical models can be composed.

How should we go about this? This is totally unclear! Even more, the
question does not even make sense. This is a bit like asking how do we
multiply a story from Hemingway with a story by Marquez.[^9]

Similarly, models in economics are independent and closed objects and
generally do not compose. It is here where the \"Cat\" in CyberCat comes
in. Category theory gives us a way to consider open systems and model
them by default relative to an environment. It is this feature which
allows us to even consider the composition of models - for instance the
composition of game theoretic models we developed.

Another central feature that is enabled through category theory is the
following paradigm:

> model == code

That is, the formalism can be seamlessly translated back and forth
between model and an actual (software) implementation. Thereby, instead
of modelling on pen and paper, modelling itself becomes programming. It
is important to note that we do not just want to translate mathematical
models into simulations but code does actually symbolically represent
mathematical statements.

To summarize, category theory gives us a formal language of composable
economic models which can be directly implemented.

Equipped with this foundation, we can turn to the programming language
design task to turn the modelling process into a process of software
engineering.

# Industrial mass customization of economic models

Modelling as programming enables the iterative refinement of models.
Whereas in the traditional sense, models are not only closed but also
dead wood (written on paper), under this paradigm models are more like
living objects which can be (automatically) updated over time.

Instead of building a library of books, in our case the models are part
of a software library. Which means the overall environment becomes way
more powerful over time, as the ecosystem grows.

Composition also means division of labor. We can build models where
parts are treated superficially at first but then details get filled in
later. This can mean more complexity but most importantly means that we
can build consistent models that are extended, refined, and updated over
time.

These aspects resembles similar attempts in mathematics and the use of
proof assistants and verification systems more generally. Here is
Terence Tao on these efforts[^10]:

> One thing that changed is the development of standard math libraries.
> Lean, in particular, has this massive project called mathlib. All the
> basic theorems of undergraduate mathematics, such as calculus and
> topology, and so forth, have one by one been put in this library. So
> people have already put in the work to get from the axioms to a
> reasonably high level. And the dream is to actually get \[the
> libraries\] to a graduate level of education. Then it will be much
> easier to formalize new fields \[of mathematics\]. There are also
> better ways to search because if you want to prove something, you have
> to be able to find the things that it already has confirmed to be
> true. So also the development of really smart search engines has been
> a major new development.

It also means different forms of collaboration between field experts and
across traditional boundaries. Need a financial component in that
traditional IO model? No problem, get a finance expert to write this
part - a modern pin factory equivalent. See again Terence Tao[^11]:

> With formalization projects, what we've noticed is that you can
> collaborate with people who don't understand the entire mathematics of
> the entire project, but they understand one tiny little piece. It's
> like any modern device. No single person can build a computer on their
> own, mine all the metals and refine them, and then create the hardware
> and the software. We have all these specialists, and we have a big
> logistics supply chain, and eventually we can create a smartphone or
> whatever. Right now, in a mathematical collaboration, everyone has to
> know pretty much all the mathematics, and that is a stumbling block,
> as \[Scholze\] mentioned. But with these formalizations, it is
> possible to compartmentalize and contribute to a project only knowing
> a piece of it.

Lastly, the current developments of ML and AI favor the setup of our
system. We can leverage the rapid development of ML and AI to improve
the tooling on both ends of the pipeline: Users are supported in the
modelling setup and solving or analyses of models becomes easier.

The common thread behind all of our efforts is to boost the modelling
process. The traditional process is manual, slow, and limited by domain
expertise - in other words very expensive.

Our goal is to turn manual work into mass customizable production.

# Closing remarks

What I described so far is narrowly limited to economic modelling. Where
is the \"Cybernetics\"?

First, I focused on the composability of economic models. But the
principles of the categorical approach extend beyond this domain. This
includes the understanding how apparently distinct approaches share
commonality (e.g. game theory and learning) and how different structures
can be composed (build game theoretic models on top of some underlying
structure like networks). In short, we work towards a whole \"theory
stack\".

Second, the software engineering process depicted above focuses very
narrowly on extending the economic modelling process itself. But the
same approach will mirror the theory stack with software enabling
analyses along each level.

Third, once we are operating software, we open the ability towards
leveraging other software to support the modelling process. This follows
pragmatic needs and can range from data analytics to LLMs.

A general challenge to decision-making is the hyper-specialization of
expert knowledge. But as decisions are more and more interconnected,
what is lacking is the ability to synthesize this knowledge. Just
consider the decision-making of governments during the Covid epidemic.
For instance, in the decision to close schools, one cannot simply rely
on a single group of domain experts (say physicians). One needs to
synthesize the outcomes of different models following different
methodologies from different domains. We want to develop frameworks in
which these tradeoffs can be articulated.

[^1]: Ariel Rubinstein. Economic fables. Open book publishers, 2012,
    p.16

[^2]: I will focus on micro-economic models. They are simply closest to
    my home base and relevant for my daily work.

[^3]: The view on what economists do there is markedly different from
    Rubinstein\'s. Prominently Al Roth: [The Economist as Engineer: Game
    Theory, Experimentation, and Computation as Tools for Design
    Economics](https://onlinelibrary.wiley.com/doi/abs/10.1111/1468-0262.00335)
    \"The economist as an engineer\".

[^4]: And probably most importantly, functions themselves can be input
    to other functions.

[^5]: Economics Rules: The Rights and Wrongs of The Dismal Science. New
    York: W.W. Norton; 2015

[^6]: Of course, the classification of practical and non-practical is
    not exclusive to economics. Mathematics is full of examples of
    domains that are initially seen as without any practical use and
    then turned out to be important later on.

[^7]: Ibid.

[^8]: In addition, if the modelling falls to academics, then also their
    incentive kick in. The chances for publishing a model on a subject
    that has already been tackled by a prominent model can be very low -
    in particular in the case of a null-result.

[^9]: We might of course come up with a way how these two stories can be
    combined or compared. But this requires extra work; there is no
    operation to achieve this generically. These days we might ask an
    LLM to do so. And indeed this might be a useful direction for the
    future to support this process.

[^10]: Quoted from [this
    interview](https://www.scientificamerican.com/article/ai-will-become-mathematicians-co-pilot/)

[^11]: Ibid.
