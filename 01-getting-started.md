# Getting started


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

## The Amos toploop

When started, the system enters the Amos top loop where it reads AmosQL statements, executes them, and prints their results on the console.  The
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
</span>

## Transactions

Database changes can be undone by using the `rollback` statement with a generation number as argument. For example, the statement:

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
