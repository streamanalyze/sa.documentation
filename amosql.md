# AmosQL

In general the user may enter different kinds of AmosQL [statements](#statements) to the Amos top loop in order to instruct the system to do operations on the database:

1.  First the database schema is created by [defining types](#types) with associated properties.
2.  Once the schema is defined the database can be populated by [creating objects](#create-object) and their properties in terms of the database schema.
3.  Once the database is populated [queries](#query-statement) may be expressed to retrieve and analyze data from the database. Queries return [collections](#collections) of objects, which can be both unordered sets of objects or ordered sequences of objects.
4.  A populated database may be [updated](#updates) to change its contents.
5.  [Procedural functions](#procedures) (stored procedures) may be defined, which are AmosQL programs having side effects that may modify the database.

This section is organized as follows:

-   Before going into the details of the different kinds of AmosQL statements, in [basic constructs](#basic-constructs) the syntactic notation is introduced along with descriptions of syntax and semantics of the basic building blocks of the query language.
-   [Defining Types](#defining-types) describes how to create a simple database schema by defining types and properties.
-   [Section 2.3](#create-object) describes how to populate the database by creating objects.
-   The concept of *queries* over a populated database is presented in [Section 2.4](#query-statement).
-   Regular queries return unordered sets of data. In addition sa.amos provides the ability to specify *vector queries*, which return ordered sequences of data, as described in [Section 2.5](#vector-queries).
-   A central concept in sa.amos is the extensive use of *functions* in database schema definitions. There are several kinds of user-defined functions supported by the system as described in [Section 2.6](#function-definitions).
-   [Section 2.7](#updates) describes how to *update* a populated database.
-   [Section 2.8](#data-mining) describes primitives in AmosQL useful for data mining, in particular different ways of grouping data and of making operations of sequences and numerical vectors.
-   [Section 2.9](#accessing-files) describes functions available to read/write data from/to files, such as CSV files.
-   [Section 2.10](#cursors) describes how to define *scans* making it possible to iterate over very large query results.

## Basic Constructs

The basic building blocks of the AmosQL query language are described here.

### Syntactic conventions

For the syntax we use BNF notation with the following special constructs:

```
A ::= B C: A consists of B followed by C.
A ::= B | C, alternatively (B | C): A consists of B or C.
A ::= [B]: A consists of B or nothing.
A ::= B-list: A consists of a sequence of one or more Bs.
A ::= B-commalist: A consists of one or more Bs separated by commas.
'xyz': The keyword xyz.
```

### Statements

*Statements* instruct sa.amos to perform various kinds of operations on the database. AmosQL statements are always terminated by a semicolon (;). The following statements can be entered to the sa.amos top loop:

| Statement |
|-----------|
| create-type-stmt |
| delete-type-stmt |
| create-object-stmt |
| delete-object-stmt |
| create-function-stmt |
| delete-function-stmt |
| query
| update-stmt |
| add-type-stmt |
| remove-type-stmt |
| for-each-stmt |
| set-interface-variable-stmt |
| declare-interface-variable-stmt |
| commit-stmt |
| rollback-stmt |
| open-cursor-stmt |
| fetch-cursor-stmt |
| close-cursor-stmt |
| quit-stmt |
| exit-stmt |

### Identifiers

*Identifiers* have the syntax:

```
identifier ::=
    ('_' | letter) [identifier-character-list] 

identifier-character ::=
    alphanumeric | '_'

```

    E.g.: MySalary

      x

      x1234

      x1234_b


Notice that sa.amos identifiers are NOT case sensitive; i.e. they are always internally capitalized. By contrast sa.amos reserved keywords are always written with *lower case* letters.

### Variables

Variables are of two kinds: *local variables* or *interface variables*:\
\
 `   variable ::= local variable | interface-variable`\
\

-   *Local variables* are identifiers for data values inside AmosQL queries and functions. *Local variables* must be declared in function signatures (see [Function definitions](#function-definitions)), in from clauses (see [Queries](#query-statement)), or by the `declare` statement (see [procedural functions](#procedures)). Notice that variables are **not** case sensitive.
-   `            `*Interface variables* hold only **temporary** results
    during interactive sessions. Interface variables **cannot** be
    referenced in function bodies and they are **not** stored in
    the database. Their lifespan is the current transaction only. Their
    purpose is to hold temporary values in scripts and
    database interactions.

### Constants

Constants can be integers, reals, strings, time stamps, booleans, or
`nil`.\
 Syntax:

      constant ::=

            integer-constant | real-constant | boolean-constant |

            string-constant | time-stamp | functional-constant

        | 'nil'







        integer-constant ::= 

            ['-'] digit-list 



     E.g. 123

     -123




        real-constant ::=

     decimal-constant | scientific-constant



    decimal-constant ::=

            ['-'] digit-list '.' [digit-list]



    scientific-constant ::=

     decimal-constant ['e' | 'E'] integer-constant



     E.g. 1.2

     -1.0

     2.3E2

     -2.4e-21



    boolean-constant ::=

            'true' | 'false'


<span style="font-family: monospace;"></span>The constant <span
style="font-style: italic;">false </span>is equivalent to <span
style="font-style: italic;">nil</span> casted to type <span
style="font-style: italic;">Boolean</span>. The only legal boolean value
that can be stored in the database is <span
style="font-style: italic;">true</span> and a boolean value is regarded
as <span style="font-style: italic;">false </span>if it is not in the
database (close world assumption).\
\
 string-constant ::= \
         string-separator character-list string-separator\
\
 string-separator ::= \
         ''' | '"'\
\
 E.g. "A string"\
 'A string'\
 'A string with "'\
 "A string with \\" and '"\
\
 The enclosing string separators (' or ") for a string constant must be
the same. If the string separator is " then \\ is the *escape character*
inside the string, replacing the succeeding character. For example the
string 'ab"\\' can also be written as "ab\\"\\\\", and the string a'"b
must be written as "a'\\"b".\

`   simple-value ::= constant | variable          E.g. :MyInterfaceVariable            MyLocalVariable            123            "Hello World"   `\
 A [simple value](#simple-value) is either a constant or a variable
reference.\

### Expressions

*Expressions* are formulas expressed with the AmosQL syntax that can be
evaluated by the system to produce a *value*. Complex expressions can be
built up in terms of other expression. Expressions are basic building
blocks in all kinds of AmosQL statements.

`expr ::=  simple-value | function-call | collection-constr | casting | vector-indexing | '(' query    ')'          E.g. 1.23               1+2               1<2 and 1>3               sqrt(:a) + 3 * :b               {1,2,3}               cast(:p as Student)`\
                       [a\[3\]](#vector-index)\
                       `sum(select income(p) from Person p)` `+10`\
\
 The value of an expression is computed if the expression is entered to
the Amos top loop, e.g.:\
\
 `   1+5*sqrt(6);          => 13.2474487139159`\
\
 Notice that Boolean expressions, [predicates](#predicates), either
return <span style="font-style: italic;">true</span>, or nothing if the
expression is not true. For example:\
 <span style="font-family: monospace;">   1&lt;2 or 3&lt;2; </span>\
 <span style="font-family: monospace;">    =&gt; TRUE </span>\
 <span style="font-family: monospace;">   1&lt;2 and 3&lt;2; </span>\
 <span style="font-family: monospace;">    =&gt; nothing </span>\
\
 Entering simple expressions followed by a semicolon is the simplest
form of AmosQL [queries](#query-statement), e.g.:\
 `  1+sqrt(25);`\
\

### Collections

*Collections* represent sets of objects. sa.amos supports three kinds of
collections: bags, vectors, and key-value associations (records):\

-   A <span style="font-style: italic;">bag </span>is a set where
    duplicates are allowed.
-   A <span style="font-style: italic;">vector </span>is an ordered
    sequence of objects.
-   A <span style="font-style: italic;">record</span> is an associative
    array of key-value pairs.\

Collections are constructed by *collection constructor* expressions.
Syntax:\
\

`collection-constr ::= bag-constr | vector-constr | record-constr         bag-constr ::= bag(expr-commalist)      E.g.: bag(1,2,3)            bag(1,:x+2)       vector-constr ::= '{' expr-comma-list '}'      E.g.: {1,2,3}            {{1,2},{3,4}}            {1,name(:p),1+sqrt(:a)}       record-constr ::= '{' key-value-comma-list '}'    key-value ::= string-constant ':' expr      E.g.: {"id":1,"name":"Kalle","age":32}`\

#### Bags

The most common collection is *bags*, which are unordered sets of
objects with duplicates allowed. The value of a query is usually a bag.
When a query to the sa.amos toploop returns a bag as result the elements
of the bag are printed on separate lines. For example: <span
style="font-family: monospace;">\
\
 Amos 2&gt; select name(p) from Person p;\
 </span> <span style="font-family: monospace;"></span>

returns the bag:\

<span style="font-family: monospace;">"Bill"\
 "John"\
 "Ulla"\
 "Eva"\
 </span>\
 Bags can be explicitly created using the *bag-constr* syntax, for
example:\
 `   bag(1,2,2,3);`\
\
 A variable can be assigned to a bag returned by some function by using
the assignment statement. For example: <span
style="font-family: monospace;">\
 </span>

       set :h = hobbies(:sam);

will assign <span style="font-style: italic;">:h</span> to a bag of
Sam's hobbies is the function <span
style="font-style: italic;">hobbies()</span> returns a bag of objects.
The elements can be extracted with <span
style="font-style: italic;">in</span>:\
\
 <span style="font-family: monospace;">  in(:h);</span>\

#### Vectors

*Vectors* are sequences of objects of any kind. Curly brackets {}
enclose vector elements, for example:
```
    set :v=**{**1,2,3**}**;then <span
style="font-family: monospace;">\
    :v;</span>\
 returns:\
       <span style="font-family:
      monospace;">**{**1,2,3**}**\
 </span> <span style="font-family: monospace;"></span>

Vector element *v~i~* can be access with the notation *v\[i\]*, where
the indexing *i* is from 0 and up. For example:\
 `   set :v={1,2,3};`\
 then\
 `   :v[2]` `;`\
 returns\
 `   3`\

#### Records

*Records*  represent dynamic associations between keys and values.  A
record is a dynamic and associative array. Other commonly used terms for
associative arrays are property lists, key-value pairs, dictionaries, or
hash links. sa.amos uses generalized JSON notation to construct records.
For example the following expression assigns *:r* to a record where the
key (property) 'Greeting' field has the value 'Hello, I am Tore' and the
key 'Email' has the value 'Tore.Andersson@it.uu.se':\

    set :r= {'Greeting':'Hello, I am Tore','Email':'Tore.Andersson@it.uu.se'}


A field *f* of a record bound to a variable *r* can be access with the
notation *r\[f\]*, for example:\
 `   :r['Greeting'` `];`\
 returns\
 `   'Hello, I am Tore'`\

### Comments

A *comment* can be placed anywhere in an AmosQL statement outside
[identifiers](#identifiers), constants, or variables. \
 Syntax:

    comment ::= '/*' character-list '*/'

## Defining types

The <span style="font-style: italic;">create type </span>statement
creates a new type stored in the database. Type and
[function](#function-definitions) definitions constitute the database
schema.\

Syntax: 

    create-type-stmt ::=

            'create type' type-name ['under' type-name-commalist]

                    ['properties' '(' attr-function-commalist ')']




      type-spec ::= type-name | 'Bag of' type-spec | 'Vector of' type-spec




      type-name ::= identifier



    attr-function ::= generic-function-name type-spec ['key']


Type names must be unique in the database.\
\
 Type names are **not** case sensitive and the type names are always
internally *upper-cased*. For clarity all type names used in examples in
this manual have the first letter capitalized.\
\
 The `attr-function-commalist` clause is optional, and provides a way to
define properties of the new type, for example:\

    create type Person properties
         (name Charstring,
        income Number,
        age Number,
        parents Bag of Person);

Each property is a [function](#function-definitions) having a single
argument and a single result. The argument type of a property function
is the type being created and the result type is specified by the
` type-spec`. The result type must be previously defined. In the above
example the function *name()* ** has  argument type *Person<span
style="font-family: monospace;"></span>* and result type *Charstring*,
i.e. signatures *name(Person)-&gt;Charstring* and
*income(Person)-&gt;Number*, respectively.\

The new type will be a subtype of all the supertypes in the *under*
clause. For example, in the following definition *Student* is subtype of
*Person* and *Person* is supertype of *Student*:\
 `   create type Student under Person;` `        `

If no supertypes are specified the new type becomes a subtype of the
system type named *Userobject*.

If *key* is specified for a property, it indicates that each value of
the attribute is unique and the system will raise an error if this
[uniqueness is violated](#cardinality-constraints). In the following
example, two objects of type *Employee* cannot have the same value of
property *emp\_no*:\
 `   create type Employee under Person properties` `        `
`   (emp_no Number key);`\

*Multiple inheritance* is defined by specifying more than one supertype,
for example:\

     create type TA under Student, Employee;


### 2.2.1 Deleting types\

The `delete type` statement deletes a type and all its subtypes. 

Syntax:

    delete-type-stmt ::= 'delete type' type-name



     E.g. delete type Employee;


If the deleted type has subtypes they will be deleted as well. Functions
using the deleted types will be deleted as well, in this case
*emp\_no()*.\

2.3 Creating objects
--------------------

The `create-object` statement populates the database by creating objects
and as instance(s) of a given [type](#types) and all its supertypes.

Syntax: 

    create-object-stmt ::=

            'create' type-name

            ['(' generic-function-name-commalist ')'] 'instances' initializer-commalist       



    initializer ::= variable |

            [variable] '(' expr-commalist ')'


The new objects are assigned *initial values* for specified *attributes*
(properties). For example:\

     create Person(name, income, age) instances (
      "Adam",3500,35), (
      "Eve",3900,40);

The attributes can be any [updatable](#updates) AmosQL function having
the created type as its only argument, here *name()* and *age()*. One
object will be created for each initializer. Each initializer includes a
comma-separated list of initial values for the specified attribute
functions. Initial values are specified as [expressions](#expressions),
for example:

     create Person (name,income) instances (
      "Kalle "+"Persson" , 3345*1.5);

The types of the initial values must match the declared result types of
the corresponding functions.\
\
 Each initializer can have an optional [variable name](#variables) which
will be bound to the new object. The variable name can subsequently be
used as a reference to the object. For example:

     create Person(name, income) instances
      :pelle ("Per",3836);

Then the query

     income(:pelle);

returns

     3386

Notice that [interface variables](#interface-variables) such as *:pelle*
are temporary and not saved in the database.

[Bag valued functions](#Bags) are initialized using the syntax
`'bag(e1,...)'` (syntax [`bag-expr`](#bag-constr)),\
 for example:\

    create Person (name,parents,income,age) instances :adam ("Adam",nil,2300,64), :eve ("Eve",nil,3200,63), :cain ("Cain",bag(:adam,:eve),1500,44), ("Abel",
      bag(:adam,:eve),900,43), :seth ("Seth",bag(:adam,:eve),1700,42), :lilith ("Lilith",bag(:adam,:eve),4500,40), :noah ("Noah",bag(:seth,:lilith),5300,25), :ruth ("Ruth",:cain,500,24), ("Shem",
      bag(:noah,:ruth),800,15), :ham ("Ham",bag(:noah,:ruth),3800,16), ("Cush",:ham,10,2);

It is possible to specify `nil` for a value when no initialization is
desired for the corresponding function.\

### <span style="font-weight: bold;"></span>2.3.1 Deleting objects

Objects are deleted from the database with the `delete` statement.

Syntax:

    delete-object-stmt ::= 'delete' variable

For example:

    delete :pelle;

The system will automatically remove the deleted object from all stored
functions where it is referenced. 

Deleted objects are printed as

    #[OID nnn *DELETED*]

The objects may be undeleted by `rollback;`. The automatic garbage
collector physically removes an OID from the database only if its
creation has been rolled back or its deletion committed, <span
style="font-style: italic;">and </span>it is not referenced from some
variable or external system.\

<span style="font-weight: bold;"></span>2.4 Queries
---------------------------------------------------

*Queries* retrieve objects having specified properties from the
database. A query can be one of the following:\

1.  It can be [calls](#function-call)to built-in or user
    defined function.
2.  It can be a [select statement](#select-statement) to search the
    database for a set of objects having properties fulfilling a query
    condition specified as a logical [predicate](#predicates).
3.  If can be a vector selection statements
    ([vselect-statement](#vselect)) to construct an ordered
    sequence (vector) of objects fulfilling the query condition. 
4.  It can be an [expression](#expressions).\

The syntax for a query is thus:\
\
 `query ::= ` `   function-call |   `
`              select-stmt |              vselect-stmt |              expression`\

### 2.4.1 Calling functions

A simple form of queries are calls to functions. Syntax:

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


The built-in functions *plus()*, *minus()*, *times()*, and *div()*  have
infix syntax +,-,\*,/ with the usual priorities. \
 For example:

     (income(:eve) + income(:ham)) * 0.5;

is equivalent to:

     times(plus(income(:eve),income(:ham)),0.5);

The '+' operator is defined for both numbers and strings. For strings it
implements string concatenation.\

The result of a function call can be saved temporarily in an interface
variable, for example:

     set :inca = income(:adam);

then the query `:inca;` returns `2300`.

Also bag valued function calls can be saved in variables, for example:

     set :pb = parents(:cain);

In this case the value of :pb is a [bag](#bags). To get the elements of
the bag, use the *in* function. For example:

     in(:pb);

[Tuple expressions](#tuple-expr) can be used to assign the result of
functions returning [tuples](#tuple-result), for example:

     set (:m,:f)=parents2(:cain);

In a function call, the types of the actual parameters must be the same
as, or subtypes of, the types of the corresponding formal parameters.\

### 2.4.2 The select statement

The *select statement* provides the most flexible way to specify
queries.

Syntax:

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


The *select statement* returns an unordered set of objects selected from
the database. Duplicates are allowed in the result set of a query, i.e.
the result is a [bag](#bags). In case you need to construct an ordered
sequence of objects rather than a bag you can use the [vector selection
statement](#vselect).\
\
 The *select-clause* in a select statement defines the objects to be
retrieved based on bindings of local variables declared in the
*from-clause* and filtered by the *where-clause*. The select clause is
often a comma-separated list of expressions to retrieve a bag of
*tuples* of objects from the database. For example:\

     select name(p), income(p)

     from Person p

     where income(p)>2500;


The *from-clause* declares data types of local variables used in the
query. For example:

     select name(p), income(p)
      from Person p
                where age(p)>20;

Notice that variables in AmosQL can be bound to *objects of any type*,
AmosQL*.* This is different from SQL select statements where all
variables must be bound to *tuples only*. AmosQL is based on *domain
calculus* while SQL select expressions are based on *tuple calculus*.

If a function is applied on the result of a function returning a bag of
values, the outer function is applied **on each element** of that bag,
the bag is *flattened*. This is called *Daplex semantics*. For example,
in the following query, if there are more than one parents per parent
generation of Cush there will be several names (e.g. Noah and Ruth)
returned:

     select name(parents(parents(q))) from Person q where name(q)= "Cush";

returns the bag:

     "Noah" "Ruth"

The *where-clause* ** gives selection criteria for the search. The
where-clause is specified as a [predicate](#predicate-expressions). For
example:\

     select name(p), income(p)

      from Person p

      where age(p)>20;


<span style="text-decoration: underline;"></span>

To retrieve the results of [tuple valued functions](#tuple-result) in
queries, use [tuple expressions](#tuple-expr), e.g.

     select name(m), name(f) from Person m, Person p where (m,f) = parents2(p);

Duplicates are removed from the result only when the keyword 'distinct'
is specified, in which case a set (rather than a bag) is returned from
the selection.\

For example, this query returns the set of different names in the
database:

     select distinct name(p) from Person p where age(p)>20;

The optional *group-by-clause* groups and summarizes (aggregates) the
result. A select statement with a group-by-class is called a [grouped
selection](#grouped-selection). For example:

     select name(p), sum(income(p))

      from Person p

     where age(p) > 20

     group by name(p);


The optional *order-by-clause* sorts the result ascending ('asc',
default) or descending ('desc'). A select statement with an
order-by-clause is called an [ordered selection](#ordered-selections).
For example:\

     select name(p), income(p)

      from Person p

     where age(p) > 20

     order by income(p) desc;


The optional *limit-clause* limits the number of returned values from
the select statement. It is often used together with ordered selections
to specify [top-k queries](#top-k-queries). For example:

     select name(p), income(p)

      from Person p

     where age(p) > 20

     order by income(p) desc

     limit 10;


The optional <span style="font-style: italic;">into-clause</span>
specifies variables to be bound to the result.  <span
style="font-weight: bold;"></span>

For example:

     select p into :e from Person p where name(p) = 'Eve';

This query retrieves into the environment variable <span
style="font-style: italic;">:eve2</span> the Person whose name is ``
<span style="font-style: italic;">'Eve'</span>.\
 <span style="font-weight: bold;">\
 NOTICE </span> that if the result bag contains more than one object the
<span style="font-style: italic;">into </span>variable(s) will be bound
only to the <span style="font-style: italic;">first</span> object in the
bag. In the example, if more that one person is named Eve the first one
found will be assigned to *:e*.\
\
 If you wish to assign the entire result from the select statement in a
variable, enclose it in parentheses. The result will be a [bag](#Bags).
The elements of the bag can then be extracted with the <span
style="font-style: italic;">in()</span> function or the infix *in*
operator:

     set :r = (select p from Person p where name(p) = 'Eve');

Inspect *:r* with one of these equivalent queries:

     in(:r); select p from Person p where p in :r;

### 2.4.3 Predicates

The [where clause](#where-clause) in a select statement specifies a
selection filter as a logical predicate over variables. A predicate is
an expression returning a boolean including logical [comparison
operators](#infix-functions)and functions with boolean results. The
boolean operators <span style="font-style: italic;">and </span>and <span
style="font-style: italic;">or</span> can be used to combine boolean
values. The general syntax of a predicate expression is:

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

<span style="font-family: monospace;"></span> <span
style="font-family: monospace;"></span>

The comparison operators (=, !=, &lt;, &lt;=, and &gt;=) are treated as
binary [predicates](#predicates). You can compare objects of any type.\

Predicates are also allowed in the result of a select expression. For
example, the query:\
        <span style="font-family:
        monospace;">select age(:p1) &lt; 20 and
home(:p1)="Uppsala";</span>\
 returns <span style="font-style: italic;">true</span> if person <span
style="font-style: italic;">:p1</span> is younger than 20 and lives in
Uppsala.\

### 2.4.4 Grouped selections

When analyzing data it is often necessary to group data, for example to
get the sum of the salaries of employees per department. Such
regroupings are specified though the *group-by-clause*. It specifies on
which expressions in the select clause the data should be grouped and
summarized.  A *grouped selection* is a select statement with a
[group-by-clause](#group-by-clause) specified. The execution semantics
of a grouped selection is different than for regular queries.\

For example:\
 `    ` `select name(d), sum(salary(p))` `        `
`       from Department d, Person p   ` `        `
`      where dept(p)=d` `        ` `      group by name(d);`\
\
 Here the *group-by-clause* specifies that the result should be grouped
on the name of the departments in the database. After the grouping, for
each department *d* the salaries of the persons *p* working at that
department should be summed using the [aggregate
function](#aggregate-functions) *sum()*.\

An element of a [select-clause](#select-clause) of a grouped selection
must be one of:\

1.  An element in the *group key* specified by the group-by-clause,
    which is *name(d)* in the example. The result is grouped on each
    group key. In the example the grouping is made over each department
    name so the group key is specified as *name(d)*.\
2.  A call to an [aggregate function](#aggregate-functions), which is
    *sum()* in the example. The aggregate function is applied for the
    set of bindings specified by the group key. In the example the
    aggregate function *sum()* is applied on the set of values of
    *salary(p)* for the persons *p* working in department *d*, i.e.
    where *dept(p)=d*.\

In general aggregate functions such as *sum(), avg(), stdev(), min(),
max(), count()* are applied on collections (bags) of values, rather than
single objects.

Contrast the above query to the regular (non-grouped) query:\

`    ` `select name(d), sum(salary(p))` `        `
`       from Department d, Person p   ` `        `
`      where dept(p)=d` `;`\

Without the grouping the aggregate function *sum()* is applied on the
salary of each person *p*, rather than the collection of salaries
corresponding to the group key *name(p)* in the grouped selection.\

The group key need not be part of the result. For example the following
query returns the sum of the salaries for all departments without
revealing the department names:\
 `    ` `select sum(salary(p))` `        `
`       from Department d, Person p   ` `        `
`      where dept(p)=d` `        ` `      group by name(d);`\

### 2.4.5 Ordered selections\

The [order-by-clause](#order-by-clause) specifies that the result should
be (partially) sorted by the specified *sort key*. The sort order is
descending when *desc* is specified and ascending otherwise.\

For example, the following query sorts the result descending based on
the sort key *salary(p)*:

`  select name(p), salary(p)          from Person p         order by name(p) desc;          `\
 The sort key does not need to be part of the result.\

For example, the following query list the salaries of persons in
descending order without associating any names with the salaries:

` select salary(p)         from Person p        order by name(p) desc;        `

### 2.4.6 Top-k queries

A *top-k query* is a query returning the first few tuples in a larger
set of tuples based on some ranking. The
[order-by-clause](#order-by-clause) and [limit-clause](#limit-clause)
can be combined to specify top-k queries. For example, the following
query returns the names and salaries of the 10 highest income earners:\

`  select name(p), salary(p)          from Person p         order by name(p) desc         limit 10;        `

The limit can be any numerical expression.For example, the following
query retrieves the *:k+3* lowest income earners, where *:k* is a
variable bound to a numeric value:

`  select name(p), salary(p)          from Person p         order by name(p)         limit :k+3;`
[](#generalized-aggregate-functions)\

### 2.4.7 Aggregation over subqueries\

[Aggregate functions](#aggregate-functions) can be used in two ways:\

1.  They can be used in [grouped selections](#grouped-selection).
2.  They can be applied on *subqueries*.\

In the second case, the subqueries are specified as nested select
expressions returning [bags](#bags), for example:\

<span style="font-family: monospace;">   avg(**select income(p) from
Person p**);\
 </span>\
 Consider the query:\

        select name(friends(p))

     from Person p

     where name(p)= "Bill";


The function *friends()* returns a bag of persons, on which the function
*name()* is applied. The normal semantics in sa.amos is that when a
function (e.g. *name()*) is applied on a bag valued function (e.g.
*friends()*) it will be *applied on each element* of the returned bag.
In the example a bag of the names of the persons named Bill is returned.
This is called [Daplex semantics](#daplex-semantics).

<span style="text-decoration: underline;"></span>Aggregate functions
work differently. They are applied <span style="font-style: italic;">on
the entire</span> bag. For example:\

        count(friends(:p));

In this case <span style="font-style: italic;">count() </span>is applied
on the subquery of all friends of <span
style="font-style: italic;">:p</span>. The system uses a rule that
arguments are converted (coerced) into a subquery when an argument of
the calling function <span style="font-style:
        italic;">(e.g. count</span>) is declared *Bag of*.\

Local variables in queries may be declared as bags, which means that the
variable is bound to a subquery that can be used as arguments to
aggregate functions. For example:\

     select sum(b), avg(b), stdev(b)

     from Bag of Integer b

     where b = (select income(p)

     from Person p);


Elements in subqueries can be accessed with the *in* operator. For
example:\

     select name(p), count(b)

     from Bag of Integer b, Person p

     where b = (select p from Person p)

     and p in b;

The query returns the names of all persons paired with the number of
persons in the database.\

Variables may be assigned to bags by assigning values of functions
returning bags, for example:\
 `   set :f = friends(:p);         count(:f);        `

Bags are not explicitly stored in the database, but are generated when
needed, for example when they are used in aggregate functions or *in*.
For example:\
 `   set :bigbag = iota(1,10000000);`\
 assigns *:bigbag* to a bag of 10^7^ numbers. The bag is not explicitly
created though. Instead its elements are generated when needed, for
example when executing:\
 `   count(:bigbag);`\
\
 To compare that two bags are equal use:\

     bequal(Bag x, Bag y) -> Boolean


<span style="font-weight: bold;">Notice</span> that *bequal()*
materializes its arguments before doing the equality computation, which
may occupy a lot of temporary space in the database image if the bags
are large.\




###

See [7.4 Aggregate functions](#aggregate-functions) for a details on
aggregate functions.\

### 2.4.8 Quantifiers

###

The function <span style="font-style: italic;">some() </span>implements
logical exist over a subquery:\

    some(Bag sq) -> Boolean

for example\

     select name(p)

     from Person p

      where some(parents(p));

\
 The function <span style="font-style: italic;">notany()</span> tests if
a subquery <span style="font-style: italic;">sq</span> returns empty
result, i.e. negation <span style="font-style: italic;"></span>:\

    notany(Bag sq) -> Boolean

For example:\

     select name(p)

     from Person p

     where notany(select parents(p) where age(p)>65);

2.5 Vector queries
------------------

<span style="font-weight: bold;"></span>The order of the objects in the
bag returned by a regular [select statement](#select-statement) is <span
style="font-weight: bold;">not</span> predetermined unless an
[order-by](#order-by-clause) clause is specified. However, even if
order-by is specified the system will not preserve the order of the
result of a select-statement if it is used in other operations.\
\
 If it is required to maintain the order of a set of data values the
data type *Vector* has to be used. The collection datatype *Vector*
represent ordered collections of any kinds of objects; the simplest and
most common case of a vector is a numerical vector of numbers. In case
the order of a query result is significant you can specify *vector
queries* which preserves the order in query result by returning vectors,
rather than the bags returned by regular select statements. This is
particularly important when working with numerical vectors. A vector
query can be one of the following:\

1.  It can be a [vector construction](#vector-construction) expression
    that creates a new vector from other objects.
2.  It can be a [vector indexing](#vector-index) expression that
    accesses vector elements by their indexes.\
3.  It can be a regular [select statement](#select-statement) returning
    a set of constructed vectors.
4.  It can be a [vselect statement](#vselect), which returns an ordered
    vector rather than an unordered bag as the regular select statement.
5.  It can be a call to some [vector function](#vector-function)
    returning vectors as result.\

### 2.5.1 Vector construction

The vector constructor {...} notation creates a single vector with
explicit contents.  The following query constructs a vector of three
numbers:\
 <span style="font-family: monospace;">  **{**1,sqrt(4),3**}**;</span>\
 The returned vector is\
 `  {1, 2.0, 3}`\
\
 The following query constructs a bag of vectors holding the persons
named Bill together with their ages.\
 <span style="font-family: monospace;">  select {p,age(p)} from Person p
where name(p)="Bill";</span>\
\
 The previous query is different from the query\
 <span style="font-family: monospace;">  select p, age(p) from Person p
where name(p)="Bill"</span>\
 which returns bag of tuples.\

###   2.5.2 The vselect statement

The *vselect statement* provides a powerful way to construct new vectors
by queries. It has the same syntax as the select-statement. The
difference is that whereas the select-statement returns a bag of
objects, the vselect statement returns a vector of objects. For
example:\

`  vselect i*2         from Integer i        where i = {1,2,3}        order by i;   `
returns the vector\
 `  {2,4,6}`\
\
 The vselect statement has the same syntax as the select statement
except for the keyword *vselect*:\

    vselect-stmt ::=

            'vselect' ['distinct']

     [select-clause]

                    [into-clause] 

                    [from-clause]

                    [where-clause]

     [group-by-clause]

     [order-by-clause]

     [limit-clause]


Notice that the [order-by-clause](#ordered-selections) normally should
be present when constructing vectors with the vselect statement in order
to exactly specify the order of the elements in the vector. If no
order-by-clause is present the order of the elements in the vector is
arbitrarily chosen by the system based on the query, which is the order
that is the most efficient to produce.\
\
 The built-in function *iota()* is very useful when constructing
vectors. It has the signature\
 `  iota(Number x, Number y) -> Bag of Integer`\
 *iota()* returns the set of all integer i where *l &lt;= i &lt;= u*.
For example,\
 `  iota(2,4)`\
 returns the bag\
 `  2` `   ` `  3` `   ` `  4`\
\
 For example:\

`  vselect i         from Number i        where i in iota(-4,5)        order by i;   `will
return the vector\
 `  ` <span
style="font-family: monospace;">{-4,-3,-2,-1,0,1,2,3,4,5}</span> <span
style="font-family: monospace;"></span>\

### <span style="font-family: monospace;"> </span>2.5.3 Accessing vector elements

Vector elements can be accessed using the <span style="font-style:
      italic;">vector-indexing</span> notation:\
\
 <span style="font-family: monospace;">  vector-indexing ::= simple-expr
'\[' expr-commalist '\]'</span>\
\
 The first element in a vector has index 0 etc.\
\
 For example: <span style="font-family: monospace;">\
   select a\[0\]+a\[1\]\
     from Vector a\
    where a = {1,2,3};\
 </span>returns\
 <span style="font-family: monospace;">    3</span>\
\
 Index variables as numbers can be used in queries to specify iteration
over all possibles index positions of a vector.\
\
 For example:\
 ` ` `vselect a[i]` `   ` `    from Integer i` `   `
`   where a[i] != 2` `   ` `     and a = {1,2,3}` `   ` `   order by i;`
`   ` ` `returns the vector:\
 `  ` `{` `1,3}` <span style="font-family:
      monospace;">\
 </span>The query should be read as "Make a vector *v* of all vector
elements *a~i~* in *a* where *a~i~* *!= 2* and order the elements in *v*
on *i*.\
\
 The following query multiplies the elements of the vectors bound to the
interface variables *:u* and *:v*:\
 ` ` `vselect :u[i] * :v[i]` `   ` `    from Integer i` `   `
`   order by i;`\

### 2.5.4 Vector functions

There is a library of numerical vector functions for numerical
computations and analyses described in [Section 2.8](#data-mining).\
\
 The function *project()* constructs a new vector by extracting from the
vector *v* the elements in the positions in *pv*:\
 <span style="font-family: monospace;">  project(Vector v, Vector of
Number pv) -&gt; Vector r</span>\
\
 For example:\
 <span style="font-family: monospace;">  project({10, 20, 30, 40},{0, 3,
2});\
 </span> returns <span style="font-family: monospace;">{10, 40, 30}
</span>\
\
 The function *substv()* replaces *x* with *y* in any collection <span
style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  substv(Object x, Object y,
Object v) -&gt; Object r</span>\
\
 The system function <span style="font-style: italic;">dim()</span>
computes the size <span style="font-style: italic;">d</span> of a vector
<span style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  dim(Vector v) -&gt; Integer
d</span>\
\
 The function <span style="font-style: italic;">concat()
</span>concatenates two vectors:\
   <span style="font-family: monospace;"> concat(Vector x, Vector y)
-&gt; Vector r</span>\
\

<span style="font-weight:
        bold;"></span>2.6 Defining functions
--------------------------------------------

The <span style="font-style: italic;"> create function</span> statement
defines a new user function stored in the database. Functions can be one
of the following kinds:

-   [*Stored functions*](#stored-function) are stored in the sa.amos
    database as a table.\
-   [*Derived functions*](#derived-function) are defined by a single
    [query](#query-statement) that returns the result of the a function
    call for given parameters. \
-   [*Foreign functions*](#foreign-functions) are defined in an external
    programming language. Foreign functions can be defined in the
    programming languages C/C++ [\[Ris12\]](#Ris00a), Java
    [\[ER00\]](#ER00), or Lisp [\[Ris06\]](#Ris00b).
-   [*Procedural functions*](#procedures) are defined using procedural
    AmosQL statements that can have side effects changing the state of
    the database. Procedural functions make AmosQL computationally
    complete.\
-   [*Overloaded functions*](#overloaded-functions) have different
    implementations depending on the argument types in a function call.

Syntax:

`create-function-stmt ::=          'create function' generic-function-name argument-spec '->' result-spec [fn-implementation]   `
`       E.g. create function born(Person) -> Integer as stored;      `
`   generic-function-name ::= identifier            function-name ::= generic-function-name |                       type-name-list '.' generic-function-name '->' type-name-list   `
`       E.g. plus              `Function names are **not** case
sensitive and are internally stored *upper-cased*.\
\

`type-name-list ::= type-name |                             type-name '.' type-name-list   `\
 All types used in the function definitions must be previously defined.\

`    argument-spec ::='(' [argument-declaration-commalist] ')'        argument-declaration ::=         type-spec [local-variable] [key-constraint]   `\
 The names of the argument and result parameters of a function
definition must be distinct.\

`      key-constraint ::= ('key' | 'nonkey')       result-spec ::=   argument-spec | tuple-result-spec        tuple-result-spec ::=       ['Bag of'] '(' argument-declaration-commalist ')'          fn-implementation ::=      'as' query |           `
`'stored' |`\

`       procedural-function-definition |           foreign-function-definition      `
The ` argument-spec` and the `result-spec` together specify the
*signature* of the function, i.e. the types and optional names of formal
parameters and results. \

### 2.6.1 Stored functions

A *stored function* is defined by the implementation ' <span
style="font-family: monospace;">as stored</span>', for example:\
\
   `  create function age(Person p) -> Integer a        as stored;   `\
 The name of an argument or result parameter can be left unspecified if
it is not referenced in the function's implementation, for example:
<span style="font-family: monospace;">\
\
   </span>
`create function name(Person) -> Charstring        as stored;      `
*Bag of* specifications on a single result parameter of a stored
function declares the function to return a bag of values, i.e. a set
with tuples allowed, for example:\
\
     
`create function parents(Person) ->   Bag of Person        as stored;`\
 **\
 Notice** that stored functions cannot have arguments declared 'Bag
of''.

AmosQL functions may also have tuple valued results by using the
[tuple-result-spec](#tuple-result) notation. For example:\

<span style="font-family: monospace;">  create function parents2(Person
p) -&gt; **(Person m, Person f)\
    ** as stored;\
\
   create function marriages(Person p)\
                   -&gt; **Bag of (Person spouse, Integer year)**\
     as stored;\
 </span>\
 [Tuple expressions](#tuple-expr)are used for binding the results of
tuple valued functions in queries, for example:\
\
 <span style="font-family: monospace;">  select s,y\
     from Person s, Integer y\
    where **(s,y)** in marriages(:p);</span>\
\
 The *multiple assignment statement* assigns several variables to the
result of a tuple valued query, for example:\

     set (:mother,:father) = parents2(:eve);

You can store [records](#records) in stored functions, for example:\
\
 `   create function pdata(Person) -> Record         as stored;` `   `
`   create Person(pdata)       instances ({'Greeting':'Hello, I am Tore',`**`       `**
`                               'Email':'Tore.Andersson@it.uu.se'}); `    \

Possible query:

`     select r['Greeting'] ` `   ` `       from Person p, Record r `
`   ` `      where name(p)='Tore'            and pdata(p)=r; `\

### 2.6.2 Derived functions

A <span style="font-style: italic;">derived function</span> is defined
by a single AmosQL  <span style="text-decoration:
      underline;"></span>[query](#query-statement), for example:

 
`   create function taxincome(Person p) -> Number          as select income(p) - taxes(p)                   where         taxes(p) < 0;`\
 *\
* Functions with result type *Boolean* implement predicates and return
<span style="font-style: italic;">true</span> when the condition is
fulfilled. For example:\

        create function child(Person p) -> Boolean


                  as select true where age(p)<18;


`        `alternatively:\

     create function child(Person p) -> Boolean

     as age(p) < 18;


Since the select statement returns a bag of values, derived functions
also often return a  *Bag of* results. If you know that a function
returns a bag of values you should indicate that in the signature. For
example:\
 <span style="font-family: monospace;"></span>

     create function youngFriends(Person p)-> Bag of Person

     as select f

     from Person f

     where age(f) < 18

     and f in friends(p);



If you write:

       create function youngFriends(Person p)-> Person

     as select f

     from Person f

       where age(f) < 18

     and f in friends(p);




you indicate to the system that <span
style="font-style: italic;">youngFriends()</span> returns a single
value. However, this constraint is **not** enforced by the system so if
there are more that one <span
style="font-style: italic;">youngFriends()</span> the system will treat
the result as a bag.\




Variables declared in the result of a derived function need not be
declared again in the from clause, their types are inferred from the
function signature. For example, <span
style="font-style: italic;">youngFriends()</span> can also be defined
as:\

      create function youngFriends(Person p) -> Bag of Person f

     as select f

          where age(f) < 18

     and f in friends(p);




<span style="font-weight: bold;">Notice</span> that the variable <span
style="font-style: italic;">f</span> is bound to the elements of the
bag, not the bag itself. This definition is equivalent:\
\
 <span style="font-family: monospace;"> create function
youngFriends(Person p) -&gt; Bag of (**Person f**)\
    as select f\
        where age(f) &lt; 18\
          and f in friends(p); </span> <span
style="font-family: monospace;">  </span>

Derived functions whose **arguments** are declared *Bag of* are user
defined [aggregate functions](#aggregate-functions). For example:\
\
 <span style="font-family: monospace;">create function myavg(**Bag of**
Number x) -&gt; Number\
      as sum(x)/count(x);</span> <span
style="font-family: monospace;"></span>\
\
 [Aggregate functions](#aggregate-functions) do not flatten the argument
bag. For example, the following query computes the average age of Carl's
grandparents:\
\
 <span style="font-family: monospace;">   select
**myavg**(age(grandparents(q)))\
      from Person p\
     where name(q)="Carl";</span> <span
style="font-family: monospace;">   </span>\

When functions returning tuples are called the results are bound by
enclosing the function result within parentheses (..) through the
[tuple-expr](#tuple-expr) syntax. For example:\

<span style="font-family: monospace;">       select age(m), age(f)\
          from Person m, Person f, Person p\
         where **(m,f)** = parents2(p)\
           and name(p) = "Oscar";</span> \

### <span style="font-weight:
        bold;"></span>2.6.3 Overloaded functions

Function names may be <span
style="font-style: italic;">overloaded</span>, i.e., functions having
the same name may be defined differently for different argument types.
This allows <span style="font-style:
      italic;">generic</span> functions applicable on objects of several
different argument types. Each specific implementation of an overloaded
function is called a *resolvent*.

For example, assume the following two sa.amos function definitions
having the same <span style="font-style: italic;">generic</span>
function name *less()<span style="font-family:
          monospace;"></span>*:

    create function less(Number i, Number j)->Boolean

            as i < j; 

    create function less(Charstring s,Charstring t)->Boolean 

            as s < t;

Its resolvents will have the signatures:

      less(Number,Number) -> Boolean

      less(Charstring,Charstring) -> Boolean

Internally the system stores the resolvents under different function
names. The name of a resolvent is obtained by concatenating the type
names of its arguments with the name of the overloaded function followed
by the symbol '-&gt;' and the type of the result. The two resolvents
above will be given the internal resolvent names <span
style="font-family: monospace;">NUMBER.NUMBER.LESS-&gt;BOOLEAN</span>
and `CHARSTRING.CHARSTRING.LESS->BOOLEAN`. 

The query compiler resolves the correct resolvent to apply based on the
types of the arguments; the type of the result is <span
style="font-style: italic;">not </span>considered. If there is an
ambiguity, i.e. several resolvents qualify in a call, or if no resolvent
qualify, an error will be generated by the query compiler.

When overloaded function names are encountered in AmosQL function
bodies, the system will use local variable declarations to choose the
correct resolvent (early binding).  For example:

     create function younger(Person p,Person q)->Boolean

            as less(age(p),age(q));

will choose the resolvent ` ` <span style="font-family:
      monospace;">NUMBER.NUMBER.LESS-&gt;BOOLEAN</span>, since `age`
returns integers and the resolvent <span style="font-family:
      monospace;">NUMBER.NUMBER.LESS-&gt;BOOLEAN</span> is applicable to
integers by inheritance. The other function resolvent
`CHARSTRING.CHARSTRING.LESS->BOOLEAN` does not qualify since it is not
legal to apply to arguments of type `Integer`.

On the other hand, this function:

    create function nameordered(Person p,Person q)->Boolean

            as less(name(p),name(q));

will choose the resolvent <span
style="font-family: monospace;">NUMBER.NUMBER.LESS-&gt;BOOLEAN</span>
since the function *name()* ** returns a string. In both cases the <span
style="font-style: italic;">type resolution</span> (selection of
resolvent) will be done at compile time.

<span style="font-weight: bold;">Late binding</span>\
\
 Dynamic type resolution at run time, *late binding*, is sometimes
required to choose the correct resolvent. For example, the query\

    less(1,2);

will choose <span
style="font-family: monospace;">NUMBER.NUMBER.LESS-&gt;BOOLEAN</span>
based on the numeric types the the arguments.\
\
 Inside function definitions and queries there may be expressions
requiring late bound overloaded functions. For example, suppose that
managers are employees whose incomes are the sum of the income as a
regular employee plus some manager bonus: 

     create type Employee under Person;

     create type Manager under Employee;

     create function mgrbonus(Manager)->Integer as stored;

     create function income(Employee)->Integer as stored; 

     create function income(Manager m)->Integer i 

            as income(cast(m as Employee)) + mgrbonus(m);

Now, suppose that we need a function that returns the gross incomes of
all persons in the database, i.e. we use `MANAGER.INCOME->INTEGER` for
managers and ` EMPLOYEE.INCOME->INTEGER` for non-manager. In sa.amos
such a function is defined as:

     create function grossincomes()->Integer i 

            as select income(p)

            from Employee p;

     /* income(p) late bound */

Since `income` is overloaded with resolvents `EMPLOYEE.INCOME->INTEGER`
and `MANAGER.INCOME->INTEGER` and both qualify to apply to employees,
the resolution of `income(p)` will be done at run time. 

To avoid the overhead of late binding one may use [casting](#casting).
<span style="font-family:
        monospace;"></span>

<span style="font-weight: bold;"></span>

Since the detection of the necessity of dynamic resolution is often at
compile time, overloading a function name may lead to a cascading
recompilation of functions defined in terms of that function name. For a
more detailed presentation of the management of late bound functions see
[\[FR95\]](#FR95).\

### 2.6.4 Casting

The type of an expression can be explicitly defined using the *casting*
statement:\

     casting ::= 'cast'(expr 'as' type-spec)


for example\

     create function income(Manager m)->Integer i 

            as income(cast(m as Employee)) + mgrbonus(m);

By using casting statements one can avoid late binding.\

### 2.6.5 Second order functions\

sa.amos functions are internally represented as any other objects and
stored in the database. Object representing functions can be used in
functions and queries too. An object representing a function is called a
<span style="font-style: italic;">functional</span>. Second order
functions take functionals as arguments or results. The system function
*functionnamed()* retrieves the functional *fno* having a given name
<span style="font-style: italic;">fn</span>:\

    functionnamed(Charstring fn) -> Function fno


The name <span style="font-style: italic;">fn</span> is not case
sensitive.\
\
 For example\

    functionnamed("plus");

     => #[OID 155 "PLUS"]


returns the object representing the [generic](#overloaded-functions)
function [<span style="font-family:
        monospace;">plus</span>](#infix-functions), while\

    functionnamed("number.number.plus->number");

     => #[OID 156 "NUMBER.NUMBER.PLUS->NUMBER"]


returns the object representing the [resolvent](#overloaded-functions)
named <span
style="font-family: monospace;">NUMBER.NUMBER.PLUS-&gt;NUMBER</span>.

Another example of a second order function is the system function\

    apply(Function fno, Vector argl) -> Bag of Vector

It calls the functional *fno* with the vector *argl* as argument list.
The result tuples are returned as a bag of vectors, for example:\

    apply(functionnamed("number.number.plus->number"),{1,3.4});

      => {4.4}


Notice how <span style="font-style: italic;">apply() </span>represents
argument lists and result tuples as vectors.\

When using second order functions one often needs to retrieve a
functional <span style="font-style: italic;">fno </span>given its name
and the function <span style="font-style: italic;">functionnamed()
</span>provides one way to achieve this. A simpler way is often to use
<span style="font-style: italic;">functional constants</span> with
syntax:\

      functional-constant ::= '#' string-constant


for example\

    #'mod';


A functional constant is translated into the functional with the name
uniquely specified by the string constant. For example, the following
expression\

    apply(#'mod',{4,3});

      => {1}


<span style="font-weight: bold;">Notice</span> that an error is raised
if the function name specified in the functional constant is not
uniquely identifying the functional. This happens if it is the
[generic](#overloaded-functions) name of an overloaded function. For
example, the functional constant <span
style="font-family: monospace;">\#'plus' </span>is illegal, since
[*plus()*](#infix-functions) <span style="font-style: italic;">
</span>is overloaded. For overloaded functions the name of a resolvent
has to be used instead, for example:\

    apply(#'plus',{2,3.5});


generates an error, while\

    apply(#'number.number.plus->number', {2,3.5});

     => {5.5}


and\

    apply(functionnamed("plus"),{2,3.5});

     => {5.5}


The last call using <span
style="font-family: monospace;">functionnamed("plus")</span> will be
somewhat slower than using <span style="font-family:
      monospace;">\#'number.number.plus-&gt;number'</span> since the
functional for the generic function *plus()* is selected and then the
system uses late binding to determine dynamically which resolvent of
[*plus()*](#infix-functions) to apply.\

### 2.6.6 Transitive closures\

The transitive closure functions <span style="font-style:
        italic;">tclose()</span> is a [second
order](#second-order-functions) function to explore graphs where the
edges are expressed by a <span style="font-style: italic;">transition
function </span> specified by argument <span style="font-style:
        italic;">fno</span>:

       tclose(Function fno, Object o) -> Bag of Object

<span style="font-style: italic;">tclose()</span> applies the transition
function <span style="font-style: italic;">fno(o)</span>, then <span
style="font-style: italic;">fno(fno(o))</span>, then <span
style="font-style: italic;">fno(fno(fno(o)))</span>, etc until <span
style="font-style: italic;">fno </span>returns  no new result. Because
of the [Daplex semantics](#daplex-semantics), if the transition function
<span style="font-style: italic;">fno </span>returns a bag of values for
some argument <span style="font-style: italic;">o</span>, the successive
applications of <span style="font-style: italic;"> fno </span>will be
applied on each element of the result bag. The result types of a
transition function must either be the same as the argument types or a
bag of the argument types. Such a function that has the same arguments
and (bag of) result types is called a <span
style="font-style: italic;">closed function</span>.\

For example, assume the following definition of a graph defined by the
transition function <span style="font-style: italic;">arcsto()</span>:\

     create function arcsto(Integer node)-> Bag of Integer n as stored;

     set arcsto(1) = bag(2,3);

     set arcsto(2) = bag(4,5);

     set arcsto(5) = bag(1);


The following query traverses the graph starting in node 1:\

    Amos 5> tclose(#'arcsto', 1);

     1

     3

     2

     5

     4


In general the function *tclose()* traverses a graph where the edges
(arcs) are defined by the transition function. The vertices (nodes) are
defined by the arguments and results of calls to the transition function
<span style="font-style: italic;">fno</span>, <span
style="font-style: italic;"></span> <span style="font-style:
        italic;"></span>i.e. a call to the transition function <span
style="font-style: italic;">fno</span> defines the neighbors of a node
in the graph. The graph may contain loops and <span
style="font-style: italic;">tclose()</span> will remember what vertices
it has visited earlier and stop further traversals for vertices already
visited.\

You can also query the inverse of *tclose()*, i.e. from which nodes
<span style="font-style: italic;">f </span>can be reached, by the query:

    Amos 6> select f from Integer f where 1 in tclose(#'arcsto',f);

     1

     5

     2


If you know that the graph to traverse is a tree or a directed acyclic
graph (DAG) you can instead use the faster function\

       traverse(Function fno, Object o) -> Bag of Object


The children in the tree to traverse is defined by the transition
function *fno*. The tree is traversed in pre-order depth first. Leaf
nodes in the tree are nodes for which <span
style="font-style: italic;">fno</span> returns nothing. The function
<span style="font-style: italic;">traverse()</span> will not terminate
if the graph is circular. Nodes are visited more than once for acyclic
graphs having common subtrees.\

A transition function may have *extra* arguments and results, as long as
it is closed. This allows to pass extra parameters to a transitive
closure computation. For example, to compute not only the transitive
closure, but also the distance from the root of each visited graph node,
specify the following transition function:\

    create function arcstod(Integer node, Integer d) -> Bag of (Integer,Integer)

      as select arcsto(node),1+d;


and call\

    tclose(#'arcstod',1,0);


which will return\

    (1,0)

    (3,1)

    (2,1)

    (5,2)

    (4,2)

Notice that only the first argument and result in the transition
function define graph vertices, while the remaining arguments and
results are extra parameters for passing information through the
traversal, as with *arcstod()*. Notice that there may be no more than
*three* extra parameters in a transition function.\

### 2.6.7 Iteration

The function *iterate()* applies a function *fn()* repeadely.
Signature:\

         iterate(Function fn, Number maxdepth, Object x) -> Object r

The iteration is initialized by setting *x~0~=x*. Then *x~i+1~=
fn(x~i~)* is repeadedly computed until one of the following conditions
hold:\
    i) there is no change (*x~i~* *=* *x~i+1~*), or\
   ii) *fn()* returns *nil* ** (*x~i+1~* *= nil*), or\
  iii) an upper limit  *maxdepth* of the number of iterations is reached
for *x~i~*.\
\
 There is another overloaded variant of *iterate()* that accepts an
extra parameter *p* passed into *fn(x~i~,p)* in the iterations.
Signature:\

         iterate(Function fn, Number maxdepth, Object x0, Object p) -> Object r

This enables flexible termination of the iteration since *fn(x,p)* can
return *nil* based on both *x* and *p*.\

### <span style="font-weight:
        bold;"></span>2.6.8 Abstract functions

Sometimes there is a need to have a function defined for subtypes of a
common supertype, but the function should never be used for the
supertype itself. For example, one may have a common supertype <span
style="font-family: monospace;">Dog</span> with two subtypes <span
style="font-family: monospace;">Beagle</span> and <span
style="font-family: monospace;">Poodle</span>. One would like to have
the function <span style="font-family: monospace;">bark</span> defined
for different kinds of dogs, but not for dogs in general. In this case
one defines the <span style="font-family:
        monospace;">bark</span> function for type <span
style="font-family: monospace;">Dog</span> as an <span
style="font-style: italic;">abstract function</span>, for example::\

    create type Dog;

    create function name(Dog)->Charstring as stored;

    create type Beagle under Dog;

    create type Poodle under Dog;

    create function bark(Dog d) -> Charstring as foreign 'abstract-function';

    create function bark(Beagle d) -> Charstring;

    create function bark(Poodle d) -> Charstring;

    create Poodle(name,bark) instances ('Fido','yip yip');

    create Beagle(name,bark) instances ('Snoopy','arf arf');


Now you can use *bark()* as a function over dogs in general, but only if
the object is a subtype of <span
style="font-family: monospace;">Dog</span>:\

    Amos 15> select bark(d) from dog d;

    "arf arf"

    "yip yip"


An abstract function is defined by:\

    create function foo(...)->... as foreign 'abstract-function'.

An abstract functions are implemented as a [foreign
function](#foreign-functions) whose [implementation](#simple-foreign)
<span style="font-family: monospace;">is named
'abstract-function'</span>. If an abstract function is called it gives
an informative error message. For example,  if one tries to call
*bark()* for an object of type <span
style="font-family: monospace;">Dog</span>, the following error message
is printed:\

    Amos 16> create Dog instances :buggy;

    NIL

    Amos 17> bark(:buggy);

    BARK(DOG)->CHARSTRING

     is an abstract function requiring a more specific argument signature than

     (DOG) for arguments

     (#[OID 1009])


### 2.6.9 Deleting functions

Functions are deleted with the `delete function` statement.

Syntax:

`delete-function-stmt ::= 'delete function' ` `function-name` ` `\
\
 For example:\
   \
 `delete function married; `\
\
 Deleting a function also deletes all functions calling the deleted
function.

2.7 Updates
-----------

Information stored in sa.amos represent mappings between function
arguments and results. These mappings are either defined at object
creation time ([Objects](#create-object)), or altered by one of the
function *update statements:* *set*, *add*, or *remove*. The 
[extent](#function-extent)  of a function is the bag of tuples mapping
its arguments to corresponding results. Updating a stored function means
updating its extent.

Syntax:

    update-stmt ::=

            update-op update-item [from-clause] [where-clause] 



    update-op ::= 

            'set' | 'add' | 'remove' 



    update-item ::= 

            function-name '(' expr-commalist ')' '=' expr

\
 For example, assume we have defined the following functions:\

        create function name(Person) -> Charstring as stored;

     create function hobbies(Person) -> Bag of Charstring as stored;

Furthermore, assume we have created two objects of type <span
style="font-style: italic;">Person</span> bound to the interface
variables <span style="font-style: italic;">:sam</span> and <span
style="font-style: italic;">:eve</span>:\

        create Person instances :sam, :eve;

The <span style="font-style: italic;">set </span>statement sets the
value of an updatable function given the arguments.\
 For example, to set the names of the two persons, do:\

        set name(:sam) = "Sam";

     set name(:eve) = "Eve";

<span style="font-family: monospace;"> </span>To populate a bag valued
function you can use [bag construction:](#Bags)\

    set hobbies(:eve) = bag("Camping","Diving");

The <span style="font-style: italic;">add </span>statement adds a result
object to a bag valued function.\
 For example, to make Sam have the hobbies sailing and fishing, do:\

        add hobbies(:sam) = "Sailing";

     add hobbies(:sam) = "Fishing";

The <span style="font-style: italic;">remove </span>statement removes
the specified tuple(s) from the result of an updatable bag valued
function, for example:\

        remove hobbies(:sam) = "Fishing";

The statement\

        set hobbies(:eve) = hobbies(:sam);

will update Eve's all hobbies to be the same a Sam's hobbies.\
\
 Several object properties can be assigned by queries in update <span
style="font-style: italic;"></span> statements. For example, to make Eve
have the same hobbies as Sam except sailing, do:\

        set hobbies(:eve) = h

     from Charstring h

     where h in hobbies(:sam) and

     h != "Sailing";

<span style="font-family: monospace;"></span> <span
style="font-family: monospace;"></span>Here a query first retrieves all
hobbies *h* of *:sam* before the hobbies of *:eve* are set.\
\
 A boolean function can be set to either <span style="font-style:
      italic;">true</span> or <span
style="font-style: italic;">false</span>.\

        create function married(Person,Person)->Boolean as stored;

     set married(:sam,:eve) = true;

Setting the value of a boolean function to <span style="font-style:
      italic;">false</span> means that the truth value is removed from
the extent of the function. For example, to divorce Sam and Eve you can
do either of the following:\

        set married(:sam,:eve)=false;




 or

        remove married(:sam) = :eve;

Not every function is updatable. sa.amos defines a function to be
updatable if it is a stored function, or if it is derived from a single
updatable function with a join that includes all arguments. In
particular inverses to stored functions are updatable. For example, the
following function is updatable:\

        create function marriedto(Person p) -> Person q

     as select q where married(p,q);

The user can define [update procedures](#user-update-functions) for
derived functions making also non-updatable functions updatable.\

### 2.7.1 Cardinality constraints

A *cardinality constraint* is a system maintained restriction on the
number of allowed occurrences in the database of an argument or result
of a [stored function](#stored-function). For example, a cardinality
constraint can be that there is at most one salary per person, while a
person may have any number of children. The cardinality constraints are
normally specified by the result part of a stored function's signature.\
\
 For example, the following restricts each person to have one salary
while many children are allowed:\
\
 <span style="font-family: monospace;">   create function salary(Person
p) -&gt; Charstring nm\
      as stored;\
    create function children(Person p) -&gt; Bag of Person\
      as stored;\
 </span>\
 The system prohibits database updates that violate the cardinality
constraints.  For the function *salary()* an error is raised if one
tries to make a person have two salaries when updating it with the [add
statement](#updates), while there is no such restriction on *children()*
<span style="font-family:
      monospace;"></span>. If the cardinality constraint is violated by
a database update the following error message is printed:\
\
 <span style="font-family: monospace;">   Update would violate upper
object participation (updating function ...)</span>\
\
 In general one can maintain four kinds of cardinality constraints for a
function modeling a relationship between types, <span
style="font-style: italic;">many-one, many-many, one-one,</span> and
<span style="font-style: italic;">one-many</span>:\

-   <span style="font-style: italic;">many-one</span> is the default
    when defining a stored function as in *salary()* <span
    style="font-family: monospace;"></span>.\
    \
-   <span style="font-style: italic;">many-many</span> is specified by
    prefixing the result type specification with 'Bag of' as in
    *children()<span style="font-family:
                monospace;"></span>*. In this case there is no
    cardinality constraint enforced.\
    \
-   <span style="font-style: italic;">one-one</span> is specified by
    suffixing a result variable with ' <span
    style="font-family: monospace;">key</span>'\
     For example:\
     <span style="font-family: monospace;">   create function
    name(Person p) -&gt; Charstring nm key\
          as stored;\
     </span>will guarantee that a person's name is unique.\
    \
-   <span style="font-style: italic;">one-many</span> is normally
    represented by an inverse function with cardinality constraint
    *many-one*. For example, suppose we want to represent a one-many
    relationship between types *Department* ** and *Employee*, i.e.
    there can be many employees for a given department but only one
    department for a given employee. The recommended way is to define
    the function *department()* enforcing a many-one constraint between
    employees as departments:\
    \
     <span style="font-family: monospace;">  create function
    department(Employee e) -&gt; Department d\
         as stored;\
     </span>\
     The inverse function can then be defined as a derived function:\
    \
     <span style="font-family: monospace;">  create function
    employees(Department d) -&gt; Bag of Employee e</span>\
     <span style="font-family: monospace;">    as select e
    where department(e) = d;</span>\
    \
     Since inverse functions are [updatable](#updates) the function
    *employees()* is also updatable and can be used when
    [populating](#create-object)the database.\

Any variable in a stored function can be specified as <span
style="font-style: italic;">key</span>, which will restrict the updates
the stored functions to maintain key uniqueness for the argument or
result of the stored function. For example, the cardinality constraints
on the following function *distance()* <span
style="font-family: monospace;"> ** </span>prohibits more than one
distance between two cities:\
 <span style="font-family: monospace;"> \
   create function distance(City x key, City y  key) -&gt;  Integer d\
     as stored;</span>\
\
 Cardinality constraints can also be specified for [foreign
functions](#foreign-functions), which is important for optimizing
queries involving foreign functions. However, it is up to the foreign
function implementer to guarantee that specified cardinality constraints
hold.\

### 2.7.2 Changing object types\

The `add-type-stmt` changes the type of one or more objects to the
specified type.

Syntax:

    add-type-stmt ::=

            'add type' type-name ['(' [generic-function-name-commalist] ')'] 

            'to' variable-commalist

The updated objects may be assigned initial values for all the specified
property functions in the same manner as in the [create object
statement](#create-object).

The `remove-type-stmt` makes one or more objects no longer belong to the
specified type.\

Syntax:

    remove-type-stmt ::= 

            'remove type' type-name 'from' variable-commalist

Removing a type from an object may also remove properties from the
object.   If all user defined types have been removed from an objects,
the object will still be member of type *Userobject*.\

###

### 2.7.3 Dynamic updates

Sometimes it is necessary to be able to create objects whose types are
not known until runtime. Similarly one may wish to update functions
without knowing the name of the function until runtime. For this there
are the following system procedural system functions:

`createobject(Type t)->Object      createobject(Charstring tpe)->Object      deleteobject(Object o)->Boolean      addfunction(Function f, Vector argl, Vector resl)->Boolean      remfunction(Function f, Vector argl, Vector resl)->Boolean      setfunction(Function f, Vector argl, Vector resl)->Boolean        `\
 *createobject()* creates an object of the type specified by its
argument.

*deleteobject()* deletes an object.

The [procedural](#procedures) system functions *setfunction()*,
*addfunction()*, and *remfunction()* update a function given an argument
list and a result tuple as vectors. They return `TRUE` if the update
succeeded.\

To delete all rows in a stored function <span style="font-style:
        italic;">fn</span>, use\

    dropfunction(Function fn, Integer permanent)->Function

If the parameter <span style="font-style: italic;">permanent</span> is
the number one the deletion cannot be rolled back, which saves space if
the extent of the function is large.\

2.8 Data mining primitives
--------------------------

sa.amos provides primitives for advanced analysis, aggregation, and
visualizations of data collections. This is useful for data mining
applications, e.g. for clustering and identifying patterns in data
collections. Primitives are provided for analyzing both unordered
collections (bags) and ordered collections (vectors). In particular
ordered collections are often used in data mining and for this the
[vselect statement](#vselect) provides a powerful way to specify queries
returning vectors. Another important issue is [grouping
data](#grouped-selection) based on some grouping criteria and [top-k
queries](#top-k-queries), which are handled by the group by construct
supported both for [regular queries](#select-statement)and [vector
queries](#vselect). System functions are provided for basic [numerical
vector](#vector-numerical) computations, [distance](#distance-functions)
computations, and  [statistical](#statistical-functions)computations .
The results of the analyzes can be visualized by calling an external
[data visualization](#plot) package.\

### 2.8.1 Numerical vector functions

For numerical vectors the <span style="font-style: italic;">times()
</span>function (infix operator: **\*** ) is defined as the scalar
product:\
 <span style="font-family: monospace;">  times(Vector x, Vector y) -&gt;
Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **\*** {4, 5,
6};</span>\
 returns the number 32.\
\
 For numerical vectors the <span style="font-style: italic;">elemtimes()
</span>function (infix operator: **.\***) is defined as the element wise
product for vectors of numbers:\
 <span style="font-family: monospace;">  elemtimes(Vector x, Vector y)
-&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **.\*** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{4, 10, 18}</span>.\
\
 For numerical vectors the <span style="font-style: italic;">elemdiv()
</span>function (infix operator: **./**) is defined as the element wise
fractions:\
 <span style="font-family: monospace;">  elemdiv(Vector x, Vector y)
-&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **./** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{0.25, 0.4, 0.5}</span>.\
\
 For numerical vectors the <span style="font-style: italic;">elempower()
</span>function (infix operator: **.\^**) is defined as the element wise
power:\
 <span style="font-family: monospace;">  elempower(Vector of Number x,
Number exp) -&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **.\^** 2;</span>\
 returns `{1, 4, 9}`.\
\
 For numerical vectors the <span style="font-style: italic;">plus()
</span> and <span style="font-style: italic;">minus() </span>functions
(infix operators: + and - ) are defined as the element wise sum and
difference, respectively:\
 <span style="font-family: monospace;">  plus(Vector of number x, Vector
of number y) -&gt; Vector of Number r</span>\
 <span style="font-family: monospace;">  minus(Vector of number x,
Vector of number y) -&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **+** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{5, 7, 9}</span> and\
 <span style="font-family: monospace;">  {1, 2, 3} **-** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{-3, -3, -3}</span>.\
\
 The *times()* and *div()* functions (infix operators: \* and / ) scale
vectors by a scalar:\
 `  times(Vector of number x,Number y) -> Vector of Number r`\
 `  div(Vector of number x,Number y) -> Vector of Number r`\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **\*** 1.5; </span>\
 returns <span style="font-family: monospace;">{1.5, 3.0, 4.5}</span>\
\
 For user convenience, *plus()* and *minus()* functions (infix
operators: + and -) allow mixing vectors and scalars:\
 `  plus(Vector of Number x, Number y) -> Vector of Number r`\
 `  minus(Vector of Number x, Number y) -> Vector of Number r `\
 For example:\
 `  {1, 2, 3} + 10;`\
 returns `{11, 12, 13}` and\
 `  {1, 2, 3} - 10;`\
 returns `{-9, -8, -7}`.\
\
 These functions can be used in queries too:\

`  select lambda        from number lambda       where {1, 2} - lambda = {11, 12};`\
 returns `-10`.\
\
 If the equation has no solution, the query will have no result:\

`  select lambda        from number lambda       where {1, 3} - lambda = {11, 12};`\
\
 By contrast, note that this query:\

`  select lambda       from vector of number lambda      where {1, 2} - lambda = {11, 12};`\
 returns `{-10,-9}`.\
\
 <span style="font-family: Times New Roman;">The functions *zeros()* and
*ones()* generate vectors of zeros and ones, respectively:\
 <span style="font-family: monospace;">   zeros(Integer)-&gt; Vector of
Number\
   ones(Integer)-&gt; Vector of Number</span>\
 For example:\
 <span style="font-family: monospace;">  **zeros**(5);\
 </span> results in <span style="font-family: monospace;">{0, 0, 0, 0,
0}</span>\
 <span style="font-family: monospace;">  3.1 \* **ones**(4);\
 </span> results in <span style="font-family: monospace;">{3.1, 3.1,
3.1, 3.1}</span>\
\
 </span>The function *roundto()* rounds each element in a vector of
numbers to the desired number of decimals:\
 <span style="font-family: monospace;">  roundto(Vector of Number v,
Integer d) -&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  **roundto**({3.14159, 2.71828},
2);\
 </span> returns <span style="font-family: monospace;">{3.14, 2.72}
</span>\
\
 The function *vavg()* computes the average value <span
style="font-style: italic;">a</span> of a vector of numbers <span
style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  vavg(Vector of Number v) -&gt;
Real a</span>\
\
 The function *vstdev()* computes the standard deviation <span
style="font-style: italic;">s</span> of a vector of numbers <span
style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  vstdev(Vector of Number v)
-&gt; Real s</span>\
\
 The function <span style="font-style: italic;">median() </span>computes
the median <span style="font-style: italic;">m</span> of a vector of
numbers <span style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  median(Vector of Number v)
-&gt; Number m\
\
 </span> <span style="font-family: Times New Roman;"> The function
*euclid()* computes the Euclidean distance between two points <span
style="font-style: italic;">p1</span> and <span
style="font-style: italic;">p2</span> expressed as vectors of numbers:\
 </span> <span style="font-family: monospace;">  euclid(Vector of Number
p1, Vector of Number p2) -&gt; Real d</span> <span
style="font-family: Times New Roman;">\
\
 The function *minkowski()* computes the Minkowski distance between two
points *p1* and *p2* expressed as vectors of numbers, with the Minkowski
parameter *r*:\
 <span style="font-family: monospace;">  minkowski(Vector of Number p1,
Vector of Number p2, Real r) -&gt; Real d</span>\
\
 The function *maxnorm()* computes the Maxnorm distance between two
points *p1* and *p2* (conceptually, this is the same as the Minkowski
distance with *r* = infinity):\
 <span style="font-family: monospace;">  maxnorm(Vector of Number p1,
Vector of Number p2) -&gt; Real d</span> </span>\

### <span style="font-family: Times New Roman;"> 2.8.2 Vector aggregate functions</span>

<span style="font-family: Times New Roman;">The following functions
group and compute aggregate values over collections of numerical
vectors.\
\
 Dimension-wise aggregates over bags of vectors can be computed using
the function *aggv*:\
 <span style="font-family: monospace;">  aggv(Bag of Vector, Function)
-&gt; Vector</span>\
 For example:\
 <span style="font-family: monospace;">  **aggv**((select {i, i + 10}\
           from integer i\
          where i in [iota](#iota)(1, 10)),
[\#'avg'](#functional-constant));\
 </span> returns in <span style="font-family: monospace;">{5.5, 15.5}
</span>\
\
 Each dimension in a bag of vector of number can be normalized using one
of the normalization functions *meansub()*, *zscore()*, or *maxmin()*.
They all have the same signature:\
 </span>

    meansub(Bag of Vector of Number b) -> Bag of Vector of Number

    zscore(Bag of Vector of Number b) -> Bag of Vector of Number

    maxmin(Bag of Vector of Number b) -> Bag of Vector of Number




*meansub()* transforms each dimension to a *N(0, s)* distribution
(assuming that the dimension was *N(u, s)* distributed) by subtracting
the mean *u* of each dimension. *zscore()* transforms each dimension to
a *N(0, 1)* distribution by also dividing by the standard deviation of
each dimension. *maxmin()* transforms each dimension to be on the \[0,
1\] interval by applying the transformation <span
style="font-family: monospace;">(w - min) ./ (max - min)</span> to each
vector *w* in bag *b* where *max* and *min* are computed using <span
style="font-family: monospace;">aggv(b, \#' [maxagg](#maxagg)')</span>
and <span style="font-family: monospace;">aggv(b,
\#'[minagg](#minagg)')</span> respectively.\
 For example:\

    meansub((select {i, i/2 + 10}

     from integer i

     where i in iota(1, 5)));


returns

    {-2.0,-1.0}

    {-1.0,-0.5}

    {0.0,0.0}

    {1.0,0.5}

    {2.0,1.0}


Principal Component Analysis is performed using the function *pca()*:\
 <span style="font-family: monospace;">   pca(Bag of Vector data)-&gt;
(Vector of Number eigval D, Vector of Vector of Number eigvec W)</span>\
 *pca()* takes a bag of *M*-dimensional vectors in *data* and computes
the *M*x*M* covariance matrix *C* of the input vectors. Then, *pca()*
computes the *M* eigenvalues *D* and the *M*x*M* eigenvector matrix *W*
of the covariance matrix. *pca()* returns the eigenvalues *D* and their
corresponding eigenvectors *W*.\
\
 To use *pca()* to reduce the dimensionality to the *L* most significant
dimensions, each input vector must be projected onto the eigenvectors
corresponding to the *L* greatest eigenvalues using the scalar product.
This is done using the function *pcascore()*:\

`  pcascore(Bag of Vector of Number, Integer d) -> Vector of Number score`\
 *pcascore()* performs PCA on *data*, and projects each data vector in
*data* onto the *d* first eigenvectors. Each projected vector in *data*
is emitted.\
 The function *LPCASCORE* allows a label to be passed along with each
vector:\

`  lpcascore(Bag of (Vector of Number, Object label), Integer d) -> (Vector of Number score, Object label)`\
 The label of each vector remains unchanged during projection.\
\
 Note that the input data might have to be pre-processed, using some
[vector normalization](#vnorm).\

### 2.8.3 Plotting numerical data

AmosII can utilize GNU Plot (v 4.2 or above), to plot numerical data.
The *plot()* function is used to plot a line connecting two-dimensional
points. Each vector in the vector `v` is a data point. *plot()* will
plot the points in the order they appear in the *v*.\
 `  plot(Vector of Vector v) -> Integer`\
 The return value is the exit code of the plot program. A nonzero value
indicates error.\
 If the data points have a higher dimensionality than two, the optional
argument *projs* is used to select the dimension to be plotted.\
 `  plot(Vector of Integer projs, Vector of Vector v) -> Integer`\
 The `projs` vector lists the dimensions onto which each data vector is
to be projected. The first dimension has number 0 (zero).\
\
 Scatter plots of bags of two-dimensional vectors are generated using
*scatter2()*.\
 *scatter2p()* and *scatter2l*() plots three-dimensional data in two
dimensions. *scatter2p()* assigns a color temperature of each point
according to the value of its value in the third dimension.
*scatter2l*() labels each point in the two-dimensional plot with the its
value of the third dimension. The value of the third dimension in
*scatter2l()* could be numerical or textual.\
\
 Three-dimensional scatter plots are generated using *scatter3()*,
*scatter3l()*, and *scatter3p()*. *scatter3()* plots 3-dimensional data,
whereas *scatter3l()* and *scatter3p()* plot 4-dimensional data in the
same fashion as *scatter2p()* and *scatter2l()*.\
 Each scatter plot function have two different signatures:

    scatter2(Bag of Vector v) -> Integer

    scatter2l(Bag of Vector v) -> Integer

    scatter2p(Bag of Vector v) -> Integer

    scatter3(Bag of Vector v) -> Integer

    scatter3l(Bag of Vector v) -> Integer

    scatter3p(Bag of Vector v) -> Integer

    scatter2(Vector of Integer projs, Bag of Vector v) -> Integer

    scatter2l(Vector of Integer projs, Bag of Vector v) -> Integer

    scatter2p(Vector of Integer projs, Bag of Vector v) -> Integer

    scatter3(Vector of Integer projs, Bag of Vector v) -> Integer

    scatter3l(Vector of Integer projs, Bag of Vector v) -> Integer

    scatter3p(Vector of Integer projs, Bag of Vector v) -> Integer




2.9 Accessing data in files
---------------------------

The file system where an sa.amos server is running can be accessed with
a number of system functions:\
\
 The function *pwd()* returns the path to the current working directory
of the server:\
 <span style="font-family: monospace;">  pwd() -&gt; Charstring
path</span> <span style="font-family: monospace;">\
\
 </span>The function *cd()* changes the current working directory of the
server:\
 <span style="font-family: monospace;">  cd(Charstring path) -&gt;
Charstring </span> <span style="font-family: monospace;">\
 </span>\
 The function *dir()* returns a bag of the files in a directory <span
style="font-style: italic;"></span>:\
 <span <style="font-family: monospace;">
`  dir() -> Bag of Charstring file` `        `
`   dir(Charstring path) -> Bag of Charstring file` `        `
`   dir(Charstring path, Charstring pat) -> Bag of Charstring file`\
 </span>\
 The first optional argument *path* specifies the path to the directory.
The second optional argument *pat* specifies a regular expression (as in
like) to match the files to return.'\
 The function *file\_exists()* returns true if a file with a given name
exists:\
 <span style="font-family: monospace;">  file\_exists(Charstring file)
-&gt; Boolean</span>\
\
 The function *directoryp()* returns true if a path is a directory:\
 <span style="font-family: monospace;">  directoryp(Charstring path)
-&gt; Boolean</span>\
\
 The function *filedate()* returns the write time of a file with a given
name:\
 <span style="font-family: monospace;">  filedate(Charstring file) -&gt;
Date</span>\
 <span style="font-family: Times New Roman;"> `` </span> <span
style="font-family: Times New Roman;"> </span>

### 2.9.1 Reading and writing files

The function *readlines()* returns the lines in a file as a bag of
strings:\

`  readlines(Charstring file) -> Bag of Charstring        readlines(Charstring file, Charstring sep) -> Bag of Charstring        `
The optional second argument *sep* specifies the character used to
separate the lines. The default is the standard line separator.\
\
\
 The function *csv\_file\_tuples()* reads a CSV (*Comma Separated
Values)* file. Each line is returned as a vector.

For example, if a file named *myfile.csv* contains the following lines:\
 `1,2.3,a b c` `            ` `4,5.5,d e f` `            ` the result
from the call *csv\_file\_tuples("myfile.csv")* is a bag containing
these vectors:\
 `{1,2.3,"a b c"}` `            ` `{4,5.5,"d e f"}` `            `\
 The CSV reader can, e.g., read CSV files saved by EXCEL, but is has to
be in **English** format.\
\
\
 The function *read\_ntuples()* imports data from a text file of space
separated values. Each line of the text file produces one vector in the
result bag. Each token on a line will be parsed into field in the
vector. Numbers in the file are parsed into numbers. All other tokens
are parsed into strings.\
 `  read_ntuples(Charstring file) -> Bag of Vector`\
\
 For example, if a file name *test.nt* contains the following:\
 `"This is the first line" another word` `            ` `            `
`1 2 3 4.45 2e9` `            ` `            `
`"This line is parsed into two fields" 3.14` `            ` <span
style="font-family: Times New Roman;"> ` `\
 the call *read\_ntuples("test.nt")* returns a bag with the following
vectors:\
 `{"This is the first line","another","word"}` `                `
`                ` `                ` `{1,2,3,4.45,2000000000.0}`
`                ` `                `
`{"This line is parsed into two fields",3.14}` <span
style="font-family: Times New Roman;"></span> <span
style="font-family: Times New Roman;">\
\
\
 The function *writecsvfile()* writes the vectors in a bag *b* into a
file in CSV (Comma Separated Values) format so that it can loaded into,
e.g., EXCEL.\
 `  writecsvfile(Charstring file, Bag b) -> Boolean         `\
\
 For example, the following statement:\

`  writecsvfile("myoutput.csv", bag({1,"a b",2.2},{3,"d e",4.5})                    `
produces the a file *myoutput.csv* having these lines:\
 `1,a b,2.2` `                    ` `3,d e,4.5` `                    `\
\
 The function *write\_ntuples()* writes a bag of vectors into a files as
space separated tokens in lines so that they can be read again with
*read\_ntuples()*:\
 `  write_ntuples(Bag of Vector rowset, Charstring file) -> Charstring`\
 </span> </span>

2.10 Scans
----------

*Scans* provide a way to iterate over a very large result of a
[query](#query-statement), a [function call](#function-call), [variable
value](#variables), or any [expression](#expressions) without explicitly
saving the result in memory. The [open-cursor-stmt](#open-cursor) opens
a new <span style="font-style: italic;">scan</span> on the result of an
expression. A scan is a data structure holding a current element, the
<span style="font-style: italic;">cursor</span>, of a potentially very
large bag of values produced by a query, function call, or variable
binding. The next element in the bag is retrieved by the [fetch
cursor](#fetch-statement) statement. Every time a fetch cursor statement
<span style="font-family: Times New Roman;"> is executed the cursor is
moved forward over the bag. When the end of the scan is reached the
fetch cursor statement</span> <span style="font-family: Times
      New Roman;"> returns empty result. The user can test whether there
is any more elements in a scan by calling one of the functions\
 </span> <span style="font-family: monospace;">   more(Scan s)   -&gt;
Boolean\
    nomore(Scan s) -&gt; Boolean\
 </span> <span style="font-family: Times New Roman;">that test whether
the scan is has more rows or not, respectively. </span> <span
style="font-family: Times New Roman;">\
 </span>

Syntax:

          open-cursor-stmt ::=

            'open' cursor-name 'for' expr



    cursor-name ::= 

            variable 




          fetch-cursor-stmt ::= 

            'fetch' cursor-name [into-clause]




          close-cursor-stmt ::=

            'close' cursor-name

<span style="font-family: Times New Roman;">If the optional *into*
clause is present in a fetch cursor statement, it will bind elements of
the first result tuple to variables. There must be one variable for each
element in the next cursor tuple. <span
style="font-family: Times New Roman;"> </span></span>

If no *into<span style="font-family: monospace;"></span>* ** clause is
present in a fetch cursor statement a single result tuple is fetched and
displayed.

For example:

    create person (name,age) instances :Viola ('Viola',38);

    open :c1  for (select p from Person p where name(p) = 'Viola'); 

    fetch :c1 into :Viola1;

    close :c1; 

    name(:Viola1); 

    --> "Viola";

<span style="font-family: Times New Roman;"> </span>

The [close cursor statement](#close-cursor) deallocates the scan.\

Cursors allow iteration over very large bags created by queries or
function calls. For example,\

    set :b = (select iota(1,1000000)+iota(1,1000000));

    /* :b contains a bag with 10**12 elements! */



    open :c for :b;

    fetch :c;

    -> 2

    fetch :c;

    -> 3

    etc.

    close :c;

<span style="font-family: Times New Roman;"></span> <span
style="font-family: Times New Roman;"> </span>

Cursors are implemented using a special datatype called <span
style="font-style: italic;">Scan</span> that allows iterating over very
large bags of tuples. The following functions are available for
accessing the tuples in a scan as vectors:\

<span style="font-family: Times New Roman;"> </span>

<span style="font-family: monospace;">next(Scan s)-&gt;Vector</span>\
 moves the cursor to the next tuple in a scan and returns the cursor
tuple. The [fetch cursor statement](#fetch-statement) is syntactic sugar
for calling *next()*.\

<span style="font-family: Times New Roman;"> </span>

<span style="font-family: monospace;">this(Scan s)-&gt;Vector</span>\
 returns the current tuple in a scan without moving the cursor forward.\

<span style="font-weight: bold;"></span> <span
style="font-family: monospace;">peek(Scan s)-&gt;Vector</span>\
 <span style="font-family: Times New Roman;"> </span>

returns the next tuple in a scan without moving the cursor forward.\
