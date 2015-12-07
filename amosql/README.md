# AmosQL

In general the user may enter different kinds of AmosQL
[statements](basic-constructs.md#statements) to the sa.amos top loop in order to instruct
the system to do operations on the database:

1.  First the database schema is created by [defining types](defining-types.md)
with associated properties.

2.  Once the schema is defined the database can be populated by
[creating objects](creating-objects.md) and their properties in terms
of the database schema.

3.  Once the database is populated [queries](queries.md) may be
expressed to retrieve and analyze data from the database. Queries
return [collections](basic-constructs.md#collections) of objects,
which can be both unordered sets of objects or ordered sequences of
objects.

4.  A populated database may be [updated](updates.md) to change its
contents.

5.  [Procedural functions](../procedural-functions/README.md) (stored procedures) may be
defined, which are AmosQL programs having side effects that may modify
the database.

This section is organized as follows:

- Before going into the details of the different kinds of AmosQL
statements, in [basic constructs](basic-constructs.md) the syntactic
notation is introduced along with descriptions of syntax and semantics
of the basic building blocks of the query language.

- [Defining Types](defining-types.md) describes how to create a simple
database schema by defining types and properties.

- [Creating Objects](creating-objects.md) describes how to populate the
database by creating objects.

- The concept of *queries* over a populated database is presented in
[the Queries section](queries.md).

- Regular queries return unordered sets of data. In addition sa.amos
provides the ability to specify *vector queries*, which return ordered
sequences of data, as described in [Section 2.5](vector-queries.md).

- A central concept in sa.amos is the extensive use of *functions* in
database schema definitions. There are several kinds of user-defined
functions supported by the system as described in [Section
2.6](defining-functions.md).

- [Section 2.7](updates.md) describes how to *update* a populated
database.

- [Section 2.8](data-mining-primitives.md) describes primitives in AmosQL useful
for data mining, in particular different ways of grouping data and of
making operations of sequences and numerical vectors.

- [Section 2.9](accessing-data-in-files.md) describes functions available to
read/write data from/to files, such as CSV files.

- [Section 2.10](scans.md) describes how to define *scans* making it
possible to iterate over very large query results.
