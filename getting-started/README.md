# Getting started


Unpack the zip file to a directory for sa.amos, `<privdir>`. The
following files are needed in `<privdir>/bin;`: `sa.amos.exe sa.amos.dll
sa.amos.dmp`

sa.amos is ready to run in `<privdir>/bin` by the command:

```
sa.amos [<db>]
```

where `[<db>]` is an optional name of an sa.amos database. If `<db>`
is omitted, the system enters an empty system database (named
`sa.amos.dmp`), where only the system objects are defined. The system
looks for `sa.amos.dmp` in the same directory as where the executable
`sa.amos.exe` is located.

The executable supports command line parameters to specify, e.g., the
database or AmosQL script to load. To get a list of the command line
parameters do: `sa.amos -h`

## The sa.amos toploop

When started, the system enters the sa.amos top loop where it reads
AmosQL statements, executes them, and prints their results on the
console. The prompter in the sa.amos top loop is:

```
[sa.amos] n>
```

where `n` is a *generation number*. The generation number is increased
every time an AmosQL statement that updates the database is executed
in the sa.amos top loop.

Typically you start by defining meta-data (a schema) as
[types](../amosql/defining-types.md) and properties of types represented as
[functions](../amosql/defining-functions.md). For example, the following
statement create a type named `Person` having two property functions
`name()` and `income()`:

```
[sa.amos] 1> create type Person properties (name Charstring, income Number);
```

When the meta-data is defined you usually *populate* the database by
[creating objects](../amosql/creating-objects.md) and [updating functions](../amosql/updates.md).

For example:
```
[sa.amos] 2> create Person(name,income) instances
 ("Bill",100),
 ("John",250),
 ("Ulla",380),
 ("Eva", 280);
```

When the database is populated you can [query](../amosql/queries.md) it, e.g.:

```
[sa.amos] 3> select income(p) 
               from Person p 
              where name(p)="Ulla";
```

Usually you load AmosQL definitions from a script file rather than entering them on the command line, e.g.

```
[sa.amos] 4> < 'mycode.amosql';
```

### Domain calculus
<a name="domain-calculus"> **Notice** that variables in AmosQL can be bound to *objects of any type*. This is different from select statements in SQL  where all variables must be bound to *tuples only*. AmosQL is based on *domain calculus* while SQL select statements are based on *tuple calculus*.



### Transactions

Database changes can be undone by using the `rollback` statement with
a generation number as argument. For example, the statement:

```
[sa.amos] 5> rollback 2;
```

will restore the database to the state it had at generation number
2. A rollback without arguments undoes all database changes of the
current transaction. The statement `commit` makes changes
permanent, i.e. all updates so far cannot be rolled back any more
and the generation numbering starts over from 1.

For example:
```
[sa.amos] 2> commit;
[sa.amos] 1> ...
```

### Saving and quitting

When your sa.amos database is defined and populated, it can be saved
on disk with the AmosQL statement:

```
[sa.amos] 1> save "foo.dmp";
```

In a later session you can connect to the saved database by starting
sa.amos with:

```
sa.amos.exe foo.dmp
```

To shut down sa.amos orderly first save the database and then type:

```
[sa.amos] 1> quit;
```

__This is all you need to know to get started with sa.amos.__

The remaining chapters in this document describe the basic sa.amos
commands. [An example of how to define and populate an sa.amos
database can be found in the tutorial](tutorial.md). There is a
tutorial on object-oriented database design with sa.amos in
<http://www.it.uu.se/research/group/udbl/amos/doc/tut.pdf>.

## Java interface

Whe you download the system you also get a 32-bits Java engine (Java
Virtual machine, JVM).  The JVM can be loaded into sa.amos by
executing the command:
```
[sa.amos] 1> enable_java(); ...
```
Once Java is enabled the sa.amos kernel can call code written in Java. You can
define sa.amos [foreign functions](../accessing-external-systems/foreign-and-multi-directional-functions.md) in Java (the
*callout* interface).

## Graphical database browser

The multi-database browser GOOVI [CR01](<http://www.it.uu.se/research/group/udbl/publ/goovipaper3.pdf>) is a graphical browser for
sa.amos written as a Java application. You can start the GOOVI browser
from the sa.amos top loop when Java is enabled by calling the AmosQL
function: 
```
[sa.amos] n> goovi();
```
It will start the browser in the main
thread. When you close the browser you return to the sa.amos top loop.

## Back-end relational databases

sa.amos includes a interface to relational databases using JDBC when
Java is enabled. Relational databases can be accessed and queried in
terms of AmosQL using this interface. The interface is described in
the section [Relational database wrapper](../accessing-external-systems/the-relational-database-wrapper.md).

## C interface

The system is interfaced with the programming language C (and
C++). Foreign AmosQL functions can be implemented in C [Ris12](<http://user.it.uu.se/~torer/publ/externalC.pdf>).
