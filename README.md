# `microservices` <img src="https://raw.githubusercontent.com/tidylab/microservices/master/pkgdown/logo.png" align="right" height="50"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/microservices)](https://CRAN.R-project.org/package=microservices)
[![R build
status](https://github.com/tidylab/microservices/workflows/R-CMD-check/badge.svg)](https://github.com/tidylab/microservices/actions)
[![codecov](https://codecov.io/gh/tidylab/microservices/branch/master/graph/badge.svg?token=U6FL5N32FL)](https://codecov.io/gh/tidylab/microservices)

<!-- badges: end -->

Breakdown a Monolithic Application to a Suite of Services

<img src="https://i.imgur.com/nZ5jw2g.png" width="100%" style="display: block; margin: auto;" />

## Introduction

‘Microservice’ architectural style is an approach to developing a single
application as a suite of small services, each running in its own
process and communicating with lightweight mechanisms, often an ‘HTTP’
resource ‘API.’ These services are built around business capabilities
and independently deployable by fully automated deployment machinery.
There is a bare minimum of centralized management of these services,
which may be written in different programming languages and use
different data storage technologies.

## Should I use microservices?

As a start, ask yourself if a microservice architecture is a good choice
for the system you’re working on?

**Caution:** If you do not plan to deploy a system into production, then
you do not need microservices.

The microservice architecture entails costs and provides benefits.
Making lots of independent parts work together incurs complexities.
Management, maintenance, support, and testing costs add up in the
system. Many software development efforts would be better off if they
don’t use it.

If you plan to deploy a system into production, then consider the
following:

-   Favour a monolith over microservices for simple applications.
    Monolith can get you to market quicker than microservices.
-   Monolith-first Strategy: If possible, start with a monolith and
    design it with clear [bounded
    contexts](https://martinfowler.com/bliki/BoundedContext.html). Then,
    when deemed necessary, gradually peel off microservices at the
    edges.

After mentioning the disadvantages and dangers of implementing
microservices, why should someone consider using them?

([Newman 2015](#ref-Newman2015)) suggests seven key benefits of using
microservices:

-   **Technology Heterogeneity**. With a system composed of multiple
    collaborating services, we can decide to use different
    technologies/programming-languages inside each one. This allows us
    to pick the right tool for each job rather than to select a more
    standardised, one-size-fits-all approach that often ends up being
    the lowest common denominator.

<img src="https://i.imgur.com/vX1u9Po.png" width="25%" style="display: block; margin: auto;" />

-   **Resilience**. A key concept in resilience engineering is the
    [bulkhead](https://en.wikipedia.org/wiki/Bulkhead_(partition)) which
    originates in ship design (see illustration). If one component of a
    system fails, but that failure doesn’t cascade, you can isolate the
    problem and the rest of the system can carry on working.

<img src="https://i.imgur.com/qelkZ9P.png" width="25%" style="display: block; margin: auto;" />

-   **Scalability**. With a large, monolithic service, we have to scale
    everything together. One small part of our overall system is
    constrained in performance, but if that behaviour is locked up in a
    giant monolithic application, we have to handle scaling everything
    as a piece. With smaller services, we can scale those services that
    need scaling, allowing us to run other parts of the system on
    smaller, less powerful hardware.

<img src="https://i.imgur.com/1Tf9Hrh.png" width="25%" style="display: block; margin: auto;" />

-   **Ease of Deployment**. With microservices, we can make a change to
    a single service and deploy it independently of the rest of the
    system. This allows us to get our code deployed faster. If a problem
    does occur, it can be isolated quickly to an individual service,
    making fast rollback easy to achieve. It also means we can get our
    new functionality out to customers faster.

<img src="https://i.imgur.com/U60xp1V.png" width="25%" style="display: block; margin: auto;" />

-   **Organizational Alignment**. Microservices allow us to better align
    our architecture to our organisation, helping us minimise the number
    of people working on anyone codebase to hit the sweet spot of team
    size and productivity.

<img src="https://i.imgur.com/8mk0BlZ.png" width="25%" style="display: block; margin: auto;" />

-   [***Composability***](https://en.wikipedia.org/wiki/Composability).
    Similarly, to the tidyverse packages, where different compositions
    of packages are used in different analytic projects in R, with
    microservices, we allow for our functionality to be consumed in
    different ways for different purposes. For example, a *demand
    forecasting* service can be consumed by several different dashboards
    and a logging system.

<img src="https://i.imgur.com/gHMkhtV.png" width="25%" style="display: block; margin: auto;" />

-   ***Optimizing for Replaceability***. With our services being small
    in size, the cost to replace them with a better implementation, or
    even delete them altogether, is much easier to manage than in a
    monolithic app. For example, during the football world cup, a news
    website may offer football-related analysis. Rather than making the
    analysis part of the website codebase, we can create a microservice
    to deliver the football analytic service and remove it when the
    tournament is over.

<img src="https://i.imgur.com/SNQAINt.png" width="25%" style="display: block; margin: auto;" />

To conclude, not every application needs to be built as a microservice.
In some cases, such as in a system that is an amalgam of programming
languages and technologies, microservices architecture is advised or
even necessary. However, seldom it is a good choice to start building an
application as a microservice. Instead, a better option is to design a
system in a modular way and implement it as a monolith. If done well,
shifting to microservices would be possible with reasonable refactoring
effort.

## Installation

You can install `microservices` by using:

    install.packages("microservices")

## Further Reading

Fowler, Martin, and James Lewis. 2014. “<span
class="nocase">Microservices - a definition of this new architectural
term</span>.” <https://martinfowler.com/articles/microservices.html>.

Newman, Sam. 2015. *<span class="nocase">Building microservices:
designing fine-grained systems</span>*. O’Reilly Media, Inc.
