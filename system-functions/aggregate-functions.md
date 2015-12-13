# Aggregate functions

[Aggregate functions](../amosql/queries.md#aggregate-function) compute
a single result from the elements in a bag. 

[Generalized aggregate functions](#generalized-aggregate-function) return new bags and collections for given argument bags. They can also have more that one bag argument.

Basic aggregate functions have
one of its arguments declared as a bag and return a single result:
```
    aggfn(Bag of Type1 x) -> Type2
```

Aggregate functions can be used in [group by queries](../amosql/queries.md#group-by).

The following basic aggregate function are predefined:
```
   avg(Bag of Number b) -> Real               average of elements
   concatagg(Bag of Object b) -> Charstring   concatenate elements
   count(Bag of Object b) -> Integer          count number of elements
   max(Bag of TP b) -> TP                     largest element
   maxagg(Bag of TP b) -> TP                  same as max(b)
   min(Bag of TP b) -> TP                     smallest element
   minagg(Bag of TP b) -> TP                  same as min(b)
   stdev(Bag of Number b) -> Real             standard deviation of elements
   sum(Bag of Number b) -> Number             sum of elements
```

###Descriptions:

__Compute the average of the elements in a bag:__
```
  avg(Bag of Number b) -> Real
```
For example `avg(iota(1,100000));` returns `50000.5`.

__String concatenate the elements in a bag:__
```
  concatagg(Bag b)-> Charstring s
```
For example:
`concatagg(bag("ab ",2,"cd "));` returns the string `"ab2cd "`.

__Count the number of elements in a bag:__
```
   count(Bag of Object b) -> Integer
```
For example `count(iota(1,100000));` returns `100000`.

__Compute the largest element in a bag:__
```
   max(Bag of TP b) -> TP r
   maxagg(Bag of Tp b) -> TP r 
```
The type of the result is the same as the type of elements of argument bag. `maxagg()` is an alias for `max()`.
For example `max(bag(3,4,2))+2;` returns `6`.

__Compute the smallest element in a bag:__  
```
   min(Bag of TP b) -> TP r
   minagg(Bag of Tp b) -> TP r
```
The type of the result is the
same as the type of elements of argument bag.  `minagg()` is an alias
for `min()`. For example `minagg(bag(3,4,2))+2;` returns `4`.

__Compute the standard deviation of the elements in a bag:__
```
   stdev(Bag of Number b) -> Real
```
For example `stdev(iota(1,100000));` returns `28867.6577966877`.

__Sum the elements in a bag:__
```
   sum(Bag of Number b) -> Number
```
For example `sum(iota(1,100000));` returns `705082704`.

## <a name="generalized-aggregate-function"> Generalized aggregate functions

Normal aggregate functions return only single values. In sa.amos they
may return collections as well, which is called *generalized aggregate
functions*. Generalized aggregate functions can furthermofe have more that one bag arguments.

The following generalized aggregate functions are predefined:
```
   bequal(Bag b1, Bag b2) -> Boolean                           Test equality of bags
   exclusive(Bag of TP b) -> Bag of TP r                       Non-duplicated elements
   inject(Bag b, Object x) -> Bag of Object r                  Insert x between elements
   unique(Bag of TP b) -> Bag of TP r                          Remove duplicates
   tuples(Bag of Object b) -> Bag of Vector                    Return elements as vectors
```

###Descriptions:

__Test that two bags are equal:__
```
bequal(Bag x, Bag y) -> Boolean
```

Example:

`bequal(bag(1,2,3),bag(3,2,1));` returns `TRUE`;

**Notice** that *bequal()* materializes its arguments before doing the
equality computation, which may occupy a lot of temporary space in the
database image if the bags are large.

__Extract non-duplicated elements from a bag:__
```
   exclusive(Bag of TP b) -> Bag of TP r
```
The type of the result bag is the same as the type of elements of `b`. 
For example `exclusive(bag(1,2,1,4));` returns the bag:
```
   2
   4
```

__Remove duplicates from a bag:__
```
   unique(Bag of TP b) -> Bag of TP r
```
The type of the result bag is the same as the type of elements of argument bag.
`unique()` implements the keyword `distinct` in select statements.
For example `unique(bag(1,2,1,4));` returns the bag:
```
   1
   2
   4
```

__Insert object between elements in a bag:__
```
   inject(Bag b, Object x) -> Bag of Object r
```
For example `inject(bag(1,2,3),0);` returns the bag
```
   1
   0
   2
   0
   3
```
The query
`concatagg(inject(bag("ab",2,"cd"),", "));` returns the string `"ab,2,cd"`.

__Convert the tuples in a bag to vectors:__
```
   tuples(Bag b) -> Bag of Vector
```


