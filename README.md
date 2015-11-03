# Amos II Release 18 User's Manual


[Uppsala DataBase Laboratory](http://www.it.uu.se/research/group/udbl)
Department of Information Technology
Uppsala University
Sweden

May 9,  2015

## Summary

Amos II is an extensible NoSQL database system that allows different kinds of data sources to be integrated and queried. The system is centered around an object-oriented and functional query language,
AmosQL, documented here. The system can store data in its internal
main-memory object store. In AmosQL queries variables are bound to
instances of objects of any kind (domain calculus), in contrast to SQL
where variables in queries always have to be bound to rows in tables
(tuple calculus). Queries in terms of function compositions over sets of
objects make AmosQL queries versatile.

Amos II includes primitives for data mining through queries and
functions to group, aggregate, transform, and visualize data. Ordered
collections are supported through the datatype <span
style="font-style: italic;">Vector</span>. Queries can produce ordered
results as vectors.

Several distributed Amos II <span
style="font-style: italic;">peers</span> can collaborate in a
federation. The documentation includes descriptions of basic peer
communication primitives.

Amos II enables <span style="font-style:
                        italic;">wrappers </span>to be defined for
different kinds of data sources and external storage managers accessed
to make them queryable. A predefined wrapper for relational databases
allows queries combining relational data with other kinds of data
accessible through Amos II.

This manual describes how to use the Amos II system and the AmosQL query
language. The principles of the Amos II system and AmosQL are described
in the document [\[RJK03\]](#RJK03).

Organization of document
========================

This document is organized as follows:\

-   [Chapter 1](#running) gives some basic information on how to
    download and get started running the system. It also mentions
    different subsystems available.
-   [Chapter 2](#amosql) describes the core of the AmosQL query
    language, including how to define database schemas, populate, query,
    and update the database.
-   [Chapter 3](#procedures) describes procedural extensions to AmosQL
    making it possible to implement algorithms that have side effects
    updating the database.
-   In addition to AmosQL the system can process also SQL (SQL-92)
    queries, as described in [Chapter 4](#SQL-processor).\
-   The mechanisms for setting up federations of distributed Amos II
    peers are described in [Chapter 5](#peers).
-   Amos II has mechanisms to access external systems and to integrate
    and query external databases managed by different kinds of external
    data managers. The extensibility mechanisms are described in
    [Chapter 6](#mediatorfns).
-   [Chapter 7](#systemfunctions) documents built-in system functions. 
-   Finally [Chapter 8](#references) gives some references to related
    documents.\
