# Foreign and multi-directional functions

The basis for accessing external systems from sa.amos is to define *foreign functions*. A foreign function allows subroutines defined in C/C++ [^Ris12], Lisp [^Ris06], or Java [^ER00] to be called from sa.amos queries. This allows access to external databases, storage managers, or computational libraries. A foreign function is defined by the following [function implementation](#fn-implementation):

```
foreign-body ::= simple-foreign-definition | multidirectional-definition
simple-foreign-body ::= 'foreign' [string-constant]
multidirectional-definition ::= 'multidirectional' capability-list
capability ::= (binding-pattern 'foreign' string-constant ['cost' cost-spec]['rewriter' string-constant ])
binding-pattern ::= A string constant containing 'b':s and 'f':s
cost-number ::= integer-constant | real-constant
cost-spec ::= function-name | '{' cost-number ',' cost-number '}'
```

For example:

```sql
create function iota(Integer l, Integer u) -> Bag of Integer
  as foreign 'iota--+';

create function sqroots(Number x)-> Bag of Number r
  as multidirectional
        ("bf" foreign 'sqrts' cost {2,2})
        ("fb" foreign 'square' cost {1.2,1});
create function bk_access(Integer handle_id )->(Vector  key, Vector)
     /* Access rows in BerkeleyDB table */                
  as multidirectional
    ('bff' foreign 'bk_scan' cost bk_cost rewriter 'abkw')
    ('bbf' foreign 'bk_get' cost {1002, 1});
create function myabs(real x)->real y
    as multidirectional
      ("bf" foreign "JAVA:Foreign/absbf" cost {2,1})
      ("fb" foreign "JAVA:Foreign/absfb" cost {4,2});
```

 The syntax using [multidirectional definition](#multidirectional) provides for specifying different implementations of foreign functions depending on what variables are known for a call to the function in a query execution plan, which is called different [binding patterns](#binding-pattern). The simplified syntax using [simple-foreign-body](#simple-foreign) is mainly for quick implementations of functions without paying attention to different implementations based on different binding patterns. A foreign function can implement one of the following:

1.  A *filter* which is a predicate, indicated by a foreign function whose result is of type `Boolean`, e.g. `<`, that succeeds when certain conditions over its results are satisfied.
2.  A *computation* that produces a result given that the arguments are known, e.g. `+` or `sqrt`. Such a function has no argument nor result of type `Bag`.
3.  A *generator* that has a result of type `Bag`. It produces the result as a bag by generating a stream of several  result tuples given the argument tuple, e.g. [`iota()`](#iota) or the function sending SQL statements to a relational database for evaluation where the result is a bag of tuples.
4.  An *aggregate function* has one argument of type `Bag` but not result of type `Bag`. It iterates over the bag argument to compute some aggregate value over the bag, e.g. `average()`.
5.  A *combiner* has both one or several arguments of type `Bag` and some result of type `Bag`. It combines one or several bags to form a new bag. For example, basic join operators can be defined as combiners.

sa.amos functions in general are *multi-directional*. A multi-directional function can be executed also when the result of a function is given and some corresponding argument values are sought. For example, if we have a function.

```sql
parents(Person)-> Bag of Person
```

we can ask these AmosQL queries:

```sql
parents(:p); 
/* Result is the bag of parents of :p */
select c from Person c where :p in parents(c);
/* Result is bag of children of :p */ 
```

It is often desirable to make foreign sa.amos functions multi-directional as well. As a very simple example, we may wish to ask these queries using the square root function `sqroots`:

```sql
sqroots(4.0);
/* Result is -2.0 and 2.0 */
select x from Number x where sqroots(x)=4.0;
/* result is 16.0 */
sqroots(4.0)=2.0;
/* Is the square root of 4 = 2 */
```

With [simple foreign functions](#simple-foreign) only the forward (non-inverse) function call is possible. Multi-directional foreign functions permit also the inverse to be called in queries.

The benefit of multi-directional foreign functions is that a larger class of queries calling the function is executable, and that the system can make better query optimization. A multi-directional foreign function can have several [capabilities](#capability) implemented depending on the *binding pattern* of its arguments and results. The binding pattern is a string of b:s and f:s, indicating which arguments or results in a given situation are known or unknown, respectively.

For example, `sqroots()` has the following possible binding patterns:

1. If we know x but not r, the binding pattern is "bf" and the implementation should return r as the square root of x.
2. If we know r but not x, the binding pattern in "fb" and the implementation should return x as r**2.
3. If we know both r and x then the binding pattern is "bb" and the implementation should check that x = r**2.

Case 1 and 2 are implemented by multi-directional foreign function `sqroots()`. Case 3 need not be implemented as it is inferred by the system by first executing `r**2` and then checking that the result is equal to `x` (see [\[LR92\]](#LR92)).

To implement a multi-directional foreign function you first need to think of which binding patterns require implementations. In the `sqroots()` case one implementation handles the square root and the other one handles the square. The binding patterns will be `"bf"` for the square root and `"fb"` for the square. The following steps are required to define a foreign function:

1. Implement each foreign function capability using the interface of the implementation language. For Java this is explained in [^ER00] and for C in [^Ris12].
2.  In case the foreign code implemented in C/C++ the implementation must be implemented as a DLL (Windows) or a shared library (Unix) and dynamically linked to the kernel by calling the function `load_extension("name-of-extension")`. There is an example of a Visual Studio project (Windows) files or a Makefile (Unix) in folder *demo* of the downloaded sa.amos version.
3. The exported initializer named `xxx` of the DLL/shared library extension must assign a *symbolic name* to the foreign C functions which is referenced in the foreign function definition (`sqrt` and `square` in the example [above](#foreign-body)) [^Ris12].
4. Finally a multidirectional foreign function needs to be *defined* through a foreign function definition in AmosQL as [above](#foreign-body). Here the implementor may associate a binding pattern and an optional [cost estimate](#cost-estimate) with each capability. Normally the foreign function definition is done separate from the actual code implementing its capabilities, in an AmosQL script.
5. The system automatically reloads foreign functions in a saved database image when the image is restarted.

A capability can also be defined as a select expression (i.e. query) executed for the given binding pattern. The variables marked bound (b) are inputs to the select expression and the result binds the free (f) variables. For example, `sqroots()` could also have been defined by:

```sql
create function sqroots(Number x)-> Bag of Number r
  as multidirectional
     ("bf" foreign 'sqrts' cost {2,2}) /* capability by foreign function */
     ("fb" select r*r);                /* capability by query */
```

Notice here that `sqroots()` is defined as a foreign function when `x` is known and `r` computed, while it is a derived function when `r` is known and `x` computed. This kind of functionality is useful when different methods are used for computing a function and its inverses. A capability can be defined as a key to improve query optimization, e.g:

```sql
create function sqroots(Number x)-> Bag of Number r
  as multidirectional
     ("bf" foreign 'sqrts' cost {2,2}) /* not unique square root per x */
     ("fb" key select r*r);            /* unique square per r */
```

Be very careful not to declare a binding pattern as *key* unless it really is a key for the arguments and results of the function. In the case of `sqroots()` the declaration says that if you know `r` you can uniquely determine `x`. However, there is no key for binding pattern `bf` since if you know `x` there may be several (i.e. two) square roots, the positive and the negative. The key declarations are used by the system to optimize queries. Wrong key declarations may result in wrong query results because the optimizer has assumed incorrect key uniqueness.

An example of an advanced multidirectional function is the bult-in function `plus()` (operator `+`):

```sql
create function plus(Number x, Number y) -> Number r
  as multidirectional
     ('bbf' key foreign 'plus--+')     /* addition*/
     ('bfb' key foreign 'plus-+-')     /* subtraction */
     ('fbb' key select x where y+x=r); /* Addition is commutative */
```

For further details on how to define multidirectional foreign functions for different implementation languages see[^Ris12] [^ER00].

## Cost estimates

Different capabilities of multi-directional foreign functions often have different execution costs. In the `sqroots()` example the cost of computing the square root is higher than the cost of computing the square. When there are several alternative implementations of a multi-directional foreign function the cost-based query optimizer needs cost estimates that help it choose the most efficient implementation. In the example we might want to indicate that the cost of executing a square root is double as large as the cost of executing a square.

Furthermore, the cost of executing a query depends on the expected size of the result from a function call. This is called the *fanout*(or *selectivity* for predicates) of the call for a given binding pattern. In the multi-directional foreign function `sqroots()` example the implementation *sqrts* usually has a fanout of 2, while the implementation *square* has a fanout of 1.

For good query optimization each foreign function capability should have associated *costs* and *fanouts*:

- The *cost* is an estimate of how expensive it is to completely execute (emit all tuples of) a foreign function for given arguments.
- The *fanout* estimates the expected number of elements in the result stream (emitted tuples), given the arguments.

The cost and fanout for a multi-directional foreign function implementation can be either specified as a constant vector of two numbers (as in `sqroots()`) or as an sa.amos *cost* function returning the vector of cost and fanout for a given function call. The numbers normally need only be rough numbers, as they are used by the query optimizer to compare the costs of different possible execution plans to produce the optimal one. The number 1 for the cost of a foreign function should roughly be the cost to perform a cheap function call, such as `+` or `<`. Notice that these estimates are run a query optimization time, not when the query is executed, so the estimates must be based on meta-data about the multi-directional foreign function.

If the [simplified syntax](#simple-foreign) is used or no cost is specified the system tries to put reasonable default costs and fanouts on foreign functions, the default cost model. The default cost model estimates the cost based on the signature of the function, index definitions, and some other heuristics. For example, the default cost model assumes aggregate functions are expensive to execute and combiners even more expensive. If you have expensive foreign functions you are strongly advised to specify cost and fanout estimates.

The cost function `cfn` is an sa.amos function with signature

```
create function <cfn>(Function f, Vector bpat, Vector args)  
                    -> (Integer cost, Integer fanout) as ...;
/* e.g. */

create function typesofcost(Function f, Vector bpat, Vector args)
                             -> (Integer cost, Integer fanout) as foreign ...;
```

The cost function is normally called at compile time when the optimizer needs the cost and fanout of a function call in some query. The arguments and results of the cost function are:

`f` is the full name the called sa.amos function. `bpat` is the binding pattern of the call as a [vector](#vector) of strings `b` and `f`, e.g. `{"f","b"}` indicating which arguments in the call are bound or free, respectively.

`args` is a vector of actual variable names and constants used in the call.

`cost` is the computed estimated cost to execute a call to `f` with the given binding pattern and argument list. The cost to access a tuple of a stored function (by hashing) is 2; other costs are calibrated accordingly.

`fanout` is the estimated fanout of the execution, i.e. how many results are emitted from the execution.

If the cost hint function does not return anything it indicates that the function is not executable in the given context and the optimizer will try some other capability or execution strategy.

The costs and fanouts are normally specified as part of the capability specifications for a multi-directional foreign function definition, as in the example. The costs can also be specified after the definition of a foreign function by using the following sa.amos system function:

```
costhint(Charstring fn,Charstring bpat,Vector ch)->Boolean 
```

Example:
```sql
costhint("number.sqroots->number","bf",{4,2});
costhint("number.sqroots->number","fb",{2,1});
```

`fn` is the full name of the resolvent. `bpat` is the binding pattern string. `ch` is a [vector](#vector) with two numbers where the first number is the estimated cost and the second is the estimated fanout. A cost function `cfn` can be assigned to a capability with:

```
costhint(Charstring fn, Charstring bpat, Function cfn) -> Boolean
```

To find out what cost estimates are associated with a function use:

```
 costhints(Function r)-> Bag of (Charstring bpat, Object q)
```

It returns the cost estimates for resolvent `r` and their associated binding patterns. To obtain the estimated cost of executing an sa.amos function `f` for a given binding pattern `bp`, use\

```
plan_cost(Function r, Charstring bp)-> (Number cost, Numbers fanout)`
```
