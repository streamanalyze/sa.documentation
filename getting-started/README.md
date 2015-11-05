# Getting started


Download the sa.amos zip from <http://www.it.uu.se/research/group/udbl/amos/>. Unpack the zip file to a directory for sa.amos, `<privdir>`. The following files are needed in `<privdir>/bin;`: `amos2.exe amos2.dll amos2.dmp`

sa.amos is ready to run in `<privdir>/bin` by the command:

```
sa.amos [<db>]
```

where `[<db>]` is an optional name of an sa.amos database. If `<db>` is omitted, the system enters an empty system database (named `amos2.dmp`), where only the system objects are defined. The system looks for `amos2.dmp` in the same directory as where the executable `sa.amos.exe` is located.

The executable supports command line parameters to specify, e.g., the database or AmosQL script to load. To get a list of the command line parameters do: `sa.engine.exe -h`

## The Amos toploop

When started, the system enters the sa.amos top loop where it reads AmosQL statements, executes them, and prints their results on the console. The prompter in the sa.amos top loop is:

```
sa.amos [n]>
```

where `n` is a *generation number*. The generation number is increased every time an AmosQL statement that updates the database is executed in the sa.amos top loop.

Typically you start by defining  meta-data (a schema) as [types](#types) and properties of types represented as [functions](#function-definitions). For example, the following statement create a type named `Person` having two property functions `name()` and `income()`:

```
Amos 1> create type Person properties (name Charstring, income Number);
```

When the meta-data is defined you usually *populate* the database by [creating objects](#create-object) and [updating functions](#updates).

For example:
```
Amos 2 > create Person(name,income) instances
 ("Bill",100),
 ("John",250),
 ("Ulla",380),
 ("Eva", 280);
```

When the database is populated you can [query](#query-statement) it, e.g.:

```
Amos 3> select income(p) from
        Person p where name(p)="Ulla";
```

Usually you load AmosQL definitions from a script file rather than entering them on the command line, e.g.

```
Amos 1> < 'mycode.amosql';
```

### Transactions

Database changes can be undone by using the `rollback` statement with a generation number as argument. For example, the statement:

```
Amos 4> rollback 2;
```

will restore the database to the state it had at generation number 2. A rollback without arguments undoes all database changes of the current transaction. The statement `commit` makes changes non-undoable, i.e. all updates so far cannot be rolled back any more and the generation numbering starts over from 1. 

For example:
 
```
Amos 2> commit;
Amos 1> ...
```

### Saving and quitting

When your sa.amos database is defined and populated, it can be saved on
disk with the AmosQL statement:

```
save "foo.dmp";
```

In a later session you can connect to the saved database by starting sa.amos with:

```
sa.amos.exe foo.dmp
```

To shut down sa.amos orderly first save the database and then type:

```
Amos 1> quit;
```

__This is all you need to know to get started with sa.amos.__

The remaining chapters in this document describe the basic sa.amos commands. [As an example of how to define and populate an sa.amos database can be found in the tutorial](tutorial.md). There is a tutorial on object-oriented database design with sa.amos in <http://www.it.uu.se/research/group/udbl/amos/doc/tut.pdf>.

## Java interface

*JavaAmos* is a version of the sa.amos kernel connected to the Java virtual machine (a 32 bits JVM is required). With it Java programs can call sa.amos functions and send AmosQL statements to sa.amos for evaluation (the *callin* interface)[^ER00]. You can also define sa.amos [foreign functions](#foreign-functions) in Java (the *callout* interface). To start JavaAmos use the script `javaamos` instead of `sa.amos`. It will enter a top loop reading and evaluating AmosQL statements. JavaAmos requires the jar file `javaamos.jar`

## Back-end relational databases

sa.amos includes a interface to relational databases using JDBC on top of JavaAmos. Any relational database can be accessed and queried in terms of AmosQL using this interface. The interface is described in the section [Relational database wrapper](#relational).

## C interface

The system is interfaced with the programming language C (and C++). As with Java, sa.amos can be called from C (callin interface) and foreign sa.amos functions can be implemented in C[^Ris12].

## Lisp interface

There is a built-in interpreter for a subset of the programming language CommonLisp in sa.amos, aLisp [^Ris06]. The system can be accessed and extended using `aLisp`.

## Graphical database browser

The multi-database browser GOOVI [^CR01] is a graphical browser for sa.amos written as a Java application. You can start the GOOVI browser from the JavaAmos top loop by calling the AmosQL function

```
goovi();
```
It will start the browser in a separate thread.

## PHP interface

sa.amos includes an interface allowing programs in PHP to call sa.amos servers. The interface is tested for Apache servers. To use sa.amos with PHP or SQL under Windows you are recommended to download and install WAMP <http://www.wamp.org/>. WAMP packages together a version of the Apache web server, the  PHP script language, and the MySQL database. sa.amos is tested with WAMP 2.0 (32 bits). See further the file readme.txt in subdirectory embeddings/PHP of the sa.amos download.
