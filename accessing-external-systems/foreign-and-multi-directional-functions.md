# Foreign and multi-directional functions

A *foreign function* allows subroutines defined in Java, C/C++, or
Lisp to be called from sa.amos queries. This allows access to external
databases, storage managers, or computational libraries.

There are different kinds of foreign functions, including:

1.  A *filter* predicate is defined as a foreign function whose result is
of type `Boolean`. It returns true when certain conditions
over its arguments are satisfied, 
e.g. `like(Charstring str, Charstring pat) -> Boolean`.

2.  A *computation* produces a result given that the arguments
are known. Such a function has neither argument
nor result of type `Bag`, e.g. `sqrt(Number x) -> Number r`.

3.  An *aggregate function* has one argument of type `Bag` while the
result is not of type `Bag`. It iterates over the bag argument to
compute some aggregate value over the bag, e.g. `max(Bag b) -> Object`. 

4.  A *generator* has the result of type `Bag` while no argument is a
bag. It produces the result by generating a stream of result
tuples for a given argument tuple, e.g. `iota(Number l, Number u) ->
Bag of Number`.

5.  A *combiner* has one or several arguments of type `Bag` and also
the result of type `Bag`. It combines one or several bags to form a
new bag. For example, basic join operators can be defined as
combiners.

A foreign function is defined by a *foreign* [function
implementation](../amosql/defining-functions.md) with syntax:
```
foreign-function-definition ::= 
               simple-foreign-definition | 
               multidirectional-definition

simple-foreign-definition ::= 
               'foreign' [string-constant]

multidirectional-definition ::= 
               'multidirectional' capability-list

capability ::= '(' binding-pattern ['key'] capability-implementation ')'

capability-implementation ::=
               foreign-capability |
               query-capability

foreign-capability ::=
               'foreign' string-constant ['cost' cost-spec]

query-capability ::= select-statement

binding-pattern ::= A string constant containing 'b':s and 'f':s

cost-spec ::=  function-name | 
               '{' number ',' number '}'
```

For example, the system function `iota()` is implemented in C as a
`simple-foreign-definition`:
```sql
create function iota(Number l, Number u) -> Bag of Integer
  as foreign 'iota--+';
```
The string `iota--+` is a *symbolic name* associated in the C code with
the address of the C function implementing `iota()`. 

The syntax using `multidirectional-definition` defines a
*multi-directional foreign function*. A multi-directional foreign
function has one or several different *capability implementations*
depending on what variables are known for its arguments or results in a
query execution plan.  For a given query using a multi-directional foreign
function, the query optimizer chooses the best capability
implementation to minimize the total execution cost.

For example, the following multi-directional foreign function computes
0, 1, or 2 square roots `r` of a number `x`:
```sql
create function sqroots(Number x) -> Bag of Number r
  as multidirectional
     ("bf" foreign 'sqrt-+') /* capability 1 as foreign function */
     ("fb" select r*r);      /* capability 2 as query */
```
`sqroots()` has two capability definitions, one when `x` is known but
not `r` indicated by *binding pattern* `bf`, and one for the inverse
when `r` is known but not `x` with binding pattern `fb`.

In general a binding pattern is a string of b:s and f:s, indicating
which arguments or results are known or unknown, respectively.

In the example, capability 1 will be used in the query:
```sql
select sqroots(4);
```
while capability 2 will be used in the query:
```sql
select n from Number n where sqroots(n)=2;
```
In the following query the system chooses the cheapest of the two capability implementations:
```sql
select sqroots(4)=2;
```

In general `sqroots()` may have the following possible binding patterns:

1. If we know `x` but not `r`, the binding pattern is `bf` and the
capability implementation should return `r` as the square root of `x`. This
capability is implemented as C and associated with the symbol `sqrt-+`.

2. If we know `r` but not `x`, the binding pattern in `fb` and the
implementation should return `x` as `r*r`. This capability is
implemented as a query (select expression).

3. If we know both `r` and `x` then the binding pattern is `bb` and
the implementation should check that `x = r*r`. We need not implement
this capability since the system can use either of the two other
capabilities to infer this test.

With simple foreign functions only the forward (non-inverse)
function call is possible. Multi-directional foreign functions
permit also the inverse to be called in queries.  The benefit of
multi-directional foreign functions is that a larger class of queries
calling the function is executable, and that the system can make
better query optimization.  

A capability can be defined as a key to improve query optimization, e.g:
```sql
create function sqroots(Number x)-> Bag of Number r
  as multidirectional
     ("bf" foreign 'sqrt-+')  /* not unique square root r per x */
     ("fb" key select r*r);            /* unique square x per r */
```

Be very careful not to declare a binding pattern as *key* unless it
really is a key for the arguments and results of the function. In the
case of `sqroots()` the declaration says that if you know `r` you can
uniquely determine `x`. However, there is no key for binding pattern
`bf` since if you know `x` there may be several (i.e. two) square
roots, the positive and the negative. The key declarations are used by
the system to optimize queries. Wrong key declarations may result in
wrong query results because the optimizer has assumed incorrect key
uniqueness.

An example of an advanced multidirectional function is the bult-in
function `plus()` (operator `+`):

```sql
create function plus(Number x, Number y) -> Number r
  as multidirectional
     ('bbf' key foreign 'plus--+')     /* addition*/
     ('bfb' key foreign 'plus-+-')     /* subtraction */
     ('fbb' key select x where y+x=r); /* Addition is commutative */
```

The following steps are required to define a foreign function:

1. Implement each foreign function capability using the interface of
the implementation language. For Java this is explained in
[ER00](http://user.it.uu.se/~torer/publ/javaapi.pdf) and for C in
[Ris12](http://user.it.uu.se/~torer/publ/externalC.pdf).

2. If the foreign function is implemented in Java, its foreign
function definition must be a string "JAVA:class/method"
(e.g. "JAVA:Foreign/helloWorld") that identifies the Java
implementation method. There are examples in the Java subfolder of
sa.amos.

3.  In case the foreign code is implemented in C/C++ the
compiled code must be included in a DLL (Windows) or a shared
library (Unix) and dynamically linked to the kernel by calling the
function `load_extension("name-of-extension");`. The C function named
`a_initialize_extension()` exported from the DLL/shared library
extension must assign a *symbolic name* to the foreign C functions
which is referenced in the foreign function definition (`sqrt-+` in
the example).

4. A multidirectional foreign function needs to be *defined* through a
foreign function definition in AmosQL as
`multidirectional-definition`. Here the implementor must associate a
binding pattern and an optional *cost estimate* with each
capability. Normally the foreign function definition is specified in
an AmosQL script.

## Cost estimates
To help the query optimizer the user can associate different costs
with each foreign capability. 

For example:
```sql
create function sqroots(Number x)-> Bag of Number r
  as multidirectional
     ("bf" foreign 'sqrts' cost {2,2}) /* capability 1 by foreign function */
     ("fb" select r*r);                /* capability 2 by query */
```

Different capabilities of multi-directional foreign functions often
have different execution costs. In the `sqroots()` example the cost of
computing the square root is higher than the cost of computing the
square. When there are several alternative implementations of a
multi-directional foreign function the cost-based query optimizer
needs cost estimates to help it choose the most efficient
implementation. In the example we might want to indicate that the cost
of executing a square root is double as large as the cost of executing
a multiplication.

Furthermore, the cost of executing a query depends on the expected
size of the result from a function call. This is called the
*fanout* (or *selectivity* for predicates) of the call for a given
binding pattern. In the multi-directional foreign function `sqroots()`
example the implementation *sqrts* usually has a fanout of 2.

For good query optimization each foreign function capability should
have associated *costs* and *fanouts*:
- The *cost* is an estimate of how expensive it is to completely execute (emit all tuples of) a foreign function for given arguments.

- The *fanout* estimates the expected number of elements in the result stream (emitted tuples), given the arguments.

The cost and fanout for a multi-directional foreign function
implementation can be either specified as a constant vector of two
numbers (as in `sqroots()`) or as an sa.amos *cost* function returning
the vector of cost and fanout for a given function call. The numbers
normally need only be rough numbers, as they are used by the query
optimizer to compare the costs of different possible execution plans
to produce the optimal one. The number 1 for the cost of a foreign
function should roughly be the cost to perform a cheap function call,
such as `+` or `*`. Notice that these estimates are run a query
optimization time, not when the query is executed, so the estimates
must be based on meta-data about the multi-directional foreign
function.

If the `simple-foreign-definition` syntax is used or no cost is
specified the system tries to put reasonable default costs and fanouts
on foreign functions, called the *default cost model*. The default
cost model estimates the cost based on the signature of the function,
index definitions, and some other heuristics. For example, the default
cost model assumes aggregate functions are expensive to execute and
combiners even more expensive. If you have expensive foreign functions
you are strongly advised to specify cost and fanout estimates.

A *cost function* `cfn` is an sa.amos function with signature

```
create function <cfn>(Function f, Vector bpat, Vector args)  
                    -> (Integer cost, Integer fanout) as ...;
/* e.g. */

create function typesofcost(Function f, Vector bpat, Vector args)
                             -> (Integer cost, Integer fanout) as foreign ...;
```

The cost function is normally called at compile time when the
optimizer needs the cost and fanout of a function call in some
query. The arguments and results of the cost function are:

`f` is the full name the called sa.amos function. 

`bpat` is the binding pattern of the call as a vector of
strings `b` and `f`, e.g. `{"f","b"}` indicating which arguments in
the call are bound or free, respectively.

`args` is a vector of actual variable names and constants used in the
call.

`cost` is the computed estimated cost to execute a call to `f` with
the given binding pattern and argument list. The cost to access a
tuple of a stored function (by hashing) is 2; other costs are
calibrated accordingly.

`fanout` is the estimated fanout of the execution, i.e. how many
results are emitted from the execution.

If the cost hint function does not return anything it indicates that
the function is *not executable* in the given context and the optimizer
will try some other capability or execution strategy.

The costs and fanouts are normally specified as part of the capability
specifications for a multi-directional foreign function definition, as
in the example. The costs can also be specified after the definition
of a foreign function by using the following sa.amos system function:

```
costhint(Charstring fn,Charstring bpat,Vector ch)->Boolean 
```

Example:
```sql
costhint("number.sqroots->number","bf",{4,2});
costhint("number.sqroots->number","fb",{2,1});
```

`fn` is the full name of the resolvent. `bpat` is the binding pattern
string. `ch` is a vector with two numbers where the first
number is the estimated cost and the second is the estimated fanout. A
cost function `cfn` can be assigned to a capability with:

```
costhint(Charstring fn, Charstring bpat, Function cfn) -> Boolean
```

To find out what cost estimates are associated with a function use:

```
costhints(Function r)-> Bag of (Charstring bpat, Object q)
```

It returns the cost estimates for resolvent `r` and their associated
binding patterns. 

To obtain the estimated cost of executing an
sa.amos function `f` for a given binding pattern `bp`, use:
```
plan_cost(Function r, Charstring bp)-> (Number cost, Number fanout)
```
