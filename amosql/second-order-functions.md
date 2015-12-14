# Second order functions

sa.amos functions are internally represented as any other objects and
stored in the database. Object representing functions can be used in
functions and queries too. An object representing a function is called
a *functional*. *Second order functions* are functions that take
functionals as arguments or results.

For example, the second order system function `functionnamed()` retrieves the
functional `fno` having a given name `fn`:
```
   functionnamed(Charstring fn) -> Function fno
```

Another example of a second order function is the system function `apply()`:
```
   apply(Function fno, Vector argl) -> Bag of Vector
```
`apply()` calls the functional `fno` with the vector `argl` as argument list. The result tuples are returned as a bag of vectors.

Example:
```
   apply(functionnamed("number.number.plus->number"),{1,3.4});
```  
returns the vector `{4.4}` Notice how `apply()` represents argument
lists and result tuples as vectors.

When using second order functions one often needs to retrieve
a functional `fno` given its name. The function `functionnamed()`
provides one way to achieve this. A simpler way is often to use
*functional constants* with syntax:
```
functional-constant ::= '#' string-constant
```  
Example:
```
#'mod';
```

A functional constant is translated into the functional with the name
uniquely specified by the string constant. For example, the following
expression `apply(#'mod',{4,3});` returns the vector `{1}`.

**Notice** that an error is raised if the function name specified in
a functional constant does not uniquely identifying the
functional. This happens if it is the generic name of an [overloaded function](defining-functions.md#overloaded-function). For example, the functional constant `#'plus'` is illegal,
since `plus()` is overloaded. For overloaded functions the name of a
[resolvent](defining-functions.md#resolvent-name) has to be used instead.

For example, `apply(#'plus',{2,3.5});` generates an error, while
`apply(#'number.number.plus->number', {2,3.5});` returns the vector 
`{5.5}`. 

You can use generic functions when applying non-unique resolvents, in
which case apply will dynamically choose the correct resolvent based
on the types in the argument vector.

For example, `apply(functionnamed("plus"),{2,3.5});` returns `{5.5}`.
This call will be somewhat slower than
`apply(#'number.number.plus->number',{2,3.5})` since the resolvent is
selected using [late binding](defining-functions.md#late-bind).

## <a name="transitive-closure"> Transitive closures

The *transitive closure* function `tclose()` is a second order function
to explore graphs where the edges are expressed by a *transition
function* specified by argument `fno`:
```
   tclose(Function fno, Object o) -> Bag of Object
```
`tclose()` applies the transition function `fno(o)`, then
`fno(fno(o))`, then `fno(fno(fno(o)))`, etc. until `fno` returns the
empty result. Because of the [Daplex semantics](queries.md#daplex-semantics), if the transition function `fno` returns a bag of values for some argument `o`, the successive applications of `fno` will be applied on each element of the result bag. The result types of a transition function must either be the same as the argument types or a bag of the argument types. Such a function that has the same arguments and (bag of) result types is called a *closed function*. 

For example, assume the following definition
of a graph defined by the transition function `arcsto()`:
```sql
   create function arcsto(Integer node)-> Bag of Integer n as stored;
   set arcsto(1) = bag(2,3);
   set arcsto(2) = bag(4,5);
   set arcsto(5) = bag(1);
```
The query `tclose(#'arcsto', 1);` traverses the graph starting in node 1. It will return the bag:
```
   1
   3
   2
   5
   4
```

In general the function `tclose()` traverses a graph where the edges
(arcs) are defined by the transition function. The vertices (nodes)
are defined by the transition function `fno`, where a call to the
transition function `fno(n)` defines the neighbors of the node `n` in
the graph. The graph may contain loops and therefore `tclose()` will remember
what vertices it has visited earlier and stop further traversals for
vertices already visited. You can also query the inverse of
`tclose()`, i.e. from which nodes `f` can be reached.

Example:
```sql
   select f 
     from Integer f 
    where 1 in tclose(#'arcsto',f);
```
will return the bag
```
   1
   5
   2
```

If you know that the graph to traverse is a tree or a directed acyclic
graph (DAG) you can instead use the faster function:
```
   traverse(Function fno, Object o) -> Bag of Object
```

As for `tclose()`, the children in the tree to traverse is defined by
the transition function `fno`. The tree is traversed in pre-order
depth first. Leaf nodes in the tree are nodes for which `fno` returns
empty result. The function `traverse()` will not terminate if the graph is
circular. Nodes are visited more than once for acyclic graphs having
common subtrees.

A transition function may have extra arguments and results, as long as
the function is closed. This allows to pass extra parameters to a
transitive closure computation. 

For example, to compute not only the transitive closure, but also the
distance from the root of each visited graph node, specify the
following transition function:
```sql
   create function arcstod(Integer node, Integer d) -> Bag of (Integer,Integer)
     as select arcsto(node),1+d;
```
The query `tclose(#'arcstod',1,0);` will return the bag:
```
   (1,0)
   (3,1)
   (2,1)
   (5,2)
   (4,2)
```

**Notice** that only the first argument and result in the transition
function define graph vertices, while the remaining arguments and
results are extra parameters for passing information through the
traversal, as with `arcstod()`. Notice that there may be no more than
three extra parameters in a transition function.

## <a name="iterating-apply"> Iteration

The function `iterate()` applies a function `fn()` repeadely. 

Signature:
```
   iterate(Function fn, Number maxdepth, Object x) -> Object r
```

The iteration is initialized by setting <i>x<sub>0</sub>=x</i>. Then <i>x<sub>i+1</sub>= fn(x<sub>i</sub>)</i> is repeadedly computed until one of the following conditions hold:
1. there is no change (<i>x<sub>i</sub></i> <i>= </i><i>x<sub>i+1</sub></i>), or
2. `fn()` returns nil (<i>x<sub>i+1 </sub></i><i>=nil</i>), or
3. an upper limit *maxdepth* of the number of iterations is reached for <i>x<sub>i</sub></i>.

There is another overloaded variant of `iterate()` that accepts an extra parameter `p` passed into *fn(x<sub>i</sub>,p)* in the iterations. 

Signature:
```
iterate(Function fn, Number maxdepth, Object x0, Object p) -> Object r
```
This enables flexible termination of the iteration since `fn(x,p)` can return `nil` based on both `x` and `p`.
