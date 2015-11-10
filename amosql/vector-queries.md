# Vector queries

The order of the objects in the bag returned by a regular [select statement](#select-statement) is __not__ predetermined unless an [order-by](#order-by-clause) clause is specified. However, even if order-by is specified the system will not preserve the order of the result of a select-statement if it is used in other operations.

If it is required to maintain the order of a set of data values the data type *Vector* has to be used. The collection datatype *Vector* represent ordered collections of any kinds of objects; the simplest and most common case of a vector is a numerical vector of numbers. In case the order of a query result is significant you can specify *vector queries* which preserves the order in query result by returning vectors, rather than the bags returned by regular select statements. This is particularly important when working with numerical vectors. A vector query can be one of the following:

1. It can be a [vector construction](#vector-construction) expression that creates a new vector from other objects.
2. It can be a [vector indexing](#vector-index) expression that accesses vector elements by their indexes.
3. It can be a regular [select statement](#select-statement) returning a set of constructed vectors.
4. It can be a [vselect statement](#vselect), which returns an ordered vector rather than an unordered bag as the regular select statement.
5. It can be a call to some [vector function](#vector-function) returning vectors as result.

## Vector construction

The vector constructor `{...}` notation creates a single vector with explicit contents. The following query constructs a vector of three numbers:
```
{1,sqrt(4),3};
```
The returned vector is
```
{1, 2.0, 3}
```
The following query constructs a bag of vectors holding the persons named Bill together with their ages.
```
select {p,age(p)} from Person p where name(p)="Bill";
```

The previous query is different from the query:
```
select p, age(p) from Person p where name(p)="Bill"
```
which returns bag of tuples.

## The vselect statement

The vselect statement provides a powerful way to construct new vectors by queries. It has the same syntax as the select-statement. The difference is that whereas the select-statement returns a bag of objects, the vselect statement returns a vector of objects. For example:
```
vselect i*2
 from Integer i
where i = {1,2,3}
order by i;
```
returns the vector `{2,4,6}`.

The vselect statement has the same syntax as the select statement except for the keyword vselect:
```
vselect-stmt ::=
        'vselect' ['distinct']

[select-clause]

                [into-clause]  
                [from-clause]
                [where-clause]
[group-by-clause]
[order-by-clause]
[limit-clause]
```

Notice that the order-by-clause normally should be present when constructing vectors with the vselect statement in order to exactly specify the order of the elements in the vector. If no order-by-clause is present the order of the elements in the vector is arbitrarily chosen by the system based on the query, which is the order that is the most efficient to produce.

The built-in function `iota()` is very useful when constructing vectors. It has the signature:
```
  iota(Number x, Number y) -> Bag of Integer
```
`iota()` returns the set of all integer `i where l <= i <= u`. For example:
```
iota(2,4)
```
returns the bag:
```
2
3
4
```
For example:
```
vselect i
  from Number i
  where i in iota(-4,5)
  order by i;
```
will return the vector `{-4,-3,-2,-1,0,1,2,3,4,5}`

## Accessing vector elements

Vector elements can be accessed using the vector-indexing notation:
```
vector-indexing ::= simple-expr '[' expr-commalist ']'
```
The first element in a vector has index 0. For example:
```
select a[0]+a[1]
  from Vector a
  where a = {1,2,3};
```
returns `3`.

Index variables as numbers can be used in queries to specify iteration over all possibles index positions of a vector. For example:
```
vselect a[i]
  from Integer i
  where a[i] != 2
    and a = {1,2,3}
  order by i;
```
returns the vector `{1,3}`.

The query should be read as "Make a vector v of all vector elements ai in a where ai != 2 and order the elements in v on i.
The following query multiplies the elements of the vectors bound to the interface variables `:u` and `:v`:
```
vselect :u[i] * :v[i]
  from Integer i
order by i;
```

## Vector functions

There is a library of numerical vector functions for numerical computations and analyses described in the [data mining section](data-mining-primitives.md). The function `project()` constructs a new vector by extracting from the vector v the elements in the positions in pv:
```
project(Vector v, Vector of Number pv) -> Vector r
```
For example:
```
project({10, 20, 30, 40},{0, 3, 2});
```
returns `{10, 40, 30}`

The function `substv()` replaces `x` with `y` in any collection `v`:
```
substv(Object x, Object y, Object v) -> Object r
```

The system function `dim()` computes the size `d` of a vector `v`:
```
dim(Vector v) -> Integer d
```

The function `concat()` concatenates two vectors:
```
concat(Vector x, Vector y) -> Vector r
```
