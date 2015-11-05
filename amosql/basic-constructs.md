# Basic Constructs

The basic building blocks of the AmosQL query language are described here.

## Syntactic conventions

For the syntax we use BNF notation with the following special constructs:

```
A ::= B C: A consists of B followed by C.
A ::= B | C, alternatively (B | C): A consists of B or C.
A ::= [B]: A consists of B or nothing.
A ::= B-list: A consists of a sequence of one or more Bs.
A ::= B-commalist: A consists of one or more Bs separated by commas.
'xyz': The keyword xyz.
```

## Statements

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

## Identifiers

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

## Variables

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

## Constants

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


The constant <span
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
 </span>

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
 </span>

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
