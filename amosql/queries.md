# Queries

*Queries* retrieve objects having specified properties from the
database. A query can be one of the following:

1. It can be [calls](#function-calls) to a built-in or user defined
function.

2. It can be a [select statement](#select-statement) to search the
database for a set of objects having properties fulfilling a query
condition specified as a logical [predicate](#predicate-expression).

3. It can be a [vector selection statements](vector-queries.md) to construct an ordered sequence (vector) of objects fulfilling the query condition.

4. It can be a general [expression](basic-constructs.md#general-expression).

Syntax:
```
query ::= function-call |
          select-stmt |
          vselect-stmt |
          expression
```

## <a name="function-calls"> Function calls

A simple form of queries are calls to functions. 

Syntax:
```
function-call ::=
      function-name '(' [parameter-value-commalist] ')' |
      expr infix-operator expr |
      tuple-expr

infix-operator ::=
      '+' | '-' | '*' | '/' | '<' | '>' | '<=' | '>=' | '=' | '!=' | 'in'

parameter-value ::= 
      expr |
      '(' select-stmt ')' |
      tuple-expr

tuple-expr ::= '(' expr-commalist ')'
```

Examples:
```
   sqrt(2.1);
   1+2;
   1+2 < 3+4;
   "a" + 1;
```

The built-in functions `plus()`, `minus()`, `times()`, and
`div()` have infix syntax `+,-,*,/` with the usual priorities.

Example:
```
   (income(:eve) + income(:ham)) * 0.5;
```
is equivalent to:
```
   times(plus(income(:eve),income(:ham)),0.5);
```

The `+` operator is defined for both numbers and strings. For strings
it implements string concatenation. The result of a function call can
be saved temporarily in an interface variable.

Example:
```
   set :inca = income(:adam);
```
then the query `:inca;` returns `2300`.

Also [bag](basic-constructs.md#bag-expression) valued function calls can be saved in variables.

Example:
```
   set :pb = parents(:cain);
```

In this case the value of `:pb` is a [bag](basic-constructs.md#bag-expression). To get the elements
of the bag, use the `in` function.

Example:
```
   in(:pb);
```

In a function call, the types of the actual parameters must be the
same as, or subtypes of, the types of the corresponding formal
parameters.

## <a name="select-statement"> The select statement

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

The `select` statement returns an unordered [bag](basic-constructs.md#bag-expression) of objects selected from the database. Duplicates are allowed in the result.

For example, the result of the following query will contain duplicates if names of persons in the database are not unique:
```sql
   select name(p) 
     from Person p 
    where age(p)>20;`
```
<a name="distinct-clause"> 

Duplicates are removed from the query result when the keyword `distinct` is specified. By specifying `distinct` the result from a `select` statment is a set rather than a [bag](basic-constructs.md#bag-expression).

For example, this query returns the set of different names in the database:
```sql
   select distinct name(p) 
     from Person p 
    where age(p)>20;`
```

In case you need to construct an ordered sequence of objects rather than a bag you can use the [vector selection statement](vector-queries.md).

<a name="select-clause">

The `select-clause` in a `select` statement defines the objects to be retrieved based on bindings of local variables declared in the
`from-clause` and filtered by the `where-clause`. The select clause is
often a comma-separated list of [expressions](basic-constructs.md#general-expression) to retrieve a bag of
*tuples* of objects from the database. 

Example:

```sql
   select name(p), income(p)
     from Person p
    where income(p)>2500;
```
<a name="from-clause">

The `from-clause` declares data types of local variables used in the query. 
<a name="where-clause">

The `where-clause` gives selection criteria for the search. The where clause is specified as a *predicate*.


### <a name="predicate-expression"> Predicates

The `where clause` in a select statement specifies a
selection filter as a logical predicate over variables. A predicate is
an [expression](basic-constructs.md#general-expression) returning a boolean value, which can be logical values
comparison operators (`>, *, +` etc.) and functions returning boolean
results. The boolean operators `and` and `or` can be used to combine
boolean values. 

Syntax:
```
predicate-expression ::=
      predicate-expression 'and' predicate-expression |
      predicate-expression 'or' predicate-expression  |
      '(' predicate-expression ')'                    |
      expr
```
Examples:
```
   x < 5
   child(x)
   "a" != s
   home(p) = "Uppsala" and name(p) = "Kalle"
   name(x) = "Carl" and child(x)
   x < 5 or x > 6 and 5 < y
   1+y <= sqrt(5.2)
   parents2(p) = (m,f)
   count(select friends(x) from Person x where child(x)) < 5
```

The boolean operator `and` has precedence over `or`. Negation is
handled by the function `notany`.

Example:
```
   a<2 and a>3 or b<3 and b>2
```
is equivalent to
```
  (a<2 and a>3) or (b<3 and b>2)
```

The comparison operators (=, !=, >, <=, and >=) are treated as
binary predicates. You can compare objects of any type.

Predicates are allowed in the result of a select expression. 

Example:
```sql
select age(:p1) < 20 and home(:p1)="Uppsala";
```
The query returns `true` if person `:p1` is younger than 20 and lives
in Uppsala.

### <a name="daplex-semantics"> Nested function calls

If a function is applied on the result of a function returning a bag of values, the outer function is applied **on each element** of that bag, the bag is *flattened*. This is called **Daplex semantics**. 

For example, consider the query:
```sql
   select name(friends(p))
     from Person p
    where name(p)= "Bill";
```

The function `friends()` returns a bag of persons, on which the
function `name()` is applied. The normal semantics in sa.amos is that
when a function (e.g. `name()`) is applied on a bag valued function
(e.g. `friends()`) it will be *applied on each element* of the
returned bag. In the example a bag of the names of the persons named
Bill is returned. 

### <a name="in-operator"> The *in* operator

If a function returns a bag the elements of that bag can be accessed using the `in` operator. 

Example:

```sql
   select name(p)
     from Person p, Person q
    where p in friends(q)
      and name(q) = "Tore";
```
Elements in subqueries specified as nested select expressions
can also be accessed with the `in` operator. 

Example:
```sql
   select name(p), count(b)
     from Bag of Integer b, Person p
    where b = (select p from Person p)
      and p in b;
```
The query returns the names of all persons paired with the number of
persons in the database. 


### <a name="tuple-expression"> Tuple expressions

To retrieve the results of [tuple valued functions](defining-functions.md#tuple-result) in queries, use *tuple expression* (syntax: `tuple-expr`).

Example:
```sql
   select name(m), name(f) 
     from Person m, Person p 
    where (m,f) = parents2(p);
```

Tuple expressions can also be used to assign the result of functions returning tuples.

Example:
```
   set (:m,:f)=parents2(:cain);
```

### <a name="into-clause"> Into clause

The optional `into-clause` specifies variables to be bound to the result. 

Example:
```sql
   select p into :e 
     from Person p 
    where name(p) = 'Eve';
```

This query retrieves into the environment variable `:eve2`, which the
object of type `Person` whose name is `Eve`.

**Notice** that if the result bag contains more
than one object the *into* variable(s) will be bound only to the
*first* object in the bag. In the example, if more that one person is
named Eve only the first one found will be assigned to `:e`.

If you wish to assign the entire result from the select statement to a
variable, enclose it in parentheses. The result will be a
[bag](basic-constructs.md#bag-expression). The elements of the bag can then be extracted with the infix `in` operator or the `in()` function.

Example:
```sql
   set :r = (select p 
               from Person p  
              where name(p) = 'Eve');
```

Inspect `:r` with one of these equivalent queries:
```sql
   select p from Person p where p in :r;
   in(:r); 
```

## <a name="aggregate-function"> Aggregate functions

Aggregate functions such as `sum()`, `avg()`, `stdev()`, `min()`, `max()`, `count()` are handled specially. They are applied on entire collections (bags) of values, rather than being applied for each element using the [Daplex semantics](#daplex-semantics) of normal function calls.

Example:
```sql
   count(friends(:p));
```
In this case `count()` is applied on the subquery of all friends of
`:p`. The system uses a rule that arguments are converted (coerced)
into a subquery when an argument of the calling function(e.g. `count`)
is declared `Bag of`. 

Example:
```sql
   sum(income(friends(:p));
```
Here, first Daplex semantics is used to form the bag of incomes of the friends of `:p` and then the aggregate function `sum` add together the incomes of the friends.

Aggregate functions can be used in two ways:

1. They can be used in [grouped selections](#group-by).
2. They can be applied on *subqueries*.

In the second case, the subqueries are specified as nested select expressions returning [bags](basic-constructs.md#bag-expression).

Example:
```
   avg(select income(p) from Person p);
```

Local variables in queries may be declared as bags, which means that
the variable is bound to a subquery that can be used as subquery arguments to
aggregate functions. 

Example:
```sql
   select sum(b), avg(b), stdev(b)
     from Bag of Integer b
    where b = (select income(p)
                 from Person p);
```

Variables may be assigned to bags by
assigning values of functions returning bags.

Example:
```sql
   set :f = friends(:p);
   count(:f);
```

Bags are not explicitly stored in the database, but are generated when
needed, for example when they are used in aggregate functions. 

Example:
```sql
   set :bigbag = iota(1,10000000);
```

The statement assigns `:bigbag` to a bag of 10^7^ numbers. The bag is
not explicitly created through. Instead its elements are generated when
needed, for example when passed to the aggregate function `count()`:
```sql
   count(:bigbag);
```

## <a name="order-by"> Ordered selections
The `order-by-clause` specifies that the result
should be sorted by the specified *sort key*. The sort order is
descending when `desc` is specified and ascending otherwise.
A select statement with an
order-by-clause is called an *ordered selection*.

For example, the following query sorts the result descending based on
the sort key `salary(p)`:

```sql
   select name(p), salary(p)
     from Person p
    order by salary(p) desc;
```

The sort key does not need to be part of the result.
For example, the following query list the salaries of persons in descending order without associating any names with the salaries:
```sql
   select salary(p)
     from Person p
    order by name(p) desc;
```


## <a name="group-by"> Grouped selections

When analyzing data it is often necessary to group data, for example
to get the sum of the salaries of employees per department. Such
regroupings are specified though the optional `group-by-clause`. It specifies
on which [expression](basic-constructs.md#general-expression) in the select clause the data should be grouped
and summarized. This is called a *grouped selection*.

Example:
```sql
   select name(p), sum(income(p))
     from Person p
    where age(p) > 20
    group by name(p);
```

A grouped selection is a select statement with a
`group-by-clause` present. The execution semantics
of a grouped selection is different than for regular queries.

Example:
```sql
   select name(d), sum(salary(p))
     from Department d, Person p
    where dept(p)=d
    group by name(d);
```

Here the `group-by-clause` specifies that the result should be grouped
on the names of the departments in the database. After the grouping,
for each department `d` the salaries of the persons `p` working at
that department should be summed using the [aggregate function](#aggregate-function) `sum()`.

An element of a [select-clause](#select-clause) of a grouped selection
must be one of:

1. An element in the *group key* specified by the `group-by-clause`,
which is `name(d)` in the example. The result is grouped on each group
key. In the example the grouping is made over each department name so
the group key is specified as `name(d)`.

2. A call to an [aggregate function](#aggregate-function), which is
`sum()` in the example. The aggregate function is applied for the set
of bindings specified by the group key. In the example the aggregate
function `sum()` is applied on the set of values of `salary(p)` for
the persons `p` working in department `d`, i.e. where `dept(p)=d`.

Contrast the above query to the regular (non-grouped) query:

```sql
   select name(d), sum(salary(p))
     from Department d, Person p
    where dept(p)=d;
```

Without the grouping the aggregate function `sum()` is applied on the
salary of each person `p`, rather than the collection of salaries
corresponding to the group key `name(p)` in the grouped selection.

The group key need not be part of the result. For example the
following query returns the sum of the salaries for all departments
without revealing the department names:
```sql
   select sum(salary(p))
     from Department d, Person p
    where dept(p)=d   
    group by name(d);
```


## <a name="top-k-queries"> Top-k queries

The optional `limit-clause` limits the number of returned values from
the select statement. It is often used together with ordered
selections to specify *top-k queries* returning the first few tuples in a set of objects based on some ranking.

For example, the following query returns the names and
salaries of the 10 highest income earners:

```sql
   select name(p), salary(p)
     from Person p
    order by name(p) desc
    limit 10;
```

The limit can be any numerical [expression](basic-constructs.md#general-expression). 

For example, the following
query retrieves the `:k+3` lowest income earners, where `:k` is a
variable bound to a numeric value:
```sql
   select name(p), salary(p)
     from Person p
    order by name(p)
    limit :k+3;
```

## <a name="quantifier-function"> Quantifiers

The function `some()` implements logical exist over a subquery. 

Signature:
```
some(Bag sq) -> Boolean
```

Example
```sql
   select name(p)
     from Person p
    where some(parents(p));
```

The function `notany()` tests if a subquery sq returns empty result,
i.e. negation.

Signature
```
notany(Bag sq) -> Boolean
```

Example:
```sql
   select name(p)
     from Person p
    where notany(select parents(p) 
                  where age(p)>65);
```
