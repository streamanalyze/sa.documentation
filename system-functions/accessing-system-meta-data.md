# Accessing system meta-data

The data that the system internally uses for maintaining the database
is exposed to the query language as well and can be queried in terms
of types and functions as other data. For example:

- The types and functions used in a database are accessible through
system functions. It is possible to search the database for types and
functions and how they relate.

- The goovi browser presents the database graphically. It is started
by calling the system function `goovi()`. 

## Type meta-data

All types in the database:
```
   alltypes() -> Bag of Type`
```

The types immediately below/above type `t` in the type hierarchy:
```
   subtypes(Type t) -> Bag of Type s
   supertypes(Type t) -> Bag of Type s
```

All types above `t` in the type hierarchy.
```
   allsupertypes(Type t) -> Bag of Type s`
```

The set of types to which an object belongs:
```
   typesof(Object o) -> Bag of Object t
```

The most specific type of an object:
```
   typeof(Object o) -> Type t
```

The type named `nm`: 
```
   typenamed(Charstring nm) -> Type t
```
Notice that type names are in upper case.

The name of the type `t`.
```
   name(Type t) -> Charstring nm
```

The [generic](../amosql/defining-functions.md#overloaded-function) functions having a single
argument of type `t` and a single result:
```
   attributes(Type t) -> Bag of Function g
```

The resolvents having a single argument of type `t` and a single result:
```
   methods(Type t) -> Bag of Function r
```

The number of objects of type `t` and all its subtypes.
```
   cardinality(Type t) -> Integer c
```

Test if the object `o` has the name `nm`:
```
   objectname(Object o, Charstring nm) -> Boolean
```

## Function meta-data

All functions in the database:
```
   allfunctions() -> Bag of Function
```

The object representing the function named `nm`:
```
   functionnamed(Charstring nm) -> Function
```
Useful for [second order functions](../amosql/second-order-functions.md).

The *one and only* [resolvent](../amosql/defining-functions.md#overloaded-function) of a generic
function named `nm`:
```
   theresolvent(Charstring nm) -> Function
```
If there is more than one resolvent for `nm` an
error is raised. If `fn` is the name of a resolvent its functional is
returned. The notation [#'...'](../amosql/second-order-functions.md) is syntactic
sugar for `theresolvent('...')`.


The name of the function `f`:
```
   name(Function f) -> Charstring
```

The signature of function `f`:
```
   signature(Function f) -> Bag of Charstring
```
If `f` is a generic function the signatures of its resolvents are
returned.


The kind of the function `f` as a string:
```
   kindoffunction(Function f) -> Charstring
```
The result can be one of 'stored', 'derived', 'foreign' or
'overloaded'

Yhe [generic](../amosql/defining-functions.md#overloaded-function) function of a resolvent:
```
   generic(Function f) -> Function
```

The resolvents of an [overloaded](../amosql/defining-functions.md#overloaded-function) function `g`:
```
   resolvents(Function g) -> Bag of Function
```

The resolvents of an overloaded function named `fn`:
```
   resolvents(Charstring fn) -> Bag of Function
```

The types of only the *first* argument of the resolvents of function resolvent `f`:
```
   resolventtype(Function f) -> Bag of Type`
```

A vector describing arguments of signature of resolvent `r`:
```
   arguments(Function r) -> Bag of Vector`
```
Each element in the vector is a triplet (vector) describing one of the
arguments with structure `{type,name,uniqueness}` where `type` is the
type of the argument, `name` is the name of the argument, and
`uniqueness` is either `key` or `nonkey` depending on the declaration
of the argument. 

Example:
```
    arguments(#'timespan');
```
returns the vector of vectors
```
   { {#[OID 371 "TIMEVAL"],"TV1","nonkey"},
     {#[OID 371 "TIMEVAL"],"TV2","nonkey"} }`
```

Analogous to `arguments(f)` the function `results(f)` returns a description of the results of function `f`:
```
   results(Function r) -> Bag of Vector
```

The number of arguments of function `f`:
```
   arity(Function f) -> Integer
```

The width of the result tuple of function `f`:
```
   width(Function f) -> Integer
```

