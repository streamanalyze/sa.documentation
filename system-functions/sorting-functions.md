# Sorting functions

Most sorting functionality is available through the [order by](#order-by-clause) clause in select statement. There are several functions that can be used to sort bags or vectors. However, since the [select](#select-statement) and [vselect](#vselect) statements provide powerful sorting options, the sorting functions usually need not be used.

## Sorting by tuple order

A natural sort order is often to sort the result tuples of a bag returned from a query or a function based on the sort order of all elements in the result tuples.

Function signatures:
```
sort(Bag b)->Vector
sort(Bag b, Charstring order)->Vector
```

Notice that the result of sorting an unordered bag is a [vector](#vector). For example:
```
Amos 1> sort(1-iota(1,3));
=> {-2,-1,0}
Amos 2> sort(1-iota(1,3),'dec');
{0,-1,-2}
Amos 3> sort(select i, 1-i from Number i where i in iota(1,3));
{ {1,0},{2,-1},{3,-2} }
```

The default first case is to sort the result in increasing order. In the second case a second argument specifies the ordering direction, which can be `inc` (increasing) or `dec` (decreasing). The third case illustrates how the result tuples are ordered for queries returning bags of tuples. The result tuples are converted into vectors.

**Notice** that the sort order is not preserved if a sorted vector is converted to a bag as the query optimizer is free to return elements of bags in any order.

For example:
```
select x from Number x where x in -iota(1,5) and x in sort(-iota(3,5));
```
returns the unsorted bag
```
-3
-4
-5
```
even though
```
sort(-iota(3,5)) -> {-5,-4,-3}
```
Notice that surrogate object will be sorted too based on their OID numbers, which usually has no meaning.

## Sorting bags by ordering directives

A common case is sorting of result tuples from queries and functions ordered by ordering directives. An ordering directive is a pair of a position number in a result tuple of a bag to be sorted and an ordering direction.

Function signatures:
```
sortbagby(Bag b, Integer pos, Charstring order) -> Vector
sortbagby(Bag b, Vector of Integer pos, Vector of Charstring order) -> Vector
```
For example:
```
Amos 1> sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),1,'dec');
=> {{3,1},{2,0},{1,1}}
Amos 2> sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),{2,1},{'inc','inc'});
=> {{2,0},{1,1},{3,1}}
```

In the first case a single tuple ordering directive i specified by two arguments, one for the tuple position and one for the ordering direction. The result tuple positions are enumerated 1 and up. The second case illustrates how several tuples positions with different ordering directions can be specified.

## Sorting bags or vectors with a custom comparison function

This group of sort functions are useful to sort bags or [vectors](#vector) of either objects or tuples with a custom function supplied by the user. Either the function object or function named can be supplied. The comparison function must take two arguments with types compatible with the elements of the bag or the vector and return a boolean value. Signatures:

```
sortvector(Vector v1, Function compfno) -> Vector
sortvector(Vector v, Charstring compfn) -> Vector
sortbag(Bag b, Function compfno) -> Vector
sortbag(Bag b, Charstring compfn) -> Vector      
```
For example:
```
create function younger(Person p1, Person p2) -> Boolean
as age(p1) < age(p2);
/* Sort all persons ordered by their age */
sortbag((select p from Person p), 'YOUNGER');
```
