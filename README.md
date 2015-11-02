---
title: 'Amos II Release 18 User''s Manual'
...

--- title: sa.amos user manual | Stream Analyze description: sa.amos
documentation. hidden: true ---

&lt;%= partial 'includes/google\_tag\_manager' if build? %&gt;

+--------------------------------------+--------------------------------------+
| \                                    | [&lt;%= image\_tag                   |
|                                      | 'amos\_logo\_53x50.jpg'              |
|                                      | %&gt;](http://www.it.uu.se/research/ |
|                                      | group/udbl/amos)                     |
+--------------------------------------+--------------------------------------+
| \                                    | 1.  [Getting started](#running)\     |
|                                      | 2.  [AmosQL](#amosql)\               |
|                                      |      2.1 [Basic                      |
|                                      |     constructs](#basic-constructs)\  |
|                                      |      2.1.1 [Syntactic                |
|                                      |     conventions](#syntax)\           |
|                                      |      2.1.2                           |
|                                      |     [Statements](#statements)\       |
|                                      |      2.1.3                           |
|                                      |     [Indentifiers](#identifiers)\    |
|                                      |      2.1.4 [Variables](#variables)\  |
|                                      |      2.1.5 [Constants](#constants)\  |
|                                      |      2.1.6                           |
|                                      |     [Expressions](#expressions)\     |
|                                      |      2.1.7                           |
|                                      |     [Collections](#collection-syntax |
|                                      | )\                                   |
|                                      |      2.1.8 [Comments](#comments)\    |
|                                      |      2.2 [Defining types](#types)\   |
|                                      |      2.2.1 [Deleting                 |
|                                      |     types](#delete-type)\            |
|                                      |      2.3 [Creating                   |
|                                      |     Objects](#create-object)\        |
|                                      |      2.3.1 [Deleting                 |
|                                      |     objects](#object-deletion)\      |
|                                      |      2.4                             |
|                                      |     [Queries](#query-statement)\     |
|                                      |      2.4.1 [Calling                  |
|                                      |     functions](#function-call)\      |
|                                      |      2.4.2 [The select               |
|                                      |     statement](#select-statement)\   |
|                                      |      2.4.3                           |
|                                      |     [Predicates](#predicates)\       |
|                                      |      2.4.4 [Grouped                  |
|                                      |     selections](#grouped-selection)\ |
|                                      |      2.4.5 [Ordered                  |
|                                      |     selections](#ordered-selections) |
|                                      | \                                    |
|                                      |      2.4.6 [Top-k                    |
|                                      |     queries](#top-k-queries)\        |
|                                      |      2.4.7 [Aggregation and          |
|                                      |     bags](#subqueries)\              |
|                                      |      2.4.8                           |
|                                      |     [Quantifiers](#quantifiers)\     |
|                                      |      2.5 [Vector                     |
|                                      |     queries](#vector-queries)\       |
|                                      |      2.5.1 [Vector                   |
|                                      |     construction](#vector-constructi |
|                                      | on)\                                 |
|                                      |      2.5.2 [The vselect              |
|                                      |     statement](#vselect)\            |
|                                      |      2.5.3 [Accessing vector         |
|                                      |     elements](#vector-index)\        |
|                                      |      2.5.4 [Vector                   |
|                                      |     functions](#vector-function)\    |
|                                      |      2.6 [Defining                   |
|                                      |     Functions](#function-definitions |
|                                      | )\                                   |
|                                      |      2.6.1 [Stored                   |
|                                      |     functions](#stored-function)\    |
|                                      |      2.6.2 [Derived                  |
|                                      |     functions](#derived-function)\   |
|                                      |      2.6.3 [Overloaded               |
|                                      |     functions](#overloaded-functions |
|                                      | )\                                   |
|                                      |      2.6.4 [Casting](#casting)\      |
|                                      |      2.6.5 [Second order             |
|                                      |     functions](#second-order-functio |
|                                      | ns)\                                 |
|                                      |      2.6.6 [Transitive               |
|                                      |     closures](#transitive-closures)\ |
|                                      |      2.6.7 [Iteration](#iteration)\  |
|                                      |      2.6.8 [Abstract                 |
|                                      |     functions](#abstract-functions)\ |
|                                      |      2.6.9 [Deleting                 |
|                                      |     functions](#deletef)\            |
|                                      |      2.7 [Updates](#updates)\        |
|                                      |      2.7.1 [Cardinality              |
|                                      |     constraints](#cardinality-constr |
|                                      | aints)\                              |
|                                      |      2.7.2 [Changing object          |
|                                      |     types](#add-type)\               |
|                                      |      2.7.3 [Dynamic                  |
|                                      |     updates](#dynamic-updates)\      |
|                                      |      2.8 [Data mining                |
|                                      |     primitives](#data-mining)\       |
|                                      |      2.8.1 [Numerical vector         |
|                                      |     functions](#vector-numerical)\   |
|                                      |      2.8.2 [Vector aggregate         |
|                                      |     functions](#vector-aggregate)\   |
|                                      |      2.8.3 [Plotting numerical       |
|                                      |     data](#plot)\                    |
|                                      |      2.9 [Accessing data in          |
|                                      |     files](#accessing-files)\        |
|                                      |      2.9.1 [Reading and writing      |
|                                      |     files](#read_file)\              |
|                                      |      2.10 [Scans](#cursors)\         |
|                                      | 3.  [Procedural                      |
|                                      |     functions](#procedures)\         |
|                                      |      3.1 [Iterating over             |
|                                      |     results](#foreach-statement)\    |
|                                      |      3.2 [User update                |
|                                      |     procedures](#user-update-functio |
|                                      | ns)\                                 |
|                                      | 4.  [The SQL                         |
|                                      |     processor](#SQL-processor)\      |
|                                      | 5.  [Peer management](#peers)\       |
|                                      |      5.1 [Peer                       |
|                                      |     communication](#peercommunicatio |
|                                      | n)\                                  |
|                                      |      5.2 [Peer queries and           |
|                                      |     views](#peer-views)\             |
|                                      | 6.  [Accessing external              |
|                                      |     systems](#mediatorfns)\          |
|                                      |      6.1 [Foreign and                |
|                                      |     multi-directional                |
|                                      |     functions](#foreign-functions)\  |
|                                      |      6.1.1 [Cost                     |
|                                      |     estimates](#cost-estimate)\      |
|                                      |      6.2 [The relational database    |
|                                      |     wrapper](#relational)\           |
|                                      |      6.2.1                           |
|                                      |     [Connecting](#rdb-connect)\      |
|                                      |      6.2.2 [Accessing                |
|                                      |     meta-data](#rdb-metadata)\       |
|                                      |      6.2.3 [Executing                |
|                                      |     SQL](#rdb-SQL)\                  |
|                                      |      6.2.4 [Object-oriented views of |
|                                      |     tables](#rdb-ooview)\            |
|                                      |      6.3 [Defining new               |
|                                      |     wrappers](#generic_wrapper)\     |
|                                      |      6.3.1 [Data                     |
|                                      |     sources](#data-sources)\         |
|                                      |      6.3.2 [Mapped types](#mapped)\  |
|                                      |      6.3.3 [Type                     |
|                                      |     translation](#type-translation)\ |
|                                      | 7.  [System functions and            |
|                                      |     commands](#systemfunctions)\     |
|                                      |      7.1 [Comparison                 |
|                                      |     operators](#comp-operators)\     |
|                                      |      7.2 [Arithmetic                 |
|                                      |     functions](#62053)\              |
|                                      |      7.3 [String                     |
|                                      |     functions](#STRING)\             |
|                                      |      7.4 [Aggregate                  |
|                                      |     functions](#aggregate-functions) |
|                                      | \                                    |
|                                      |      7.4.1 [Generalized aggregate    |
|                                      |     functions](#generalized-aggregat |
|                                      | e-functions)\                        |
|                                      |      7.5 [Temporal                   |
|                                      |     functions](#TEMPORAL)\           |
|                                      |      7.6 [Sorting functions](#SORT)\ |
|                                      |      7.7 [Accessing system           |
|                                      |     meta-data](#system-metadata)\    |
|                                      |      7.7.1 [Type                     |
|                                      |     meta-data](#type-metadata)\      |
|                                      |      7.7.2 [Function                 |
|                                      |     meta-data](#function-metadata)\  |
|                                      |      7.8 [Searching source           |
|                                      |     code](#code-search)\             |
|                                      |      7.9 [Extents](#extents)\        |
|                                      |      7.10 [Query optimizer           |
|                                      |     tuning](#62191)\                 |
|                                      |      7.11 [Indexing](#indexing)\     |
|                                      |      7.12 [Clustering](#clustering)\ |
|                                      |      7.13 [Unloading](#unloading)\   |
|                                      |      7.14                            |
|                                      |     [Miscellaneous](#miscellaneous)\ |
|                                      | 8.  [References](#references)        |
+--------------------------------------+--------------------------------------+

 

Amos II Release 18 User's Manual
================================

*Staffan Flodin, Martin Hansson, Vanja Josifovski, Timour Katchaounov,
Tore Risch, Martin Sköld, and Erik Zeitler*

[Uppsala DataBase Laboratory](http://www.it.uu.se/research/group/udbl)\
 Department of Information Technology\
 Uppsala University\
 Sweden

May 9,  2015\

Summary
=======

Amos II is an extensible NoSQL database system that allows different
kinds of data sources to be integrated and queried. The system is
centered around an object-oriented and functional query language,
AmosQL, documented here. The system can store data in its internal
main-memory object store. In AmosQL queries variables are bound to
instances of objects of any kind (domain calculus), in contrast to SQL
where variables in queries always have to be bound to rows in tables
(tuple calculus). Queries in terms of function compositions over sets of
objects make AmosQL queries versatile.

Amos II includes primitives for data mining through queries and
functions to group, aggregate, transform, and visualize data. Ordered
collections are supported through the datatype <span
style="font-style: italic;">Vector</span>. Queries can produce ordered
results as vectors.

Several distributed Amos II <span
style="font-style: italic;">peers</span> can collaborate in a
federation. The documentation includes descriptions of basic peer
communication primitives.

Amos II enables <span style="font-style:
                        italic;">wrappers </span>to be defined for
different kinds of data sources and external storage managers accessed
to make them queryable. A predefined wrapper for relational databases
allows queries combining relational data with other kinds of data
accessible through Amos II.

This manual describes how to use the Amos II system and the AmosQL query
language. The principles of the Amos II system and AmosQL are described
in the document [\[RJK03\]](#RJK03).

Acknowledgments
===============

The following persons have contributed to the development of the Amos II
Release 18 system:\
 Andrej Andrejev, Sobhan Badiozamany, Kristofer Cassel, Daniel Elin,
Gustav Fahl, Staffan Flodin, Ruslan Fomkin, Jörn Gebhardt, Gyozo
Gidofalvi, Martin Hansson, Milena Ivanova, Vanja Josifovski, Markus
Jägerskogh, Jonas Karlsson, Timour Katchaounov, Khalid Mahmood,
Salah-Eddine Machani, Lars Melander, Joakim Näs, Kjell Orsborn, Johan
Petrini, Tore Risch, Manivasakan Sabesan, Martin Sköld, Silvia
Stefanova, Thanh Truong, Christian Werner, Magnus Werner, Cheng Xu, Erik
Zeitler, and Minpeng Zhu.

\

Organization of document
========================

This document is organized as follows:\

-   [Chapter 1](#running) gives some basic information on how to
    download and get started running the system. It also mentions
    different subsystems available.
-   [Chapter 2](#amosql) describes the core of the AmosQL query
    language, including how to define database schemas, populate, query,
    and update the database.
-   [Chapter 3](#procedures) describes procedural extensions to AmosQL
    making it possible to implement algorithms that have side effects
    updating the database.
-   In addition to AmosQL the system can process also SQL (SQL-92)
    queries, as described in [Chapter 4](#SQL-processor).\
-   The mechanisms for setting up federations of distributed Amos II
    peers are described in [Chapter 5](#peers).
-   Amos II has mechanisms to access external systems and to integrate
    and query external databases managed by different kinds of external
    data managers. The extensibility mechanisms are described in
    [Chapter 6](#mediatorfns).
-   [Chapter 7](#systemfunctions) documents built-in system functions. 
-   Finally [Chapter 8](#references) gives some references to related
    documents.\

1 Getting started\
==================

Download the Amos II zip  from
<http://www.it.uu.se/research/group/udbl/amos/>. Unpack the zip file to
a directory for Amos II, `<privdir>`. The following files are needed in
`<privdir>/bin;`:

      amos2.exe amos2.dll amos2.dmp

Amos II is ready to run in `<privdir>/bin` by the command:

    amos2 [<db>]

where `[<db>]` is an optional name of an Amos II database. If ` <db>` is
omitted, the system enters an empty system database (named `amos2.dmp`),
where only the system objects are defined. The system looks for <span
style="font-family: monospace;">amos2.dmp</span> in the same directory
as where the executable <span style="font-family:
      monospace;">amos2.exe</span> is located.

The executable supports command line parameters to specify, e.g., the
database or AmosQL script to load. To get a list of the command line
parameters do:\
 <span style="font-family: monospace;">  amos2 -h</span>\

The Amos toploop\
\
 When started, the system enters the Amos top loop where it reads AmosQL
statements, executes them, and prints their results on the console.  The
prompter in the Amos II top loop is:

    Amos n>

where `n` is a *generation number*. The generation number is increased
every time an AmosQL statement that updates the database is executed in
the Amos top loop.

Typically you start by defining  meta-data (a schema) as [types](#types)
and properties of types represented as
[functions](#function-definitions). For example, the following statement
create a type named *Person* having two property functions *name()* and
*income()*:

    Amos 1> create type Person properties
      
     (name Charstring,
      
     income Number);
      

When the meta-data is defined you usually *populate* the database by
[creating objects](#create-object) and [updating functions](#updates).

For example:\
 <span style="font-family: monospace;">Amos 2&gt; create Person(name,
income) instances\
 ("Bill",100),\
 ("John",250),\
 ("Ulla",380),\
 ("Eva", 280);\
 </span>\
 When the database is populated you can [query](#query-statement) it,
e.g.:\
 <span style="font-family: monospace;">Amos 3&gt; select income(p) from
Person p where name(p)="Ulla";\
\
 </span> Usually you load AmosQL definitions from a script file rather
than entering them on the command line, e.g.\
 <span style="font-family: monospace;">Amos 1&gt; &lt; 'mycode.amosql';
</span>\
\
 Transactions\
\
 Database changes can be undone by using the `rollback` statement with a
generation number as argument. For example, the statement:

    Amos 4> rollback 2;

will restore the database to the state it had at generation number 2. A
rollback without arguments undoes all database changes of the current
transaction.

The statement `commit` makes changes non-undoable, i.e. all updates so
far cannot be rolled back any more and the generation numbering starts
over from 1. 

For example: 

    Amos 2> commit;
      
    Amos 1> ...

Saving and quitting\

When your Amos II database is defined and populated, it can be saved on
disk with the AmosQL statement:

    save "filename";

In a later session you can connect to the saved database by starting
Amos II with:

    amos2 filename

To shut down Amos II orderly first save the database and then type:

    Amos 1> quit;

<span style="font-weight: bold;">This is all you need to know to get
started with Amos II.</span>

The remaining chapters in this document describe the basic Amos II
commands. As an example of how to define and populate an Amos II
database, cut-and-paste the commands in
<http://www.it.uu.se/research/group/udbl/amos/doc/intro.amosql>. There
is a tutorial on object-oriented database design with Amos II in
<http://www.it.uu.se/research/group/udbl/amos/doc/tut.pdf>.

Java interface\

*JavaAmos* is a version of the Amos II kernel connected to the Java
virtual machine (a 32 bits JVM is required). With it Java programs can
call Amos II functions and send AmosQL statements to Amos II for
evaluation (the *callin* interface) [\[ER00\]](#ER00). You can also
define Amos II [foreign functions](#foreign-functions) in Java (the
*callout* interface). To start JavaAmos use the script

     javaamos
      

instead of `amos2`. It will enter a top loop reading and evaluating
AmosQL statements. JavaAmos requires the Java jar file <span
style="font-family: monospace;">javaamos.jar</span>.

Back-end relational databases\

Amos II includes a interface to relational databases using JDBC on top
of JavaAmos. Any relational database can be accessed and queried in
terms of AmosQL using this interface. The interface is described in the
section [Relational database wrapper](#relational).\

Graphical database browser

The multi-database browser GOOVI [\[CR01\]](#CR01) is a graphical
browser for Amos II written as a Java application. You can start the
GOOVI browser from the JavaAmos top loop by calling the Amos II function

    goovi();

It will start the browser in a separate thread.

PHP interface\

Amos II includes an interface allowing programs in PHP to call Amos II
servers. The interface is tested for Apache servers. To use Amos II with
PHP or SQL under Windows you are recommended to download and install
WAMP <http://www.wamp.org/>. WAMP packages together a version of the
Apache web server, the  PHP script language, and the MySQL database.
Amos II  is tested with WAMP 2.0 (32 bits). See further the file <span
style="font-style: italic;">readme.txt</span> in subdirectory <span
style="font-style: italic;">embeddings/PHP</span> of the Amos II
download.

C interface\

The system is interfaced with the programming language C (and C++). As
with Java, Amos II can be called from C (callin interface) and foreign
Amos II functions can be implemented in C. See [\[Ris12\]](#Ris00a).

Lisp interface\

There is a built-in interpreter for a subset of the programming language
CommonLisp in Amos II, <span style="font-style: italic;">aLisp</span>
[\[Ris06\]](#Ris00b). The system can be accessed and extended using
<span style="font-style: italic;">aLisp</span>.

2 AmosQL
========

In general the user may enter different kinds of AmosQL
[statements](#statements) to the Amos top loop in order to instruct the
system to do operations on the database:\

1.  First the database schema is created by [defining types](#types)
    with associated properties.
2.  Once the schema is defined the database can be populated by
    [creating objects](#create-object) and their properties in terms of
    the database schema.\
3.  Once the database is populated [queries](#query-statement) may be
    expressed to retrieve and analyze data from the database. Queries
    return [collections](#collection-syntax) of objects, which can be
    both unordered sets of objects or ordered sequences of objects.
4.  A populated database may be [updated](#updates)to change
    its contents.
5.  [Procedural functions](#procedures) (stored procedures) may be
    defined, which are AmosQL programs having side effects that may
    modify the database.

This section is organized as follows:

-   Before going into the details of the different kinds of AmosQL
    statements, in [Section 2.1](#basic-constructs) the syntactic
    notation is introduced along with descriptions of syntax and
    semantics of the basic building blocks of the query language.
-   [Section 2.2](#types) describes how to create a simple database
    schema by defining types and properties.\
-   [Section 2.3](#create-object) describes how to populate the database
    by creating objects.
-   The concept of *queries* over a populated database is presented in
    [Section 2.4](#query-statement).
-   Regular queries return unordered sets of data. In addition Amos II
    provides the ability to specify *vector queries*, which return
    ordered sequences of data, as described in [Section
    2.5](#vector-queries).\
-   A central concept in Amos II is the extensive use of *functions* in
    database schema definitions. There are several kinds of user-defined
    functions supported by the system as described in [Section
    2.6](#function-definitions).
-   [Section 2.7](#updates) describes how to *update* a
    populated database.
-   [Section 2.8](#data-mining) describes primitives in AmosQL useful
    for data mining, in particular different ways of grouping data and
    of making operations of sequences and numerical vectors.
-   [Section 2.9](#accessing-files) describes functions available to
    read/write data from/to files, such as CSV files.
-   [Section 2.10](#cursors) describes how to define *scans* making it
    possible to iterate over very large query results.

2.1 Basic constructs
--------------------

The basic building blocks of the AmosQL query language are described
here.\

### 2.1.1 Syntactic conventions

For the syntax we use BNF notation with the following special
constructs:

A ::= B C: A consists of B followed by C. \
 A ::= B | C, alternatively (B | C): A consists of B or C.\
 A ::= \[B\]: A consists of B or nothing.\
 A ::= B-list: A consists of a sequence of one or more Bs.\
 A ::= B-commalist: A consists of one or more Bs separated by commas.\
 'xyz': The keyword xyz.

### 2.1.2 Statements

*Statements* instruct Amos II to perform various kinds of operations on
the database. AmosQL statements are always terminated by a semicolon
(;). The following statements can be entered to the Amos II top loop:

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

### 2.1.3 Identifiers

*Identifiers* have the syntax:

    identifier ::=
      
             ('_' | letter) [identifier-character-list] 
      
     identifier-character ::=
      
            alphanumeric | '_'
      

      
    E.g.: MySalary
      
      x
      
      x1234
      
      x1234_b
      

<span style="font-weight: bold;">Notice</span> that Amos II identifiers
are NOT case sensitive; i.e. they are always internally capitalized. By
contrast Amos II reserved keywords are always written with *lower case*
letters.

### 2.1.4 Variables

Variables are of two kinds: *local variables* or *interface variables*:\
\
 `   variable ::= local variable | interface-variable`\
\

-   *Local variables* are identifiers for data values inside AmosQL
    queries and functions. *Local variables* must be declared in
    function signatures (see [Function
    definitions](#function-definitions)), in from clauses (see
    [Queries](#query-statement)), or by the `declare` statement (see
    [procedural functions](#procedures)). Notice that variables are
    **not** case sensitive.
-   `            `*Interface variables* hold only **temporary** results
    during interactive sessions. Interface variables **cannot** be
    referenced in function bodies and they are **not** stored in
    the database. Their lifespan is the current transaction only. Their
    purpose is to hold temporary values in scripts and
    database interactions.

### 2.1.5 Constants

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

### 2.1.6 Expressions

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

### 2.1.7 Collections

*Collections* represent sets of objects. Amos II supports three kinds of
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
When a query to the Amos II toploop returns a bag as result the elements
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
enclose vector elements, for example: <span style="font-family:
      monospace;">\
    set :v=**{**1,2,3**}**;</span> <span
style="font-family: monospace;"> \
 </span> <span style="font-family: monospace;"></span>then <span
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
hash links. Amos II uses generalized JSON notation to construct records.
For example the following expression assigns *:r* to a record where the
key (property) 'Greeting' field has the value 'Hello, I am Tore' and the
key 'Email' has the value 'Tore.Andersson@it.uu.se':\

    set :r= {'Greeting':'Hello, I am Tore','Email':'Tore.Andersson@it.uu.se'}
      

A field *f* of a record bound to a variable *r* can be access with the
notation *r\[f\]*, for example:\
 `   :r['Greeting'` `];`\
 returns\
 `   'Hello, I am Tore'`\

### 2.1.8 Comments

A *comment* can be placed anywhere in an AmosQL statement outside
[identifiers](#identifiers), constants, or variables. \
 Syntax:

    comment ::= '/*' character-list '*/'

2.2 Defining types
------------------

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
*name()* is applied. The normal semantics in Amos II is that when a
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

-   [*Stored functions*](#stored-function) are stored in the Amos II
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

For example, assume the following two Amos II function definitions
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
managers and ` EMPLOYEE.INCOME->INTEGER` for non-manager. In Amos II
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

Amos II functions are internally represented as any other objects and
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

Information stored in Amos II represent mappings between function
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

Not every function is updatable. Amos II defines a function to be
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

Amos II provides primitives for advanced analysis, aggregation, and
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

The file system where an Amos II server is running can be accessed with
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

<span style="font-weight: bold;"></span> 3 Procedural functions
===============================================================

<span style="font-family: Times New Roman;"></span>

<span style="font-family: Times New Roman;"></span> <span
style="font-family: Times New Roman;"> A *procedural function* is an
Amos II function defined as a sequence of AmosQL statements that may
have side effects (e.g. database update statements). Procedural
functions may iteratively return elements of a result bag by using a
[return](#result) statement. Each time *return* is executed another
result element is emitted from the function. </span> <span
style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;">Procedural functions should be
avoided in queries</span> since procedural functions may change the
data, and since the execution order of function calls in queries is
undefined.  Most, but not all, AmosQL statements are allowed in
procedure bodies as can be seen by the syntax below. </span>

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
          

        

For example, the procedural function *creperson()* creates a new person
and sets the properties *name()* and *income()*, i.e. it is a
*constructor* for persons: 

     create function creperson(Charstring nm,Integer inc) -> Person p 
          
                    as 
          
                    begin 
          
                      create Person instances p; 
          
                      set name(p)=nm; 
          
                      set income(p)=inc; 
          
                      return p; 
          
                    end;
          

          
     set :p = creperson('Karl',3500);
          

        

<span style="font-family: Times New Roman;">The procedural function
*makestudent()* makes a person a student and sets the student's
*score()* property:\
\
 </span> <span style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;"></span>
`create function makestudent(Object o,Integer sc) -> Boolean `
`            ` `  as add type Student(score) to o (sc); `
`            `\
 Call: `            ` ` makestudent(:p,30); `\
\
 The function *flatten\_incomes()* updates the incomes of all persons
having higher income than a threshold value:\
\
 ` create function flatten_incomes(Integer threshold) -> Boolean      `
`            `
`    as for each Person p                  where income(p) > threshold `
`            ` `          set income(p) = income(p) - ` `            `
`              (income(p) - threshold) / 2;`\
 Call:\
 ` flatten_incomes(1000);`\
\
 The function *sumb2()* multiplies the elements of two bags:\
\
 `            `
`create function sumb2(Bag of Number b1, Bag of Number b2) -> Number`
`            `
`   as begin declare Number r, Number x1, Number x2,                            Scan c1, Scan c2;`
`            ` `      open c1 for b1;` `            `
`      open c2 for b2;` `            ` `      set r = 0;` `            `
`      while more(c1) and more(c2)     ` `            `
`       do fetch c1 into x1;` `            `
`          fetch c2 into x2;` `            `
`          set r = r + x1*x2;` `            ` `          return r;`
`            ` `      end while;` `            ` `      end;`\
 Call:\
 `sumb2(` `iota` `(1,10),iota(10,20));`\
\
 *sumb2()* illustrates the use of [while statements](#while-stmt) in
procedural functions to iterate over several [scans](#cursors)
simultaneously.\
\
 Queries and updates embedded in procedure bodies are optimized at
compile time. The compiler saves the optimized query plans in the
database so that dynamic query optimization is not needed when
procedural functions are executed. \
\
 </span> <span style="font-weight: bold;"></span>A procedural function
may return a bag of result values iteratively by executing the [return
statement](#result) several times in a procedural function returning a
bag. Every time the return statement is executed an element of the
result bag <span style="font-family:
      monospace;"></span> is emitted from the function.  <span
style="font-family: Times New Roman;">The return statement does not not
abort the control flow (different from, e.g., *return* in C), but it
only specifies that a value is to be emitted to the result bag of the
function and then the procedure evaluation is continued as usual. 
</span>For example,\

`      create function myiota(Number l, Number u) -> Bag of Integer        as begin declare Integer r;           set r = l;           while r <= u           do return r;              set r = r + 1;           end while;           end;        `Call:\
 `myiota(3,5)` `;`\
 returns\
 `3` `        ` `4` `        ` `5`\
\
 Notice that [scans](#cursors) can be used for iterating over functions
producing very large bags by many executions of the return statement.
For example:\
 `open :c for myiota(1,10000000);` `        ` `fetch :c;` `        `
`fetch :c;`\
 etc.\
\
 If the return statement [<span style="font-family:
        Times New Roman;"></span>](#result) is never called in a
procedural function, the result of the procedural function is empty. If
a procedural function is used for its side effects only, not returning
any value, the result type *Boolean* can be specified.\
 <span style="font-family: Times New Roman;"> </span>

3.1 Iterating over results\
---------------------------

The [for-each statement](#for-each) statement iterates over the result
of a query by executing the [for-each body](#for-each-body) for each
result variable binding of the query. For example the following
procedural function adds *inc* to the incomes of all persons with
salaries higher than *limit* and returns their *old* incomes: 

    create function increase_incomes(Integer inc,Integer thres)
          
                                   -> Integer oldinc 
          
      as for each Person p, Integer i 
          
            where i > thres
          
              and i = income(p) 
          
         begin 
          
           return i; 
          
           set income(p) = i + inc 
          
         end;

The for-each statement does not return any value at all unless a
*return* statement is called within its body as in
*increase\_incomes()*.  \
\
 The [for-each option](#for-each-option) specifies how to treat the
result of the query iterated over. If it is omitted the system default
is to iterate directly over the result of the query while immediately
applying the [for-each body](#for-each-body) on each retrieved element.\
\
 If *distinct* is specified in a for-each statement the iteration is
over a copy where duplicates in addition have been removed.\
\
 If  *copy* is specified the code is applied on a copy of the result of
the query. This options may be needed if the body updates the same
collections as it is iterating over.\
\
 <span style="font-weight: bold;">Notice</span> that scans can be used
as an alternative to the [for-each statement](#foreach-statement) for
iterating over the result of a bag. However, the for-each statement is
faster than iterating with cursors, but it cannot be used for
simultaneously iterating over several bags such as is done by the 
[sumb2()](#sumb2). <span style="font-family: Times New Roman;"></span>
<span style="font-family: Times New Roman;"></span>

3.2 User update procedures
--------------------------

It is possible to register user defined *user update procedures* for any
function. The user update procedures are [procedural
functions](#procedures) which are transparently invoked when update
statements are executed for the function.

    
`set_addfunction(Function f, Function up)->Boolean            set_remfunction(Function f, Function up)->Boolean            set_setfunction(Function f, Function up)->Boolean                `\
 The function *f* is the function for which we wish to declare a user
update function and *up* ** is the actual update procedure. The
arguments of a user update procedures is the concatenation of argument
and result tuples of  *f*. For example, assume we have a function\

<span style="font-family: monospace;">  create function
netincome(Employee e) -&gt; Number\
     as income(e)-taxes(e);</span>\

Then we can define the following user update procedure:\

<span style="font-family: monospace;">create function
set\_netincome(Employee e, Number i) -&gt; Boolean\
   as begin\
      set taxes(e)= i\*taxes(e)/income(e) + taxes(e);\
      set income(e) = i\*(1-taxes(e))/income(e) +\
                      income(e);\
      end;\
 </span>

The following declaration makes *netincome()* <span
style="font-family: monospace;"> </span>updatable with the [set<span
style="font-family: monospace;"></span>](#updates) statement:\

<span style="font-family: monospace;"> 
set\_setfunction([\#'employee.netincome-&gt;number'](#functional-constant),\
                   \#'employee.number-&gt;boolean');\
 </span>

Now one can update *netincome()* with, e.g.:\

<span style="font-family: monospace;">   set netincome(p)=32000\
   from Person p\
  where name(p)="Tore";</span> <span style="font-family: Times
      New Roman;"> </span>

4 The SQL processor
===================

<span style="font-family: Times New Roman;"> </span>

Amos II databases can be manipulated using SQL as an alternative to
AmosQL. The SQL preprocessor translates SQL commands to corresponding
AmosQL statements. The SQL preprocessor is called using a special
foreign function:\

    sql(Charstring query)->Bag of vector result

<span style="font-family: Times New Roman;"> </span>

To make it possible to use an Amos II function in SQL queries, its name
must be prefixed with ' <span style="font-family:
          monospace;">sql:</span>'. Thus an Amos II function whose name
is <span style="font-family: monospace;">sql:</span> <span
style="font-style: italic;">&lt;table&gt;</span> is regarded from SQL as
a table named <span style="font-style: italic;">&lt;table&gt;</span> and
can be queried and updated using SQL statements passed as argument to
the foreign function <span style="font-style:
          italic;">sql</span>.\
\
 For example, assume we define the stored functions:\

    create function sql:employee(Integer ssn) -> (Charstring name, Number Income, Integer dept) as stored;

<span style="font-family: Times New Roman;"></span>

    create function sql:dept(Integer dno) -> Charstring dname as stored;
          

        

<span style="font-family: Times New Roman;"> </span>

Then we can populate the tables by the following calls to the sql
function:\

    sql("insert into employee values (12345, "Kalle", 10000, 1)");

<span style="font-family: Times New Roman;"></span>

    sql("insert into employee values (12386, "Elsa", 12000, 2)");

<span style="font-family: Times New Roman;"></span>

    sql("insert into employee values (12493, "Olof", 5000, 1)");

<span style="font-family: Times New Roman;"></span>

    sql("insert into dept values(1,"Toys")");

<span style="font-family: Times New Roman;"></span>

    sql("insert into dept values(2,"Cloths")");
          

        

<span style="font-family: Times New Roman;"> </span>

Examples of SQL queries are:\

    sql("select ssn from employee where name = "Kalle"");

<span style="font-family: Times New Roman;"></span>

    sql("select dname from dept, employee where dept = dno and name="Kalle"");
          

        

<span style="font-family: Times New Roman;"> </span>

The parser is based on the SQL-92 version of SQL. <span
style="font-family: Times New Roman;">Thus, the SQL processor allows an
Amos II database be both updated and queried using SQL-92. The
parser</span> passes most of the SQL-92 validation test.  However, SQL
views are not supported. For further details see
<http://www.it.uu.se/research/group/udbl/Theses/MarkusJagerskoghMSc.pdf>.\

The command line option\

     amos2 ... -q sql...

<span style="font-family: Times New Roman;"> </span>

will make Amos II accept SQL as query language in the top loop rather
than AmosQL.\

5 Peer management\
==================

Using a basic Amos II peer communication system, distributed Amos II
peers can be set up which communicate using TCP/IP. A federation of Amos
II peers is managed by a <span style="font-style: italic;">name
server</span> which is an Amos II peer knowing addresses and names of
other Amos II peers. Queries, AmosQL commands, and results can be
shipped between peers. Once a federation is set up, multi-database
facilities can be used for defining queries and views spanning several
Amos II peers [\[RJK03\]](#RJK03). Reconciliation primitives can be used
for defining object-oriented multi-peer views
[\[JR99a\]](#JR99a)[\[JR99b\]](#JR99b).\

5.1 Peer communication
----------------------

The following AmosQL system functions are available for inter-peer
communication:\

`   nameserver(Charstring name)->Charstring`\
 The function makes the current stand-alone database into a name server
and registers there itself as a peer with the given `name`. If name is
empty ("") the name server will become *anonymous* and not registered as
a peer. It can be accessed under the peer name "NAMESERVER" though.\

`   listen()`\
 The function starts the peer listening loop. It informs the name server
that this peer is ready to receive incoming messages. The listening loop
can be interrupted with CTRL-C and resumed again by calling <span
style="font-style: italic;">listen()</span>. The name server must be
listening before any other peer can register.

`   register(Charstring name)->Charstring`\
 The function registers in the name server the current stand-alone
database as a peer with the given <span
style="font-style: italic;">name</span> `. ` The system will complain if
the name is already registered in the name server. The peer needs to be
activated with <span style="font-style: italic;">listen()</span> to be
able to receive incoming requests. The name server must be running on
the local host.\

`   register(Charstring name, Charstring host)->Charstring         `\
 Registers the current database as a peer in the federation name server
running on the given <span style="font-style: italic;">host</span>.
Signals error if peer with same name already registered in federation.\

`   reregister(Charstring name)->Charstring               reregister(Charstring name, Charstring host)->Charstring         `\
 as <span style="font-style: italic;">register()</span> but first
unregisters another registered peer having same name rather than
signaling error. Good when restarting peer registered in name server
after crash so the crashed peer will be unregistered.  

`   this_amosid()->Charstring name`\
 Returns the `name` of the peer where the call is issued. Returns the
string `"NIL"` if issued in a not registered standalone Amos II system.

`   other_peers()->Bag of Charstring name`\
 Returns the `name`s of the other peers in the federation managed by the
name server.

`   ship(Charstring peer, Charstring cmd)-> Bag of Vector`\
 Ships the AmosQL command <span style="font-style: italic;">cmd</span>
for execution in the named peer. The result is shipped back to the
caller as a set of tuples represented as vectors.  If an error happens
at the other peer the error is also shipped back.\

<span style="font-family: Times New Roman;">
`   call_function(Charstring peer, Charstring fn, Vector args, Integer stopafter)-> Bag of Vector`\
 Calls the Amos II function named <span style="font-style:
            italic;">fn</span> with argument list <span
style="font-style: italic;">args</span> in <span
style="font-style: italic;">peer</span>. The result is shipped back to
the caller as a set of tuples represented as vectors. The maximum number
of tuples shipped back is limited by <span
style="font-style: italic;">stopafter</span>. If an error happens at the
other peer the error is also shipped back.\
\
 </span> `   send(Charstring peer, Charstring cmd)-> Charstring peer`\
 Sends the AmosQL command <span style="font-style: italic;">cmd</span>
for asynchronous execution in the named peer without waiting for the
result to be returned. Errors are handled at the other peer and <span
style="font-style: italic;">not </span>shipped back.\

<span style="font-family: Times New Roman;">
`   send_call(Charstring peer, Charstring fn, Vector args)-> Boolean           `\
 Calls the Amos II function named <span style="font-style:
            italic;">fn</span> with argument list <span
style="font-style: italic;">args</span> asynchronously in the named
<span style="font-style: italic;">peer</span> without waiting for the
result to be returned. Errors are handled at the other peer and <span
style="font-style:
            italic;">not </span>shipped back.</span>

`   broadcast(Charstring cmd)-> Bag of Charstring         `\
 Sends the AmosQL command <span style="font-style: italic;">cmd</span>
for asynchronous execution in all other peers. Returns the names of the
receiving peers.\

`   gethostname()->Charstring name`\
 Returns the name of the host where the current peer is running.\

`   kill_peer(Charstring name)->Charstring`\
 Kills the named peer. If the peer is the name server it will not be
killed, though. Returns the name of the killed peer.\

<span style="font-family: monospace;">   kill\_all\_peers()-&gt;Bag of
Charstring</span>\
 Kills all peers. The name server and the current peer will still be
alive afterwards. Returns the names of the killed peers.\

<span style="font-family: monospace;">  
kill\_the\_federation()-&gt;Boolean </span>\
 Kills all the peers in the federation, including the name server and
the peer calling <span
style="font-style: italic;">kill\_the\_federation</span>.\

<span style="font-family: monospace;">   is\_running(Charstring 
peer)-&gt;Boolean</span>\
 Returns <span style="font-style: italic;">true</span> if peer is
listening.\

<span style="font-family: monospace;">   wait\_for\_peer(Charstring
peer)-&gt;Charstring</span>\
 Waits until the peer is running and then returns the peer name.

<span style="font-family: monospace;">   amos\_servers()-&gt;Bag of
Amos</span>\
 Returns all peers managed by the name server on this computer. You need
not be member of federation to run the function.

5.2 Peer queries and views\
---------------------------

Once you have established connections to Amos II peers you can define
views of data from your peers. You first have to import the meta-data
about selected types and functions from the peers. This is done by
defining *proxy types* and *proxy functions* [\[RJK03\]](#RJK03) using
the system function `import_types`:\

<span style="font-family: monospace;">   import\_types(Vector of
Charstring typenames,  Charstring p)-&gt; Bag of Type pt</span>\
 defines proxy types <span style="font-family: monospace;">pt</span> for
types named <span style="font-family: monospace;">typenames</span> in
peer <span style="font-family: monospace;">p</span>. Proxy functions are
defined for the functions in <span
style="font-family: monospace;">p</span> having the imported types as
only argument. Inheritance among defined proxy types  is imported
according to the corresponding  inheritance relationships between
imported types in the peer <span
style="font-family: monospace;">p</span>.\

Once the proxy types and functions are defined they can transparently be
queried. Proxy types can be references using <span
style="font-family: monospace;">@</span> notation to reference types in
other peers.\
 For example,\
 <span style="font-family: monospace;">   select name(p) from
Person@p1;</span>\
 selects the <span style="font-family: monospace;">name</span> property
of objects of type <span style="font-family:
          monospace;">Person</span> in peer <span style="font-family:
          monospace;">p1</span>.\

<span style="font-family: monospace;">import\_types</span> imports only
those functions having one of `typenames` as its single arguments. You
can import other functions using system function `import_func`:\

<span style="font-family: monospace;">   import\_func(Charstring fn,
Charstring p)-&gt;Function pf</span>\
 imports a function named <span
style="font-family: monospace;">fn</span> from peer <span
style="font-family: monospace;">p</span> returning proxy function <span
style="font-family: monospace;">pf</span>.\

On top of the imported types object-oriented multi-peer views can be
defined, as described in [\[RJK03\]](#RJK03) consisting of <span
style="font-style: italic;">derived types</span> [\[JR99a\]](#JR99a)
whose extents are derived through queries intersecting extents of other
types, and <span style="font-style: italic;">IUTs</span>
[\[JR99b\]](#JR99b) whose extents reconciles unions of other type
extents. Notice that the implementation of IUTs is limited. (In
particular the system flag <span
style="font-family: monospace;">latebinding('OR');</span> must be set
before IUTs can be used and this may cause other problems).\

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

7 System functions and commands
===============================

7.1 Comparison operators\
-------------------------

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

<span style="font-family: Times New Roman;"> </span>
----------------------------------------------------

7.2 Arithmetic functions

<span style="font-family: Times New Roman;"> </span>

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
            

          

*iota()* constructs a bag of integers between <span
style="font-style: italic;">l</span> and <span
style="font-style: italic;">u</span>. \
 For example, to execute n times the AmosQL statement 'print(1)' do: 

    for each Integer i where i in iota(1,n) 
            
            print(1);

<span style="font-family: Times New Roman;"> </span>
----------------------------------------------------

7.3 String functions

<span style="font-family: Times New Roman;"> String concatenation is
made using the '+' operator, e.g.\
 `"ab" + "cd" + "ef";`  returns
`"abcdef"          "ab"+12+"de"; `returns
`"ab12de"          1+2+"ab"; `is illegal since the first argument of '+'
must be a string. `          "ab"+1+2; `returns `"ab12"` since '+' is
left associative.\
\
 `char_length(Charstring)->Integer`\
 Count the number of characters in string.</span>\
 <span style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;">\
 `like(Charstring string, Charstring pattern) -> Boolean`\
 Test if string matches regular expression pattern where '\*' matches
sequence of characters and '?' matches single character. For example:\
 `like("abc","??c")` returns TRUE\
 `like("ac","a*c")` returns TRUE\
 `like("ac","a?c")` fails\
 `like("abc","a[bd][dc]");` returns TRUE\
 `like("abc","a[bd][de]");` fails\
\
 `like_i(Charstring string, Charstring pattern) -> Boolean`\
 Case insensitive *like()*
`.                       locate(Charstring substr, Charstring str) -> Integer                    `The
position of the first occurrence of substring *substr* in string *str.*\
\
 <span style="font-family: monospace;"></span> </span>
`lower(Charstring str)->Charstring         `\
 Lowercase string.\
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

8 References
============

\[CR01\]K.Cassel and T.Risch: [An Object-Oriented Multi-Mediator
Browser](http://www.it.uu.se/research/group/udbl/publ/goovipaper3.pdf%20).
Presented at <span style="font-style: italic; ">2nd International
Workshop on User Interfaces to Data Intensive
Systems</span>[**](http://www.uidis01.ethz.ch/%20), Zürich, Switzerland,
May 31 - June 1, 2001

\[ER00\] D.Elin and T. Risch: [Amos II Java
Interfaces](http://user.it.uu.se/%7Etorer/publ/javaapi.pdf%20),  Uppsala
University, 2000.

\[FR95\] S. Flodin and T. Risch, [Processing Object-Oriented Queries
with Invertible Late Bound
Functions](http://user.it.uu.se/%7Etorer/publ/vldb95.pdf%20), *Proc.
VLDB Conf.*, Zürich, Switzerland, 1995.\
\
 \[FR97\] G. Fahl and T. Risch: [Query Processing over Object Views of
Relational
Data](http://www.it.uu.se/research/group/udbl/publ/vldbj97.pdf%20), The
VLDB Journal , Vol. 6 No. 4, November 1997, pp 261-281.\

\[JR99a\] V.Josifovski, T.Risch: **Functional Query Optimization over
Object-Oriented Views for Data Integration** *Journal of Intelligent
Information Systems (JIIS)*, Vol. 12, No. 2-3, 1999.

\[JR99b\] V.Josifovski, T.Risch: [Integrating Heterogeneous Overlapping
Databases through Object-Oriented
Transformations](http://www.it.uu.se/research/group/udbl/publ/vldb99.pdf%20).
In *Proc. 25th Intl. Conf. On Very Large Databases*, Edinburgh,
Scotland, September 1999.\

\[JR02\] V.Josifovski, T.Risch: **Query Decomposition for a Distributed
Object-Oriented Mediator System** . [*Distributed and Parallel Databases
J.*](http://www.wkap.nl/journalhome.htm/0926-8782%20), Kluwer, May
2002.\

\[KJR03\] T.Katchaounov, V.Josifovski, and T.Risch: [**Scalable View
Expansion in a Peer Mediator
System**](http://user.it.uu.se/%7Etorer/publ/dsve.pdf%20), *Proc. 8th
International Conference on Database Systems for Advanced Applications
(DASFAA 2003)*, Kyoto, Japan, March 2003.

\[LR92\] W.Litwin and T.Risch: Main Memory Oriented Optimization of OO
Queries Using Typed Datalog with Foreign Predicates, *IEEE Transactions
on Knowledge and Data Engineering*, Vol. 4, No. 6, December 1992
([http://user.it.uu.se/\~udbl/publ/tkde92.pdf](http://www.it.uu.se/research/group/udbl/publ/tkde92.pdf%20)). 

\[Nas93\] J.Näs: [Randomized optimization of object oriented queries in
a main memory database management
system](http://www.it.uu.se/research/group/udbl/Theses/JoakimNasMSc.pdf%20),
MSc thesis, LiTH-IDA-Ex 9325 Linköping University 1993.

\[Ris12\] T.Risch: [Amos II C
Interfaces](http://user.it.uu.se/%7Etorer/publ/externalC.pdf%20),
Uppsala University, 2012.\

\[Ris06\]T.Risch: [ALisp v2 User's
Guide](http://user.it.uu.se/%7Etorer/publ/alisp2.pdf%20), Uppsala
University, 2006.\

\[RJK03\] T.Risch, V.Josifovski, and T.Katchaounov: [**Functional Data
Integration in a Distributed Mediator
System**](http://user.it.uu.se/%7Etorer/publ/FuncMedPaper.pdf%20), in
P.Gray, L.Kerschberg, P.King, and A.Poulovassilis (eds.): <span
style="font-style: italic; ">Functional Approach to Data Management -
Modeling, Analyzing and Integrating Heterogeneous Data</span>, Springer,
ISBN 3-540-00375-4, 2003.
