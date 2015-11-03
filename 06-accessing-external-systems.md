6 Accessing external systems
============================

<span style="font-family: Times New Roman;"> </span>

This chapter first describes <span style="font-style:
          italic;">multi-directional foreign functions</span>
[\[LR92\]](#LR92), the basis for accessing external systems from Amos II
queries. Then we describe how to query relational databases through Amos
II. Finally some general types and functions used for defining wrappers
of external sources are described.

Amos II provides a number of primitives for accessing different external
data sources by defining *wrappers* for each kind external sources. A
wrapper is a software module for making it possible to query an external
data source using AmosQL. The basic wrapper interface is based on user
defined <span style="font-style: italic;">multi-directional</span>
foreign functions having various <span
style="font-style: italic;">capabilities</span> used to access external
data sources in different ways [\[LR92\]](#LR92) depending on what
variables are bound or free in an execution plan, the <span
style="font-style:
          italic;">binding patterns</span>. On top of the basic foreign
function mechanism object oriented abstractions are defined through
<span style="font-style: italic;">mapped types</span> [\[FR97\]](#FR97).
A number of important query rewrite techniques used in the system for
scalable access to wrapped sources, in particular relational databases,
are described in [\[FR97\]](#FR97). Rewrites for handling scalable
execution of queries involving late bound function calls are described
in [\[FR95\]](#FR95). Multi-database views are further described
in [\[JR99a\]](#JR99a)[\[JR99b\]](#JR99b). The distributed query
decomposer is described in [\[JR02\]](#JR02) and [\[RJK03\]](#KJR03).\

A general wrapper for [relational databases](#relational) using JDBC is
predefined in Amos II.

6.1 Foreign and multi-directional functions
-------------------------------------------

The basis for accessing external systems from Amos II is to define <span
style="font-style: italic;">foreign functions</span>. A foreign function
allows subroutines defined in C/C++ [\[Ris12\]](#Ris00a), Lisp
[\[Ris06\]](#Ris00b), or Java [\[ER00\]](#ER00) to be called from Amos
II queries. This allows access to external databases, storage managers,
or computational libraries. A foreign function is defined by the
following [function implementation](#fn-implementation):\
\

`         foreign-body ::= simple-foreign-definition | multidirectional-definition                           simple-foreign-body ::= 'foreign' [string-constant]                           multidirectional-definition ::= 'multidirectional' capability-list                           capability ::= (binding-pattern 'foreign' `
`string-constant       ` `['cost' cost-spec]['rewriter' `
`string-constant` `])                           binding-pattern ::= `A
string constant containing 'b':s <span style="font-family:
      Times New Roman;"> and </span>'f':s <span style="font-family:
      Times New Roman;">
`                   cost-number ::= integer-constant | real-constant                   cost-spec ::= function-name | '{' cost-number ',' cost-number '}'                         `
<span style="font-family: times new roman;">  For example: </span>
`                     create function iota(Integer l, Integer u) -> Bag of Integer              as foreign 'iota--+';                              create function sqroots(Number x)-> Bag of Number r              as multidirectional                 ("bf" foreign 'sqrts' cost {2,2})                 ("fb" foreign 'square' cost {1.2,1});            create function bk_access(Integer handle_id )->(Vector  key, Vector)                 /* Access rows in BerkeleyDB table */                                  as multidirectional                 ('bff' foreign 'bk_scan' cost bk_cost rewriter 'abkw')                 ('bbf' foreign 'bk_get' cost {1002, 1});            create function myabs(real x)->real y              as multidirectional                 ("bf" foreign "JAVA:Foreign/absbf" cost {2,1})                 ("fb" foreign "JAVA:Foreign/absfb" cost {4,2});                `\
 The syntax using [multidirectional definition](#multidirectional)
provides for specifying different implementations of foreign functions
depending on what variables are known for a call to the function in a
query execution plan, which is called different [<span
style="font-style:
          italic;">binding patterns</span>](#binding-pattern). The
simplified syntax using [simple-foreign-body](#simple-foreign) is mainly
for quick implementations of functions without paying attention to
different implementations based on different binding patterns.\
\
 A foreign function can implement one of the following:\
 </span>

1.  A <span style="font-style: italic;"> filter </span>which is a
    predicate, indicated by a foreign function whose result is of type
    <span style="font-style: italic;">Boolean</span>, e.g. '&lt;', that
    succeeds when certain conditions over its results are satisfied.
2.  A <span style="font-style: italic;"> computation </span>that
    produces a result given that the arguments are known, e.g. + or
    <span style="font-family: monospace;">sqrt</span>. Such a function
    has no argument nor result of type <span
    style="font-style: italic;">Bag</span>.\
3.  A <span style="font-style: italic;"> generator </span>that has a
    result of type <span style="font-style: italic;">Bag</span>. It
    produces the result as a bag by generating a stream of several 
    result tuples given the argument tuple, e.g. [iota()](#iota) or the
    function sending SQL statements to a relational database for
    evaluation where the result is a bag of tuples.
4.  An <span style="font-style: italic;">aggregate function</span> has
    one argument of type <span style="font-style: italic;">Bag</span>
    but not result of type <span style="font-style: italic;">Bag</span>.
    It iterates over the bag argument to compute some aggregate value
    over the bag, e.g. <span
    style="font-style: italic;">average()</span>.
5.  A <span style="font-style: italic;">combiner has</span> has both one
    or several arguments of type <span
    style="font-style: italic;">Bag</span> and some result of type <span
    style="font-style: italic;">Bag</span>. It combines one or several
    bags to form a new bag. For example, basic join operators can be
    defined as combiners.\

Amos II functions in general are <span style="font-style:
        italic;">multi-directional</span>. A multi-directional function
can be executed also when the result of a function is given and some
corresponding argument values are sought. For example, if we have a
function\

        parents(Person)-> Bag of Person

we can ask these AmosQL queries:\

     parents(:p);  /* Result is the bag of parents of :p */

     select c from Person c where :p in parents(c);

                    /* Result is bag of children of :p */ 

It is often desirable to make <span
style="font-style: italic;">foreign</span> Amos II functions
multi-directional as well. As a very simple example, we may wish to ask
these queries using the square root function <span
style="font-family: monospace;">sqroots</span> above:\

     sqroots(4.0);    /* Result is -2.0 and 2.0 */

     select x from Number x where sqroots(x)=4.0;

                    /* result is 16.0 *

     sqroots(4.0)=2.0;

     /* Is the square root of 4 = 2 */




With [simple foreign functions](#simple-foreign) only the forward
(non-inverse) function call is possible. Multi-directional foreign
functions permit also the inverse to be called in queries.\
\
 The benefit of multi-directional foreign functions is that a larger
class of queries calling the function is executable, and that the system
can make better query optimization. A multi-directional foreign function
can have several [capabilities](#capability) implemented depending on
the <span style="font-style: italic;">binding pattern</span> of its
arguments and results. The binding pattern is a string of b:s and f:s,
indicating which arguments or results in a given situation are known or
unknown, respectively.\
\
 For example, *sqroots()* has the following possible binding patterns:\
\
 (1) If we know <span style="font-family: monospace;">x</span> but not
<span style="font-family: monospace;">r</span>, the binding pattern is
<span style="font-family: monospace;">"bf"</span> and the implementation
should return <span style="font-family:
        monospace;">r</span> as the square root of <span
style="font-family: monospace;">x</span>.\
 (2) If we know <span style="font-family: monospace;">r</span> but not
<span style="font-family: monospace;">x</span>, the binding pattern in
<span style="font-family: monospace;">"fb"</span> and the implementation
should return <span style="font-family:
        monospace;">x</span> as <span
style="font-family: monospace;">r\*\*2</span>.\
 (3) If we know both <span style="font-family: monospace;">r</span> and
<span style="font-family: monospace;">x</span> then the binding pattern
is <span style="font-family: monospace;">"bb"</span> and the
implementation should check that <span style="font-family: monospace;">x
= r\*\*2</span>.\
  \
 Case (1) and (2) are implemented by multi-directional foreign function
*sqroots()<span style="font-family: monospace;"></span>* above.\
 Case (3) need not be implemented as it is inferred by the system by
first executing <span style="font-family: monospace;">r\*\*2</span> and
then checking that the result is equal to <span
style="font-family: monospace;">x</span> (see [\[LR92\]](#LR92)).\
\
 To implement a multi-directional foreign function you first need to
think of which binding patterns require implementations. In the <span
style="font-style: italic;">sqroots()</span> case one implementation
handles the square root and the other one handles the square. The
binding patterns will be <span
style="font-family: monospace;">"bf"</span> for the square root and
<span style="font-family: monospace;">"fb"</span> for the square.\
\
 The following steps are required to define a foreign function:\

1.  <span style="font-style: italic;">Implement </span>each foreign
    function capability using the interface of the
    implementation language. For Java this is explained in
    [\[ER00\]](#ER00)  and for C in  [\[Ris12\]](#Ris00a).
2.  In case the foreign code implemented in C/C++ the implementation
    must be implemented as a DLL (Windows) or a shared library (Unix)
    and <span style="font-style: italic;">dynamically linked </span>to
    the kernel by calling the function
    *load\_extension("name-of-extension")*. There is an example of a
    Visual Studio project (Windows) files or a Makefile (Unix) in folder
    *demo* of the downloaded Amos II version.\
3.  The exported initializer named xxx of the DLL/shared library
    extension must assign a <span style="font-style: italic;">symbolic
    name </span> to the foreign C functions which is referenced in the
    foreign function definition ( <span style="font-family:
                monospace;"></span>sqrt and square <span
    style="font-family:
                monospace;"></span> in the example <span
    style="font-family: Times New Roman;">[above](#foreign-body)</span>)
    [\[Ris12\]](#Ris00a).
4.  Finally a multidirectional foreign function needs to be <span
    style="font-style: italic;">defined </span>through a foreign
    function definition in AmosQL as [above](#foreign-body). Here the
    implementor may associate a binding pattern and an optional [cost
    estimate](#cost-estimate) with each capability. Normally the foreign
    function definition is done separate from the actual code
    implementing its capabilities, in an AmosQL script.
5.  The system automatically realoads foreign functions in a saved
    database image when the image is restarted.\

A capability can also be defined as a select expression (i.e. query)
executed for the given binding pattern. The variables marked bound (b)
are inputs to the select expression and the result binds the free (f)
variables. For example, *sqroots()* could also have been defined by:\
\

`  create function sqroots(Number x)-> Bag of Number r              as multidirectional                 ("bf" foreign 'sqrts' cost {2,2}) /* capability by foreign function */                 ("fb" select r*r);                /* capability by query */            `\
 Notice here that *sqroots()* is defined as a foreign function when
<span style="font-style: italic;">x</span> is known and <span
style="font-style: italic;">r</span> computed, while it is a derived
function when <span style="font-style: italic;">r</span> is known and
<span style="font-style: italic;">x</span> computed. This kind of
functionality is useful when different methods are used for computing a
function and its inverses.\
\
 A capability can be defined as a key to improve query optimization,
e.g.\
\

`  create function sqroots(Number x)-> Bag of Number r              as multidirectional                 ("bf" foreign 'sqrts' cost {2,2}) /* not unique square root per x */                 ("fb" key select r*r);            /* unique square per r */                `\
 Be very careful not to declare a binding pattern as *key* unless it
really is a key for the arguments and results of the function. In the
case of <span style="font-style: italic;">sqroots()</span> the
declaration says that if you know <span style="font-style:
        italic;">r</span> you can uniquely determine <span
style="font-style: italic;">x</span>. However, there is no key for
binding pattern <span style="font-style: italic;">bf</span> since if you
know <span style="font-style: italic;">x</span> there may be severeal
(i.e. two) square roots, the positive and the negative. The key
declaraions are used by the system to optimize queries. Wrong key
declarations may result in wrong query results because the optimizer has
assumed incorrect key uniqueness.\
\
 An example of an advanced multidirectional function is the bult-in
function *plus()* (operator +):\
 <span style="font-family: Times New Roman;"></span>

    create function plus(Number x, Number y) -> Number r

     as multidirectional

     ('bbf' key foreign 'plus--+') /* addition*/

     ('bfb' key foreign 'plus-+-') /* subtraction */

     ('fbb' key select x where y+x=r); /* Addition is commutative */




<span style="font-family: Times New Roman;">For further details on how
to define multidirectional foreign functions for different
implementation languages see  [\[Ris12\]\[ER00\]](#Ris00a).\
 </span>

### 6.1.1 Cost estimates

Different capabilities of multi-directional foreign functions often have
different execution costs. In the *sqroots()* example the cost of
computing the square root is higher than the cost of computing the
square. When there are several alternative implementations of a
multi-directional foreign function the cost-based query optimizer needs
cost estimates that help it choose the most efficient implementation. In
the example we might want to indicate that the cost of executing a
square root is double as large as the cost of executing a square.\
\
 Furthermore, the cost of executing a query depends on the expected size
of the result from a function call. This is called the <span
style="font-style: italic;">fanout</span> (or <span
style="font-style: italic;">selectivity</span> for predicates) of the
call for a given binding pattern. In the multi-directional foreign
function *[sqroots()](#sqroots)* example the implementation *sqrts*
<span style="font-family:
        monospace;"></span> usually has a fanout of 2, while the
implementation *square* <span style="font-family: monospace;"></span>
has a fanout of 1.\
\
 For good query optimization each foreign function capability should
have associated *costs* and *fanouts*:\

-   The <span style="font-style: italic;">cost </span>is an estimate of
    how expensive it is to completely execute (emit all tuples of) a
    foreign function for given arguments.
-   The *fanout* estimates the expected number of elements in the result
    stream (emitted tuples), given the arguments.

The cost and fanout for a multi-directional foreign function
implementation can be either specified as a constant vector of two
numbers (as in *sqroots()*) or as an Amos II <span
style="font-style: italic;">cost function </span>returning the vector of
cost and fanout for a given function call. The numbers normally need
only be rough numbers, as they are used by the query optimizer to
compare the costs of different possible execution plans to produce the
optimal one. The number 1 for the cost of a foreign function should
roughly be the cost to perform a cheap function call, such as '+' or
'&lt;'. Notice that these estimates are run a query optimization time,
not when the query is executed, so the estimates must be based on
meta-data about the multi-directional foreign function.\
\
 If the [simplified syntax](#simple-foreign) is used or no cost is
specified the system tries to put reasonable default costs and fanouts
on foreign functions, the <span style="font-style: italic;">default cost
model</span>. The default cost model estimates the cost based on the
signature of the function, index definitions, and some other heuristics.
<span style="font-family: Times New Roman;">For example, the default
cost model assumes aggregate functions are expensive to execute and
combiners even more expensive. </span> <span
style="font-family: Times New Roman;">If you have expensive foreign
functions you are strongly advised to specify cost and fanout
estimates.\
\
 The cost function <span style="font-family: monospace;">cfn</span> is
an Amos II function with signature\
 </span>

    create function <cfn>(Function f, Vector bpat, Vector args) 

     -> (Integer cost, Integer fanout) as ...;

    e.g.



    create function typesofcost(Function f, Vector bpat, Vector args)

     -> (Integer cost, Integer fanout) as foreign ...;




The cost function is normally called at compile time when the optimizer
needs the cost and fanout of a function call in some query. The
arguments and results of the cost function are:\
\
 <span style="font-family: monospace;">f</span>       is the full name
the called Amos II function.\
 <span style="font-family: monospace;">bpat</span> is the binding
pattern of the call as a [vector](#vector) of strings 'b' and 'f', e.g.
{"f","b"} indicating which arguments in the call are bound or free,
respectively.\
 <span style="font-family: monospace;">args</span> is a vector of actual
variable names and constants used in the call.\
 *cost* is the computed estimated cost to execute a call to f with the
given binding pattern and argument list. The cost to access a tuple of a
stored function (by hashing) is 2; other costs are calibrated
accordingly.\
 *fanout* is the estimated fanout of the execution, i.e. how many
results are emitted from the execution.\
\
 If the cost hint function does not return anything it indicates that
the function is not executable in the given context and the optimizer
will try some other capability or execution strategy.\
\
 The costs and fanouts are normally specified as part of the capability
specifications for a multi-directional foreign function definition, as
in the example. The costs can also be specified after the definition of
a foreign function by using the following Amos II system function:\

     costhint(Charstring fn,Charstring bpat,Vector ch)->Boolean 

e.g.\

     costhint("number.sqroots->number","bf",{4,2});

     costhint("number.sqroots->number","fb",{2,1});




<span style="font-family: monospace;">fn</span> is the full name of the
resolvent.\
 <span style="font-family: monospace;"> bpat</span> is the binding
pattern string.\
 <span style="font-family: monospace;">ch </span>is a [vector](#vector)
with two numbers where the first number is the estimated cost and the
second is the estimated fanout.\
\
 A cost function <span style="font-family: monospace;">cfn</span> can be
assigned to a capability with:\
 <span style="font-family: monospace;">costhint(Charstring fn,
Charstring bpat, Function cfn)  -&gt; Boolean\
\
 </span>To find out what cost estimates are associated with a function
use:\
 `   costhints(Function r)-> Bag of (Charstring bpat, Object q)`\
 It returns the cost estimates for resolvent *r* and their associated
binding patterns.\
\
 To obtain the estimated cost of executing an Amos II  function <span
style="font-style: italic;">f</span> for a given binding pattern <span
style="font-style: italic;">bp</span>, use\

`   plan_cost(Function r, Charstring bp)-> (Number cost, Numbers fanout)`\

6.2 The relational database wrapper
-----------------------------------

There is a predefined wrapper for relational databases using the JDBC
standard Java-based relational database interface. The JDBC wrapper is
tested with [MySQL
Connector](http://www.mysql.com/products/connector/j/) and Microsoft's
SQLServer driver. 

An instance of type *Relational* ** represents a relational database and
functions of type *Relational* implements the interface to relational
databases. The general wrapper *Relational* is an *abstract* wrapper in
the sense that it does not implement an interface a a specific
relational DBMS therefore has no instances. Several of the database
interface functions of type <span style="font-family:
          Times New Roman;">*Relational*</span> ** are defined as
[*abstract functions*](#abstract-functions). In the type hierarchy 
there is a specific implemented wrapper for JDBC represented by type
*Jdbc*. The type *Jdbc* <span style="font-family: monospace;"></span>
has one instance for each relational database JDBC connection. The type
hierarchy is currently:

     Datasource

     |

     Relational

     |

     Jdbc




If some other interface than JDBC (e.g. ODBC) is used for a relational
database it would require the implementation of a new wrapper also being
subtype to <span style="font-style: italic;">Relational</span>.\
\
 The use of abstract functions  type checking to find equivalent
implementations for different relational database interfaces.\

#### 6.2.1 Connecting\

The instances of relational data sources are created using a *datasource
constructor function* that loads necessary drivers. Later the
*connect()* function associates a <span style="font-style:
        italic;">connection </span>object to a wrapped database using
the driver.\
\
 <span style="text-decoration: underline;">Creating connections</span>\
\
 For creating a relational database connection using JDBC  use the
constructor:\
\
 <span style="font-family: monospace;">   jdbc(Charstring dsname,
Charstring driver);\
 </span>where ** <span style="font-family: monospace;"></span>*dsname*
is the chosen data source name and *driver<span
style="font-family: monospace;"></span>* is the JDBC driver to use for
the access. The created connection is an instance of the wrapper type
*Jdbc*. For example, to create a connection called 'db1' to access a
relational database using JDBC with MySQL call:\

     jdbc("db1","
          com.mysql.jdbc.Driver");






<span style="text-decoration: underline;">Connecting the data source to
a database</span>\
\
 Once the connection object has been created you can open the connection
to a specific relational database:\

     connect(Relational r, Charstring database, Charstring username, Charstring password) -> Relational

where <span style="font-style: italic;">r</span> is the data source
object, <span style="font-style: italic;">db</span> is the identifier of
the database to access, along with user name and password to use when
accessing the database. For example, if the relational database called
'Personnel' resides on the local computer and MySQL is used for the
managing it, the following opens a connection to the database for user
'U1' with password 'PW':\
\
 <span style="font-family: monospace;">   connect(:db,
"jdbc:mysql://localhost:3306/Personnel", "U1", "PW");</span>\
\
 <span style="text-decoration: underline;">Disconnecting from the
database </span>\
\
 Once the connection is open you can use the data source object for
various manipulations of the connected database. The connection is
closed with:\

     disconnect(Relational r) -> Boolean

for example:\
\
 <span style="font-family: monospace;">   disconnect(:a):\
 </span>\
 <span style="text-decoration: underline;">Finding a named data source
</span>\
\
 To get a relational data source object given its name use:\
\

     relational_named(Charstring nm)-> Relational

for example:\
\
 <span style="font-family: monospace;">   relational\_named("db1");
</span>\

#### 6.2.2 Accessing meta-data\

Relational meta-data are general information about the tables stored in
a relational database.\
\
 <span style="text-decoration: underline;">Tables in database</span>\
\
 To find out what tables there are in a relational database, use\

     tables(Relational r)

     -> Bag of (Charstring table, Charstring catalog,

     Charstring schema, Charstring owner)

for example

     tables(relational_named("db1"));




The function *tables()* ** returns a bag of tuples describing the tables
stored in the relational database.\
\
\
 To test whether a table is present in a database use:\

     has_table(Relational r, Charstring table_name) -> Boolean




for example\

     has_table(relational_named("db1"),"SALES");

\
 <span style="text-decoration: underline;">Columns in table</span>\
\
 To get a description of the columns in a table use:\

     columns(Relational r, Charstring table_name)

     -> Bag of (Charstring column_name, Charstring column_type)

for example\
\
 <span style="font-family: monospace;">   
columns(relational\_named("db1"),"CUSTOMER");\
\
 </span> <span style="text-decoration: underline;">Size of table</span>\
\
 To find out how many rows there are in a table use:\

     cardinality(Relational r, Charstring table_name) -> Integer

for example\

     cardinality(relational_named("db1"),"SALES");

\
 <span style="text-decoration: underline;">Primary keys of table</span>\
\
 To get a description of the primary keys of a table use:\

     primary_keys(relational r, charstring table_name)

     -> Bag of (charstring column_name, charstring constraint_name)

for example:\

     primary_keys(relational_named("db1"),"CUSTOMER");




\
 <span style="text-decoration: underline;">Foreign keys of table</span>\
\
 To get information about the foreign keys referenced from a table use:\

     imported_keys(Jdbc j, Charstring fktable)

     -> Bag of (Charstring pktable, Charstring pkcolumn, Charstring fkcolumn)

for example\

     imported_keys(relational_named("db1"),"PERSON_TELEPHONES");

The elements of the result tuples denote the following:\

-   `pktable` - The table referenced by the foreign key.
-   `pkcolumn` - The column referenced by the foreign key.
-   `fkcolumn` - The foreign key column in the table.

<span style="font-weight: bold;">NOTICE</span> that composite foreign
keys are not supported.\
\
  To find what keys in a table are exported as foreign keys to some
other table use:\

     exported_keys(Jdbc j, Charstring pktable)

     -> Bag of (Charstring pkcolumn, Charstring fktable, Charstring fkcolumn)

for example\
 <span style="font-family: monospace;">    
exported\_keys(relational\_named("db1"),"PERSON"); </span>\
\
 The elements of the result tuples denote the following:\

-   `pkcolumn` - The primary key column in the table.
-   `fktable` - The table whose foreign key references the table.
-   `fkcolumn` - The foreign key column in the table that references
    the table.

<span style="text-decoration: underline;">Deleting tables</span>\
\
 The function *drop\_table()* deletes a table from a wrapped relational
database:\
 <span style="font-family: monospace;">   \
     drop\_table(Relational r, Charstring name) -&gt; Integer</span>\
 <span style="font-family: monospace;"></span>

#### 6.2.3 Executing SQL

<span style="text-decoration: underline;">SQL statements</span>\
\
 The function *sql()* ** executes an arbitrary SQL statement as a
string:

<span style="font-family: monospace;">    sql(Relational r, Charstring
query) -&gt; Bag of Vector results </span>\

The result is a bag of results tuples represented as vectors. If the SQL
statement is an update a single tuple containing one number is returned,
being the number of rows affected by the update. Example:\

<span style="font-family: monospace;">    sql(relational\_named("db1"),
"select NAME from PERSON where INCOME &gt; 1000 and AGE&gt;50");\
\
 </span>

<span style="text-decoration: underline;">Parameterized SQL statements
</span>\

To execute the same SQL statement with different parameters use:\

<span style="font-family: monospace;">    sql(Relational r, Charstring
query, Vector params) -&gt; Bag of Vector results</span>\

The parameters *params* <span style="font-family:
          monospace;"></span> are substituted into the corresponding
occurrences in the SQL statement, for example:\

<span style="font-family: monospace;">    sql(relational\_named("db1"),
"select NAME from PERSON where INCOME &gt; ? and AGE&gt;?", {1000,50));\
\
 </span>\
 <span style="text-decoration: underline;">Loading SQL scripts</span>\
\
 SQL statements in a file separated with ';' can be loaded with:\
\
 <span style="font-family: monospace;">    read\_sql(Relational r,
Charstring filename) -&gt; Bag of Vector</span>\
\
 The result from *read\_sql()* <span
style="font-family: Times New Roman;">is a bag containing the result
tuples from executing the read SQL statements.\
\
 **Hint:** If something is wrong in the script you may trace the calls
inside *read\_sql()*</span> <span style="font-family:
      Times New Roman;"> to *sql()*</span> <span
style="font-family: Times New Roman;"> ** by calling\
 <span style="font-family: monospace;">    trace("sql"); </span>\
 <span style="font-family: monospace;"></span> </span>

#### 6.2.4 Object-oriented views of tables

The relational wrapper allows to to define object-oriented views of data
residing in a relational database. Once the view has been defined the
contents of the database can be used in AmosQL queries without any
explicit calls to SQL.\
\
 To regard a relational table as an Amos II type use:\

     import_table(Relational r, Charstring table_name) -> Mapped_type

for example

     import_table(relational_named("db1"),"SALES");

The view is represented by a [*mapped type*](#mapped) which is a type
whose extent is defined by the rows of the table. Each instance of the
mapped type corresponds to a row in the table. The name of the mapped
type is constructed by concatenating the table name, the character `_`
and the data source name, for example *Person\_db1*. Mapped type names
are internally capitalized, as for other Amos II types.\

For each columns in the mapped relational database table
*import\_table()* will generate a corresponding derived *wrapper
function* returning the column's value given an instance of the mapped
type. For example, a table named `person` having the column `ssn` will
have a function

returning the social security number of a person from the imported
relational table.\
\
 The system also allows wrapped relational tables to be transparently
updated using an [update statement](#updates) by importing the table
with:\

     import_table(Relational r,

     Charstring table_name,

     Boolean updatable)

     -> Mappedtype mt

for example\

     import_table(relational_named("db1"),"COUNTRY",true);

If the flag <span style="font-style: italic;">updatable</span> is set to
true the functions in the view are transparently updatable so the
relational database is updated when instances of the mapped type are
created or the extent of some wrapper function updated.  For example:\

     create Country_db1(currency,country) instances ("Yen","Japan");

     set currency(c)= "Yen" from Country_db1 c where country(c)= "Japan";




The most general resolvent of *import\_table()* ** is:\

     import_table(Relational r, Charstring catalog_name,

     Charstring schema_name, Charstring table_name,

     Charstring typename, Boolean updatable,

     Vector supertypes) -> Mappedtype mt

The table resides in the given catalog and schema. If *catalog* is "",
the table is assumed not to be in a catalog. If *schema* is "", the
table is assumed not to be in a schema. ``The parameter *typename* is
the desired name of the mapped type created, as alternative to the
system generated concatenation of table and data source name. ``The
parameter *updatable* gives an updatable mapped type. The parameter
*supertypes``* is a [vector](#vector) of either type names or type
objects, or a mixture of both. The effect is that Amos II will perceive
the mapped type as an immediate subtype of the supertypes.\

There are also two other variants of *import\_table()*  <span
style="font-family: Times New Roman;">to be used for relational
databases where schema and catalog names need not be specified:\
 </span>

     import_table(Relational r,

     Charstring table_name,

     Charstring typename,

     Boolean updatable,

     Vector supertypes) -> Mappedtype mt

     import_table(Relational r,

     Charstring table_name,

     Charstring type_name,

     Boolean updatable) -> Mappedtype mt




<span style="font-family: monospace;"></span>

#### Importing many-to-many relationships

All tables in relational databases do not correspond to 'entities' in an
ER diagram and therefore cannot be directly mapped to types. The most
common case is tables representing many-to-many relationships between
entities. Typically such tables have two columns, each of which is a
foreign key imported from two other tables, expressing the many-to-many
relationship between the two. Only entities are imported as types and
special types are not generated for such relationship tables. A
many-to-many relationship in a relational database corresponds to a
function returning a *bag* in AmosQL, and can be imported using
*import\_relation()* rather than *import\_table()* ``:

    import_relation(Relational r,

     Charstring table_name, Charstring argument_column_name,

     Charstring result_column_name, Charstring function_name,

     Boolean updatable)

     -> Function




-   `table_name` - the name of the table containing the relation.
-   `argument_column_name` - the name of the column which is argument of
    the function.
-   `result_column_name` - the name of the column which is result of
    the function.
-   `function_name` - the desired name of the function.
-   `updatable` - whether the function should be transparently updatable
    via `set`, `add`, and `remove`.

For example, assume we have two entity types, *person* and *telephone*.
Most of the time telephones are not regarded as entities in their own
respect since nobody would care to know more about a telephone than its
number. However, assume that also the physical location of the telephone
is kept in the database, so telephones are an entity type of their own.

A person can be reached through several telephones, and every telephone
may be answered by several person. The schema looks as follows:

  ------- -------- -------
  `ssn`   `name`   `...`

  \       \        \

  ------- -------- -------

  :  `person`

`person_telephones`

`ssn`

`ext_no`

\

\

\

  ---------- ------------ -------
  `ext_no`   `location`   `...`

  \          \            \

  ---------- ------------ -------

  :  `telephone`

Now, this schema can be wrapped by the following commands:

1.  `import_table(my_relational, 'person');`
2.  `import_table(my_relational, 'telephone');`
3.  `import_relation(my_relational, 'telephone', 'ssn','ext_no','phones', false);`\
4.  `create function phones(person@my_relational p) -> telephone@my_relational t as select t where phones(ssn(p)) = ext_no(t);           `\

Notice that only relationship functions with a single argument and
result can be generated, i.e. composite foreign keys are not supported.\

<span style="font-family: Times New Roman;"> </span>

6.3 Defining new wrappers\
--------------------------

Wrappers make data sources queryable. Some wrapper functionality is
completely data source independent while other functionality is specific
for a particular kind of data source. Therefore, to share wrapper
functionality Amos II contains a type hierarchy of wrappers. In this
section we describe common functionality used for defining any kind of
wrapper.\

### 6.3.1 Data sources

Objects of type *Datasource* describe properties of different kinds of
data sources accessible through Amos II. A wrapper interfacing a
particular external data manager is defined as a subtype of
*Datasource*. For example, the types *Amos*, *Relational*, and *Jdbc*
define interfaces to Amos II peers, relational databases, and relational
data bases accessed through JDBC, respectively. These types are all
subtypes of type *Datasource*. Each *instance* of a data source type
represents a particular database of that kind, e.g. a particular
relational database accessed trough JDBC are instances of type *Jdbc*.\

### <span style="font-family: Times New Roman;"> </span>6.3.2 Mapped types

A *mapped type* is a type whose instances are identified by a *key*
consisting of one or several other objects [\[FR97\]](#FR97). Mapped
types are needed when proxy objects corresponding to external values
from some data source are created in a peer. For example, a wrapped
relational database may have a table PERSON(SSN,NAME,AGE) where SSN is
the key. One may then wish to define a mapped type named *Pers*
representing proxy objects for the persons in the table. The instances
of the proxy objects are identified by an SSN. The type *Pers* should
furthermore have the following property functions derived from the
contents of the wrapped table PERSON:\

`     ssn(Pers)->Integer               name(Pers)->Charstring               age(Pers)->Integer`\
\
 The instances and primary properties of a mapped type are defined
through a *source function* that returns these as a set of tuples, one
for each instance. In our example the source function should return
tuples of three elements <span style="font-family:
        monospace;">(ssn,name,age)</span>. The [relational database
wrapper](#relational) will automatically generate such a source function
for table PERSON (type `Pers`) with signature:\

`   pers_cc()->Bag of (Integer ssn, Charstring name, Integer age) as ...`\
\
 A mapped type is defined through a system function with signature:\

`   create_mapped_type(Charstring name, Vector keys, Vector attrs, Charstring ccfn)-> Mappedtype`\
 where\
     `name` is the name of the mapped type\
     `keys` is a [vector](#vector) of the names of the keys identifying
each instance of the mapped type.\
     `attrs` is a vector of the names of the properties of the mapped
type.\
     `ccfn` is the name of the core cluster function.\
\
 In our example the relational database wrapper will automatically
define the mapped type `Pers` through this call:\

`   create_mapped_type("Pers",{"ssn"},{"ssn","name","age"},"pers_cc");       `\
\
 Notice that the implementor of a mapped type must guarantee key
uniqueness.\
\
 Once the mapped type is defined it can be queried as any other type,
e.g.:\
 `   select name(p) from Pers p where age(p)>45;`\

### 6.3.3 Type translation

Types in a specific data source are translated to corresponding types in
Amos II using the following system functions:

-   amos_type(Datasource ds, Charstring native_type_name) -> Type;




<!-- -->

-   wrapped_type(Datasource ds, Type t) -> Charstring typename;




The most common relational types *and* their Amos II counterparts are
provided by default. Both functions are stored functions that can be
updated as desired for future wrappers. <span
style="font-family: Times New Roman;">\
 </span>
