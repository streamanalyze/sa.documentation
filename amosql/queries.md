# Queries

*Queries* retrieve objects having specified properties from the database. A query can be one of the following:

1. It can be [calls](#function-call)to built-in or user defined function.
2. It can be a [select statement](#select-statement) to search the database for a set of objects having properties fulfilling a query condition specified as a logical [predicate](#predicates).
3. If can be a vector selection statements ([vselect-statement](#vselect)) to construct an ordered sequence (vector) of objects fulfilling the query condition. 
4. It can be an [expression](#expressions).

The syntax for a query is thus:

```
query ::= function-call |
          select-stmt |
          vselect-stmt |
          expression
```

## Calling functions

A simple form of queries are calls to functions. Syntax:
```
function-call ::=

        function-name '(' [parameter-value-commalist] ')' |

 expr infix-operator expr |

 tuple-expr

infix-operator ::= '+' | '-' | '*' | '/' | '<' | '>' | '<=' | '>=' | '=' | '!=' | 'in'



parameter-value ::= expr |

 '(' select-stmt ')' |

 tuple-expr

  tuple-expr ::= '(' expr-commalist ')'

 E.g. sqrt(2.1);

 1+2;

 1+2 < 3+4;

  "a" + 1;
```

The built-in functions `plus()`, `minus()`, `times()`, and `div()` have infix syntax `+,-,*,/` with the usual priorities. For example:
```
(income(:eve) + income(:ham)) * 0.5;
```
is equivalent to:
```
times(plus(income(:eve),income(:ham)),0.5);
```

The `+` operator is defined for both numbers and strings. For strings it implements string concatenation. The result of a function call can be saved temporarily in an interface variable, for example:

```
set :inca = income(:adam);
```
then the query `:inca;` returns `2300`.

Also bag valued function calls can be saved in variables, for example:
```
set :pb = parents(:cain);
```

In this case the value of :pb is a [bag](#bags). To get the elements of the bag, use the `in` function. For example:
```
in(:pb);
```
[Tuple expressions](#tuple-expr) can be used to assign the result of functions returning [tuples](#tuple-result), for example:
```
set (:m,:f)=parents2(:cain);
```
In a function call, the types of the actual parameters must be the same as, or subtypes of, the types of the corresponding formal parameters.

## The select statement

The *select statement* provides the most flexible way to specify queries.

Syntax:
```
select-stmt ::=

        'select' ['distinct']

[select-clause]

                [into-clause]

                [from-clause]

                [where-clause]

[group-by-clause]

[order-by-clause]

[limit-clause]

select-clause ::= expr-commalist

into-clause ::=

        'into' variable-commalist

from-clause ::=

        'from' variable-declaration-commalist

  variable-declaration ::=

        type-spec local-variable

  where-clause ::=

       'where' predicate-expression

  group-by-clause ::=

 'group by' expression-commalist

  order-by-clause ::=

 'order by' expression ['asc' | 'desc']

  limit-clause ::=

 'limit' expression
```
The *select statement* returns an unordered set of objects selected from the database. Duplicates are allowed in the result set of a query, i.e. the result is a [bag](#bags). In case you need to construct an ordered sequence of objects rather than a bag you can use the [vector selection statement](#vselect).

The *select-clause* in a select statement defines the objects to be retrieved based on bindings of local variables declared in the *from-clause* and filtered by the *where-clause*. The select clause is often a comma-separated list of expressions to retrieve a bag of *tuples* of objects from the database. For example:
```sql
select name(p), income(p)
from Person p
where income(p)>2500;
```

The *from-clause* declares data types of local variables used in the query. For example:
```sql
select name(p), income(p)
from Person p
  where age(p)>20;
```

Notice that variables in AmosQL can be bound to *objects of any type*, AmosQL `*.*` This is different from SQL select statements where all variables must be bound to *tuples only*. AmosQL is based on *domain calculus* while SQL select expressions are based on *tuple calculus*.

If a function is applied on the result of a function returning a bag of values, the outer function is applied **on each element** of that bag, the bag is *flattened*. This is called *Daplex semantics*. For example, in the following query, if there are more than one parents per parent generation of Cush there will be several names (e.g. Noah and Ruth) returned:

```sql
     select name(parents(parents(q))) from Person q where name(q)= "Cush";
```
returns the bag:
```
"Noah" "Ruth"
```

The *where-clause* gives selection criteria for the search. The where-clause is specified as a [predicate](#predicate-expressions). For example:
```sql
select name(p), income(p)
from Person p
where age(p)>20;
```

To retrieve the results of [tuple valued functions](#tuple-result) in queries, use [tuple expressions](#tuple-expr), e.g.
```sql
select name(m), name(f) from Person m, Person p where (m,f) = parents2(p);
```

Duplicates are removed from the result only when the keyword `distinct` is specified, in which case a set (rather than a bag) is returned from the selection.

For example, this query returns the set of different names in the database:

`select distinct name(p) from Person p where age(p)>20;`

The optional *group-by-clause* groups and summarizes (aggregates) the result. A select statement with a group-by-class is called a [grouped selection](#grouped-selection). For example:
```sql
 select name(p), sum(income(p))
   from Person p
 where age(p) > 20
 group by name(p);
 ```

The optional *order-by-clause* sorts the result ascending `('asc', default)` or descending `('desc')`. A select statement with an order-by-clause is called an [ordered selection](#ordered-selections). For example:

```sql
select name(p), income(p)
  from Person p
where age(p) > 20
  order by income(p) desc;
```

The optional *limit-clause* limits the number of returned values from the select statement. It is often used together with ordered selections to specify [top-k queries](#top-k-queries). For example:
```sql
select name(p), income(p)
  from Person p
where age(p) > 20
  order by income(p) desc
limit 10;
```

The optional *into-clause* specifies variables to be bound to the result. For example:
```sql
select p into :e from Person p where name(p) = 'Eve';
```

This query retrieves into the environment variable `:eve2` the Person whose name is `Eve`. __NOTICE__ that if the result bag contains more than one object the *into* variable(s) will be bound only to the *first* object in the bag. In the example, if more that one person is named Eve the first one found will be assigned to `:e`.

If you wish to assign the entire result from the select statement in a variable, enclose it in parentheses. The result will be a [bag](#Bags). The elements of the bag can then be extracted with the `in()` function or the infix *in* operator:
```sql
set :r = (select p from Person p where name(p) = 'Eve');
```
Inspect *:r* with one of these equivalent queries:
```
     in(:r); select p from Person p where p in :r;
```
## Predicates

The [where clause](#where-clause) in a select statement specifies a selection filter as a logical predicate over variables. A predicate is an expression returning a boolean including logical [comparison operators](#infix-functions)and functions with boolean results. The boolean operators `and` and `or` can be used to combine boolean values. The general syntax of a predicate expression is:
```
    predicate-expression ::=

            predicate-expression 'and' predicate-expression | 

            predicate-expression 'or' predicate-expression | 

            '(' predicate-expression ')' | 

            expr

        Examples of predicates:


     x < 5

     child(x)


       "a" != s

     home(p) = "Uppsala" and name(p) = "Kalle"

       name(x) = "Carl" and child(x)

       x < 5 or x > 6 and 5 < y

       1+y <= sqrt(5.2)

     parents2(p) = (m,f)

       count(select friends(x) from Person x where child(x)) < 5

      The boolean operator
        and has precedence over
        or. Negation is handled by the quantifier function notany().

    For example:


     a<2 and a>3 or b<3 and b>2

      is equivalent to

      (a<2 and a>3) or (b<3 and b>2)
```

The comparison operators (=, !=, >, <=, and >=) are treated as
binary [predicates](#predicates). You can compare objects of any type.

Predicates are also allowed in the result of a select expression. For
example, the query:
```
select age(:p1) < 20 and home(:p1)="Uppsala";
```
returns `true` if person `:p1` is younger than 20 and lives in Uppsala.

## Grouped selections

When analyzing data it is often necessary to group data, for example to get the sum of the salaries of employees per department. Such regroupings are specified though the `group-by-clause`. It specifies on which expressions in the select clause the data should be grouped and summarized.  A *grouped selection* is a select statement with a [group-by-clause](#group-by-clause) specified. The execution semantics of a grouped selection is different than for regular queries.

For example:
```
select name(d), sum(salary(p))
  from Department d, Person p
where dept(p)=d
group by name(d);
```

Here the *group-by-clause* specifies that the result should be grouped on the name of the departments in the database. After the grouping, for each department `d` the salaries of the persons `p` working at that department should be summed using the [aggregate function](#aggregate-functions) `sum()`.

An element of a [select-clause](#select-clause) of a grouped selection must be one of:

1. An element in the *group key* specified by the group-by-clause, which is `name(d)` in the example. The result is grouped on each group key. In the example the grouping is made over each department name so the group key is specified as `name(d)`.
2. A call to an [aggregate function](#aggregate-functions), which is `sum()` in the example. The aggregate function is applied for the set of bindings specified by the group key. In the example the aggregate function `sum()` is applied on the set of values of `salary(p)` for the persons `p` working in department `d`, i.e. where `dept(p)=d`.

In general aggregate functions such as `sum()`, `avg()`, `stdev()`, `min()`, `max()`, `count()` are applied on collections (bags) of values, rather than single objects.

Contrast the above query to the regular (non-grouped) query:

```sql
select name(d), sum(salary(p))
  from Department d, Person p
where dept(p)=d;
```

Without the grouping the aggregate function `sum()` is applied on the salary of each person `p`, rather than the collection of salaries corresponding to the group key `name(p)` in the grouped selection.

The group key need not be part of the result. For example the following query returns the sum of the salaries for all departments without revealing the department names:
```
select sum(salary(p))
  from Department d, Person p
  where dept(p)=d   
  group by name(d);
```

## Ordered selections

The [order-by-clause](#order-by-clause) specifies that the result should be (partially) sorted by the specified *sort key*. The sort order is descending when *desc* is specified and ascending otherwise.

For example, the following query sorts the result descending based on the sort key `salary(p)`:

```sql
select name(p), salary(p)
 from Person p
order by name(p) desc;
```
The sort key does not need to be part of the result.

For example, the following query list the salaries of persons in descending order without associating any names with the salaries:
```sql
select salary(p)
from Person p
order by name(p) desc;
```

## Top-k queries

A *top-k query* is a query returning the first few tuples in a larger set of tuples based on some ranking. The order-by-clause](#order-by-clause) and [limit-clause](#limit-clause) can be combined to specify top-k queries. For example, the following query returns the names and salaries of the 10 highest income earners:
```sql
select name(p), salary(p)
from Person p
order by name(p) desc
limit 10;
```

The limit can be any numerical expression.For example, the following query retrieves the `:k+3` lowest income earners, where `:k` is a variable bound to a numeric value:
```sql
select name(p), salary(p)
from Person p
order by name(p)
limit :k+3;
```

## Aggregation over subqueries

[Aggregate functions](#aggregate-functions) can be used in two ways:

1. They can be used in [grouped selections](#grouped-selection).
2. They can be applied on *subqueries*.

In the second case, the subqueries are specified as nested select expressions returning [bags](#bags), for example:

```
avg(select income(p) from Person p);
```
Consider the query:
```
select name(friends(p))
  from Person p
where name(p)= "Bill";
```

The function `friends()` returns a bag of persons, on which the function `name()` is applied. The normal semantics in sa.amos is that when a function (e.g. `name()`) is applied on a bag valued function (e.g. `friends()`) it will be *applied on each element* of the returned bag. In the example a bag of the names of the persons named Bill is returned. This is called [Daplex semantics](#daplex-semantics).

Aggregate functions work differently. They are applied on the entire bag. For example:
```
count(friends(:p));
```
In this case `count()` is applied on the subquery of all friends of `:p`. The system uses a rule that arguments are converted (coerced) into a subquery when an argument of the calling function(e.g. `count`) is declared *Bag of*.

Local variables in queries may be declared as bags, which means that the variable is bound to a subquery that can be used as arguments to aggregate functions. For example:

```
select sum(b), avg(b), stdev(b)
from Bag of Integer b
where b = (select income(p)
from Person p);
```

Elements in subqueries can be accessed with the *in* operator. For example:
```
select name(p), count(b)
  from Bag of Integer b, Person p
  where b = (select p from Person p)
  and p in b;
```

The query returns the names of all persons paired with the number of persons in the database. Variables may be assigned to bags by assigning values of functions returning bags, for example:

```
set :f = friends(:p);
count(:f);
```

Bags are not explicitly stored in the database, but are generated when needed, for example when they are used in aggregate functions or *in*. For example:
```
set :bigbag = iota(1,10000000);
```
assigns *:bigbag* to a bag of 10^7^ numbers. The bag is not explicitly created though. Instead its elements are generated when needed, for example when executing:
```
count(:bigbag);
```

To compare that two bags are equal use:
```
bequal(Bag x, Bag y) -> Boolean
```

**Notice** that *bequal()* materializes its arguments before doing the equality computation, which may occupy a lot of temporary space in the database image if the bags are large.

See [Aggregate functions](#aggregate-functions) for a details on aggregate functions.

## Quantifiers

The function `some()` implements logical exist over a subquery:
```
some(Bag sq) -> Boolean
```
for example
```
select name(p)
from Person p
 where some(parents(p));
```

The function `notany()` tests if a subquery sq returns empty result, i.e. negation
```
notany(Bag sq) -> Boolean
```
For example:
```
select name(p)
from Person p
where notany(select parents(p) where age(p)>65);
```
