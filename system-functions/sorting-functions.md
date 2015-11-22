# Sorting functions

Most sorting functionality is available through the [order
by](#order-by-clause) clause in select statement. There are several
functions that can be used to sort bags or vectors. However, since the
[select](#select-statement) and [vselect](#vselect) statements provide
powerful sorting options, the sorting functions usually need not be
used.

## Sorting by tuple order

A natural sort order is often to sort the result tuples of a bag
returned from a query or a function based on the sort order of all
elements in the result tuples.

Function signatures:
```
   sort(Bag b)->Vector
   sort(Bag b, Charstring order)->Vector
```
The `order` parameter can be `"inc"` (increasing) or `"dec"`
(decreasing).  The result of sorting an unordered bag is a
[vector](#vector).

Examples:
```
   sort(1-iota(1,3));
```
returns the vector `{-2,-1,0}`.

```
   sort(1-iota(1,3),'dec');
```
returns the vector `{0,-1,-2}`.

```
   sort(select i, 1-i from Number i where i in iota(1,3));
```
returns the vector of vectors `{{1,0},{2,-1},{3,-2}}`, i.e. the result
tuples in the `select` statement are converted to vectors.

If `order` is omitted the result is sorted in increasing order. 

**Notice** that the sort order is not preserved if a sorted vector is
converted to a bag in a query since the query optimizer is free to
return elements of bags in any order.

Example:
```
   select x from Number x where x in -iota(1,5) and x in sort(-iota(3,5));
```
returns the unsorted bag
```
   -3
   -4
   -5
```
even though `sort(-iota(3,5))` returns `{-5,-4,-3}`.

**Notice** that surrogate object are sorted based on their OID
numbers, which usually has no meaning.

## Sorting bags by ordering directives

A common case is sorting of result tuples from queries and functions
ordered by *ordering directives*. An ordering directive is a pair of a
*position number* in a result tuple of a bag to be sorted and an
*ordering direction*.

Function signatures:
```
   sortbagby(Bag b, Integer pos, Charstring order) -> Vector
   sortbagby(Bag b, Vector of Integer pos, Vector of Charstring order) -> Vector
```
Example:
```
   sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),1,'dec');
```
returns the vector of vectors `{{3,1},{2,0},{1,1}}`. Here the position
number is `1` and the ordering direction `dec`. The result tuple
positions are enumerated 1 and up.

```
   sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),{2,1},{'inc','inc'});
```
returns the vector of vectors `{{2,0},{1,1},{3,1}}`. This illustrates
how several tuples positions with different ordering directions can be
specified.


## Sorting bags or vectors with a custom comparison function

The group functions below are useful to sort bags or
[vectors](#vector) of either objects or tuples with a custom function
supplied by the user. Either the function object or function named can
be supplied. The comparison function must take two arguments with
types compatible with the elements of the bag or the vector and return
a boolean value. Signatures:

```
   sortvector(Vector v1, Function compfno) -> Vector
   sortvector(Vector v, Charstring compfn) -> Vector
   sortbag(Bag b, Function compfno) -> Vector
   sortbag(Bag b, Charstring compfn) -> Vector      
```
Example:
```
   create function younger(Person p1, Person p2) -> Boolean
     /* Sort all persons ordered by their age */
     as age(p1) < age(p2);
```
Example of usage:
```
   sortbag((select p from Person p), 'YOUNGER');
```
