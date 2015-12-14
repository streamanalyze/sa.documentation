# Accessing external systems

This chapter first describes *multi-directional foreign functions*,
the basis for accessing external systems from sa.amos queries. Then we
describe how to query relational databases through sa.amos. Finally
some general types and functions used for querying external sources
are described.

sa.amos provides a number of primitives for accessing different
external data sources by defining *wrappers* for each kind external
sources. A wrapper is a software module making it possible to query an
external data source using AmosQL. The basic wrapper interface is
based on user defined *multi-directional* foreign functions having
various capabilities used to access external data sources in different
ways depending on what variables are bound or free in an execution
plan, the *binding patterns*. Object oriented abstractions are defined
through *mapped types* on top of the basic foreign function
mechanism. A number of query rewrite techniques are used in the system
for scalable access to wrapped sources, in particular relational
databases.

A general wrapper for [relational databases](the-relational-database-wrapper.md) using JDBC is predefined in sa.amos.
