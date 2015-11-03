## System functions and commands


### Comparison operators

The built-in, infix comparison operators are: 

    =(Object x, Object y) -> Boolean   (infix operator =)

    !=(Object x, Object y) -> Boolean  (infix operator !=) 

    >(Object x, Object y) -> Boolean   (infix operator >) 

    >=(Object x,Object y) -> Boolean   (infix operator >=)

    <(Object x, Object y) -> Boolean   (infix operator <) 

    <=(Object x,Object y) -> Boolean   (infix operator <=)

All objects can be compared. Strings are compared by characters, lists
by elements, OIDs by identifier numbers. Equality between a bag and
another object denotes set membership of that object. The comparison
functions can be [overloaded](#overloaded-functions) for user defined
types. 


## Arithmetic functions

```
    abs(Number x) -> Number y
    div(Number x, Number y)   -> Number z Infix operator /
    max(Object x, Object y)   -> Object z
    minus(Number x, Number y) -> Number z Infix operator - 
    mod(Number x, Number y) -> Number z
    plus(Number x, Number y)  -> Number z Infix operator +
    times(Number x, Number y) -> Number z Infix operator * 
    power(Number x, Number y) -> Number z Infix operator ^
    iota(Integer l, Integer u)-> Bag of Integer z
    sqrt(Number x) -> Number z
    integer(Number x) -> Integer i Round
            x to nearest integer
    real(Number x) -> Real r Convert x to real number
    roundto(Number x, Integer d) -> Number Round
            x to
            d decimals
    log10(Number x) -> Real y
```



*iota()* constructs a bag of integers between `l`and `u`. For example, to execute n times the AmosQL statement `print(1)`do: 

```sql
for each Integer i where i in iota(1,n) 
         print(1);
```

### String functions

String concatenation is made using the `+` operator, e.g.
`"ab" + "cd" + "ef";` returns `"abcdef"          
"ab"+12+"de";` returns `"ab12de"
1+2+"ab";` is illegal since the first argument of '+' must be a string.
`"ab"+1+2;` returns `"ab12"` since `+` is left associative.

`char_length(Charstring)->Integer`

 Count the number of characters in string.

`like(Charstring string, Charstring pattern) -> Boolean`

Test if string matches regular expression pattern where '\*' matches
sequence of characters and '?' matches single character. For example:
 `like("abc","??c")` returns TRUE
 `like("ac","a*c")` returns TRUE
 `like("ac","a?c")` fails
 `like("abc","a[bd][dc]");` returns TRUE
 `like("abc","a[bd][de]");` fails

 `like_i(Charstring string, Charstring pattern) -> Boolean`\
 Case insensitive *like()*
`.                       locate(Charstring substr, Charstring str) -> Integer`

The position of the first occurrence of substring *substr* in string *str.*

`lower(Charstring str)->Charstring`
 Lowercase string.
 </span>\
 `ltrim(` `Charstring chars, Charstring str) -> Charstring     `\
 Remove characters in *chars* from beginning of *str*.\
\
 <span style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;"> <span style="font-family:
          monospace;">not\_empty(Charstring s) -&gt; Boolean</span>\
 Returns true if string <span style="font-style: italic;">s</span>
contains only whitespace characters (space, tab, or new line).\
 </span>\

`replace(Charstring str, Charstring from_str, Charstring to_str) -> Charstring`\
 Returns the string *str* with all occurrences of the string *from\_str*
replaced by the string *to\_str*. *replace()* is case sensitive.\
\
 `rtrim(Charstring chars, Charstring str) -> Charstring`\
 </span> <span style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;">Remove characters in *chars* from
end of *str*.\
 </span> </span> <span style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;"> <span style="font-family:
          Times New Roman;">\
 <span style="font-family: monospace;">stringify(Object
x)-&gt;Charstring s</span>\
 Convert any object <span style="font-style: italic;">x</span> into a
string.\
 </span>\

`substring(Charstring string,Integer start, Integer end)->Charstring         `\
 Extract substring from given character positions. First character has
position 0.\
\
 `trim(Charstring chars, Charstring str) -> Charstring`\
 </span> Remove characters in *chars* from beginning and end of *str*.\
\
 <span style="font-family: monospace;">unstringify(Charstring s) -&gt;
Object x</span>\
 Convert string s to object <span style="font-style: italic;">x</span>.
Inverse of <span style="font-style: italic;">stringify()</span>.\
\
 `upper(Charstring s)->Charstring`\
 Uppercase string <span style="font-style: italic;">s</span>.\
\
 </span>

7.4 Aggregate functions
-----------------------

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

### <span style="font-family: Times New Roman; "></span>

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

<span style="font-family: Times New Roman; "></span>7.5 Temporal functions
--------------------------------------------------------------------------

Amos II supports three data types for referencing *Time, Timeval,* and
*Date*.\
 Type *Timeval*  is for specifying absolute time points including year,
month, and time-of-day.\
\
 The type *Date* specifies just year and date, and type *Time* specifies
time of day. A limitation is that the internal operating system
representation is used for representing *Timeval* values, which means
that one cannot specify value too far in the past or future.\
\
 Constants of type *Timeval* are written as
|*year-month-day*/*hour:minute*:*second*|, e.g. |1995-11-15/12:51:32|.\
 Constants of type *Time* are written as |*hour*:*minute*:*second*|,
e.g. |12:51:32|.\
 Constants of type *Date* are written as |*year*-*month*-*day*|, e.g.
|1995-11-15|.\
\
 The following functions exist for types *Timeval, Time,* and *Date*:\
\
 `now() -> Timeval`\
 The current absolute time.\
\
 `time() -> Time     `The current time-of-day.\
\
 <span style="font-family: monospace; ">clock() -&gt; Real</span>\
 The number of seconds since the system was started.\
\
 `date() -> Date`\
 The current year and date.\
\

`timeval(Integer year,Integer month,Integer day,               Integer hour,Integer minute,Integer       second) -> Timeval`\
 Construct *Timeval.*\
\
 `time(Integer hour,Integer minute,Integer second) -> Time`\
 Construct *Time.*\
\
 `date(Integer year,Integer month,Integer day) -> Date`\
 Construct *Date.*\
\
 `time(Timeval) -> Time`\
 Extract *Time* from *Timeval.*\
\
 `date(Timeval) -> Date`\
 Extract *Date* from *Timeval.*\
\
 `date_time_to_timeval(Date, Time) -> Timeval`\
 Combine *Date* and *Time* to *Timeval.*\
\
 `year(Timeval) -> Integer`\
 Extract year from *Timeval.*\
\
 `month(Timeval) -> Integer`\
 Extract month from *Timeval.*\
\
 `day(Timeval) -> Integer`\
 Extract day from *Timeval.*\
\
 `hour(Timeval) -> Integer`\
 Extract hour from *Timeval.*\
\
 `minute(Timeval) -> Integer`\
 Extract minute from *Timeval.*\
\
 `second(Timeval) -> Integer`\
 Extract second from *Timeval.*\
\
 `year(Date) -> Integer`\
 Extract year from *Date.*\
\
 `month(Date) -> Integer`\
 Extract month from *Date.*\
\
 `day(Date) -> Integer`\
 Extract day from *Date.*\
\
 `hour(Time) -> Integer`\
 Extract hour from *Time.*\
\
 `minute(Time) -> Integer`\
 Extract minute from *Time.*\
\
 `second(Time) -> Integer`\
 Extract second from *Time.*\
\
 `timespan(Timeval, Timeval) -> (Time, Integer usec)     `Compute
difference in *Time* and microseconds between two time values\
\

7.6 Sorting functions
---------------------

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

7.7 Accessing system meta-data
------------------------------

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

### 7.7.1 Type meta-data\

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

<span style="font-family: Times New Roman; "></span><span
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

7.8 Searching source code
-------------------------

The source codes of all functions except some basic system functions are
stored in the database. You can retrieve the source code for a
particular function, search for functions whose names contain some
string, or make searches based on the source code itself. Some system
functions are available to do this.\
\
 <span style="font-family: monospace; ">apropos(Charstring str) -&gt;
Bag of Function</span>\
 returns all functions in the system whose names contains the string
<span style="font-style: italic; ">str</span>. Only the
[generic](#overloaded-functions%20) name of the function is used in the
search. The string is not case sensitive. For example:\
 <span style="font-family: monospace; ">     apropos("qrt ");</span>\
 returns all functions whose generic name contains 'qrt'.\
\
 `doc(Charstring str) -> Bag of Charstring`\
 returns the available documentations of all functions in the system
whose names contain the (non case sensitive) string *str*. For example:\
 `doc("qrt ");`\

<span style="font-family: monospace; ">sourcecode(Function f) -&gt; Bag
of Charstring\
 sourcecode(Charstring fname) -&gt; Bag of Charstring\
 </span>returns the sourcecode of a function *f*, if available. For
[generic](#overloaded-functions%20) functions the sources of all
resolvents are returned. For example:\
 `sourcecode("sqrt ");`\

To find all functions whose definitions contain the string 'tclose'
use:\
 <span style="font-family: monospace; ">     select sc\
      from Function f, Charstring sc\
      where like\_i(sc,"\*tclose\* ") and source\_text(f)=sc;\
 </span>

`usedwhere(Function f) -> Bag of Function c`\
 returns the functions calling the function `f`.

`useswhich(Function f) -> Bag of Function c`\
 returns the functions called from the function `f`.

<span style="font-family: monospace; ">userfunctions() -&gt; Bag of
Function</span>\
 returns all user defined functions in the database.\

<span style="font-family: monospace; ">usertypes() -&gt; Bag of
Type</span><span style="font-family: monospace; "></span>\
 returns all user defined types in the database.\

`allfunctions(Type t)-> Bag of Function`\
 returns all functions where one of the arguments are of type <span
style="font-style: italic; ">t</span>.\

7.9 Extents
-----------

<span style="font-family: Times New Roman; "></span><span
style="font-family: Times New Roman; ">The local Amos II database can be
regarded as a set of *extents*. There are two kinds of extents: </span>

-   *Type extents* represent surrogate objects belonging to a
    particular type.

    -   The *deep extent* of a type is defined as the set of all
        surrogate objects belonging to that type and to all its
        descendants in the type hierarchy. The deep extent of a type is
        retrieved with:

            extent(Type t)->Bag of Object

        For example, to count how many functions are defined in the
        database call:\

               count(extent(typenamed("function ")));

        To get all surrogate objects in the database call:\
         <span style="font-family: monospace; ">  
        extent(typenamed("object "))</span>\
        \
         The function <span
        style="font-family: monospace; ">allobjects();</span> does the
        same.\

    -   The *shallow extent* of a type is defined as all surrogate
        objects belonging only to that type but <span
        style="font-style: italic; ">not</span> to any of
        its descendants. The shallow extent is retrieved with:

            shallow_extent(Type t) -> Bag of Object

        For example:

               shallow_extent(typenamed("object "));

        returns nothing since type `Object` has no own instances.

-   *Function extents* represent the state of stored functions. The
    extent of a function is the bag of tuples mapping its argument(s) to
    the corresponding result(s). The function *extent()* returns the
    extent of the function `fn`. The extent tuples are returned as a bag
    of [vectors](#vector%20). The function can be any kind of function.\
    \

        extent(Function fn) -> Bag of Vector

    For example, 

           extent(#'coercers');

    For stored functions the extent is directly stored in the
    local database. The example query thus returns the state of all
    stored functions. The state of the local database is this state plus
    the deep extent of type `Object`.

    The extent is always defined for stored functions and can also be
    computed for derived functions through their function definitions.
    The extent of a derived function may not be computable, *unsafe*, in
    which case the extent function returns nothing.

    The extent of a foreign function is always empty.

    The extent of a [generic](#overloaded-functions%20) function is the
    union of the extents of its resolvents.

<span style="font-family: Times New Roman; "> </span>7.10 Query optimizer tuning<span style="font-family: Times New Roman; "> </span>
-------------------------------------------------------------------------------------------------------------------------------------

<span style="font-family: Times New Roman; "> </span>

    optmethod(Charstring new) -> Charstring old
    sets the optimization method used for cost-based optimization in Amos II to the method named new.
    Three optimization modes for AmosQL queries can be chosen:
    "ranksort ": (default) is fast but not always optimal. 
    "exhaustive ": is optimal but it may slow down the optimizer considerably.
    "randomopt ": is a combination of two random optimization heuristics:
    Iterative improvement and sequence heuristics [Nas93].        

`optmethod `returns the old setting of the optimization method.\
\
 Random optimization can be tuned by using the function: 

    optlevel(Integer i,Integer j);

where *i* and *j* are integers specifying number of iterations in
iterative improvement and sequence heuristics, respectively. Default
settings is *i=5* and *j=5*. 

    reoptimize(Function f) -> Boolean
    reoptimize(Charstring fn) -> Boolean
    reoptimizes function named fn.

7.11 Indexing
-------------

The system supports indexing on any single argument or result of a
stored function. Indexes can be *unique* or *non-unique*. A unique index
disallows storing different values for the indexed argument or result.
The cardinality constraint *key* of stored functions ([Cardinality
Constraints](#cardinality-constraints%20)) is implemented as unique
indexes. By default the system puts a unique index on the first argument
of stored functions. That index can be made non-unique by suffixing the
first argument declaration with the keyword *nonkey* or specifying *Bag
of* for the result, in which case a non-unique index is used instead.

For example, in the following function there can be only one name per
person:

          create function name(Person)->Charstring as stored;

By contrast, *names()* allow more than one name per person: 

          create function names(Person p)->Bag of Charstring nm as stored;

Any other argument or result declaration can be suffixed with the
keyword *key* to indicate the position of a unique index. For example,
the following definition puts a unique index on *nm* to prohibit two
persons to have the same name:

          create function name(Person p)->Charstring nm key as stored;

Indexes can also be explicitly created on any argument or result with a
procedural system function *create\_index()*:

          create_index(Charstring fn, Charstring arg, Charstring index_type,
                       Charstring uniqueness)

For example:

          create_index("person.name->charstring ", "nm ", "hash ", "unique ");
          create_index("names ", "charstring ", "mbtree ", "multiple ");

The parameters of *create\_index()* are:

*fn*: The name of a stored function. Use the resolvent name for
[overloaded](#overloaded-functions%20) functions.

*arg*: The name of the argument/result parameter to be indexed. When
unambiguous, the names of types of arguments/results can also be used
here.

*index\_type*: The kind of index to put on the argument/result. The
supported index types are currently hash indexes (type *hash*), ordered
main-memory B-tree indexes (type *mbtree*), and X-tree spatial indexes
(type *xtree*<span style="font-family: Times New Roman; "></span>). The
default index for key/nonkey declarations is *hash*.

*uniqueness*: Index uniqueness indicated by <span
style="font-style: italic; ">unique</span> for unique indexes and <span
style="font-style: italic; ">multiple</span> for non-unique indexes.\

Descriptors of all indexes for a resolvent *f* can be retrieved by:\
 `indexes(Function f) -> Bag of Vector`\
 *indexes()* will return vectors containing *create\_index()* parameters
for all indexes on function *f*.\

Indexes are deleted by the procedural system function:

          drop_index(Charstring functioname, Charstring argname);

The meaning of the parameters are as for function *create\_index()*.
There must always be at least one index left on each stored function and
therefore the system will never delete the last remaining index on a
stored function.

To save space it is possible to delete the default index on the first
argument of a stored function. For example, the following stored
function maps parts to unique identifiers through a unique hash index on
the identifier:

          create type Part; 
          create function partid(Part p)->Integer id as stored;

*partid()* will have two indexes, one on *p* and one on *id*. To drop
the index on *p* do the following:

          drop_index('partid', 'p');

7.12 Clustering
---------------

Functions can be *clustered* by creating multiple result stored
functions, and then each individual function can be defined as a derived
function. 

For example, to cluster the properties name and address of persons one
can define:  

    create function personprops(Person p) -> 
            (Charstring name,Charstring address) as stored; 
    create function name(Person p) -> Charstring nm 
      as select nm
           from Charstring a 
          where personprops(p) = (nm,a); 
    create function address(Person p) -> Charstring a 
      as select a
           from Charstring nm 
          where personprops(p) = (nm,a);

Clustering does not improve the execution time performance
significantly. However, clustering can decrease the database size
considerably. \

7.13 Unloading
--------------

<span style="font-family: Times New Roman; "> The data stored in the
local database can be unloaded to a text file as an *unload script* of
AmosQL statements generated by the system. The state of the database can
be restored by loading the unload script as any other AmosQL file.
Unloading is useful for backups and for transporting data between
different systems such as different Amos II versions or Amos II systems
running on different computers. The unload script can be edited in case
the schema has changed. </span>

`unload(Charstring filename)->Boolean`\
 generates an AmosQL script that restores the current local database
state if loaded into an Amos II peer with the same schema as the current
one.

`excluded_fns()->Bag of Function`\
 set of functions that should not be unloaded. Can be updated by user.\
\

7.14 Miscellaneous<span style="font-family: Times New Roman; "> </span>
-----------------------------------------------------------------------

<span style="font-family: Times New Roman; "></span> <span
style="font-family: Times New Roman; "> </span><span
style="font-family: Times New Roman; ">`apply(Function fn,         Vector args) -> Bag of Vector r`\
 calls the AmosQL function *fn*<span
style="font-family: monospace; "><span
style="font-family: Times New Roman; "> </span></span></span><span
style="font-family: Times New Roman; ">with elements in vector
*args*</span><span style="font-family: Times New Roman; "><span
style="font-family: monospace; "></span></span><span
style="font-family: Times New Roman; "> as arguments and returns the
result tuples as vectors *r*.\
\
 </span><span
style="font-family: Times New Roman; ">`evalv(Charstring stmt)             -> Bag of Vector r`\
 evaluates the AmosQL statement  *stmt*` `</span><span
style="font-family: Times New Roman; ">and returns the result tuples as
vectors *r*.</span><span
style="font-family: Times New Roman; "></span><span
style="font-family: Times New Roman; "></span>\
 <span style="font-family: Times New Roman; "> </span>

` error(Charstring msg) -> Boolean`\
 prints an error message on the terminal and raises an exception.
Transaction aborted.\

<span style="font-family: Times New Roman; "> </span>

`print(Object x) -> Boolean       ` prints `x`. Always returns `true`.
The printing is by default to the standard output (console) of the Amos
II server where *print()* ** is executed but can be redirected to a file
by the function `openwritefile`:

`openwritefile(Charstring filename)->Boolean`\
 *openwritefile()* changes the output stream for *print() * to the
specified filename. The file is closed and output directed to standard
output by calling *closewritefile()*.\
 `         filedate(Charstring file) -> Date`\
 returns the time for modification or creation of  a file<span
style="font-family: monospace; "></span>.\
\
 `amos_version() -> Charstring`\
 returns string identifying the current version of Amos II.

`quit;`\
 quits Amos II. If the system is registered as a peer it will be removed
from the name server.\

`exit;`\
 returns to the program that called Amos II if the system is embedded in
some other system.

    goovi();

starts the multi-database browser GOOVI[\[CR01\]](#CR01%20). This works
only under JavaAmos.\
 <span style="font-family: Times New Roman; "> </span>

The *redirect* statement reads AmosQL statements from a file: 

    redirect-stmt ::= '<' string-constant

For example 

    < 'person.amosql';

<span style="font-family: monospace; ">load\_amosql(Charstring
filename)-&gt;Charstring</span>\
 loads a file containing AmosQL statements as the redirect statement.\
\
 <span style="font-family: monospace; ">loadSystem(Charstring dir,
Charstring filename)-&gt;Charstring</span>\
 loads a master file, *filename*<span
style="font-family: monospace; ">,</span> containing an AmosQL script
defining a subsystem. The current directory is temporarily set to
*dir*<span style="font-family: monospace; "></span> while loading. The
file is not loaded if it was previously loaded into the database. To see
what master files are currently loaded, call *loadedSystems()*.\
\
\
 <span style="font-family: monospace; ">getenv(Charstring
var)-&gt;Charstring value</span>\
 retrieves the value of OS environment variable *var*<span
style="font-family: monospace; "></span>. Generates an error of variable
not set.\
\
 The *trace()* and *untrace()*` `functions are used for tracing foreign
function calls:\
\
    
`trace(Function fno)->Bag of Function r           trace(Charstring fn)->Bag of Function r           untrace(Function fno)->Bag of Function r           untrace(Charstring fn)->Bag of Function r`\
\
 If an [overloaded](#overloaded-functions%20) functions is (un)traced it
means that all its resolvents are (un)traced. Results are the foreign
functions (un)traced. For example:\
\

`Amos 2> trace("iota ");         #[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]         Amos 2> iota(1,3);         >>#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 *)         <<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 1)         1         <<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 2)         2         <<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 3)         3         Amos 2>                ``dp(Object x, Number priority)-> Boolean`\
 For debug printing in where clauses. Prints *x* on the console. Always
returns *true*. The placement of *dp* ** in the execution plan is
regulated with *priority* which must be positive numeric constant. The
higher priority the earlier in the execution plan.\
