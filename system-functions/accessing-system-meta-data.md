# Accessing system meta-data

The data that the system internally uses for maintaining the database is exposed to the query language as well and can be queried in terms of types and functions as other data. For example:

- The types and functions used in a database are accessible through system functions. It is possible to search the database for types and functions and how they relate.
-   The goovi browser available from javaamos by calling the system function `goovi()` presents the database graphically. It is written completely as an application Java program using AmosQL queries as the only interface to the sa.amos kernel.

## Type meta-data

```
alltypes() -> Bag of Type`
```
Returns all types in the database.

```
subtypes(Type t) -> Bag of Type s
supertypes(Type t) -> Bag of Type s
```
Returns the types immediately below/above type `t` in the type hierarchy.

```
allsupertypes(Type t) -> Bag of Type s`
```
Returns all types above `t` in the type hierarchy.

```
typesof(Object o) -> Bag of Object t
```
Returns the type set of an object.

```
typeof(Object o) -> Type t
```
Returns the most specific type of an object.

```
typenamed(Charstring nm) -> Type t
```
Returns the type named `nm`. Notice that type names are in upper case.

```
name(Type t) -> Charstring nm
```
Returns the name of the type `t`.

```
attributes(Type t) -> Bag of Function g
```
Returns the [generic](#overloaded-functions) functions having a single argument of type `t` and a single result.

```
methods(Type t) -> Bag of Function r
```
Returns the resolvents having a single argument of type *t* and a single result.

```
cardinality(Type t) -> Integer c
```
Returns the number of object of type `t` and all its subtypes.

```
objectname(Object o, Charstring nm) -> Boolean
```
Returns `true` if the object `o` has the name `nm`.

## Function meta-data

```
allfunctions() -> Bag of Function
```
Returns all functions in the database.

```
functionnamed(Charstring nm) -> Function
```
Returns the object representing the function named `nm`. Useful for [second order functions](#second-order-functions).

```
theresolvent(Charstring nm) -> Function
```
Returns the single [resolvent](#overloaded-functions) of a generic function named `nm`. If there is more than one resolvent for `nm` an error is raised. If `fn` is the name of a resolvent its functional is returned. The notation [#'...'](#functional-constant) is syntactic sugar for `theresolvent('...')`.

```
name(Function f) -> Charstring
```
Returns the name of the function `f`.

```
signature(Function f)  -> Bag of Charstring
```
Returns the signature of `f`. If `f` is a generic function the signatures of its resolvents are returned.

```
kindoffunction(Function f) -> Charstring
```

Returns the kind of the function `f` as a string. The result can be one of 'stored', 'derived', 'foreign' or 'overloaded'.

```
generic(Function f) -> Function
```
Returns the [generic](#overloaded-functions) function of a resolvent.

```
resolvents(Function g) -> Bag of Function
```
Returns the resolvents of an [overloaded](#overloaded-functions) function `g`.

```
resolvents(Charstring fn) -> Bag of Function
```
Returns the resolvents of an overloaded function named `fn`.

```
resolventtype(Function f) -> Bag of Type`
```
Returns the types of only the *first* argument of the resolvents of function resolvent `f`.

```
arguments(Function r) -> Bag of Vector`
```
Returns vector describing arguments of signature of resolvent `r`. Each element in the vector is a triplet (vector) describing one of the arguments with structure `{type,name,uniqueness}` where `type` is the type of the argument, `name` is the name of the argument, and `uniqueness` is either `key` or `nonkey` depending on the declaration of the argument. For example:

```
arguments(#'timespan');  
--> {{#[OID 371 "TIMEVAL"],"TV1","nonkey"},
     {#[OID 371 "TIMEVAL"],"TV2","nonkey"}}
```

```
results(Function r) -> Bag of Vector
```
Analogous to arguments for result (tuple) of function.

```
arity(Function f) -> Integer
```
Returns the number of arguments of function.

```
width(Function f) -> Integer
```
returns the width of the result tuple of function `f`.
