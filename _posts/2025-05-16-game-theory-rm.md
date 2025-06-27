---
layout: post
title: "The Untapped Potential of Game Theory in Revenue Management"
author: Nicolas Eschenbaum
date: 2025-05-16
categories: [game theory, economics]
usemathjax: false
excerpt: "Revenue management has evolved significantly since its origins in 1980s airline yield management. Travel, logistics, and hospitality industries employ it to maximize occupancies; e-commerce platforms use it to schedule promotion campaigns. It is the go-to tool across industries to match resource availability with consumer demand. But most current approaches still rely on relatively simple demand forecasting and optimization. The behaviour of other players in the market (for example competitors) is rarely explicitly accounted for, even though their behaviour implicitly shows up in the data used to estimate the models. Game theory — which has emerged as the dominant tool for modeling strategic dynamics — offers powerful potential to change this."
---

Revenue management has evolved significantly since its origins in 1980s airline yield management. Travel, logistics, and hospitality industries employ it to maximize occupancies; e-commerce platforms use it to schedule promotion campaigns. It is the go-to tool across industries to match resource availability with consumer demand.

But most current approaches still rely on relatively simple demand forecasting and optimization. The behaviour of other players in the market (for example competitors) is rarely explicitly accounted for, even though their behaviour implicitly shows up in the data used to estimate the models. Game theory — which has emerged as the dominant tool for modeling strategic dynamics — offers powerful potential to change this. 

## Revenue Management Today

Today's revenue management typically translates historical demand patterns into future forecasts or price elasticity models. In other words, the dominant design is competitor-agnostic. This despite the fact that real-time data availability increasingly allows for more rapid price adjustments, which require customer acceptance and this acceptance is inevitably linked to competitor pricing.

"Competitor-aware pricing" is generally in its infancy and considered an area of cutting-edge yield management research. Digital e-commerce platforms, for example, use highly sophisticated algorithms to dynamically adjust prices — usually by timing promotional campaigns — but systems generally respond to immediate market conditions and demand projections rather than predicting and incorporating the expected responses of suppliers or competitors. Hospitality and retail industries are following the lead of the airline industry, but tend to use traditional rules-based systems and basic environment-agnostic forecasting.

In short: strategic analysis typically happens offline in a manual way, far away from the possibility frontier. This leaves a lot of money on the table.

## The Game Theory Opportunity

Game theory has completely transformed business models in Silicon Valley. Hal Varian, Google's Chief Economist, famously played a key role in designing Google's ad auctions — still to date the dominant source of revenue for the company. Game theory similarly has the power to transform revenue management by offering the possibility to:

- **Forecast how competitors might adjust their strategies.** What would a "smart" competitor do? And what is the likely reaction of suppliers or competitors to different promotional strategies?
- **Estimate the long-term effects** of strategic decisions and evaluate trade-offs between short-term revenue and long-term market position. Standard revenue management estimates are often notoriously short-sighted.
- **Optimize the timing of price changes** to maximize long-term value and strategically time promotions.
- **Analyze and forecast strategic customer behavior**, anticipation effects, and dynamic customer learning and adaptation strategies.

It should be noted that the possibilities game theory offers are well-known to revenue management professionals. Every business and economics student has learned about simple games of market entry and studied the relevant strategic effects. But applying game theory in practice beyond simple '2 players, 2 strategies' textbook toy examples requires much deeper and more specialized skills, combined with the right framework and technology.

Modern enterprise-scale game theory engines are highly complex, connecting many interlocking parts, mathematically sophisticated, and need to be designed with care.

## Beyond "Traditional" Game Theory

We approached this challenge with a new mathematical lens — particularly through a structure called **compositional game theory** — to model complex strategic interactions with unprecedented fidelity. This mathematical foundation allows us to:

- Model interactions between multiple economic agents (competitors, customers, suppliers) simultaneously with true compositionality.
- Integrate statistical estimates from real-world data on customer demand or company strategy — and feed results back, building a "Digital Twin".
- Incorporate machine learning algorithms to find optimal strategies, predict competitor responses, and optimize pricing.
- Capture complex feedback loops of multi-market interactions and supply chain cascades in a simple, modular way.

Compositional game theory provides a framework where strategic interactions can be assembled, broken down, analyzed, and reconstructed while preserving their essential characteristics. This makes it possible to model real-world market dynamics far more accurately than with standard economic models.

## Case Example: Competitor-Aware Dynamic Pricing

To demonstrate the power of compositional game theory in revenue management, we recently completed a six-month research pilot with a major airline focused on **competitor-aware dynamic pricing**. While traditional approaches generally do not react to competitor price changes, our approach explicitly models competitor behavior, allowing for more strategic pricing decisions.

We can model the complex structure of airline bookings, including connecting flights or multi-segment journeys, learn optimal pricing policies in response to competitor strategies, and even simultaneously optimize multiple agents' pricing strategies within the same market.

What makes this approach particularly powerful is its ability to handle the natural compositional structure of airline markets. Airline revenue management perfectly fits the modular structure of our framework, since each flight can be thought of as its own optimization problem. But because competing airlines are active across multiple of these, the overarching strategic interaction operates across various different flights. So the pricing decisions for individual flights interact in complex ways that are difficult to capture with traditional methods. For those interested, see the [companion blog post](https://cybercat.institute/2025/06/26/equilibrium-checking-learning/) explaining how we adapted the [Open Game Engine](https://github.com/CyberCat-Institute/open-game-engine) for this specific application.

## Looking Ahead

This pilot project represents just one example of how game theory can transform revenue management practices. By explicitly modeling strategic interactions between market participants, companies can move beyond reactive pricing and toward truly strategic revenue optimization — avoiding markets from spiraling down, for example, and strategically considering the longer-term effects of today's decisions.

The limitations of current revenue management approaches are becoming increasingly apparent as markets grow more complex and interconnected and data becomes abundant. Our approach allows us to unlock this value through sophisticated game-theoretic models that integrate seamlessly with existing systems.

For revenue management and dynamic pricing experts interested in exploring these advanced approaches, we invite you to connect with us to discuss the opportunities modern algorithmic game theory offers to revenue management practice.
