# Accessing system meta-data

The data that the system internally uses for maintaining the database is
exposed to the query language as well and can be queried in terms of
types and functions as other data. For example:\

-   The types and functions used in a database are accessible through
    system functions. It is possible to search the database for types
    and functions and how they relate.
-   The goovi browser available from javaamos by calling the system
    function *goovi()*; presents the database graphically. It is written
    completely as an application Java program using AmosQL queries as
    the only interface to the Amos II kernel.

## Type meta-data

`alltypes() -> Bag of Type`\
 returns all types in the database.

<span
style="font-family: monospace; "></span>`subtypes(Type           t) -> Bag of Type s           supertypes(Type t) -> Bag of Type s`\
 returns the types immediately below/above type *t* in the type
hierarchy.

`allsupertypes(Type t) -> Bag of Type s`\
 returns all types above *t* in the type hierarchy.

`typesof(Object o) -> Bag of Object t`\
 returns the type set of an object.

`typeof(Object o) -> Type t`\
 returns the most specific type of an object.\

`typenamed(Charstring nm) -> Type t`\
 returns the type named *nm*. Notice that type names are in upper case.

`name(Type t) -> Charstring nm`\
 returns the name of the type *t*.\

`attributes(Type t) -> Bag of Function g`\
 returns the [generic](#overloaded-functions%20) functions having a
single argument of type *t* and a single result.

`methods(Type t) -> Bag of Function r`\
 returns the resolvents having a single argument of type *t* and a
single result.\

`cardinality(Type t) -> Integer c`\
 returns the number of object of type *t* and all its subtypes.

`objectname(Object o, Charstring nm) -> Boolean`\
 returns *true* ** if the object *o* has the name *nm*.\

### 7.7.2 Function meta-data\

`allfunctions() -> Bag of Function         `returns all functions in the
database.\
 <span style="font-family: monospace; "></span>\
 <span
style="font-family: monospace; "></span>`functionnamed(Charstring               nm) -> Function`\
 returns the object representing the function named *nm*. Useful for
[second order functions](#second-order-functions%20).\

<span
style="font-family: Times New Roman; "> </span>

<span style="font-family: monospace; ">theresolvent(Charstring nm) -&gt;
Function</span>\
 returns the single [resolvent](#overloaded-functions%20) of a generic
function named <span style="font-style: italic; ">nm</span>. If there is
more than one resolvent for <span style="font-style: italic; ">nm</span>
an error is raised. If <span style="font-style: italic; ">fn</span> is
the name of a resolvent its functional is returned.  The notation [<span
style="font-style: italic; ">\#'...'</span>](#functional-constant%20)is
syntactic sugar for <span
style="font-style: italic; ">theresolvent('..')</span>;\

`name(Function f) -> Charstring`\
 returns the name of the function *f*.

<span style="font-family: Times New Roman; "> </span>

<span style="font-family: monospace; ">signature(Function f)  -&gt; Bag
of Charstring</span>\
 returns the signature of <span style="font-style: italic; ">f.</span>
If *f* is a generic function the signatures of its resolvents are
returned.\

<span
style="font-family: Times New Roman; "></span>`kindoffunction(Function f) ->           Charstring`\
 returns the kind of the function *f* as a string. The result can be one
of 'stored', 'derived', 'foreign' or 'overloaded'.

`generic(Function f) -> Function`\
 returns the [generic](#overloaded-functions%20) function of a
resolvent.

`resolvents(Function g) -> Bag of Function`\
 returns the resolvents of an [overloaded](#overloaded-functions%20)
function *g*.\

`resolvents(Charstring fn) -> Bag of Function`\
 retturns the resolvents of an overloaded function named *fn*.\

`resolventtype(Function f) -> Bag of Type`\
 returns the types of only the <span
style="font-style: italic; ">first</span> argument of the resolvents of
function resolvent *f*.

`arguments(Function r) -> Bag of Vector       `returns vector describing
arguments of signature of resolvent *r*. Each element in the vector is a
triplet (vector) describing one of the arguments with structure
*{type,name,uniqueness}*`       `where *type* is the type of the
argument, *name* is the name of the argument, and *uniqueness* is either
*key* or *nonkey* depending on the declaration of the argument.. For
example,
`         arguments(#'timespan');``                       --> {{#[OID 371 "TIMEVAL "],"TV1 ","nonkey "},              {#[OID 371 "TIMEVAL "],"TV2 ","nonkey "}}       `

`results(Function r) -> Bag of Vector`\
 Analogous to arguments for result (tuple) of function.\

`arity(Function f) -> Integer`\
 returns the number of arguments of function.

`width(Function f) -> Integer`\
 returns the width of the result tuple of function `f`.\
