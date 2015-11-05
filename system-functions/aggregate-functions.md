# Aggregate functions

*Aggregate functions* are functions with one argument declared as a bag
and that return a single result:

       aggfn(Bag of
            Type1 x) -> Type2

The following are examples of predefined [aggregate
functions](#aggregate-functions):

       sum(Bag of Number x) -> Number 

       count(Bag of Object x) -> Integer

       avg(Bag of Number x) -> Real

       stdev(Bag of Number x) -> Real

       max(Bag of Object x) -> Object

       min(Bag of Object x) -> Object




Aggregate functions can be used in [subqueries or
bags](#grouped-selection%3Egrouped%20selections%3C/a%3E%20or%20applied%20on%20%3Ca%0A%20%20%20%20%20%20href=).\
\
 The overloaded function *in()* implement the infix operator 'in'. It
extracts each element from a collection:

    in(Bag of Object b) -> Bag
    in(Vector v) -> Bag

For example:

    in({1,2,2}); =>
    1
    2
    2

\
 Number of objects in a bag: 

    count(Bag of Object b) -> Integer

For example:

    count(iota(1,100000)); =>
    100000

\
 Sum elements in bags of numbers:

    sum(Bag of Number b) -> Number 

For example:

    sum(iota(1,100000)); =>
    705082704

\
 Average value in a bag of numbers:\

    avg(Bag of Number b) -> Real

For example:

    avg(iota(1,100000)); =>
    50000.5

\
 Standard deviation of values in a bag of numbers:\

    stdev(Bag of Number b) -> Real

For example:

    stdev(iota(1,100000)); =>
    28867.6577966877

\
 Largest object in a bag: 

    max(Bag of TP b) -> TP r
    maxagg(Bag of Tp b) -> TP r

The type of the result is the same as the type of elements of argument
bag. For example:

    max(bag(3,4,2))+2; =>
    6

*maxagg()* is an alias for *max()*.\
\
\
 Smallest number in a bag: 

    min(Bag of TP b) -> TP r
    minagg(Bag of Tp b) -> TP r

The type of the result is the same as the type of elements of argument
bag. For example:

    minagg(bag(3,4,2))+2; =>
    4

*minagg()* is an alias for *min()*:\
\
 <span style="font-family: Times New Roman; "><span
style="font-family: Times New Roman; ">The aggregate function
*concatagg()* makes a string of the elements in a bag
`b`{style="font-style: italic; "}: </span></span>

    concatagg(Bag of Object b)-> Charstring s

For example:

    concatagg(bag("ab ",2,"cd ")); =>
    "ab2cd "

    concatagg(inject(bag("ab ",2,"cd "),", ")); =>
    "ab,2,cd "

### <span style="font-family: Times New Roman; ">7.4.1 Generalized aggregate functions</span>

###

<span style="font-family: Times New Roman; ">Normal aggregate functions
return only single values. In Amos they may return collections as well,
which is called *generalized aggregate functions*.\
\
 The generalized aggregate function *unique()* removes duplicates from a
bag *b*. It implements the keyword *distinct* in select statements.
</span>

    unique(Bag of TP b) -> Bag of TP r

The type of the result bag is the same as the type of elements of
argument bag. For example:

    unique(bag(1,2,1,4)); =>
    1
    2
    4

The generalized aggregate function *exclusive()* extract non-duplicated
elements from a bag *b*: 

    exclusive(Bag of TP b) -> Bag of TP r

The type of the result bag is the same as the type of elements of
argument bag. For example:

    exclusive(bag(1,2,1,4)); =>
    2
    4

The generalized aggregate function *inject()* inserts *x* between
elements in a bag *b*:

    inject(Bag of Object b, Object x) -> Bag of Object r

For example:

    inject(bag(1,2,3),0); =>
    1
    0
    2
    0
    3

The generalized aggregate functions *topk()* and *leastk()* return the
*k* highest and lowest elements in a bag of key-value pairs *p*:<span
style="font-family: Times New Roman; "></span>

`  topk(Bag b, Number k) -> Bag of (Object rk,         Object value)           leastk(Bag b, Number k) -> Bag of (Object rk, Object         value)        `\
 If the tuples in *b* have only one attribute (the <span
style="font-style: italic; ">rk</span> attribute) the *value* will be
*nil*. The [limit clause](#limit-clause%20) of select statements provide
a more general way to do this, do these functions are normally not
used.\
\
 For example,\
   `topk(iota(1, 100), 3);`\
 returns

`(98,NIL)``     ``(99,NIL)``     ``(100,NIL) `\
 whereas\

`topk((select i, v[i-1]``     ``      from Integer i, Vector v``     ``     where i in ``iota``(1, 5)``     ``       and v={" ", " ", " ",       "fourth ", "fifth "}), 3);``     `` `returns\
 `(3," ")``     ``(4,"fourth ")``     ``(5,"fifth ") ``     `\
 For example,\
 `leastk(iota(1, 100), 3);`\
 returns\
 `(3,NIL)``     ``(2,NIL)``     ``(1,NIL)     `
