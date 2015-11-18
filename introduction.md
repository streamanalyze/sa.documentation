# sa.amos user manual

sa.amos is an extensible NoSQL database system that allows different
kinds of data sources to be integrated and queried. The system is
centered around an object-oriented and functional query language,
AmosQL, documented here. The system can store data in its internal
main-memory object store. In AmosQL queries, variables are bound to
instances of objects of any kind (domain calculus), in contrast to SQL
where variables in queries always have to be bound to rows in tables
(tuple calculus). Queries in terms of function compositions over sets
of objects make AmosQL queries versatile.

sa.amos includes primitives for data mining through queries and
functions to group, aggregate, and transform data. Ordered collections
are supported through the datatype `Vector`. Queries can produce
ordered results as vectors.

Several distributed sa.amos peers can collaborate in a federation. The
documentation includes descriptions of basic peer communication
primitives.

sa.amos allows different kinds of data sources and external storage
managers to be wrapped in order to enable queries over wrapped data. A
predefined wrapper for relational databases allows queries combining
relational data with other kinds of data accessible through sa.amos.

This manual describes how to use the sa.amos system and the AmosQL
query language.

## Organization of documentation

This document is organized as follows:

- [Chapter 1](getting-started/README.md) gives some basic information
on how to download and get started running the system. It also
mentions different subsystems available.

- [Chapter 2](amosql/README.md) describes the core of the AmosQL query
language, including how to define database schemas, populate, query,
and update the database.

- [Chapter 3](procedural-functions/README.md) describes how to make
stored procedures in AmosQL, making it possible to implement
algorithms that have side effects and updates the database.

- In addition to AmosQL the system can process also SQL (SQL-92)
queries, as described in [Chapter 4](sql-processor/README.md).

- The mechanisms for setting up federations of distributed sa.amos
peers are described in [Chapter 5](peer-management/README.md).

- sa.amos has mechanisms to access external systems and to integrate
and query external databases managed by different kinds of external
data managers. The extensibility mechanisms are described in [Chapter
6](accessing-external-systems/README.md).

- [Chapter 7](system-functions/README.md) documents built-in system
functions.

- [Chapter 8](references/README.md) gives some references to related
documents.
