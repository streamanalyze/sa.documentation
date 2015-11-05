# Sorting functions

Most sorting functionality is available through the [order
by](#order-by-clause%20) clause in select statement. There are several
functions that can be used to sort bags or vectors. However, since the
[select](#select-statement%20) and [vselect](#vselect%20) statements
provide powerful sorting options, the sorting functions usually need not
be used.\

### Sorting by tuple order

A natural sort order is often to sort the result tuples of a bag
returned from a query or a function based on the sort order of all
elements in the result tuples.\
\
 Function signatures:\

    sort(Bag b)->Vector
    sort(Bag b, Charstring order)->Vector

<span style="font-weight: bold; ">Notice</span> that the result of
sorting an unordered bag is a [vector](#vector%20).\
\
 For example:\

    Amos 1> sort(1-iota(1,3));
    => {-2,-1,0}
    Amos 2> sort(1-iota(1,3),'dec');
    {0,-1,-2}
    Amos 3> sort(select i, 1-i from Number i where i in iota(1,3));
    {{1,0},{2,-1},{3,-2}}

The default first case is to sort the result in increasing order.\
\
 In the second case a second argument specifies the <span
style="font-style: italic; ">ordering direction</span>, which can be
<span style="font-style: italic; ">'inc'</span> (increasing) or <span
style="font-style: italic; ">'dec'</span> (decreasing). \
\
 The third case illustrates how the result tuples are ordered for
queries returning bags of  tuples. The result tuples are converted into
[vectors](#vector%20).\
\
 <span style="font-weight: bold; ">Notice</span> that the sort order is
not preserved if a sorted vector is converted to a bag as the query
optimizer is free to return elements of bags in any order.\
\
 For example:\
 <span style="font-family: monospace; ">   select x from Number x where
x in -[iota](#iota%20)(1,5) and x in sort(-iota(3,5));</span><span
style="font-family: Times New Roman; ">\
 returns the unsorted bag\
 </span><span style="font-family: monospace; ">  -3</span>\
 <span style="font-family: monospace; ">  -4</span>\
 <span style="font-family: monospace; ">  -5</span><span
style="font-family: Times New Roman; ">\
 even though\
 </span><span style="font-family: monospace; ">sort(-iota(3,5)) -&gt;
{-5,-4,-3}</span><span style="font-family: Times New Roman; ">\
  \
 <span style="font-weight: bold; ">Notice</span> that surrogate object
will be sorted too based on their OID numbers, which usually has no
meaning.\
 </span>

### Sorting bags by ordering directives\

A common case is sorting of result tuples from queries and functions
ordered by <span style="font-style: italic; ">ordering
directives</span>. An ordering directive is a pair of a position number
in a result tuple of a bag to be sorted and an ordering direction.\
\
 Function signatures:

    sortbagby(Bag b, Integer pos, Charstring order) -> Vector
    sortbagby(Bag b, Vector of Integer pos, Vector of Charstring order) -> Vector

For example:\

    Amos 1> sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),1,'dec');
    => {{3,1},{2,0},{1,1}}
    Amos 2> sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),{2,1},{'inc','inc'});
    => {{2,0},{1,1},{3,1}}

In the first case a single tuple ordering directive i specified by two
arguments, one for the tuple position and one for the ordering
direction. The result tuple positions are enumerated 1 and up.\
\
 The second case illustrates how several tuples positions with different
ordering directions can be specified.<span
style="font-family: monospace; ">\
 </span>**\
**

### Sorting bags or vectors with a custom comparison function

This group of sort functions are useful to sort bags or
[vectors](#vector%20) of either objects or tuples with a custom function
supplied by the user. Either the function object or function named can
be supplied. The comparison function must take two arguments with types
compatible with the elements of the bag or the vector and return a
boolean value. Signatures:\

    sortvector(Vector v1, Function compfno) -> Vector
    sortvector(Vector v, Charstring compfn) -> Vector
    sortbag(Bag b, Function compfno) -> Vector
    sortbag(Bag b, Charstring compfn) -> Vector      

**Example:**\

    create function younger(Person p1, Person p2) -> Boolean
    as age(p1) < age(p2);

    /* Sort all persons ordered by their age */
    sortbag((select p from Person p), 'YOUNGER');
