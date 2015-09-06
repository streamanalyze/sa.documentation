# sa.amos User's Manual

sa.amos is an extensible NoSQL database system allowing different kinds of data sources to be integrated and queried. The system is centered around an object-oriented and functional query language, AmosQL, documented here. The system can store data in its main-memory object store. Furthermore, wrappers can be defined for different kinds of data sources and external storage managers accessed to make them queryable. This manual describes how to use the sa.amos system and the AmosQL query language. sa.amos includes primitives for data mining through functions for data analyzis, aggregation,  visualization, and handling of ordered collections through the datatype Vector. The principles of the sa.amos system and AmosQL are described in the document [RJK03].

Several distributed sa.amos peers can collaborate in a federation. The documentation includes documentation of basic peer communication primitives, multi-database queries and views, the wrapper functionality, and the predefined wrappers for relational databases through  JDBC.

The basic wrapper interface is based on user defined multi-directional foreign functions having various capabilities used to access external data sources in different ways [LR92] depending on what variables are bound or free in an execution plan, the binding patterns. On top of the basic foreign function mechanism object oriented abstractions are defined through mapped types [FR97]. A number of important query rewrite techniques for scalable access to wrapped sources, in particular relational databases, are described in [FR97]. Rewrites for handling scalable execution of queries involving late bound function calls are described in [FR95]. Multi-database views are further described in [JR99a][JR99b]. The distributed query decomposer is described in [JR02] and [RJK03].


## Getting started

Download the sa.amos zip  from http://www.it.uu.se/research/group/udbl/amos/. Unpack the zip file to a directory for sa.amos, <privdir>. The following files are needed in <privdir>:

```
amos2.exe
amos2.dll
amos2.dmp
sa.amos is ready to run in <privdir> by the command:
amos2 [<db>]
where [<db>] is an optional name of an sa.amos database image.
You need not connect to any particular database, but instead, if <db> is omitted, the system enters an empty database (named amos2.dmp), where only the system objects are defined. The system looks for amos2.dmp in the same directory as where the executable amos2.exe is located.
```

The executable has a number of command line parameters to specify, e.g., the database or AmosQL script to load. To get a list of the command line parameters do:
  `amos2 -h`


### The sa.amos REPL

When started, the system enters the Amos REPL where it reads AmosQL statements, executes them, and prints their results. The prompt in the sa.amos REPL is: `Amos n>` where n is a generation number. The generation number is increased every time an AmosQL statement that updates the database is executed in the Amos REPL.

Typically you start by defining  meta-data (a schema) as types and functions. For example:

```
Amos 1> create type Person;
Amos 2> create function name(Person)->Charstring as stored;
Amos 3> create function father(Person)->Person as stored;
Amos 4> create type Student under Person;
# Often you load AmosQL definitions from a script file rather than entering them on the command line, e.g.
Amos 1> < 'mycode.amosql';
```
When the meta-data is defined you usually populate the database by creating objects and updating functions. For example:
```
Amos 5> create Person(name) instances ("Jacob"),("Sam");
Amos 6> set father(p) = q
            from Person p, Person q
            where name(p)="Jacob" and name(q) = "Sam";
```
Interface variables can be used to bind created object.

```
Amos 7> create Person(name, father) instances :b ("Bill",nil), ("John",:b);
```

Notice that interface variables  are not part of the database but simply place holders for created objects when running AmosQL scripts.

When the database is populated you can query it:

```
Amos 8> select name(father(p)) from Person p;
```

### Transactions

Database changes can be undone by using the rollback statement with a generation number as argument. For example, the statement: `Amos 4> rollback 2;` will restore the database to the state it had at generation number 2. In the example the rollback thus undoes the effect of the statements after:

```
create type Student under Person;
```

After the rollback above, the type Student is removed from the database, but not type Person.
A rollback without arguments undoes all database changes of the current transaction. All interface variables are cleared by rollback.

The statement commit makes changes non-undoable, i.e. all updates so far cannot be rolled back any more and the generation numbering starts over from 1.

For example:

```
Amos 2> commit;
Amos 1> ...
```

Notice that all interface variables are cleared by rollback.

### Saving and quitting

When your sa.amos database is defined and populated, it can be saved on disk with the AmosQL statement: `save "filename";` In a later session you can connect to the saved database by starting sa.amos with: `amos2 filename`

To shut down sa.amos orderly first save the database and then type: `Amos 1> quit;`

This is all you need to get started with sa.amos.

The remaining chapters in this document describe the basic sa.amos commands. As an example of how to define and populate an sa.amos database, cut-and-paste the commands in http://www.it.uu.se/research/group/udbl/amos/doc/intro.osql. There is a tutorial on object-oriented database design with sa.amos http://www.it.uu.se/research/group/udbl/amos/doc/tut.pdf.

### Java interface

JavaAmos is a version of the sa.amos kernel connected to the Java virtual machine. With it Java programs can call sa.amos functions and send AmosQL statements to sa.amos for evaluation (the callin interface) [ER00]. You can also define sa.amos foreign functions in Java (the callout interface). To start JavaAmos use the script `javaamos`
instead of `amos2`. It will enter a REPL reading and evaluating AmosQL statements as amos2. JavaAmos requires the Java jar file `javaamos.jar`.


### Back-end relational databases

sa.amos includes a wrapper of relational databases using JDBC on top of JavaAmos. Any relational database can be accessed in terms of AmosQL using this wrapper. The interface is described in the section Relational database wrapper.

### Graphical database browser

The multi-database browser GOOVI [CR01] is a graphical browser for sa.amos written as a Java application. You can start the GOOVI browser from the JavaAmos REPL by calling the sa.amos function `goovi();` It will start the browser in a separate thread.

### PHP interface

sa.amos includes an interface allowing programs in PHP to call sa.amos servers. The interface is tested for Apache servers. To use sa.amos with PHP or SQL under Windows you are recommended to download and install WAMP http://www.wamp.org/. WAMP packages together a version of the Apache web server, the  PHP script language, and the MySQL database. sa.amos  is tested with WAMP 2.0 (32 bits). See further the file readme.txt in subdirectory embeddings/PHP of the sa.amos download.

### C interface

The system is interfaced with the programming language C (and C++). As with Java, Amos  II can  be called from C (callin interface) and foreign sa.amos functions can be implemented in C. See [Ris12].

### Lisp interface

There is a built-in interpreter for a subset of the programming language CommonLisp in sa.amos, aLisp [Ris06]. The system can be accessed and extended using aLisp.

## AmosQL

This section describes the syntax of AmosQL and explains some semantic details. For the syntax we use BNF notation with the following special constructs:

```bnf
A ::= B C: A consists of B followed by C.
A ::= B | C, alternatively (B | C): A consists of B or C.
A ::= [B]: A consists of B or nothing.
A ::= B-list: A consists of one or more Bs.
A ::= B-commalist: A consists of one or more Bs separated by commas.
'xxx': The string (keyword) xxx.
```
AmosQL statements are always terminated by a semicolon (`;`).

### Comments

The comment statement can be placed anywhere outside identifiers and constants.
Syntax:

```
comment ::=
        '/*' character-list '*/'
```

### Identifiers

Identifiers have the syntax:
```
identifier ::=
        ('_' | letter) [identifier-character-list]

identifier-character ::=
        alphanumeric | '_'
```
Example:
```
MySalary
x
x1234
x1234_b
```
Notice that sa.amos identifiers are NOT case sensitive; i.e. they are always internally capitalized. By contrast sa.amos keywords are always written with lower case letters.

### Variables

Variables are of two kinds: local variables or interface variables:

```
   variable ::= local variable | interface-variable
```

Local variables are identifiers for data values inside AmosQL queries and functions. Local variables must be declared in function signatures (see Function definitions), in from clauses (see Queries), or by the declare statement (see procedural functions). Notice that variables are not case sensitive.

```
local-variable ::= identifier

   E.g. my_variable
        MyVariable2
```

Interface variables hold only temporary results during interactive sessions. Interface variables cannot be referenced in function bodies and they are not stored in the database. Their lifespan is the current transaction only. Their purpose is to hold temporary values in scripts and database interactions.
Syntax:

```
interface-variable ::= ':' identifier

   E.g. :my_interface_variable
        :MyInterfaceVariable2
```

Interface variables are by default untyped (of type Object). The user can declare an interface variable to be of a particular type by the interface variable declare statement:

```
interface-variable-declare-stmt ::=
        'declare' interface-variable-declaration-commalist

interface-variable-declaration ::=
        type-spec interface-variable
```
Example:
```
declare Integer :i, Real :x3;_
```

Interface variables can be assigned either by the into-clause of the select statement or by the interface variable assignment statement set:
```
set-interface-variable-stmt ::= 'set' interface-variable '=' expr
```

Example:
```
set :x3 = 2.3;
set :i = 2 + sqrt(:x3);
```

### Constants

Constants can be integers, reals, strings, time stamps, booleans, or nil.

```
constant ::=
        integer-constant | real-constant | boolean-constant |
        string-constant | time-stamp | functional-constant | 'nil'

integer-constant ::=
        ['-'] digit-list

real-constant ::=
        decimal-constant | scientific-constant

decimal-constant ::=
        ['-'] digit-list '.' [digit-list]

scientific-constant ::=
        decimal-constant ['e' | 'E'] integer-constant

boolean-constant ::=
        'true' | 'false'
```

Example:
```
123
-123
 1.2
-1.0
2.3E2
-2.4e-21
```

The constant false is actually nil casted to type Boolean. The only legal boolean value that can be stored in the database is true and a boolean value is regarded as false if it is not in the database (close world assumption).

```
string-constant ::=
        string-separator character-list string-separator

string-separator ::=
        ''' | '"'
```
Example:
```
"A string"
'A string'
'A string with "'
"A string with \" and '"
```

The enclosing string separators (`'` or `"`) for a string constant must be the same. If the string separator is `"` then `\` is the escape character inside the string, replacing the succeeding character. For example the string `'ab"\'` can also be written as `"ab\"\\"`, and the string `a'"b` must be written as `"a'\"b"`.

```
simple-value ::= constant | variable
```
Example:
```
:MyInterfaceVariable
MyLocalVariable
123
"Hello World"
```

A simple value is either a constant or a variable reference.

### Expressions

```
expr ::=  simple-value | function-call | collection | casting | vector-indexing
```
Example:
```
1.23
1+2
1<2 and 1>3
sqrt(:a) + 3 * :b
{1,2,3}
cast(:p as Student)
        a[3]
```

An expression is either a constant, a variable, or a function call. An expression has a computed value. The value of an expression is computed if the expression is entered to the Amos REPL, e.g.:

```
1+5*sqrt(6);
=> 13.2474487139159
```

Notice that Boolean expressions either return true, or nothing if the expression is not true. For example:
   1<2 or 3<2;
    => TRUE
   1<2 and 3<2;
    => nothing

Entering simple expressions is the simplest form of AmosQL queries.

### Collections

collection ::= bag-expr | vector-expr
bag-expr ::= bag(expr-commalist)
  E.g.: bag(1,2,3)
        bag(1,:x+2)

vector-expr ::= '{' expr-comma-list '}'
  E.g.: {1,2,3}
        {{1,2},{3,4}}
        {1,name(:p),1+sqrt(:a)}

Collections represent sets of objects. Collections can be bags (type Bag), vectors (type Vector) or key/value pairs (type Record):
 Bags are unordered sets of objects with duplicates allowed. The value of a query is by default a bag. When a query returns a bag the elements of the bag are printed on separate lines, for example:
 ```
Amos 2> select name(p) from Person p;
"Bill"
"Carl"
"Adam"
```
 Vectors are sequences of objects of any kind. Curly brackets {} enclose vector elements, for example:
```
Amos 1> set :v={1,2,3};
Amos 2> :v;
{1,2,3}
```
### Statements

Statements instruct sa.amos to perform various kinds of services. The following statements can be entered to the sa.amos REPL:

```
  create-type-stmt |
  delete-type-stmt |
  create-object-stmt |
  delete-object-stmt |
  create-function-stmt |
  delete-function-stmt |
  query |
  update-stmt |
  add-type-stmt |
  remove-type-stmt |
  for-each-stmt |
  set-interface-variable-stmt |
  declare-interface-variable-stmt |
  commit-stmt |
  rollback-stmt |
  open-cursor-stmt |
  fetch-cursor-stmt |
  close-cursor-stmt |
  quit-stmt |
  exit-stmt
```

### Types

The create type statement creates a new type in the database.
Syntax:

```
create-type-stmt ::=
        'create type' type-name ['under' type-name-commalist]
                ['properties' '(' attr-function-commalist ')']

type-spec ::= type-name | 'Bag of' type-spec | 'Vector of' type-spec

type-name ::= identifier

attr-function ::=
        generic-function-name type-spec ['key']
```
Example:
```
  create type Person;
  create type Employee under Person;
  create type Student under Person;
  create type Kid under Person properties
   (name Charstring key,
    attitude Integer);
```

Type names must be unique in the database.

Type names are not case sensitive and the type names are always internally upper-cased. For clarity all type names used in examples in this manual always have the first letter capitalized.
The new type will be a subtype of all the supertypes in the 'under' clause. If no supertypes are specified the new type becomes a subtype of the system type named Userobject. Multiple inheritance is specified through more than one supertype, for example:
   `create type TA under Student, Employee;`
The attr-function-commalist clause is optional, and provides a way to define attributes for the new type. Each attribute is a function having a single argument and a single result. An attribute is represented as a stored function in the local database. The argument type of an attribute function is the type being created and the result type is specified by the type-spec. The result type must be previously defined. In the above example the `function name()` has the argument of type Person and result of type Charstring.
If 'key' is specified for a property, it indicates that each value of the attribute is unique and the system will raise an error if this uniqueness is violated. In the example, two objects of type Person cannot have the same value of attribute name.


#### Deleting types

The delete type statement deletes a type and all its subtypes.

```
delete-type-stmt ::=
        'delete type' type-name
```
   E.g. delete type Person;
If the deleted type has subtypes they will be deleted as well, in this case types Employee, Student, and Kid. Functions using the deleted types will be deleted as well.
2.2 Objects

The create-object statement creates one or more objects and makes the new object(s) instance(s) of a given user type and all its supertypes.
Syntax:

```
create-object-stmt ::=
        'create' type-name
        ['(' generic-function-name-commalist ')'] 'instances' initializer-commalist

initializer ::=
        variable |
        [variable] '(' expr-commalist ')'
```
Examples:
```
   create Person (name,age) instances
          :adam ('Adam',26),:eve ('Eve',32);

   create Person instances :olof;

   create Person (parents) instances
          :tore (bag(:adam,:eve));

   create Person (name,age) instances
          ("Kalle "+"Persson" , 30*1.5);
```

The new objects are assigned initial values for the specified attributes. The attributes can be any updatable AmosQL functions of a single argument and value. One object will be created for each initializer. Each initializer can have an optional variable name which will be bound to the new object. The variable name can subsequently be used as a reference to the object. The initializer also contains a comma-separated list of initial values for the specified functions in generic-function-name-commalist.

Initial values are specified as expressions.

The types of the initial values must match the declared result types of the corresponding functions.

Bag valued functions are initialized using the syntax `bag(e1,...)` (syntax bag-expr).

Vector result functions are formed with a comma-separated list of values enclosed in curly brackets (syntax vector-expr).

It is possible to specify nil for a value when no initialization is desired for the corresponding function.

#### Deleting objects

Objects are deleted from the database with the delete statement.
Syntax:

```
delete-object-stmt ::=
        'delete' variable
```

The system will automatically remove the deleted object from all stored functions where it is referenced.
Deleted objects are printed as `#[OID nnn *DELETED*]`

The objects may be undeleted by rollback. An automatic garbage collector physically removes an OID from the database only if its creation has been rolled back or its deletion committed, and it is not referenced from some variable or external system.

### Queries

Queries retrieve objects having specified properties. They are specified using the query statement denoting either  function calls, select statements, or variable references.
```
query ::= select-stmt | function-call | expr

2.3.1 Function calls
```
A simple form of queries are calls to functions.

Syntax:
```
function-call ::=
        function-name '(' [parameter-value-commalist] ')' |
        expr infix-operator expr |
        tuple-expr

infix-operator ::= '+' | '-' | '*' | '/' | '<' | '>' | '<=' | '>=' | '=' | '!=' | 'in'


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
The built-in functions `plus()`, `minus()`, `times()`, and `div()` have infix syntax `+`,`-`,`*`,`/` with the usual priorities.
For example:
```
(income(:eve) + income(:ulla)) * 0.5;
```
is equivalent to:

```
times(plus(income(:eve),income(:ulla)),0.5);
```

The `+` operator is defined for both numbers and strings. For strings it implements string concatenation. In a function call, the types of the actual parameters and results must be the same as, or subtypes of, the types of the corresponding formal parameters or results.
Tuple expressions are used for assigning values of tuple valued functions in queries.

#### The select statement

The select statement provides the most flexible way to specify queries.
Syntax:

```
select-stmt ::=
        'select' ['distinct'] expr-commalist
                 [into-clause]
                 [from-clause]
                 [where-clause]

into-clause ::=
        'into' variable-commalist

from-clause ::=
        'from' variable-declaration-commalist

variable-declaration ::=
        type-spec local-variable

where-clause ::=
       'where' predicate-expression
```
   For example:
```
select name(p)
from Person p
where age(p)<2 and
      city(p)="Uppsala";

select income(x),income(father(x))+income(mother(x))
from Person x
where name(p) = "Carl"; /* Returns bag of tuples */

select {income(x),income(father(x))+income(mother(x))}
from Person x
where name(p) = "Carl"; /* Returns bag of vectors constructed using {....} notation */
```

The expr-commalist defines the object(s) to be retrieved.
The from-clause declares types of local variables used in the query.

The where-clause gives selection criteria for the search. The where clause is specified as a predicate expression having a boolean value.

The result of a select statement is a bag of single result tuples. Duplicates are removed only when the keyword 'distinct' is specified, in which case a set (rather than a bag) is returned. The in operator can be used for extracting the values in a bag.

Example:
```
select distinct friends(p)
from Person p
where "Carl" in name(parents(p));
```

The optional into-clause specifies variables to be bound to the result.

Example:
```
select p into :eve2 from Person p where name(p) = 'Eve';
name(:eve2);
```
This query retrieves into the environment variable :eve2 the Person whose name is 'Eve'.

__If more than one object is retrieved the into variable(s) will be bound only to the first retrieved tuple. In the example, if more that one person is named Eve the first one retrieved will be assigned to `:eve2`.__

To assign the results of tuple valued functions in queries, use tuple expressions:
```
select m, f from Person m, Person p where (m,f) = parents2(:p);
```

If you wish to assign the entire result from the select statement in a variable, enclose it in parentheses. The result will be a bag. The elements of the bag can then be extracted with the in() function or the infix in operator:
```
set :r = (select p from Person p where name(p) = 'eve');
in(:r);
select p in :r from Person p;
```

#### Predicate expressions

Predicate expressions are expressions returning boolean values. The where clauses of queries are predicate expressions. The boolean operators and and or can be used to combine boolean values.

Syntax:
```
predicate-expression ::=
        predicate-expression 'and' predicate-expression |
        predicate-expression 'or' predicate-expression |
        '(' predicate-expression ')' |
        expr
```
Example:
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

The boolean operator and has precedence over or.
For example:
	a<2 and a>3 or b<3 and b>2
is equivalent to
	(a<2 and a>3) or (b<3 and b>2)
The comparison operators (=, !=, <, <=, and >=) are treated as binary boolean functions. You can compare objects of any type.
Predicate expressions are allowed in the result of a select expression.
For example, the query:
```
select age(:p1) < 20 and home(:p1)="Uppsala";
```
or simply
```
age(:p1) < 20 and home(:p1)="Uppsala";
```
returns true if person `:p1` is younger than 20 and lives in Uppsala.

#### Quantifiers

The function `some()` implements logical exist over a subquery.
To test if a subquery sq returns empty result use `some()`:
```
some(Bag sq) -> Boolean
```
for example
```
select name(p) from Person p where some(parents(p));
```

The function `notany()` tests if a subquery sq returns empty result, i.e. negation:
```
notany(Bag sq) -> Boolean
```
for example
```
select name(p) from Person p where notany(select parents(p) where age(p)>65);
```
### Functions

The create function statement defines a new user function. Functions can be defined as one of the following:

- Stored functions are stored in the sa.amos database as a table.
- Derived functions are defined by a single query that returns the result of the a function call for given parameters.
- Foreign functions are defined in an external programming language.
- Foreign functions can be defined in the programming languages C/C++ [Ris12], Java [ER00], and Lisp [Ris06].
- Procedural functions are defined using procedural AmosQL statements that can have side effects changing the state of the database.
- Procedural functions makes AmosQL computationally complete.
- Overloaded functions have different implementations depending on the argument types in a function call.

Syntax:
```
create-function-stmt ::=
  'create function' generic-function-name argument-spec '->' result-spec [fn-implementation]
```
Example:
```
create function born(Person) -> Integer as stored;
```

```
generic-function-name ::= identifier

function-name ::= generic-function-name |
  type-name-list '.' generic-function-name '->' type-name-list
```
Example:
```
plus
```

Function names are not case sensitive and are internally stored upper-cased.
```
type-name-list ::= type-name |
                   type-name '.' type-name-list
```
The types used in the function definitions must be previously defined.
```
argument-spec ::='(' [argument-declaration-commalist] ')'

argument-declaration ::= type-spec [local-variable] [key-constraint]
```
The names of the argument and result parameters of a function definition must be distinct.
```
key-constraint ::= ('key' | 'nonkey')

result-spec ::=   argument-spec | tuple-result-spec

tuple-result-spec ::= ['Bag of'] '(' argument-declaration-commalist ')'

fn-implementation ::= 'as' (query |
                            'stored' |
                            procedural-function-definition |
                            foreign-function-definition)
```

The argument-spec and the result-spec together specify the signature of the function, i.e. the types and optional names of formal parameters and results.

A stored function is defined by the implementation 'as stored'.
Example:
```
create function age(Person p) -> Integer a as stored;
```
The name of an argument or result parameter can be left unspecified if it is not referenced in the function's implementation.
Example:
```
create function name(Person) -> Charstring as stored;
```

`Bag of` specifications on a single result parameter of a stored function declares the function to return a bag of values, i.e. a set with tuples allowed. For example:
```
create function parents(Person) -> Bag of Person as stored;
```
AmosQL functions may also have tuple valued results by using the tuple-result-spec notation. For example:
```
create function parents2(Person p) -> (Person m, Person f) as stored;
create function marriages(Person p)
                -> Bag of (Person spouse, Integer year) as stored;
```
Tuple expressions are used for binding the results of tuple valued functions in queries, for example:
```
select s,y from Person s, Integer y where (s,y) in marriages(:p);
```

A derived function is defined by a single AmosQL query.
For example:
```
create function netincome(Person p) -> Number
       as income(p) - taxes(p);
```

Boolean functions  return true or nothing (nil).

For example:
```
create function child(Person p) -> Boolean
  as select true where age(p)<18;
/* alternatively */
create function child(Person p) -> Boolean
  as age(p) < 18;
```
Since the select statement returns a bag of values, derived functions also often return a  Bag of results. If you know that a function returns a bag of values you should indicate that in the signature.
For example:
```
create function youngFriends(Person p)-> Bag of Person
  as select f
  from Person f
  where age(f) < 18
  and f in friends(p);
```
If you write:
```
create function youngFriends(Person p)-> Person
  as select f
  from Person f
  where age(f) < 18
  and f in friends(p);
```
you indicate to the system that youngFriends() returns a single value. However, this constraint is not enforced by the system so if there are more that one `youngFriends()` the system will treat the result as a bag.
Variables declared in the result of a derived function need not be declared again in the from clause. For example, youngFriends() can also be defined as:
```
create function youngFriends(Person p)-> Bag of Person f
  as select f
  where age(f) < 18
  and f in friends(p);
```
Notice that the variable `f` is bound to the elements of the bag, not the bag itself. This definition is equivalent:
```
create function youngFriends(Person p)-> Bag of (Person f)
  as select f
  where age(f) < 18
  and f in friends(p);
```

If a function is applied on the result of a function returning a bag of values, the outer function is applied on each element of that bag, the bag is flattened. This is called Daplex semantics. See also Bags. For example:
```
create function grandparents(Person p) -> Bag of Person
  as parents(parents(p));
```

If there are two parents per parent generation of Carl there will be four names returned when querying:

```
select name(grandparents(q)) from Person q where name(q)= "Carl";
```
Derived functions whose arguments are declared 'Bag of' are called aggregate functions.
For example:
```
create function myavg(Bag of Number x) -> Number
  as sum(x)/count(x);
```

Aggregate functions do not flatten the argument bag. For example, the following query computes the average age of Carl's grandparents:
```
select myavg(age(grandparents(q))) from Person p where name(q)="Carl";
```
When tuple valued functions are called the values are bound by enclosing the function result within parentheses (..) through the tuple-expr syntax. For example:
```
select age(m), age(f)
from Person m, Person f, Person p
where (m,f) = parents2(p) and
              name(p) = "Oscar";
```
The value of a bag valued function can be saved in a bag and extracted using in(), e.g.:
```
set :par = parents(:p);
in(:par);
```

#### Deleting functions

Functions are deleted with the delete function statement.
Syntax:
```
delete-function-stmt ::=
        'delete function' function-name
```
For example:
```
delete function married;
```
Deleting a function also deletes all functions calling the deleted function.

#### Overloaded functions

Function names may be overloaded, i.e., functions having the same name may be defined differently for different argument types. This allows generic functions applicable on objects of several different argument types. Each specific implementation of an overloaded function is called a resolvent.
For example, assume the following two sa.amos function definitions having the same generic function name `less()`:
```
create function less(Number i, Number j)->Boolean
        as i < j;
create function less(Charstring s,Charstring t)->Boolean
        as s < t;
```
Its resolvents will have the signatures:
```
less(Number,Number) -> Boolean
less(Charstring,Charstring) -> Boolean
```
Internally the system stores the resolvents under different function names. The name of a resolvent is obtained by concatenating the type names of its arguments with the name of the overloaded function followed by the symbol `->` and the type of the result. The two resolvents above will be given the internal resolvent names `NUMBER.NUMBER.LESS->BOOLEAN` and `CHARSTRING.CHARSTRING.LESS->BOOLEAN`.
The query compiler resolves the correct resolvent to apply based on the types of the arguments; the type of the result is not considered. If there is an ambiguity, i.e. several resolvents qualify in a call, or if no resolvent qualify, an error will be generated by the query compiler.

When overloaded function names are encountered in AmosQL function bodies, the system will try to use local variable declarations to choose the correct resolvent (early binding).
For example:
```
create function younger(Person p,Person q)->Boolean
       as less(age(p),age(q));
```
will choose the resolvent `NUMBER.NUMBER.LESS->BOOLEAN`, since age returns integers and the resolvent `NUMBER.NUMBER.LESS->BOOLEAN` is applicable to integers by inheritance. The other function resolvent `CHARSTRING.CHARSTRING.LESS->BOOLEAN` does not qualify since it is not legal to apply to arguments of type Integer. On the other hand, this function:
```
create function nameordered(Person p,Person q)->Boolean
        as less(name(p),name(q));
```
will choose the resolvent `NUMBER.NUMBER.LESS->BOOLEAN` since the function `name()` returns a string. In both cases the type resolution (selection of resolvent) will be done at compile time.

#### Late binding

Dynamic type resolution at run time, late binding, is done for REPL function calls to choose the correct resolvent. For example, the query
`less(1,2);` will choose `NUMBER.NUMBER.LESS->BOOLEAN` based on the numeric types the the arguments.

Inside function definitions and queries there may be expressions requiring late bound overloaded functions. For example, suppose that managers are employees whose incomes are the sum of the income as a regular employee plus some manager bonus:
```
create type Employee under Person;
create type Manager under Employee;
create function mgrbonus(Manager)->Integer as stored;
create function income(Employee)->Integer as stored;
create function income(Manager m)->Integer i
       as income(cast(m as Employee)) + mgrbonus(m);
```
Now, suppose that we need a function that returns the gross incomes of all persons in the database, i.e. we use `MANAGER.INCOME->INTEGER` for managers and `EMPLOYEE.INCOME->INTEGER` for non-manager. In sa.amos such a function is defined as:
```
create function grossincomes()->Integer i
       as select income(p)
       from Employee p;
       /* income(p) late bound */
```
Since income is overloaded with resolvents `EMPLOYEE.INCOME->INTEGER` and `MANAGER.INCOME->INTEGER` and both qualify to apply to employees, the resolution of `income(p)` will be done at run time. To avoid the overhead of late binding one may use casting.

Since the detection of the necessity of dynamic resolution is often at compile time, overloading a function name may lead to a cascading recompilation of functions defined in terms of that function name. For a more detailed presentation of the management of late bound functions see [FR95].

#### Casting

The type of an expression can be explicitly defined using the casting statement:
```
casting ::= 'cast'(expr 'as' type-spec)
```
for example
```
create function income(Manager m)->Integer i
       as income(cast(m as Employee)) + mgrbonus(m);
```
By using casting statements one can avoid late binding.

#### Second order functions

sa.amos functions are internally represented as any other objects and stored in the database. Object representing functions can be used in functions and queries too. An object representing a function is called a functional. Second order functions take functionals as arguments or results. The system function functionnamed() retrieves the functional fno having a given name fn:
```
functionnamed(Charstring fn) -> Function fno
```

The name fn is not case sensitive.

For example
```
functionnamed("plus");
  => #[OID 155 "PLUS"]
```
returns the object representing the generic function plus, while
```
functionnamed("number.number.plus->number");
  => #[OID 156 "NUMBER.NUMBER.PLUS->NUMBER"]
```
returns the object representing the resolvent named NUMBER.NUMBER.PLUS->NUMBER.

Another example of a second order function is the system function
```
apply(Function fno, Vector argl) -> Bag of Vector
```
It calls the functional fno with argl as argument list. The result tuples are returned as a bag of vectors, for example:
```
apply(functionnamed("number.number.plus->number"),{1,3.4});
=> {4.4}
```
Notice how apply represents argument lists and result tuples as vectors. When using second order functions one often needs to retrieve a functional fno given its name and the function `functionnamed()` provides one way to achieve this. However, a simpler way is often to use functional constants with syntax:
```
functional-constant ::= '#' string-constant
```
Example:
```
#'mod';
```
A functional constant is translated into the functional with the name uniquely specified by the string constant. For example, the following expression
```
apply(#'mod',{4,3});
  => {1}
```
Notice that an error is raised if the function name specified in the functional constant is not uniquely identifying the functional. This happens if it is the generic name of an overloaded function. For example, the functional constant #'plus' is illegal, since plus() is overloaded. For overloaded functions the name of a resolvent has to be used instead, for example:
```
apply(#'plus',{2,3.5});
```
generates an error, while
```
apply(#'number.number.plus->number', {2,3.5});
 => {5.5}
```
and
```
apply(functionnamed("plus"),{2,3.5});
 => {5.5}
```

The last call using functionnamed("plus") will be somewhat slower than using #'number.number.plus->number' since the functional for the generic function plus is selected and then the system uses late binding to determine dynamically which resolvent of plus() to apply.

#### Transitive closures
The transitive closure functions tclose() is a second order function to explore graphs where the edges are expressed by a transition function specified by argument fno:
```
tclose(Function fno, Object o) -> Bag of Object
```
`tclose()` applies the transition function `fno(o)`, then `fno(fno(o))`, then `fno(fno(fno(o)))`, etc until fno returns  no new result. Because of the Daplex semantics, if the transition function fno returns a bag of values for some argument o, the successive applications of fno will be applied on each element of the result bag. The result types of a transition function must either be the same as the argument types or a bag of the argument types. Such a function that has the same arguments and (bag of) result types is called a closed function.
For example, assume the following definition of a graph defined by the transition function arcsto():
```
create function arcsto(Integer node)-> Bag of Integer n as stored;
set arcsto(1) = bag(2,3);
set arcsto(2) = bag(4,5);
set arcsto(5) = bag(1);
```
The following query traverses the graph starting in node 1:
```
Amos 5> tclose(#'arcsto', 1);
  1
  3
  2
  5
  4
```
In general the function `tclose()` traverses a graph where the edges (arcs) are defined by the transition function. The vertices (nodes) are defined by the arguments and results of calls to the transition function fno, i.e. a call to the transition function fno defines the neighbors of a node in the graph. The graph may contain loops and tclose() will remember what vertices it has visited earlier and stop further traversals for vertices already visited.
You can also query the inverse of `tclose()`, i.e. from which nodes f can be reached, by the query:
```
Amos 6> select f from Integer f where 1 in tclose(#'arcsto',f);
  1
  5
  2
```

If you know that the graph to traverse is a tree or a directed acyclic graph (DAG) you can instead use the faster function
```
traverse(Function fno, Object o) -> Bag of Object
```

The children in the tree to traverse is defined by the transition function fno. The tree is traversed in pre-order depth first. Leaf nodes in the tree are nodes for which fno returns nothing. The function traverse() will not terminate if the graph is circular. Nodes are visited more than once for acyclic graphs having common subtrees.
A transition function may have extra arguments and results, as long as it is closed. This allows to pass extra parameters to a transitive closure computation. For example, to compute not only the transitive closure, but also the distance from the root of each visited graph node, specify the following transition function:
```
create function arcstod(Integer node, Integer d) -> Bag of (Integer,Integer)
  as select arcsto(node),1+d;
and call
tclose(#'arcstod',1,0);
```
which will return
```
(1,0)
(3,1)
(2,1)
(5,2)
(4,2)
```
Notice that only the first argument and result in the transition function define graph vertices, while the remaining arguments and results are extra parameters for passing information through the traversal, as with arcstod(). Notice that there may be no more than three extra parameters in a transition function.

#### Iteration

The function `iterate()` applies a function `fn()` repeadely.
Signature:
```
   iterate(Function fn, Number maxdepth, Object x) -> Object r
```
The iteration is initialized by setting `x0=x`. Then `xi+1= fn(xi)` is repeadedly computed until one of the following conditions hold:

1. there is no change `(xi = xi+1)`, or
2. `fn()` returns nil `(xi+1 = nil)`, or
3. an upper limit  maxdepth of the number of iterations is reached for `xi`.

There is another overloaded variant of `iterate()` that accepts an extra parameter p passed into `fn(xi,p)` in the iterations.
Signature:
```
iterate(Function fn, Number maxdepth, Object x0, Object p) -> Object r
```

This enables flexible termination of the iteration since `fn(x,p)` can return `nil` based on both `x` and `p`.

#### Abstract functions

Sometimes there is a need to have a function defined for subtypes of a common supertype, but the function should never be used for the supertype itself. For example, one may have a common supertype Dog with two subtypes Beagle and Poodle. One would like to have the function bark defined for different kinds of dogs, but not for dogs in general. In this case one defines the bark function for type Dog as an abstract function, for example:
```
create type Dog;
create function name(Dog)->Charstring as stored;
create type Beagle under Dog;
create type Poodle under Dog;
create function bark(Dog d) -> Charstring as foreign 'abstract-function';
create function bark(Beagle d) -> charstring;
create function bark(Poodle d) -> charstring;
create Poodle(name,bark) instances ('Fido','yip yip');
create Beagle(name,bark) instances ('Snoopy','arf arf');
```
Now you can use `bark()` as a function over dogs in general, but only if the object is a subtype of Dog:
```
Amos 15> select bark(d) from dog d;
"arf arf"
"yip yip"
```
An abstract function is defined by:
```
create function foo(...)->... as foreign 'abstract-function'
```
An abstract functions are implemented as a foreign function whose implementation is named 'abstract-function'. If an abstract function is called it gives an informative error message. For example,  if one tries to call `bark()` for an object of type Dog, the following error message is printed:
```
Amos 16> create Dog instances :buggy;
NIL
Amos 17> bark(:buggy);
BARK(DOG)->CHARSTRING
  is an abstract function requiring a more specific argument signature than
  (DOG) for arguments
  (#[OID 1009])
```

### Updates

Information stored in sa.amos represent mappings between function arguments and results. These mappings are either defined at object creation time (Objects), or altered by one of the function update statements `set`, `add`, or `remove`. The  extent  of a function is the bag of tuples mapping its arguments to corresponding results. Updating a stored function means updating its extent.
Syntax:
```
update-stmt ::=
        update-op update-item [from-clause] [where-clause]

update-op ::=
        'set' | 'add' | 'remove'

update-item ::=
        function-name '(' expr-commalist ')' '=' expr
```
For example, assume we have defined the following functions:
```
  create function name(Person) -> Charstring as stored;
  create function hobbies(Person) -> Bag of Charstring as stored;
```
Furthermore, assume we have created two objects of type Person bound to the environment variables `:sam` and `:eve:`
  create Person instances :sam, :eve;
The set statement sets the value of an updatable function given the arguments.
For example, to set the names of the two persons, do:
  set name(:sam) = "Sam";
  set name(:eve)= "Eve";
To populate a bag valued function you can use bag expressions:
set hobbies(:eve) = bag("Camping","Diving");
The add statement adds result elements to bag valued functions.
For example, to make Sam have the hobbies sailing and fishing, do:
  add hobbies(:sam) = "Sailing";
  add hobbies(:sam) = "Fishing";
The remove statement removes the specified tuple(s) from the result of an updatable function returning a bag for given arguments, for example:
  remove hobbies(:sam) = "Fishing";
Several object properties can be assigned by specifying the set or add statement by a query.
For example, to make Eve have the same hobbies as Sam except sailing, do:
  set hobbies(:eve) = h
  from Charstring h
  where h in hobbies(:sam) and
        h != "Sailing";
A boolean function can be set to either true or false.
  create function married(Person,Person)->Boolean as stored;
  set married(:sam,:eve) = true;
Setting the value of a boolean function to false means that the truth value is removed from the extent of the function. For example,
to divorce Sam and Eve you can do either of the following:
  set married(:sam,:eve)=false;
 or
  remove married(:sam) = :eve;

A variable can be assigned to a bag returned by some function by using the assigment statement. For example:
   set :h = hobbies(:sam);
will assign :h to a bag of Sam's hobbies since the result type of function hobbies() is 'Bag of Charstring'. The elements can be extracted with in:

  in(:h);

The multiple assignment statement assigns several variables to the result of a tuple valued query, for example:
  set (:mother,:father) = parents2(:eve);
The statement
  set hobbies(:eve) = hobbies(:sam);
will update Eve's all hobbies to be the same a Sam's hobbies.

Not every function is updatable. sa.amos defines a function to be updatable if it is a stored function, or if it is derived from a single updatable function without a join that includes all arguments. In particular inverses to stored functions are updatable. For example, the following function is updatable:
  create function marriedto(Person p) -> Person q
  as select q where married(p,q);
The user can declare explicit update rules for derived functions making also non-updatable functions updatable.

#### Cardinality constraints

A cardinality constraint is a system maintained restriction on the number of allowed occurrences in the database of an argument or result of a stored function. For example, a cardinality constraint can be that there at most one salary per person, while a person may have any number of children. The cardinality constraints are normally specified by the result part of a stored function's signature.

For example, the following restricts each person to have one salary while many children are allowed:
```
create function salary(Person p) -> Charstring nm as stored;
create function children(Person p) -> Bag of Person c as stored;
```
The system will restrict database updates so that the cardinality constraints are not violated.  For the function `salary()` an error is raised if one tries to make a person have two salaries when updating it with the add statement, while there is no such restriction on children(). If the cardinality constraint is violated by a database update the following error message is printed: `Update would violate upper object participation (updating function ...)`

In general one can maintain four kinds of cardinality constraints for a function modeling a relationship between types, many-one, many-many, one-one, and one-many:
many-one is the default when defining a stored function as in `salary()`.

many-many is specified by prefixing the result type specification with 'Bag of' as in `children()`.

one-one is specified by suffixing a result variable with 'key'
For example:
```
create function name(Person p) -> Charstring nm key as stored;
```
will guarantee that a person's name is unique.

one-many is normally represented by the inverse function. For example, suppose we want to represent the one-many relationship between types Department and Employee, there can be many employees for a given department but only one department for a given employee. The recommended way is to define the function:
```
create function department(Employee e) -> Department d as stored;
```
The inverse function can then be defined as a derived function:
```
create function employees(Department d) -> Bag of Employee e
  as select e where department(e) = d;
```

Inverse functions are updatable.
Any variable in a stored function can be specified as key, which will restrict the updates the stored functions to maintain key uniqueness for the argument or result of the stored function. For example, the cardinality constraints on the following function distance() prohibits more than one distance between two cities:
```
create function distance(City x key, City y  key) ->  Integer d as stored;
```
Cardinality constraints can also be specified for foreign functions. These are important for optimizing queries involving foreign functions. However, it is up to the foreign function implementor to guarantee that specified cardinality constraints hold.

#### Changing object types dynamically

The add-type-stmt changes the type of one or more objects to the specified type.
Syntax:
```
add-type-stmt ::=
        'add type' type-name ['(' [generic-function-name-commalist] ')']
        'to' variable-commalist
```
The updated objects may be assigned initial values for all the specified property functions in the same manner as in the create object statement.
The remove-type-stmt makes one or more objects no longer belong to the specified type.
Syntax:
```
remove-type-stmt ::=
        'remove type' type-name 'from' variable-commalist
```

Referential integrity is maintained so that all references to the objects as instances of the specified type cease to exist.  If all user defined types have been removed, the object will still be member of type Userobject.

#### User update procedures

It is possible to register user defined user update procedures for any function. The user update procedures are procedural functions which are transparently invoked when update statements are executed for the function.
```
set_addfunction(Function f, Function up)->Boolean
set_remfunction(Function f, Function up)->Boolean
set_setfunction(Function f, Function up)->Boolean
```

The function `f` is the function for which we wish to declare a user update function and up is the actual update procedure. The arguments of a user update procedures is the concatenation of argument and result tuples of f. For example, assume we have a function

```
create function netincome(Employee e) -> Number
    as income(e)-taxes(e);
```
Then we can define the following user update procedure:

```
create function set_netincome(Employee e, Number i)-> Boolean
       as begin
             set taxes(e)= i*taxes(e)/income(e) + taxes(e);
             set income(e) = i*(1-taxes(e))/income(e) + income(e);
          end;
```

The following declaration makes netincome() updatable with the set statement:
  set_setfunction(#'employee.netincome->number',
                  #'employee.number->boolean');

Now one can update netincome() with, e.g.:
  set netincome(p)=32000 from Person p where name(p)="Tore";


#### Dynamic updates

Sometimes it is necessary to be able to create objects whose types are not known until runtime. Similarly one may wish to update functions without knowing the name of the function until runtime. For this there are the following system procedural system functions:
createobject(Type t)->Object
createobject(Charstring tpe)->Object
deleteobject(Object o)->Boolean
addfunction(Function f, Vector argl, Vector resl)->Boolean
remfunction(Function f, Vector argl, Vector resl)->Boolean
setfunction(Function f, Vector argl, Vector resl)->Boolean

createobject() creates a surrogate object of the type specified by its argument.

deleteobject() deletes a surrogate object.

The procedural system functions setfunction(), addfunction(), and remfunction() update a function given an argument list and a result tuple as vectors. They return TRUE if the update succeeded.
To delete all rows in a stored function fn, use
dropfunction(Function fn, Integer permanent)->Function
If the parameter permanent is one the deletion cannot be rolled back.

### Collections

sa.amos supports three kinds of collections: bags, vectors, and key-value collections (records):
A bag is a set where duplicates are allowed.
A vector is an ordered sequence of objects.
A record is an associative array of key-value pairs.
The result of a query is a bag of tuples of objects. The tuples themselves are not objects but must be retrieved using the tuple-expr notation. This section first introduces aggregate functions, which are functions computing aggregated values over bags, such as sums and averages. Then the general behavior of the built in collection types Bag and Vector are described.

#### Subqueries and aggregate functions

Aggregate functions are functions where one or several arguments are declared as bags:
   Bag of type x
The following system aggregate functions are defined:
   sum(Bag of Number x) -> Number
   count(Bag of Object x) -> Integer
   avg(Bag of Number x) -> Real
   stdev(Bag of Number x) -> Real
   maxagg(Bag of Object x) -> Object
   minagg(Bag of Object x) -> Object
   some(Bag of Object x) -> Boolean
   notany(Bag of Object x) -> Boolean
For example, sum() must be applied only to bags of numbers.
Now consider the query:
  select name(friends(p))
  from Person p
  where name(p)= "Bill";
The function friends() returns several (a bag of) persons on which the function name() is applied. The normal semantics in sa.amos is that when a function (e.g. name()) is applied on a bag valued function  (e.g. friends()) it will be applied on each element of the returned bag.  In the example a bag of the names of the persons named Bill is returned.

Aggregate functions work differently. They are applied on the entire bag. For example:
```
count(friends(:p));
```
In this case `count()` is applied on the entire bag of all friends of :p. This closed bag is specified by declaring the type of an argument of an aggregate function with 'Bag of''. The function count() has the signature:
```
count(Bag of Object) -> Integer
```
Aggregate functions can be applied on subqueries, for example:
```
count(select p from Person p);
```
The following two queries return the same values:
```
count(select friends(:p));
count(friends(:p));
```
Local variables in queries may be declared as bags that can be used as arguments to aggregate functions.
For example, the function totalincomes() computes the sum of all incomes:
```
create function totalincomes()->Integer
  as sum(select income(p) from Person P);
```
or
```
create function totalincomes()->Integer
  as select sum(b)
     from Bag of Integer b
     where b = (select income(p)
                 from Person p);
```
Notice that stored functions cannot have arguments declared 'Bag of''.

#### Bags

When a stored function is defined the default is that it can return only a single value. For example:
```
create function friends(Person p) -> Person f as stored;
```
In this case there is a cardinality constraint that says that a given person p can have only a single friend f. This cardinality constraint is removed by instead defining:
```
create function friends(Person p) -> Bag of Person f as stored;
```
The update commands set, add, and remove can be used for updating such bag valued functions.

For derived functions the result can potentially always be a bag since the result of the select statement is a bag. For example:
```
create function friendsof(Charstring pn)-> Bag of Charstring fn
  as select name(friends(p))
     from Person p
     where name(p)=pn;
```
You can set a variable to the bag representing the result from a query (i.e. a select statement), for example:
```
set :fnb = friendsof("Bill");
```
Since the result type of friendsof() is 'Bag of Charstring', in this case the variable :fnb is bound to the bag of friends of Bill. If the result type had been just 'Charstring', instead :fnb would have been assigned the first element in the bag of Bill's friends.

You can extract the elements from the bag with the `in()` function or infix operator:
```
in(:fnb);
select fn from Charstring fn where fn in :fnb;
```

Notice that, unlike most programming languages, bags are usually not evaluated when they are assigned. It is up to the query optimizer to compute the values of a bag when so needed.

Query variables can also be bound to bags, e.g.:
```
select sum(b),count(b)
from Bag of Integer b
where b = (select income(p)
           from Person p);
```
The elements of a bag can be extracted with the in operator, e.g.:
```
select t/i
from Number i, Number t, Bag of (Number, Number) b
where (i, t) in b and
       b = (select income(p), taxes(p)
            from Person p);
```

Notice that in this case the preferred much more elegant flat formulation of the query is:
```
select income(p)/taxes(p)
from Person p;
```
Avoid using the in operator if a more elegant flat query formulation can be made!

Sometimes it is more convenient to use the function in() that extracts the elements from closed bags, for example:
```
select in(b)
from Bag of Number b
where b = (select income(p)
           from Person p);
```

Notice that the preferred elegant flat formulation of the above query is:
```
select income(p)
from Person p;
```

If you make the query
```
count(friends(:p));
```
the system uses a rule that non bag arguments are converted (coerced) into a closed bags if an argument (e.g. of the aggregate function count) so requires.

The query could also have been formulated with an explicitly specified bag as

```
count(select friends(:p));
```

Sometimes it may be necessary to materialize a bag explicitly, which is done by the function:
```
materialize(Bag of T b) -> T m
```
where T can be any type. The function materialize() extracts all the elements from bag b and stores them in the materialized bag m. Notice the differences between these assignments:

```
set :f = friendsof("Bill");                /* assigns :f to a bag of Bill's friends. */
set :mb = materialize(friendsof("Bill"));  /* Assigns :mb to a materialized bag of Bill's friends */
```

To compare that two bags are equal use:
```
  bequal(Bag x, Bag y) -> Boolean
```
Notice that bequal() materializes its arguments before doing the equality computation.

#### Vectors

Vectors represent sequences of objects of any type. Vectors can be constructed in queries and updates using the vector-expr notation.
For example:
```
set :a = {1,2,3};
```
sets variable :a to a vector value.

The following query forms a bag of vectors holding the persons named Bill together with their ages.
```
select {p,age(p)} from Person p where name(p)="Bill";
```

The previous query is different from the query
```
select p, age(p) from Person p where name(p)="Bill"
```
that returns bag of tuples.

Vectors can be queried by converting them to bags using the in operator.
For example:
```
select x from Number x where x > 1 and x in :a;
```
returns the bag elements:
```
2
3
```

Notice that the order of the elements of a bag is not predetermined and you cannot assume that selecting elements from a vector is in the vector's element order. In general the order of the elements of a bag is undefined and the query optimizer has the freedom to return a bag in any order if that speeds up query execution.

Vector elements can also be accessed using the vector-indexing notation:
```
vector-indexing ::= simple-expr '[' expr-commalist ']'
```

The first element in a vector has index 0 etc.
For example:
```
:a[0]+:a[1];
```
returns
```
3
``
Index variables can be unbound in queries to specify iteration over all possibles index positions of a vector.
For example:
```
select i, :a[i] from Integer i, where i >= 1;
```
returns the bag of tuples:
```
(1,2)
(2,3)
```

The following function converts a vector to a bag:
```
create function vectorBag(Vector v) -> Bag of Object
as select v[i]
   from Integer i;
```

For example:
```
vectorbag({1,2,3});
```
returns the bag
```
1
2
3
```

The aggregate function `vectorof()` converts a bag to a vector:
```
vectorof(Bag of Object b) -> Vector v
```

For example:
```
vectorof(select iota(1,10));
```
or just:
```
vectorof(iota(1,10));
```
returns the vector
```
{1,2,3,4,5,6,7,8,9,10}
```

The function `vectorof()`  can be used when the order of the elements in the produced vector is unimportant. Notice again that the order of the elements returned by a select expression (bag) is undetermined.  The order of the elements in a bag depends on the operators in the query and is the order that is the most efficient to execute the query.

In order to exactly specify the index order when converting a bag to a vector, use the system aggregate function:
```
vectorize(Bag vb) -> Vector r
```
The function `vectorize()` takes as input vb a vector bag of tuples `(i, o)` and forms a vector `r` containing objects `o` in position `i` of the vector bag.
For example:
```
vectorize(select i, i*i
          from Integer i
          where i in iota(0,10));
```
will form the vector
```
{0,1,4,9,16,25,36,49,64,81,100}
```
The function `vectorize()` is much slower than `vectorof()`, so use `vectorize()` only when needed.

If the tuples in a vector bag has more than two elments,  (i, o1,o2,...), `vectorize()` will form vectors of vectors.

For example:
```
vectorize(select i, 2*i, 3*i
          from Integer i
          where i in iota(0,10));
```
will form the vector
```
{{0,0},{2,3},{4,6},{6,9},{8,12},{10,15},{12,18},{14,21},{16,24},{18,27},{20,30}}
```

To convert a vector into a vector bag use the system function
```
bagify(Vector v)-> Bag of (Integer i, Object o1,...on)
```

For example:
```
bagify({2,4,6,8});
```
yields the bag
```
(0,2)
(1,4)
(2,6)
(3,8)
```
The query:
```
bagify({{1,2},{3,4}});
```
yields the bag:
```
(0,{1,2})
(1,{3,4})
```
Notice that the function `bagify()` is the inverse of function `vectorize()`.

The function `project()` constructs a new vector by extracting from the vector v the elements in the positions in pv:
```
project(Vector v, Vector of Number pv) -> Vector r
```
For example:
```
project({10, 20, 30, 40},{0, 3, 2});
```
returns:
```
{10, 40, 30}
```

The function `substv()` replaces x with y in any collection v:

```
substv(Object x, Object y, Object v) -> Object r
```
The system function dim() computes the size d of a vector v:

```
dim(Vector v) -> Integer d
```
The function `concat()` concatenates two vectors:
```
concat(Vector x, Vector y) -> Vector r
```

#### Key-value associations

The collection datatype named Record is used for representing dynamic associations between keys and values.  A record is a dynamic and associative array. Other commonly used terms for associative arrays are property lists, key-value pairs, or hash links (Java). For example the following expression represents a record where the key (property) 'Greeting' field has the value 'Hello, I am Tore' and the key 'Email' has the value 'Tore.Andersson@it.uu.se':
{'Greeting':'Hello, I am Tore','Email':'Tore.Andersson@it.uu.se'}
You can store records in sa.amos as any other datatype, e.g.
create function pdata(Person) -> Record as stored;
create Person(pdata) instances ({'Greeting':'Hello, I am Tore',
                                 'Email':'Tore.Andersson@it.uu.se'});
A possible query could be:
select r['Greeting']
from Person p, Record r
where name(p)='Tore' and pdata(p)=r;
Notice that records and sa.amos function are similar. The main difference is that records are dynamic in the sense that one can assign property values without any restrictions, while functions must be predefined by the schema. The problem with arbitrary properties is that there is no guarantee that users are actually being systematic when assigning new properties, while with schema-defined functions one gets a systematic naming of the properties. The user should be careful to choose the right data representation depending on the application.
2.7 Data mining primitives

sa.amos provides primitives for advanced analysis, aggregation, and visualizations of data collections. This is useful for data mining applications, e.g. for clustering and identifying patterns in data collections. Primitives are provided for analyzing both unordered collections (bags) and ordered collections (vectors). Primitive functions are provided for grouping the result of queries, basic numerical vector functions, distance functions, and  statistical functions. The results of the analyzes can be visualized by calling an external data visualization package.
2.7.1 Top-k queries

The function topk() returns the top k elements in a bag:

  topk(Bag b, Integer k) -> Bag of (Object rk, Object value)

If the tuples in b have only one attribute (the rk attribute), the value will be nil.

For example,
topk(iota(1, 100), 3);
returns
(98,NIL)
(99,NIL)
(100,NIL)
whereas
topk((select i, v[i-1]
      from integer i, vector v
      where i in iota(1, 5)
      and v={"", "", "", "fourth", "fifth"}), 3);
returns
(3,"")
(4,"fourth")
(5,"fifth")
Similar to topk(), leastk() returns the k least elements in a bag.
  leastk(Bag b, Integer k) -> Bag of (Object key, Object value)

For example,
leastk(iota(1, 100), 3);

returns
(3,NIL)
(2,NIL)
(1,NIL)
2.7.2 Grouped aggregation

To investigate how related data values form groups of values, aggregate functions need to be applied on groups of values for each value of some variable. For example, one would like to count how many employees there are for each department with the following schema:
  create type Department;
  create function name(Department)->Charstring as stored;
  create type Employee;
  create function name(Employee)->Charstring as stored;
  create function dept(Employee)->Department as stored;

  create Department(name) instances :d1 ("Toys"), :d2 ("Cloths");
  create Employee(name, dept) instances ("Kalle", :d1),("Pelle", :d1),("Oskar",:d2),("Ludolf",:d2),("Anna",:d2);
The following query returns the different departments in dept along with counts of the number of employees per department;
  groupby((select name(d), e
           from Department d, Employee e
           where dept(e)=d),
          #'count');
  =>  ("Toys",2)
      ("Cloths",3)
The groups on which the aggregate function is applied are constructed with the group forming query:
  select name(d), e
  from Department d, Employee e
  where dept(e)=d;
  => ("Toys",#[OID 1360])
     ("Toys",#[OID 1359])
     ("Cloths",#[OID 1361])
     ("Cloths",#[OID 1362])
     ("Cloths",#[OID 1363])
The second order aggregate function groupby() has the signature:
groupby(Bag of (Object,Object) sq, Function aggfn) -> Bag of (Object gk, Object aggv)
The bag sq contains key-value pairs  (k, v) where k is called a group key and v is an arbitrary value paired with k.  The result is a bag of new key-value pairs (gk, aggv) where gk is each distinct group key in sq and aggv is the result of applying aggfn on the bag of the values paired with gk.
2.7.3 Numerical vector functions

The `times()` function `(infix operator: * )` is defined as the scalar product for vectors of numbers:
  times(Vector x, Vector y) -> Number r
For example:
```
  {1, 2, 3} * {4, 5, 6};
```
returns the number 32.

The elemtimes() function (infix operator: .*) is defined as the element wise product for vectors of numbers:
  elemtimes(Vector x, Vector y) -> Vector of Number r
For example:
  {1, 2, 3} .* {4, 5, 6};
returns {4, 10, 18}.

The elemdiv() function (infix operator: ./) is defined as the element wise fractions for vectors of numbers:
  elemdiv(Vector x, Vector y) -> Vector of Number r
For example:
  {1, 2, 3} ./ {4, 5, 6};
returns {0.25, 0.4, 0.5}.

The elempower() function (infix operator: .^) is defined as the element wise power for vectors of numbers:
  elempower(Vector of Number x, Number exp) -> Vector of Number r
For example:
  {1, 2, 3} .^ 2;
returns {1, 4, 9}.

The plus() and minus() functions (infix operators: + and - ) are defined as the element wise sum and difference for vectors of numbers, respectively:
  plus(Vector of number x, Vector of number y) -> Vector of Number r
  minus(Vector of number x, Vector of number y) -> Vector of Number r
For example:
  {1, 2, 3} + {4, 5, 6};
returns {5, 7, 9} and
  {1, 2, 3} - {4, 5, 6};
returns {-3, -3, -3}.

The times() and div() functions (infix operators: * and / ) scale vectors by a scalar:
  times(Vector of number x,Number y) -> Vector of Number r
  div(Vector of number x,Number y) -> Vector of Number r
For example:
  {1, 2, 3} * 1.5;
returns {1.5, 3.0, 4.5}

For user convenience, plus() and minus() functions (infix operators: + and -) allow mixing vectors and scalars:
  plus(Vector of Number x, Number y) -> Vector of Number r
  minus(Vector of Number x, Number y) -> Vector of Number r
For example:
  {1, 2, 3} + 10;
returns {11, 12, 13} and
  {1, 2, 3} - 10;
returns {-9, -8, -7}.

These functions can be used in queries too:
  select lambda from number lambda where {1, 2} - lambda = {11, 12};
returns -10.

If the equation has no solution, the query will have no result:
  select lambda from number lambda where {1, 3} - lambda = {11, 12};

By contrast, note that this query will have a result:
  select lambda from vector of number lambda where {1, 2} - lambda = {11, 12};
returns {-10,-9}.

The functions zeros() and ones() generate vectors of zeros and ones, respectively:
  zeros(Integer)-> Vector of Number
  ones(Integer)-> Vector of Number
For example:
  zeros(5);
 results in {0, 0, 0, 0, 0}
  3.1 * ones(4);
 results in {3.1, 3.1, 3.1, 3.1}

The function roundto() rounds each element in a vector of numbers to the desired number of decimals:
  roundto(Vector of Number v, Integer d) -> Vector of Number r
For example:
  roundto({3.14159, 2.71828}, 2);
 returns {3.14, 2.72}

The function vavg() computes the average value a of a vector of numbers v:
  vavg(Vector of Number v) -> Real a

The function vstdev() computes the standard deviation s of a vector of numbers v:
  vstdev(Vector of Number v) -> Real s

The function median() computes the median m of a vector of numbers v:
  median(Vector of Number v) -> Number m

The function euclid() computes the Euclidean distance between two points p1 and p2 expressed as vectors of numbers:
  euclid(Vector of Number p1, Vector of Number p2) -> Real d

The function minkowski() computes the Minkowski distance between two points p1 and p2 expressed as vectors of numbers, with the Minkowski parameter r:
  minkowski(Vector of Number p1, Vector of Number p2, Real r) -> Real d

The function maxnorm() computes the Maxnorm distance between two points p1 and p2 (conceptually, this is the same as the Minkowski distance with r = infinity):
  maxnorm(Vector of Number p1, Vector of Number p2) -> Real d

#### Vector aggregate functions

The following functions group and compute aggregate values over collections of numerical vectors.

Dimension-wise aggregates over bags of vectors can be computed using the function aggv:
```
aggv(Bag of Vector, Function) -> Vector
```
For example:
```
aggv((select {i, i + 10}
 from integer i
 where i in iota(1, 10)), #'avg');
results in {5.5, 15.5}
 ```

Each dimension in a bag of vector of number can be normalized using one of the normalization functions `meansub()`, `zscore()`, or `maxmin()`. They all have the same signature:
meansub(Bag of Vector of Number b) -> Bag of Vector of Number
zscore(Bag of Vector of Number b) -> Bag of Vector of Number
maxmin(Bag of Vector of Number b) -> Bag of Vector of Number
meansub() transforms each dimension to a N(0, s) distribution (assuming that the dimension was N(u, s) distributed) by subtracting the mean u of each dimension. zscore() transforms each dimension to a N(0, 1) distribution by also dividing by the standard deviation of each dimension. maxmin() transforms each dimension to be on the [0, 1] interval by applying the transformation (w - min) ./ (max - min) to each vector w in bag b where max and min are computed using aggv(b, #'maxagg') and aggv(b, #'minagg') respectively.
For example:
meansub((select {i, i/2 + 10}
         from integer i
         where i in iota(1, 5)));
 results in
{-2.0,-1.0}
{-1.0,-0.5}
{0.0,0.0}
{1.0,0.5}
{2.0,1.0}
Principal Component Analysis is performed using the function pca():
  pca(Bag of Vector data)-> (Vector of Number eigval D, Vector of Vector of Number eigvec W)
pca() takes a bag of M-dimensional vectors in data and computes the MxM covariance matrix C of the input vectors. Then, pca() computes the M eigenvalues D and the MxM eigenvector matrix W of the covariance matrix. pca() returns the eigenvalues D and their corresponding eigenvectors W.

To use pca() to reduce the dimensionality to the L most significant dimensions, each input vector must be projected onto the eigenvectors corresponding to the L greatest eigenvalues using the scalar product. This is done using the function pcascore():
  pcascore(Bag of Vector of Number, Integer d) -> Vector of Number score
pcascore() performs PCA on data, and projects each data vector in data onto the d first eigenvectors. Each projected vector in data is emitted.
The function LPCASCORE allows a label to be passed along with each vector:
  lpcascore(Bag of (Vector of Number, Object label), Integer d) -> (Vector of Number score, Object label)
The label of each vector remains unchanged during projection.

Note that the input data might have to be pre-processed, using some vector normalization.

#### Plotting numerical data

sa.engine can utilize GNU Plot (v 4.2 or above), to plot numerical data. The `plot()` function is used to plot a line connecting two-dimensional points. Each vector in the vector v is a data point. plot() will plot the points in the order they appear in the v.
  plot(Vector of Vector v) -> Integer
The return value is the exit code of the plot program. A nonzero value indicates error.
If the data points have a higher dimensionality than two, the optional argument projs is used to select the dimension to be plotted.
  plot(Vector of Integer projs, Vector of Vector v) -> Integer
The projs vector lists the dimensions onto which each data vector is to be projected. The first dimension has number 0 (zero).

Scatter plots of bags of two-dimensional vectors are generated using scatter2().
scatter2p() and scatter2l() plots three-dimensional data in two dimensions. scatter2p() assigns a color temperature of each point according to the value of its value in the third dimension. scatter2l() labels each point in the two-dimensional plot with the its value of the third dimension. The value of the third dimension in scatter2l() could be numerical or textual.

Three-dimensional scatter plots are generated using scatter3(), scatter3l(), and scatter3p(). scatter3() plots 3-dimensional data, whereas scatter3l() and scatter3p() plot 4-dimensional data in the same fashion as scatter2p() and scatter2l().
Each scatter plot function have two different signatures:
```
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
```

### Accessing data in files

The file system where an sa.amos server is running can be access with a number of system functions:

The function pwd() returns the path to the current working directory of the server:
  pwd() -> Charstring path

The function cd() changes the current working directory of the server:
  cd(Charstring path) -> Charstring

The function dir() returns a bag of the files in a directory:
  dir() -> Bag of Charstring file
  dir(Charstring path) -> Bag of Charstring file
  dir(Charstring path, Charstring pat) -> Bag of Charstring file
The first optional argument path specifies the path to the directory. The second optional argument pat specifies a regular expression (as in like) to match the files to return.

The function file_exists() returns true if a file with a given name exists:
  file_exists(Charstring file) -> Boolean

The function directoryp() returns true if a path is a directory:
  directoryp(Charstring path) -> Boolean

The function filedate() returns the write time of a file with a given name:
  filedate(Charstring file) -> Date

#### Reading vectors from a file

The function csv_file_tuples() reads a CSV (Comma Separated Values) file. Each line is returned as a vector.
  csv_file_tuples(Charstring file) -> Bag of Vector
For example, if a file named myfile.csv contains the following lines:
1,2.3,a b c
4,5.5,d e f
Then the result from the call csv_file_tuples("myfile.csv") is  bag containing these vectors:
{1,2.3,"a b c"}
{4,5.5,"d e f"}
The CSV reader can, e.g., read CSV files saved by EXCEL in English format.

The function writecsvfile() writes the vectors in a bag b into a file in CSV  (Comma Separated Values) format so that it can loaded into, e.g., EXCEL.
  writecsvfile(Charstring file, Bag b) -> Boolean
For example, the following statement:
  writecsvfile("myoutput.csv", bag({1,"a b",2.2},{3,"d e",4.5})
produces the a file myoutput.csv having these lines:
1,a b,2.2
3,d e,4.5

The function read_ntuples() imports data from a text file of space separated values. Each line of the text file produces one vector in the result bag. Each token on a line will be parsed into field in the vector. Numbers in the file are parsed into numbers. All other tokens are parsed into strings.
  read_ntuples(Charstring file) -> Bag of Vector
For example, if a file name test.nt contains the following:
"This is the first line" another word
1 2 3 4.45 2e9
"This line is parsed into two fields" 3.14
Then the call read_ntuples("test.nt") returns a beg with the following vectors:
{"This is the first line","another","word"}
{1,2,3,4.45,2000000000.0}
{"This line is parsed into two fields",3.14}

### Cursors

Cursors provide a way to iterate over the result of a query or a function call or the value of a variable. The open-cursor-stmt opens a new scan on the result of a query, function call, or variable binding. A scan is a data structure holding a current element, the cursor, of a potentially very large bag produced by a query, function call, or variable binding. The next element in the bag is retrieved by the fetch-cursor-stmt. Every time a fetch-cursor-stmt statement is executed the cursor is moved forward over the bag. When the end of the bag is reached the fetch-cursor-stmt returns empty result. The user can test whether there is any more elements in a scan by calling one of the functions
   `more(Scan s)   -> Boolean`
   `nomore(Scan s) -> Boolean`

that test whether the scan is has more rows or not, respectively.

```
open-cursor-stmt ::=
        'open' cursor-name 'for' expr

cursor-name ::=
        variable

fetch-cursor-stmt ::=
        'fetch' cursor-name into-clause

close-cursor-stmt ::=
        'close' cursor-name
```

For example:

```
create person (name,age) instances :Viola ('Viola',38);
open :c1  for (select p from Person p where name(p) = 'Viola');
fetch :c1 into :Viola1;
close :c1;
name(:Viola1);
--> "Viola";
```

The fetch-cursor-stmt fetches the next result tuple from the scan; i.e. the tuple is removed from the scan.

If present in a fetch-cursor-stmt, the into clause will bind elements of the first result tuple to AmosQL interface variables. There must be one interface variable for each element in the next cursor tuple.

If no into clause is present in a fetch-cursor-stmt, a single result tuple is fetched and displayed.

The close-cursor-stmt deallocates the scan.
Cursors allow iteration over very large bags created by queries or function calls. For example,
 set :b = (select iota(1,1000000)+iota(1,1000000));
/* :b contains a bag with 10**12 elements! */

open :c for :b;
fetch :c;
-> 2
fetch :c;
-> 3
etc.
close :c;
Cursors are implemented using a special datatype called Scan that allows iterating over very large bags of tuples. The following functions are available for accessing the tuples in a scan as vectors:
next(Scan s)->Vector
moves the cursor to the next tuple in a scan and returns the cursor tuple. The fetch-cursor-statement is based on this function.
this(Scan s)->Vector
returns the current tuple in a scan without moving the cursor forward.
Notice that cursors can be used as an alternative to the for-each statement for iterating over the result of a bag. The for-each statements is faster than iterating with cursors but it cannot be used for simultanously iterating over several bags such as is done by the sumb2() example function.
peek(Scan s)->Vector
returns the next tuple in a scan without moving the cursor forward.
3 Procedural functions
A procedural function is an sa.amos function defined as a sequence of AmosQL statements that may have side effects (e.g. database update statements). Procedural functions may return a bag of results by using a special return statement. Each time return is called another result ba element is emitted from the function. Procedural functions should not be used in queries. However, this restriction is currently not enforced. Most, but not all, AmosQL statements are allowed in procedure bodies as can be seen by the syntax below.
Syntax:

procedural-function-definition ::=
        block | procedure-stmt

    procedure-stmt ::=
        create-object-stmt |
        delete-object-stmt |
        for-each-stmt |
        update-stmt |
        add-type-stmt |
        remove-type-stmt |
        set-local-variable-stmt |
        query |
        if-stmt |
        commit-stmt |
        abort-stmt |
        loop-stmt |
        while-stmt |
        open-cursor-stmt |
        fetch-cursor-stmt |
        close-cursor-stmt

    block ::=
        'begin'
               ['declare' variable-declaration-commalist ';']
               procedure-stmt-semicolonlist
        'end'

    return-stmt ::=
        'return' expr

    for-each-stmt ::=
        'for each' [for-each-option] variable-declaration-commalist
                   [where-clause] for-each-body

    for-each-option ::= 'distinct' | 'copy'

    for-each-body ::= procedure-body

    if-stmt ::=
        'if' expr
        'then' procedure-body
        ['else' procedure-body]

     set-local-variable-stmt ::=
        'set' local-variable '=' expr

    while-stmt ::=
        'while' expr 'do' procedure-stmt-semicolonlist 'end while'

    loop-stmt ::=
        'loop' procedure-stmt-semicolonlist 'end loop'

    leave-stmt ::=
        'leave'
Examples:
 create function creperson(Charstring nm,Integer inc) -> Person p
                as
                begin
                  create Person instances p;
                  set name(p)=nm;
                  set income(p)=inc;
                  return p;
                end;

 set :p = creperson('Karl',3500);

 create function makestudent(Object o,Integer sc) -> Boolean
                as add type Student(score) to o (sc);

 makestudent(:p,30);

 create function flatten_incomes(Integer threshold) -> Boolean
                as for each Person p where income(p) > threshold
                     set income(p) = income(p) -
                                     (income(p) - threshold) / 2;

 flatten_incomes(1000);

 create function sumb2(Bag of Number b1, Bag of Number b2)->Number
   as begin declare Number r, Number x1, Number x2, Scan c1, Scan c2;
            open c1 for b1;
            open c2 for b2;
            set r = 0;
            while more(c1) and more(c2)
            do fetch c1 into x1;
               fetch c2 into x2;
               set r = r + x1*x2;
               return r;
            end while;
      end;

sumb2(iota(1,10),iota(10,20));
Notice that queries and updates embedded in procedure bodies are optimized at compile time. The compiler saves the optimized query plans in the database so that dynamic query optimization is not needed when procedural functions are executed.
A procedural function may return a bag of result values iteratively. The return-stmt statement is used for this, where an element of the result bag is returned every time it is executed.  The return-stmt does not not abort the control flow (different from, e.g., return in C), but it only specifies that a value is to be emitted to the return bag of the function and then the procedure evaluation is continued as usual. If return-stmt is never called the result of the procedural function is empty. Usually the result type of procedural functions not returning any value is Boolean.
3.1 Iterating over results
The for-each statement iterates over the result of the query specified by the variable declarations (variable-declaration-commalist) and the where clause executing the for-each-body for each result variable binding of the query. For example the following function adds inc to the incomes of all persons with salaries higher than limit and returns their old incomes:

 create function increase_incomes(Integer inc,Integer limit)
                                         -> Integer oldinc
            as for each Person p, Integer i
               where i > limit
                 and i = income(p)
              begin
                return i;
                set income(p) = i + inc
              end;
The for-each-stmt does not return any value at all unless return-stmt is called within its body.

The for-each-option specifies how to treat the result of the query iterated over. If it is omitted the system default is to iterate directly over the result of the query while immediately applying the for-each-body on each retrieved element. If 'distinct' is specified the iteration is over a copy where duplicates in addition have been removed. If  the option is 'copy' the code is applied on a copy of the result of the query.

4 The SQL processor

sa.amos databases can be manipulated using SQL as an alternative to AmosQL. The SQL preprocessor translates SQL commands to corresponding AmosQL statements. The SQL preprocessor is called using a special foreign function:
 sql(Charstring query)->Bag of vector result
To make an sa.amos function be queried using SQL its name must be prefixed with 'sql:'. Thus an sa.amos function whose name is sql:<table> can be regarded as a table named <table> which is queried and updated using SQL statements passed as argument to the foreign function sql.

For example, assume we define the stored functions:
 create function sql:employee(Integer ssn) -> (Charstring name, Number Income, Integer dept) as stored;
 create function sql:dept(Integer dno) -> Charstring dname as stored;
Then we can populate the tables by the following calls to the sql function:
 sql("insert into employee values (12345, ‘Kalle’, 10000, 1)");
 sql("insert into employee values (12386, ‘Elsa’, 12000, 2)");
 sql("insert into employee values (12493, ‘Olof’, 5000, 1)");
 sql("insert into dept values(1,’Toys’)");
 sql("insert into dept values(2,’Cloths’)");
Examples of SQL queries are:
 sql("select ssn from employee where name = ‘Kalle’");
 sql("select dname from dept, employee where dept = dno and name=’Kalle’");
The parser is based on the SQL-92 version of SQL. Thus, the SQL processor allows an sa.amos database be both updated and queried using SQL-92. The parser passes most of the SQL-92 validation test.  However, SQL views are not supported. For further details see http://www.it.uu.se/research/group/udbl/Theses/MarkusJagerskoghMSc.pdf.
The command line option
         amos2 ... -q sql...
will make sa.amos accept SQL as query language in the REPL rather than AmosQL.
5 Peer management
Using a basic sa.amos peer communication system, distributed sa.amos peers can be set up that communicate using TCP/IP. A federation of sa.amos peers is managed by a name server which is an sa.amos peer knowing addresses and names of other sa.amos peers. Queries, AmosQL commands, and results can be shipped between peers. Once a federation is set up, multi-database facilities can be used for defining queries and views spanning several sa.amos peers [RJK03]. Reconciliation primitives can be used for defining object-oriented multi-peer views [JR99a][JR99b].
5.1 Peer communication

The following AmosQL system functions are available for inter-peer communication:
   nameserver(Charstring name)->Charstring
The function makes the current stand-alone database into a name server and registers there itself as a peer with the given name. If name is empty ("") the name server will become anonymous and not registered as a peer. It can be accessed under the peer name "NAMESERVER" through.
   listen()
The function starts the peer listening loop. It informs the name server that this peer is ready to receive incoming messages. The listening loop can be interrupted with `ctrl-c` and resumed again by calling listen(). The name server must be listening before any other peer can register.

   register(Charstring name)->Charstring
The function registers in the name server the current stand-alone database as a peer with the given name.  The system will complain if the name is already registered in the name server.  The peer needs to be activated with listen() to be able to receive incoming requests. The name server must be running on the local host.
   register(Charstring name, Charstring host)->Charstring
Registers the current database as a peer in the federation name server running on the given host. Signals error if peer with same name already registered in federation.
   reregister(Charstring name)->Charstring
   reregister(Charstring name, Charstring host)->Charstring
as register() but first unregisters another registered peer having same name rather than signaling error. Good when restarting peer registered in name server after crash so the crashed peer will be unregistered.

   this_amosid()->Charstring name
Returns the name of the peer where the call is issued. Returns the string "NIL" if issued in a not registered standalone sa.amos system.

   other_peers()->Bag of Charstring name
Returns the names of the other peers in the federation managed by the name server.

   ship(Charstring peer, Charstring cmd)-> Bag of Vector
Ships the AmosQL command cmd for execution in the named peer. The result is shipped back to the caller as a set of tuples represented as vectors.  If an error happens at the other peer the error is also shipped back.
   call_function(Charstring peer, Charstring fn, Vector args, Integer stopafter)-> Bag of Vector
Calls the sa.amos function named fn with argument list args in peer. The result is shipped back to the caller as a set of tuples represented as vectors. The maximum number of tuples shipped back is limited by stopafter. If an error happens at the other peer the error is also shipped back.

   send(Charstring peer, Charstring cmd)-> Charstring peer
Sends the AmosQL command cmd for asynchronous execution in the named peer without waiting for the result to be returned. Errors are handled at the other peer and not shipped back.
   send_call(Charstring peer, Charstring fn, Vector args)-> Boolean
Calls the sa.amos function named fn with argument list args asynchronously in the named peer without waiting for the result to be returned. Errors are handled at the other peer and not shipped back.

   broadcast(Charstring cmd)-> Bag of Charstring
Sends the AmosQL command cmd for asynchronous execution in all other peers. Returns the names of the receiving peers.
   gethostname()->Charstring name
Returns the name of the host where the current peer is running.
   kill_peer(Charstring name)->Charstring
Kills the named peer. If the peer is the name server it will not be killed, though. Returns the name of the killed peer.
   kill_all_peers()->Bag of Charstring
Kills all peers. The name server and the current peer will still be alive afterwards. Returns the names of the killed peers.
   kill_the_federation()->Boolean
Kills all the peers in the federation, including the name server and the peer calling kill_the_federation.
   is_running(Charstring  peer)->Boolean
Returns true if peer is listening.
   wait_for_peer(Charstring peer)->Charstring
Waits until the peer is running and then returns the peer name.

   amos_servers()->Bag of Amos
Returns all peers managed by the name server on this computer. You need not be member of federation to run the function.

5.2 Peer queries and views
Once you have established connections to sa.amos peers you can define views of data from your peers. You first have to import the meta-data about selected types and functions from the peers. This is done by defining proxy types and proxy functions [RJK03] using the system function import_types:
   import_types(Vector of Charstring typenames,  Charstring p)-> Bag of Type pt
defines proxy types pt for types named typenames in peer p. Proxy functions are defined for the functions in p having the imported types as only argument. Inheritance among defined proxy types  is imported according to the corresponding  inheritance relationships between imported types in the peer p.
Once the proxy types and functions are defined they can transparently be queried. Proxy types can be references using @ notation to reference types in other peers.
For example,
   select name(p) from Person@p1;
selects the name property of objects of type Person in peer p1.
import_types imports only those functions having one of typenames as its single arguments. You can import other functions using system function import_func:
   import_func(Charstring fn, Charstring p)->Function pf
imports a function named fn from peer p returning proxy function pf.
On top of the imported types object-oriented multi-peer views can be defined, as described in [RJK03] consisting of derived types [JR99a] whose extents are derived through queries intersecting extents of other types, and IUTs [JR99b] whose extents reconciles unions of other type extents. Notice that the implementation of IUTs is limited. (In particular the system flag latebinding('OR'); must be set before IUTs can be used and this may cause other problems).
6 Accessing external systems

This chapter first describes multi-directional foreign functions [LR92], the basis for accessing external systems from sa.amos queries.
The we describe how to query relational databases through sa.amos. Finally some general types and functions used for defining wrappers of external sources are described.

sa.amos contains number of primitives for accessing different external data sources by defining wrappers for each kind external sources. A wrapper is a software module for making it possible to query an external data source using AmosQL. To allow transparent queries, wrappers allow specification of different capabilities for different kinds of data sources. The capabilities provide hooks to define data source specific re-write rules and cost models.
A general wrappers for relational databases using JDBC is predefined in sa.amos.
6.1 Foreign and multi-directional functions

The basis for accessing external systems from sa.amos is to define foreign functions. A foreign function allows subroutines defined in C/C++ [Ris12], Lisp [Ris06], or Java [ER00] to be called from sa.amos queries. This allows access to external databases, storage managers, or computational libraries. A foreign function is defined by the following function implementation:

foreign-body ::= simple-foreign-definition | multidirectional-definition

simple-foreign-body ::= 'foreign' [string-constant]

multidirectional-definition ::= 'multidirectional' capability-list

capability ::= (binding-pattern 'foreign' string-constant ['cost' cost-spec]['rewriter' string-constant])

binding-pattern ::= A string constant containing 'b':s and 'f':s

cost-number ::= integer-constant | real-constant

cost-spec ::= function-name | '{' cost-number ',' cost-number '}'

  For example:

   create function iota(Integer l, Integer u) -> Bag of Integer as foreign 'iota--+';
   create function sqroots(Number x)-> Bag of Number r
       as multidirectional
          ("bf" foreign 'sqrts' cost {2,2})
          ("fb" foreign 'square' cost {1.2,1});
   create function bk_access(Integer handle_id )->(Vector  key, Vector)
       /* Access rows in BerkeleyDB table */
       as multidirectional
          ('bff' foreign 'bk_scan' cost bk_cost rewriter 'abkw')
          ('bbf' foreign 'bk_get' cost {1002, 1});
   create function myabs(real x)->real y
       as multidirectional
          ("bf" foreign "JAVA:Foreign/absbf" cost {2,1})
          ("fb" foreign "JAVA:Foreign/absfb" cost {4,2});

The syntax using multidirectional definition provide for specifying different implementations of foreign functions depending on what variables are known for a call to the function in a query, which is called different binding patterns. The simplified syntax using simple-foreign-body is mainly for quick implementations of functions without paying attention to different implementations based on different binding patterns.

A foreign function can implement one of the following:
A filter which is a predicate, indicated by a foreign function whose result is of type Boolean, e.g. '<', that succeeds when certain conditions over its results are satisfied.
A computation that produces a result given that the arguments are known, e.g. + or sqrt. Such a function has no argument nor result of type Bag.
A generator that has a result of type Bag. It produces the result as a bag by generating a stream of several  result tuples given the argument tuple, e.g. iota() or the function sending SQL statements to a relational database for evaluation where the result is a bag of tuples.
An aggregate function has some argument of type Bag but not result of type Bag. It iterates over one or several bag argument to compute some aggregate value over the bag, e.g. average().
A combiner has has both one or several arguments of type Bag and some result of type Bag. It combines one or several bags to form a new bag. For example, basic join operators can be defined as combiners.
sa.amos functions in general are multi-directional. A multi-directional function can be executed also when the result of a function is given and some corresponding argument values are sought. For example, if we have a function
    parents(Person)-> Bag of Person
we can ask these AmosQL queries:
    parents(:p);  /* Result is the bag of parents of :p */
    select c from Person c where :p in parents(c);
                  /* Result is bag of children of :p */
It is often desirable to make foreign Amos II functions multi-directional as well. As a very simple example, we may wish to ask these queries using the square root function sqroots above:
    sqroots(4.0);    /* Result is -2.0 and 2.0 */
    select x from Number x where sqroots(x)=4.0;
                    /* result is 16.0 *
    sqroots(4.0)=2.0;
                    /* Is the square root of 4 = 2 */
With simple foreign functions only the forward (non-inverse) function call is possible. Multi-directional foreign functions permit also the inverse to be called in queries.

The benefit of multi-directional foreign functions is that a larger class of queries calling the function is executable, and that the system can make better query optimization. A multi-directional foreign function can have several capabilities implemented depending on the binding pattern of its arguments and results. The binding pattern is a string of b:s and f:s, indicating which arguments or results in a given situation are known or unknown, respectively.

For example, sqroots() has the following possible binding patterns:

(1) If we know x but not r, the binding pattern is "bf" and the implementation should return r as the square root of x.
(2) If we know r but not x, the binding pattern in "fb" and the implementation should return x as r**2.
(3) If we know both r and x then the binding pattern is "bb" and the implementation should check that x = r**2.

Case (1) and (2) are implemented by multi-directional foreign function sqroots() above.
Case (3) need not be implemented as it is inferred by the system by first executing r**2 and then checking that the result is equal to x (see [LR92]).

To implement a multi-directional foreign function you first need to think of which binding patterns require implementations. In the sqroots case one implementation handles the square root and the other one handles the square. The binding patterns will be "bf" for the square root and "fb" for the square.

The following steps are required to define a foreign function:
Implement each foreign function capability using the interface of the implementation language. For Java this is explained in [ER00]  and for C in  [Ris12].
In case the foreign code implemented in C/C++ the implementation must be implemented as a DLL (Windows) or a shared library (Unix) and dynamically linked to the kernel by calling the function load_extension("name-of-extension"). There is an example of a Visual Studio project (Windows) files or a Makefile (Unix) in folder demo of the downloaded sa.amos version.
The main program of the DLL/shared library extension must also assign a symbolic name to the foreign C functions which is referenced in the foreign function definition (sqrts and square in the example above) [Ris12].
Finally a multidirectional foreign function needs to be defined through a foreign function definition in AmosQL as above. Here the implementor may associate a binding pattern and an optional cost estimate with each capability. Normally the foreign function definition is done separate from the actual code implementing its capabilities, in an AmosQL script.
A capability can also be defined as a select expression (i.e. query) executed for the given binding pattern. The variables marked bound (b) are inputs to the select expression and the result binds the free (f) variables. For example, sqroots() could also have been defined by:

   create function sqroots(Number x)-> Bag of Number r
       as multidirectional
          ("bf" foreign 'sqrts' cost {2,2}) /* capability by foreign function */
          ("fb" select r*r);                /* capability by query */

Notice here that sqroots() is defined as a foreign function when x is known and r computed, while it is a derived function when r is known and x computed. This kind of functionality is useful when different methods are used for computing a function and its inverses.

A capability can be defined as a key to improve query optimization, e.g.

   create function sqroots(Number x)-> Bag of Number r
       as multidirectional
          ("bf" foreign 'sqrts' cost {2,2}) /* not unique square root per x */
          ("fb" key select r*r);            /* unique square per r */

Be very careful not to declare a binding pattern as key unless it really is a key for the arguments and results of the function. In the case of sqroots() the declaration says that if yoo know r you can uniquely determine x. However, there is no key for binding pattern bf since if you know x there may be severeal (i.e. two) square roots, the positive and the negative. The key declarions are used by the system to optimize queries. Wrong key declarations may result in wrong query results because the optimizer has assumed incorrect key uniqueness.

An example of an advanced multidirectional function is the bult-in function plus() (operator +):
 create function plus(Number x, Number y) -> Number r
  as multidirectional
     ('bbf' key foreign 'plus--+')     /* addition*/
     ('bfb' key foreign 'plus-+-')     /* subtraction */
     ('fbb' key select x where y+x=r); /* Addition is commutative */
For further details on how to define multidirectional foreign functions for different implementation languages see  [Ris12][ER00].

6.1.1 Cost estimates

Different capabilities of multi-directional foreign functions often have different execution costs. In the sqroots() example the cost of computing the square root is higher than the cost of computing the square. When there are several alternative implementations of a multi-directional foreign function the cost-based query optimizer needs cost estimates that help it choose the most efficient implementation. In the example we might want to indicate that the cost of executing a square root is double as large as the cost of executing a square.

Furthermore, the cost of executing a query depends on the expected size of the result from a function call. This is called the fanout (or selectivity for predicates) of the call for a given binding pattern. In the multi-directional foreign function sqroots() example the implementation sqrts usually has a fanout of 2, while square has a fanout of 1.

Thus for good query optimization each foreign function capability should have associated costs and fanouts:
The cost is an estimate of how expensive it is to completely execute (emit all tuples of) a foreign function for given arguments.
The fanout estimates the expected number of elements in the result stream (emitted tuples), given the arguments.
The cost and fanout for a multi-directional foreign function implementation can be either specified as a constant vector of two numbers (as in sqroots()) or as an sa.amos cost function returning the vector of cost and fanout for a given function call. The numbers normally need only be rough numbers, as they are used by the query optimizer to compare the costs of different possible execution plans to produce the optimal one. The number 1 for the cost of a foreign function should roughly be the cost to perform a cheap function call, such as '+' or '<'. Notice that these estimates are run a query optimization time, not when the query is executed, so the estimates must be based on meta-data about the multi-directional foreign function.

If the simplified syntax is used or no cost is specified the system tries to put reasonable default costs and fanouts on foreign functions, the default cost model. The default cost model estimates the cost based on the signature of the function, index definitions, and some other heuristics. For example, the default cost model assumes aggregate functions are expensive to execute and combiners even more expensive. If you have expensive foreign functions you are strongly advised to specify cost and fanout estimates.

The cost function cfn is an sa.amos function with signature
create function <cfn>(Function f, Vector bpat, Vector args)
                    -> (Integer cost, Integer fanout) as ...;
e.g.

   create function typesofcost(Function f, Vector bpat, Vector args)
                             -> (Integer cost, Integer fanout) as foreign ...;
The cost function is normally called at compile time when the optimizer needs the cost and fanout of a function call in some query. The arguments and results of the cost function are:

f       is the full name the called sa.amos function.
bpat is the binding pattern of the call as a vector of strings ’b’ and ’f’, e.g. {"f","b"} indicating which arguments in the call are bound or free, respectively.
args is a vector of actual variable names and constants used in the call.
cost   is the computed estimated cost to execute a call to f with the given binding pattern and argument list. The cost to access a tuple of a stored function (by hashing) is 2; other costs are calibrated accordingly.
fanout is the estimated fanout of the execution, i.e. how many results are emitted from the execution.

If the cost hint function does not return anything it indicates that the function is not executable in the given context and the optimizer will try some other capability or execution strategy.

The costs and fanouts are normally specified as part of the capability specifications for a multi-directional foreign function definition, as in the example. The costs can also be specified after the definition of a foreign function by using the following sa.amos system function:
   costhint(Charstring fn,Charstring bpat,Vector ch)->Boolean
e.g.
   costhint("number.sqroots->number","bf",{4,2});
   costhint("number.sqroots->number","fb",{2,1});
fn is the full name of the resolvent.
bpat is the binding pattern string.
ch is a vector with two numbers where the first number is the estimated cost and the second is the estimated fanout.

A cost function cfn can be assigned to a capability with:
costhint(Charstring fn, Charstring bpat, Function cfn)  -> Boolean

To find out what cost estimates are associated with a function use:
   costhints(Function r)-> Bag of (Charstring bpat, Object q)
It returns the cost estimates for resolvent r and their associated binding patterns.

To obtain the estimated cost of executing an sa.amos  function f for a given binding pattern bp, use
   plan_cost(Function r, Charstring bp)-> (Number cost, Numbers fanout)
6.2 The relational database wrapper

There is a predefined wrapper for relational databases using the JDBC standard Java-based relational database interface. The JDBC wrapper is tested with MySQL Connector,  FireBird's InterClient JDBC driver, and Microsoft's SQLServer driver.

An instance of type Relational represents a relational database and the functions represents the interface functions to relational databases. The Relational wrapper is an abstract wrapper in the sense that it does not implement a specific data source and thus has no instances. Therefore some of the relational database interface functions of type Relational are defined as abstract functions. In the type hierarchy below for the abstract Relational wrapper there is a specific implemented wrapper for JDBC represented by type Jdbc. The type Jdbc has one instance for each JDBC data source connected to by the system. The type hierarchy is currently:

	Datasource
	    |
	Relational
            |
	  Jdbc
If some other interface than JDBC (e.g. ODBC) is used for a relational database it would require the implementation of a new wrapper and subtype to Relational.

The use of abstract functions makes sure that sa.amos will use the type resolution to look for implementations of these functions in any subtype to Relational.
6.2.1 Connecting
The instances of relational data sources are created using a datasource constructor function that loads necessary drivers. Later the connect() functions associates a connection object to a wrapped database using the driver.

Creating data sources

For creating a relational database data source using JDBC (the currently only supported option) use the constructor:

   jdbc(Charstring dsname, Charstring driver);
where dsname is the chosen data source name and driver is the JDBC driver to use for the access. For example, to create a connection called 'db1' to access a relational database using JDBC with MySQL call:
   jdbc("db1","com.mysql.jdbc.Driver");

Connecting the data source to a database

Once the connection object has been created you can open the connection to a specific relational database:
   connect(Relational r, Charstring database, Charstring username, Charstring password) -> Relational
where r is the data source object, db is the identifier of the database to access, along with user name and password to use when accessing the database. For example, if the relational database called 'Personnel' resides on the local computer and MySQL is used for the managing it, the following opens a connection to the database for user 'U1' with password 'PW':

   connect(:db, "jdbc:mysql://localhost:3306/Personnel", "U1", "PW");

Disconnecting from the database

Once the connection is open you can use the data source object for various manipulations of the connected database. The connection is closed with:
   disconnect(Relational r) -> Boolean
for example:

   disconnect(:a):

Finding a named data source

To get a relational data source object given its name use:

   relational_named(Charstring nm)-> Relational
for example:

   relational_named("db1");

####  Accessing meta-data
Relational meta-data are general information about the tables stored in a relational database.

Tables in database

To find out what tables there are in a relational database, use
   tables(Relational r)
       -> Bag of (Charstring table, Charstring catalog,
                  Charstring schema, Charstring owner)
for example
    tables(relational_named("db1"));
The function tables() returns a bag of tuples describing the tables stored in the relational database.


To test whether a table is present in a database use:
    has_table(Relational r, Charstring table_name) -> Boolean
for example
    has_table(relational_named("db1"),"SALES");

Columns in table

To get a description of the columns in a table use:
    columns(Relational r, Charstring table_name)
        -> Bag  of (Charstring column_name, Charstring column_type)
for example

    columns(relational_named("db1"),"CUSTOMER");

Size of table

To find out how many rows there are in a table use:
     cardinality(Relational r, Charstring table_name) -> Integer

for example
     cardinality(relational_named("db1"),"SALES");

Primary keys of table

To get a description of the primary keys of a table use:
    primary_keys(relational r, charstring table_name)
             -> Bag of (charstring  column_name, charstring constraint_name)
for example:
     primary_keys(relational_named("db1"),"CUSTOMER");

Foreign keys of table

To get information about the foreign keys referenced from a table use:
     imported_keys(Jdbc j, Charstring fktable)
               -> Bag of (Charstring pktable, Charstring pkcolumn, Charstring fkcolumn)
for example
     imported_keys(relational_named("db1"),"PERSON_TELEPHONES");
The elements of the result tuples denote the following:
pktable - The table referenced by the foreign key.
pkcolumn - The column referenced by the foreign key.
fkcolumn - The foreign key column in the table.
NOTICE that composite foreign keys are not supported.


To find what keys in a table are exported as foreign keys to some other table use:
     exported_keys(Jdbc j, Charstring pktable)
               -> Bag of (Charstring pkcolumn, Charstring fktable, Charstring fkcolumn)
for example
     exported_keys(relational_named("db1"),"PERSON");

The elements of the result tuples denote the following:
pkcolumn - The primary key column in the table.
fktable - The table whose foreign key references the table.
fkcolumn - The foreign key column in the table that references the table.
Deleting tables

The function drop_table() deletes a table from a wrapped relational database:

    drop_table(Relational r, Charstring name) -> Integer
6.2.3 Executing SQL

SQL statements

The function sql() executes an arbitrary SQL statement as a string:

    sql(Relational r, Charstring query) -> Bag of Vector results
The result is a bag of results tuples represented as vectors. If the SQL statement is an update a single tuple containing one number is returned, being the number of rows affected by the update. Example:
    sql(relational_named("db1"), "select NAME from PERSON where INCOME > 1000 and AGE>50");


Parameterized SQL statements
To execute the same SQL statement with different parameters use:
    sql(Relational r, Charstring query, Vector params) -> Bag of Vector results
The parameters in params are substituted into the corresponding occurrences in the SQL statement, for example:
    sql(relational_named("db1"), "select NAME from PERSON where INCOME > ? and AGE>?", {1000,50));


Loading SQL scripts

SQL statements in a file separated with ';' can be loaded with:

    read_sql(Relational r, Charstring filename) -> Bag of Vector

The result from read_sql() is a bag containing the result tuples from executing the read SQL statements.

Hint: If something is wrong in the script you may trace the calls inside read_sql() to sql() by calling
    trace("sql");
6.2.4 Object-oriented view of tables

The relational wrapper allows to to define object-oriented views of data residing in a relational database. Once the view has been defined the contents of the database can be used in AmosQL queries without any explicit calls to SQL.

To regard a relational table as an sa.amos type use:
    import_table(Relational r, Charstring table_name) -> Mapped_type
for example
    import_table(relational_named("db1"),"SALES");
The view is represented by a mapped type which is a type whose extent is defined by the rows of the table. Each instance of the mapped type corresponds to a row in the table. The name of the mapped type is constructed by concatenating the table name, the character _ and the data source name, for example Person_db1. Mapped type names are internally capitalized, as for other sa.amos types.
For each columns in the table import_table will generate a corresponding derived wrapper function returning the column's value given an instance of the mapped type. For example, a table named person having the column ssn will have a function

 ssn(Person_db1)->Integer
returning the ssn of a person from the imported relational table.


The system also allows wrapped relational tables to be transparently updated using an update statement by importing the table with:
      import_table(Relational r,
                   Charstring table_name,
                   Boolean updatable)
               -> Mappedtype mt
for example
      import_table(relational_named("db1"),"COUNTRY",true);
If the flag updatable is set to true the functions in the view are transparently updatable so the relational database is updated when instances of the mapped type are created or the extent of some wrapper function updated.  For example:
      create Country_db1(currency,country) instances ("Yen","Japan");
      set currency(c)= "Yen" from Country_db1 c where country(c)= "Japan";

The most general resolvent of import_table() is:
      import_table(Relational r, Charstring catalog_name,
                   Charstring schema_name, Charstring table_name,
                   Charstring typename, Boolean updatable,
                   Vector supertypes) -> Mappedtype mt
The table resides in the given catalog and schema. If catalog is "", the table is assumed not to be in a catalog. If schema is "", the table is assumed not to be in a schema. typename is the desired name of the mapped type created, as alternative to the system generated concatenation of table and data source name. updatable gives an updatable mapped type. supertypes is a vector of either type names or type objects, or a mixture of both. The effect is that sa.amos will perceive the mapped type as an immediate subtype of the types.

There are also two other variants of import_table()  to be used for relational databases where schema and catalog names need not be specified:
      import_table(Relational r,
                   Charstring table_name,
                   Charstring typename,
                   Boolean updatable,
                   Vector supertypes) -> Mappedtype mt
      import_table(Relational r,
                   Charstring table_name,
                   Charstring type_name,
                   Boolean updatable) -> Mappedtype mt

6.2.4.1 Importing many-to-many relationships

All tables in relational databases do not correspond to 'entities' in an ER diagram and therefore cannot be directly mapped to types. The most common case is tables representing many-to-many relationships between entities. Typically such tables have two columns, each of which is a foreign key imported from two other tables, expressing the many-to-many relationship between the two. Only entities are imported as types and special types are not generated for such relationship tables. A many-to-many relationship in a relational database corresponds to a function returning a bag in AmosQL, and can be imported using import_relation() rather than import_table():

import_relation(Relational r,
                Charstring table_name, Charstring argument_column_name,
                Charstring result_column_name, Charstring function_name,
                Boolean updatable)
            -> Function
table_name - the name of the table containing the relation.
argument_column_name - the name of the column which is argument of the function.
result_column_name - the name of the column which is result of the function.
function_name - the desired name of the function.
updatable - whether the function should be transparently updatable via set, add, and remove.
For example, assume we have two entities, person and telephone. Most of the time telephones are not regarded as entities in their own respect since nobody would care to know more about a telephone than its number. However, assume that also the physical location of the telephone is kept in the database, so telephones are an entity type of their own.

A person can be reached through several telephones, and every telephone may be answered by several person. The schema looks as follows:

person
ssn	name	...



person_telephones
ssn	ext_no



telephone
ext_no	location	...



Now, this schema can be wrapped by the following commands:
import_table(my_relational, 'person');
import_table(my_relational, 'telephone');
import_relation(my_relational, 'telephone', 'ssn','ext_no','phones', false);
create function phones(person@my_relational p) -> telephone@my_relational t as select t where phones(ssn(p)) = ext_no(t);
Notice that only relationship functions with a single argument and result can be generated, i.e. composite foreign keys are not supported.
6.3 Defining new wrappers
Wrappers make data sources queryable. Some wrapper functionality is completely data source independent while other functionality is specific for a particular kind of data source. Therefore, to share wrapper functionality sa.amos contains a type hierarchy of wrappers. In this section we describe common functionality used for defining any kind of wrapper.
6.3.1 Data sources

Types and objects of type Datasource describe properties of different kinds of data sources accessible through Amos II. Each kind of wrapped data source has a corresponding data source type, for example type Amos, Relational, or Jdbc to describe sa.amos peers, relational databases, or relational data bases accessed through JDBC, respectively. These types are all subtypes of type Datasource. Each instance of a data source type represents a particular data source of that kind, e.g. a particular relational database accessed trough JDBC are instances of type Jdbc.

6.3.2 Mapped types

A mapped type is a type whose instances are identified by a key consisting of one or several other objects [FR97]. Mapped types are needed when proxy objects corresponding to external values from some data source are created in a peer. For example, a wrapped relational database may have a table PERSON(SSN,NAME,AGE) where SSN is the key. One may then wish to define a mapped type named Pers in the mediator representing proxy objects for the persons in the table. The instances of the proxy objects are identified by an SSN. The type Pers should furthermore have the following property functions derived from the contents of the wrapped table PERSON:
     ssn(Pers)->Integer
     name(Pers)->Charstring
     age(Pers)->Integer

The instances and primary properties of a mapped type are defined through a Source Function that returns these as a set of tuples, one for each instance. In our example the source function should return tuples of three elements (ssn,name,age). The relational database wrapper will automatically generate such a source function for table PERSON (type Pers) with signature:
   pers_cc()->Bag of (Integer ssn, Charstring name, Integer age) as ...

A mapped type is defined through a system function with signature:
   create_mapped_type(Charstring name, Vector keys, Vector attrs, Charstring ccfn)-> Mappedtype
where
   name is the name of the mapped type
   keys is a vector of the names of the keys identifying each instance of the mapped type.
   attrs is a vector of the names of the properties of the mapped type.
   ccfn is the name of the core cluster function.

In our example the relational database wrapper will automatically define the mapped type Pers through this call:
   create_mapped_type("Pers",{"ssn"},{"ssn","name","age"},"pers_cc");

Notice that the implementor of a mapped type must guarantee key uniqueness.

Once the mapped type is defined it can be queried as any other type, e.g.:
   select name(p) from Pers p where age(p)>45;

6.3.3 Type translation

Types in a specific data source are translated to corresponding types in sa.amos using the following system functions:
amos_type(Datasource ds, Charstring native_type_name) -> Type;
for example
amos_type(relational_named("IBDS"),"VARCHAR");
amos_type returns the sa.amos type corresponding to the a specific data source.
wrapped_type(Datasource ds, Type t) -> Charstring typename;
for example
wrapped_type(relational_named("IBDS"),typenamed("CHARSTRING"));
returns the data source type corresponding to an sa.amos type. Since one external type may correspond to more than one sa.amos type wrapped_type is not the inverse of amos_type.
The most common relational types and their sa.amos counterparts are provided by default. Both functions are stored functions that can be updated as desired for future wrappers.
7 Physical database design

This section describes some AmosQL commands for database space and performance tuning.
7.1 Indexing

The system supports indexing on any single argument or result of a stored function. Indexes can be unique or non-unique. A unique index disallows storing different values for the indexed argument or result. The cardinality constraint 'key' of stored functions (Cardinality Constraints) is implemented as unique indexes. Thus by default the system puts a unique index on the first argument of stored functions. That index can be made non-unique by suffixing the first argument declaration with the keyword 'nonkey' or to specify 'Bag of' for the result, in which case a non-unique index is used instead.
For example, in the following function there can be only one name per person:

      create function name(Person)->Charstring as stored;
By contrast, names() allow more than one name per person:
      create function names(Person p)->Bag of Charstring nm as stored;
Any other argument or result declaration can be suffixed with the keyword 'key' to indicate the position of a unique index. For example, the following definition puts a unique index on nm to prohibit two persons to have the same name:
      create function name(Person p)->Charstring nm key as stored;
Indexes can also be explicitly created on any argument or result with a procedural system function create_index():
      create_index(Charstring function, Charstring argname, Charstring index_type,
                   Charstring uniqueness)
For example:
      create_index("person.name->charstring", "nm", "hash", "unique");
      create_index("names", "charstring", "mbtree", "multiple");
The parameters of create_index() are:
function: The name of a stored function. Use the resolvent name for overloaded functions.

argname: The name of the argument/result parameter to be indexed. When unambiguous, the names of types of arguments/results can also be used here.

index_type: Type kind of index to put on the argument/result. The supported index types are currently hash indexes (type hash), ordered B-tree indexes (type mbtree), and X-tree spatial indexes (type xtree). The default index for key/nonkey declarations is hash.

uniqueness: Index uniqueness indicated by unique for unique indexes and multiple for non-unique indexes.

Indexes are deleted by the procedural system function:

      drop_index(Charstring functioname, Charstring argname);
The meaning of the parameters are as for function create_index(). There must always be at least one index left on each stored function and therefore the system will never delete the last remaining index on a stored function.
To save space it is possible to delete the default index on the first argument of a stored function. For example, the following stored function maps parts to unique identifiers through a unique hash index on the identifier:

      create type Part;
      create function partid(Part p)->Integer id as stored;
partid() will have two indexes, one on p and one on id. To drop the index on p, do the following:
      drop_index('partid', 'p');
7.2 Clustering

Functions can be clustered by creating multiple result stored functions, and then each individual function can be defined as a derived function.
For example, to cluster the properties name and address of persons one can define:

create function personprops(Person p) ->
        (Charstring name,Charstring address) as stored;
create function name(Person p) -> Charstring nm
        as select nm from Charstring a
                where personprops(p) = (nm,a);
create function address(Person p) -> Charstring a
        as select a from Charstring nm
                where personprops(p) = (nm,a);
Clustering does not improve the execution time performance significantly in a main-memory DBMS such as Amos II. However, clustering can decrease the database size considerably.
8 System functions and commands

8.1 Comparison operators
The built-in, infix comparison operators are:

=(Object x, Object y) -> Boolean   (infix operator =)
!=(Object x, Object y) -> Boolean  (infix operator !=)
>(Object x, Object y) -> Boolean   (infix operator >)
>=(Object x,Object y) -> Boolean   (infix operator >=)
<(Object x, Object y) -> Boolean   (infix operator <)
<=(Object x,Object y) -> Boolean   (infix operator <=)
All objects can be compared. Strings are compared by characters, lists by elements, OIDs by identifier numbers. Equality between a bag and another object denotes set membership of that object. The comparison functions can, of course, be overloaded for user defined types.

8.2 Arithmetic functions

abs(Number x) -> Number y
div(Number x, Number y)   -> Number z         Infix operator /
max(Object x, Object y)   -> Object z
min(Object x, Object y)   -> Object z
minus(Number x, Number y) -> Number z         Infix operator -
mod(Number x, Number y) -> Number z
plus(Number x, Number y)  -> Number z         Infix operator +
times(Number x, Number y) -> Number z         Infix operator *
power(Number x, Number y) -> Number z         Infix operator ^
iota(Integer l, Integer u)-> Bag of Integer z
sqrt(Number x) -> Number z
integer(Number x) -> Integer i                Round x to nearest integer
real(Number x) -> Real r                      Convert x to real number
roundto(Number x, Integer d) -> Number        Round x to d decimals
log10(Number x) -> Real y
iota() constructs a bag of integers between l and u.
For example, to execute n times AmosQL statement 'print(1)' do:
for each Integer i where i in iota(1,n)
        print(1);

8.3 String functions

String concatenation is made using the '+' operator, e.g.
"ab" + "cd" + "ef";  returns "abcdef"
"ab"+12+"de"; returns "ab12de"
1+2+"ab"; is illegal since the first argument of '+' must be a string.
"ab"+1+2; returns "ab12" since '+' is left associative.

char_length(Charstring)->Integer
Count number of characters in string.

lower(Charstring)->Charstring
Lowercase string.

like(Charstring string, Charstring pattern) -> Boolean
Test if string matches regular expression pattern where '*' matches sequence of characters and '?' matches single character. For example:
like("abc","??c") returns TRUE
like("ac","a*c") returns TRUE
like("ac","a?c") fails
like("abc","a[bd][dc]"); returns TRUE
like("abc","a[bd][de]"); fails

like_i(Charstring string, Charstring pattern) -> Boolean
Case insensitive like().

stringify(Object x)->Charstring s
Convert any object x into a string.

unstringify(Charstring s) -> Object x
Convert string s to object x. Inverse of stringify().

substring(Charstring string,Integer start, Integer end)->Charstring
Extract substring from given character positions. First character has position 0.

upper(Charstring s)->Charstring
Uppercase string s.

lower(Charstring s) -> Charstring
Lowercase string s.

not_empty(Charstring s) -> Boolean
Returns true if string s contains only whitespace characters (space, tab, or new line).

8.4 Aggregate functions

Some of these system functions are also described in Subqueries and Aggregate functions.

The overloaded function in() implement the infix operator 'in'. It extracts each element from a collection:
in(Bag of Object b) -> Bag
in(Vector v) -> Bag
For example:
in({1,2,2}); =>
1
2
2

Number of objects in a bag:
count(Bag of Object b) -> Integer
For example:
count(iota(1,100000)); =>
100000

Sum elements in bags of numbers:
sum(Bag of Number b) -> Number
For example:
sum(iota(1,100000)); =>
705082704

Average value in a bag of numbers:
avg(Bag of Number b) -> Real
For example:
avg(iota(1,100000)); =>
50000.5

Standard deviation of values in a bag of numbers:
stdev(Bag of Number b) -> Real
For example:
stdev(iota(1,100000)); =>
28867.6577966877

Largest object in a bag:
maxagg(Bag of TP b) -> TP y
The type of the result is the same as the type of elements of argument bag. For example:
maxagg(bag(3,4,2))+2; =>
6

Smallest number in a bag:
minagg(Bag of TP b) -> TP y
The type of the result is the same as the type of elements of argument bag. For example:
minagg(bag(3,4,2))+2; =>
4

Test if a bag is empty. Logical NOT EXISTS:
notany(Bag of Object b) -> Boolean b
For example:
notany(bag()); =>
TRUE

notany(select n from number n where n>5 and n in {1,2,3});
TRUE

Test if there are any elements in a bag. Logical EXISTS:
some(Bag of Object b) -> Boolean b
For example:
some(iota(1,1000000)); =>
TRUE

some(select n from number n where n in {1,2,3} and n < 10); =>
TRUE

Remove duplicates from a bag:
unique(Bag of TP b) -> Bag of TP r
The type of the result bag is the same as the type of elements of argument bag. For example:
unique(bag(1,2,1,4)); =>
1
2
4

Extract non-duplicated elements from a bag:
exclusive(Bag of TP b) -> Bag of TP r
The type of the result bag is the same as the type of elements of argument bag. For example:
```
exclusive(bag(1,2,1,4)); =>
2
4
```
Insert x between elements in a bag b:
inject(Bag of Object b, Object x) -> Bag of Object r
For example:
```
inject(bag(1,2,3),0); =>
1
0
2
0
3
```
Make a string of elements in a bag b:
concatagg(Bag of Object b)-> Charstring s
For example:
concatagg(bag("ab",2,"cd")); =>
"ab2cd"

concatagg(inject(bag("ab",2,"cd"),",")); =>
"ab,2,cd"

### Temporal functions

sa.amos supports three data types for referencing Time, Timeval, and Date.
Type Timeval  is for specifying absolute time points including year, month, and time-of-day.
The type Date specifies just year and date, and type Time specifies time of day. A limitation is that the internal operating system representation is used for representing Timeval values, which means that one cannot specify value too far in the past or future.

Constants of type Timeval are written as |year-month-day/hour:minute:second|, e.g. |1995-11-15/12:51:32|.
Constants of type Time are written as |hour:minute:second|, e.g. |12:51:32|.
Constants of type Date are written as |year-month-day|, e.g. |1995-11-15|.

The following functions exist for types Timeval, Time, and Date:

now() -> Timeval
The current absolute time.

time() -> Time
The current time-of-day.

clock() -> Real
The number of seconds since the system was started.

date() -> Date
The current year and date.

timeval(Integer year,Integer month,Integer day,
        Integer hour,Integer minute,Integer second) -> Timeval
Construct Timeval.

time(Integer hour,Integer minute,Integer second) -> Time
Construct Time.

date(Integer year,Integer month,Integer day) -> Date
Construct Date.

time(Timeval) -> Time
Extract Time from Timeval.

date(Timeval) -> Date
Extract Date from Timeval.

date_time_to_timeval(Date, Time) -> Timeval
Combine Date and Time to Timeval.

year(Timeval) -> Integer
Extract year from Timeval.

month(Timeval) -> Integer
Extract month from Timeval.

day(Timeval) -> Integer
Extract day from Timeval.

hour(Timeval) -> Integer
Extract hour from Timeval.

minute(Timeval) -> Integer
Extract minute from Timeval.

second(Timeval) -> Integer
Extract second from Timeval.

year(Date) -> Integer
Extract year from Date.

month(Date) -> Integer
Extract month from Date.

day(Date) -> Integer
Extract day from Date.

hour(Time) -> Integer
Extract hour from Time.

minute(Time) -> Integer
Extract minute from Time.

second(Time) -> Integer
Extract second from Time.

timespan(Timeval, Timeval) -> (Time, Integer usec)
Compute difference in Time and microseconds between two time values


### Sorting functions

There are several functions that can be used to sort bags or vectors.
Sorting by tuple order

A natural sort order is often to sort the result tuples of a bag returned from a query or a function based on the sort order of all elements in the result tuples.

Function signatures:
sort(Bag b)->Vector
sort(Bag b, Charstring order)->Vector
Notice that the result of sorting an unordered bag is a vector.

For example:
Amos 1> sort(1-iota(1,3));
=> {-2,-1,0}
Amos 2> sort(1-iota(1,3),'dec');
{0,-1,-2}
Amos 3> sort(select i, 1-i from Number i where i in iota(1,3));
{{1,0},{2,-1},{3,-2}}
The default first case is to sort the result in increasing order.

In the second case a second argument specifies the ordering direction, which can be 'inc' (increasing) or 'dec' (decreasing).

The third case illustrates how the result tuples are ordered for queries returning bags of  tuples. The result tuples are converted into vectors.

Notice that the sort order is not preserved if a sorted vector is converted to a bag as the query optimizer is free to return elements of bags in any order.

For example:
   select x from Number x where x in -iota(1,5) and x in sort(-iota(3,5));
returns the unsorted bag
  -3
  -4
  -5
even though
sort(-iota(3,5)) -> {-5,-4,-3}

Notice that surrogate object will be sorted too based on their OID numbers, which usually has no meaning.
Sorting bags by ordering directives
A common case is sorting of result tuples from queries and functions ordered by ordering directives. An ordering directive is a pair of a position number in a result tuple of a bag to be sorted and an ordering direction.

Function signatures:
sortbagby(Bag b, Integer pos, Charstring order) -> Vector
sortbagby(Bag b, Vector of Integer pos, Vector of Charstring order)->Vector
For example:
Amos 1> sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),1,'dec');
=> {{3,1},{2,0},{1,1}}
Amos 2> sortbagby((select i, mod(i,2) from Number i where i in iota(1,3)),{2,1},{'inc','inc'});
=> {{2,0},{1,1},{3,1}}
In the first case a single tuple ordering directive i specified by two arguments, one for the tuple position and one for the ordering direction. The result tuple positions are enumerated 1 and up.

The second case illustrates how several tuples positions with different ordering directions can be specified.

Sorting bags or vectors with a custom comparison function

This group of sort functions are useful to sort bags or vectors of either objects or tuples with a custom function supplied by the user. Either the function object or function named can be supplied. The comparison function must take two arguments with types compatible with the elements of the bag or the vector and return a boolean value. Signatures:

```sh
sortvector(Vector v1, Function compfno) -> Vector
sortvector(Vector v, Charstring compfn) -> Vector
sortbag(Bag b, Function compfno) -> Vector
sortbag(Bag b, Charstring compfn) -> Vector
```
Example:
```
create function younger(Person p1, Person p2) -> Boolean
as age(p1) < age(p2);

/* Sort all persons sorted by their age */
sortbag((select p from Person p), 'YOUNGER');
```

### Accessing system meta-data

The data that the system internally uses for maintaining the database is exposed to the query language as well and can be queried in terms of types and functions as other data. For example:
The types and functions used in a database are accessible through system functions. It is possible to search the database for types and functions and how they relate.
The goovi browser available from javaamos by calling the system function goovi(); presents the database graphically. It is written completely as an application Java program using AmosQL queries as the only interface to the sa.amos kernel.

#### Type meta-data

alltypes() -> Bag of Type
returns all types in the database.
subtypes(Type t) -> Bag of Type s
supertypes(Type t) -> Bag of Type s
returns the types immediately below/above type t in the type hierarchy.

allsupertypes(Type t) -> Bag of Type s
returns all types above t in the type hierarchy.

typesof(Object o) -> Bag of Object t
returns the type set of an object.

typeof(Object o) -> Type t
returns the most specific type of an object.
typenamed(Charstring nm) -> Type t
returns the type named nm. Notice that type names are in upper case.

name(Type t) -> Charstring nm
returns the name of the type t.
attributes(Type t) -> Bag of Function g
returns the generic functions having a single argument of type t and a single result.

methods(Type t) -> Bag of Function r
returns the resolvents having a single argument of type t and a single result.
cardinality(Type t) -> Integer c
returns the number of object of type t and all its subtypes.

objectname(Object o, Charstring nm) -> Boolean
returns TRUE if the object o has the name nm.

#### Function meta-data

allfunctions() -> Bag of Function
returns all functions in the database.

functionnamed(Charstring nm) -> Function
returns the object representing the function named nm. Useful for second order functions.
theresolvent(Charstring nm) -> Function
returns the single resolvent of a generic function named nm. If there is more than one resolvent for nm an error is raised. If fn is the name of a resolvent its functional is returned.  The notation #'...' is syntactic sugar for theresolvent('..');
name(Function fn) -> Charstring
returns the name of the function fn.


signature(Function f)  -> Charstring
returns the signature of f.
kindoffunction(Function f) -> Charstring
returns the kind of the function f as a string. The result can be one of 'stored', 'derived', 'foreign' or 'overloaded'.
generic(Function f) -> Function
returns the generic function of a resolvent.

resolvents(Function g) -> Bag of Function
returns the resolvents of an overloaded function g.

resolventtype(Function fn) -> Bag of Type
returns the types of only the first argument of the resolvents of function resolvent fn.

arguments(Function r) -> Bag of Vector
returns vector describing arguments of signature of resolvent r. Each element in the vector is a triplet (vector) describing one of the arguments with structure {type,name,uniqueness} where type is the type of the argument, name is the identifier for the argument, and uniqueness is either "key" or "nonkey" depending on the declaration of the argument.. For example,
arguments(resolvents(#'timespan')))
--> {{#[OID 371 "TIMEVAL"],"TV1","nonkey"},{#[OID 371 "TIMEVAL"],"TV2","nonkey"}}

results(Function r) -> Bag of Vector
Analogous to arguments for result (tuple) of function.
arity(Function f)-> Integer
returns the number of arguments of function.

width(Function f) -> Integer
returns the width of the result tuple of function f.

### Searching source code

The source codes of all functions except some basic system functions are stored in the database. You can retrieve the source code for a particular function, search for functions whose names contain some string, or make searches based on the source code itself. Some system functions are available to do this.

apropos(Charstring str) -> Bag of Function
returns all functions in the system whose names contains the string str. Only the generic name of the function is used in the search. The string is not case sensitive. For example:
     apropos("qrt");
returns all functions whose generic name contains 'qrt'.

signature(Function f) -> Charstring
returns the signature of f. For example:
signature(apropos("qrt"));

doc(Charstring str) -> Bag of Charstring
returns the available documentations of all functions in the system whose names contain the (non case sensitive) string str. For example:
doc("qrt");
sourcecode(Function f) -> Bag of Charstring
sourcecode(Charstring fname) -> Bag of Charstring
returns the sourcecode of a function f, if available. For generic functions the sources of all resolvents are returned. For example:
sourcecode("sqrt");
To find all functions whose definitions contain the string 'tclose' use:
     select sc
     from Function f, Charstring sc
     where like_i(sc,"*tclose*") and source_text(f)=sc;

usedwhere(Function f) -> Function c
returns the functions calling the function f.

useswhich(Function f) -> Function c
returns the functions called from the function f.

userfunctions() -> Bag of Function
returns all user defined functions in the database.
usertypes() -> Bag of Type
returns all user defined types in the database.
allfunctions(Type t)-> Bag of Function
returns all functions where one of the arguments are of type t.

### Extents

The local sa.amos database can be regarded as a set of extents. There are two kinds of extents:
Type extents represent surrogate objects belonging to a particular type.
The deep extent of a type is defined as the set of all surrogate objects belonging to that type and to all its descendants in the type hierarchy. The deep extent of a type is retrieved with:
extent(Type t)->Bag of Object
For example, to count how many functions are defined in the database call:
   count(extent(typenamed("function")));
To get all surrogate objects in the database call:
   extent(typenamed("object"))

The function allobjects(); does the same.
The shallow extent of a type is defined as all surrogate objects belonging only to that type but not to any of its descendants. The shallow extent is retrieved with:
shallow_extent(Type t)->Bag of Object
For example:
   shallow_extent(typenamed("object"));
returns nothing since type Object has no own instances.
 Function extents represent the state of stored functions. The extent of a function is the bag of tuples mapping its argument(s) to the corresponding result(s). The function extent() returns the extent of the function fn. The extent tuples are returned as a bag of vectors. The function can be any kind of function.

extent(Function fn) -> Bag of Vector
For example,
   extent(#'coercers');
For stored functions the extent is directly stored in the local database. The example query thus returns the state of all stored functions. The state of the local database is this state plus the deep extent of type Object.
The extent is always defined for stored functions and can also be computed for derived functions through their function definitions. The extent of a derived function may not be computable, unsafe, in which case the extent function returns nothing.

The extent of a foreign function is always empty.

The extent of a generic function is the union of the extents of its resolvents.

### Query optimizer tuning


optmethod(Charstring new) -> Charstring old
sets the optimization method used for cost-based optimization in sa.amos to the method named new.
Three optimization modes for AmosQL queries can be chosen:
"ranksort": (default) is fast but not always optimal.
"exhaustive": is optimal but it may slow down the optimizer considerably.
"randomopt": is a combination of two random optimization heuristics:
Iterative improvement and sequence heuristics [Nas93].
optmethod returns the old setting of the optimization method.

Random optimization can be tuned by using the function:
optlevel(Integer i,Integer j);
where i and j are integers specifying number of iterations in iterative improvement and sequence heuristics, respectively. Default settings is i=5 and j=5.
reoptimize(Function f) -> Boolean
reoptimize(Charstring f) -> Boolean
reoptimizes function named fn.

### Unloading

The data stored in the local database can be unloaded to a text file as an unload script of AmosQL statements generated by the system. The state of the database can be restored by loading the unload script as any other AmosQL file. Unloading is useful for backups and for transporting data between different systems such as different sa.amos versions or sa.amos systems running on different computers. The unload script can be edited in case the schema has changed.
unload(Charstring filename)->Boolean
generates an AmosQL script that restores the current local database state if loaded into an sa.amos peer with the same schema as the current one.

excluded_fns()->Bag of Function
set of functions that should not be unloaded. Can be updated by user.



### Miscellaneous
```
apply(Function fn, Vector args) -> Bag of Vector r
```
calls the AmosQL function fn with elements in vector args as arguments and returns the result tuples as vectors.
```
evalv(Charstring stmt) -> Bag of Vector r
```
evaluates the AmosQL statement stmt and returns the result tuples as vectors.
```
error(Charstring msg) -> Boolean
```
prints an error message on the terminal and raises an exception. Transaction aborted.
```
output_lines(Number n) -> Number
```
controls how many lines to print on standard output before prompting for more lines. By default the system prints the entire result of a query on standard output. The user can interrupt the printing by `ctrl-c`. However, when running under Emacs and Windows the `ctrl-c` method to terminate an output may not be effective. As an alternative to `ctrl-c` `output_lines(n)` causes the system to prompt for more output lines after n lines have been printed on standard output. output_lines(0) turns off output line control.
```
print(Object x) -> Boolean
```
prints x. Always returns true. The printing is by default to the standard output (console) of the sa.amos server where `print()` is executed but can be redirected to a file by the function openwritefile:
```
openwritefile(Charstring filename)->Boolean
```
`openwritefile()` changes the output stream for `print()` to the specified filename. The file is closed and output directed to standard output by calling `closewritefile()`.
```
filedate(Charstring file) -> Date
```
returns the time for modification or creation of file.
```
amos_version() -> Charstring
```
returns string identifying the current version of Amos II.
```
quit;
```
quits Amos II.
```
exit;
```
returns to the program that called sa.amos if the system is embedded in some other system.
Same as `quit;` for stand-alone Amos II.
```
goovi();
```
starts the multi-database browser GOOVI[CR01]. This works only under JavaAmos.

The redirect statement reads AmosQL statements from a file:
```
redirect-stmt ::= '<' string-constant
```
For example
```
< 'person.amosql';
```
```
load_AmosQL(Charstring filename)->Charstring
```
loads a file containing AmosQL statements.
```
loadSystem(Charstring dir, Charstring filename)->Charstring
```
loads a master file, filename, containing an AmosQL script defining a subsystem. The current directory is temporarily set to dir while loading. The file is not loaded if it was previously loaded into the database. To see what master files are currently loaded, call `loadedSystems()`.
```
getenv(Charstring var)->Charstring value
```
retrieves the value of OS environment variable var. Generates an error of variable not set.

The trace and untrace functions are used for tracing foreign function calls:
```
trace(Function fno)->Bag of Function r
trace(Charstring fn)->Bag of Function r
untrace(Function fno)->Bag of Function r
untrace(Charstring fn)->Bag of Function r
```
If an overloaded functions is (un)traced it means that all its resolvents are (un)traced. Results are the foreign functions (un)traced. For example:
```
Amos 2> trace("iota");
#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER"]
Amos 2> iota(1,3);
>>#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER"]#(1 3 *)
<<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER"]#(1 3 1)
1
<<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER"]#(1 3 2)
2
<<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER"]#(1 3 3)
3
Amos 2>

dp(Object x, Number priority)-> Boolean
```

For debug printing in where clauses. Prints x on the console. Always returns true. The placement of dp in the execution plan is regulated with priority which must be positive numeric constant. The higher priority the earlier in the execution plan.

## Acknowledgments

The following persons have contributed to the development of the sa.amos system:
Andrej Andrejev, Sobhan Badiozamany, Kristofer Cassel, Daniel Elin, Gustav Fahl, Staffan Flodin, Ruslan Fomkin, Jörn Gebhardt, Gyozo Gidofalvi, Martin Hansson, Milena Ivanova, Vanja Josifovski, Markus Jägerskogh, Jonas Karlsson, Timour Katchaounov,  Salah-Eddine Machani, Lars Melander, Joakim Näs, Kjell Orsborn, Johan Petrini, Tore Risch, Manivasakan Sabesan, Martin Sköld, Silvia Stefanova, Thanh Truong, Christian Werner, Magnus Werner, Cheng Xu, Erik Zeitler, and Minpeng Zhu.

## References

[CR01] K.Cassel and T.Risch: An Object-Oriented Multi-Mediator Browser. Presented at 2nd International Workshop on User Interfaces to Data Intensive Systems, Zürich, Switzerland, May 31 - June 1, 2001
[ER00] D.Elin and T. Risch: Amos II Java Interfaces,  Uppsala University, 2000.
[FR95] S. Flodin and T. Risch, Processing Object-Oriented Queries with Invertible Late Bound Functions, Proc. VLDB Conf., Zürich, Switzerland, 1995.
[FR97] G. Fahl and T. Risch: Query Processing over Object Views of Relational Data, The VLDB Journal , Vol. 6 No. 4, November 1997, pp 261-281.
[JR99a] V.Josifovski, T.Risch: Functional Query Optimization over Object-Oriented Views for Data Integration Journal of Intelligent Information Systems (JIIS), Vol. 12, No. 2-3, 1999.
[JR99b] V.Josifovski, T.Risch: Integrating Heterogeneous Overlapping Databases through Object-Oriented Transformations. In Proc. 25th Intl. Conf. On Very Large Databases, Edinburgh, Scotland, September 1999.
[JR02] V.Josifovski, T.Risch: Query Decomposition for a Distributed Object-Oriented Mediator System . Distributed and Parallel Databases J., Kluwer, May 2002.
[KJR03] T.Katchaounov, V.Josifovski, and T.Risch: Scalable View Expansion in a Peer Mediator System, Proc. 8th International Conference on Database Systems for Advanced Applications (DASFAA 2003), Kyoto, Japan, March 2003.
[LR92] W.Litwin and T.Risch: Main Memory Oriented Optimization of OO Queries Using Typed Datalog with Foreign Predicates, IEEE Transactions on Knowledge and Data Engineering, Vol. 4, No. 6, December 1992 ( http://user.it.uu.se/~udbl/publ/tkde92.pdf).
[Nas93] J.Näs: Randomized optimization of object oriented queries in a main memory database management system, MSc thesis, LiTH-IDA-Ex 9325 Linköping University 1993.
[Ris12] T.Risch: Amos II C Interfaces, Uppsala University, 2012.
[Ris06]T.Risch: ALisp v2 User's Guide, Uppsala University, 2006.
[RJK03] T.Risch, V.Josifovski, and T.Katchaounov: Functional Data Integration in a Distributed Mediator System, in P.Gray, L.Kerschberg, P.King, and A.Poulovassilis (eds.): Functional Approach to Data Management - Modeling, Analyzing and Integrating Heterogeneous Data, Springer, ISBN 3-540-00375-4, 2003.
