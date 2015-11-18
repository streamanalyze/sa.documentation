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

```
statement ::=
      create-type-stmt                | 
      delete-type-stmt                |
      create-object-stmt              |
      delete-object-stmt              |
      create-function-stmt            |
      delete-function-stmt            |
      query                           |
      update-stmt                     |
      add-type-stmt                   |
      remove-type-stmt                |
      for-each-stmt                   |
      set-interface-variable-stmt     |
      declare-interface-variable-stmt |
      commit-stmt                     |
      rollback-stmt                   |
      open-cursor-stmt                |
      fetch-cursor-stmt               |
      close-cursor-stmt               |
      quit-stmt                       |
      exit-stmt
```

## Identifiers

*Identifiers* have the syntax:

```
identifier ::=
      ('_' | letter) [identifier-character-list] 

identifier-character ::=
      alphanumeric | '_'

```
Examples:
```
   MySalary
   x
   x1234
   x1234_b
```

Notice that sa.amos identifiers are NOT case sensitive; i.e. they are
always internally capitalized. By contrast sa.amos reserved keywords
are always written with *lower case* letters.

## Variables

Variables are of two kinds: *local variables* or *interface variables*. 

Syntax:
```
variable ::= 
     local variable | interface-variable
```

*Local variables* are identifiers for data values inside AmosQL
queries and functions. *Local variables* must be declared in function
signatures (see [Function definitions](#function-definitions)), in
from clauses (see [Queries](#query-statement)), or by the `declare`
statement (see [procedural functions](#procedures)). Notice that
variables are **not** case sensitive.

Syntax:
```
local-variable ::= identifier
```
Examples:
```
   my_variable
   MyVariable2
```

*Interface variables* hold only **temporary** results during
interactive sessions. Interface variables **cannot** be referenced in
function bodies and they are **not** stored in the database. Their
lifespan is the current transaction only. Their purpose is to hold
temporary values in scripts and database interactions.

Syntax:
```
interface-variable ::= ':' identifier
```
Examples:
```
   :my_interface_variable
   :MyInterfaceVariable2
```

The user can declare an interface variable to be of a particular type
by the interface variable declare statement. 

Syntax:
```
interface-variable-declare-stmt ::= 
      'declare' interface-variable-declaration-commalist

interface-variable-declaration ::= 
      type-spec interface-variable
```
Example:
```
   declare Integer :i, Real :x3;
```

Interface variables can be assigned either by the into-clause of the
select statement or by the interface variable assignment statement
*set*. 

Syntax:
```
set-interface-variable-stmt ::= 
      'set' interface-variable '=' expr
```
Examples
```
   set :x3 = 2.3;
   set :i = 2 + sqrt(:x3);
```

## Constants

Constants can be integers, reals, strings, time stamps, booleans, or nil.

Syntax:
```
constant ::=
      integer-constant | real-constant | boolean-constant |
      string-constant | time-stamp | functional-constant  | 'nil'

integer-constant ::=
      ['-'] digit-list

real-constant ::=
      decimal-constant | scientific-constant

decimal-constant ::=
      ['-'] digit-list '.' [digit-list]

scientific-constant ::=
      decimal-constant ['e' | 'E'] integer-constant

```
Examples:
```
   123
   -123
   1.2
   -1.0
   2.3E2
   -2.4e-21
``` 

Boolean contsant represent logical values. 

Syntax:
``` 
boolean-constant ::=
      'true' | 'false'
``` 
The constant *false* is equivalent to nil casted to type *Boolean*. The
only legal boolean value that can be stored in the database is true
and a boolean value is regarded as false if it is not in the database
(called close world assumption).

String have syntax:  
```
string-constant ::=
        string-separator character-list string-separator

string-separator ::=
        ''' | '"'
```
Examples:
```
   "A string"
   'A string'
   'A string with "'
   "A string with \" and '"
```

The enclosing string separators (`'` or `"`) for a string constant
must be the same. If the string separator is `"` then `\` is the
escape character inside the string, replacing the succeeding
character. For example the string `'ab"\'` can also be written as
`"ab\"\\"`, and the string `a'"b` must be written as `"a'\"b"`.

A [simple value](#simple-value) is either a constant or a variable reference.

Syntax:
```
simple-value ::= constant | variable
```
Examples:
```
   :MyInterfaceVariable
   MyLocalVariable
   123
   "Hello World"
```

## Expressions

*Expressions* are formulas expressed with the AmosQL syntax that can
be evaluated by the system to produce a *value*. Complex expressions
can be built up in terms of other expression. Expressions are basic
building blocks in all kinds of AmosQL statements.  

Syntax:
```
expr ::=
      simple-value | function-call | collection-constr | casting |
      vector-indexing | '(' query ')'
```
Examples:
```
   1.23
   1+2
   1<2 and 1>3
   sqrt(:a) + 3 * :b
   {1,2,3}
   cast(:p as Student)
   a[3]
   sum(select income(p) from Person p) +10
```

The value of an expression is computed if the expression is entered to
the sa.amos top loop. Example:
```
   1+5*sqrt(6);
```

Notice that Boolean expressions, [predicates](#predicates), either
return *true*, or nothing if the expression is not true. Example:

```
   1<2 or 3<2;
     => TRUE
   1<2 and 3<2;
     => nothing
```

Entering simple expressions followed by a semicolon is the simplest
form of AmosQL [queries](#query-statement). Example:

```
   1+sqrt(25);
```

## Collections

Collections represent sets of objects. Amos II supports three kinds of
collections: bags, vectors, and key-value associations (records):

- A `bag` is a set where duplicates are allowed.
- A `vector` is an ordered sequence of objects.
- A `record` is an associative array of key-value pairs.

Collections are constructed by collection constructor
expressions. 

Syntax:
```
collection-constr ::= 
      bag-constr | vector-constr | record-constr

bag-constr ::= 
      bag(expr-commalist)

vector-constr ::= 
      '{' expr-comma-list '}'

record-constr ::= 
      '{' key-value-comma-list '}'

key-value ::= 
      string-constant ':' expr
```
Examples:
``` 
   bag(1,2,3)
   bag(1,:x+2)
   { 1,2,3 }
   { {1,2},{3,4} }
   { 1,name(:p),1+sqrt(:a) }
   {"id":1,"name":"Kalle","age":32}
```

### Bags

The most common collection is *bags*, which are unordered sets of
objects with duplicates allowed. The value of a query is usually a
bag. When a query to the sa.amos toploop returns a bag as result the
elements of the bag are printed on separate lines. For example:

```
   select name(p) from Person p;
```
returns the bag:
```
   "Bill"
   "John"
   "Ulla"
   "Eva"
```

Bags can be explicitly created using the *bag-constr* syntax, for example:
```
   bag(1,2,2,3);
```

### Vectors

*Vectors* are sequences of objects of any kind. Curly brackets `{}`
enclose vector elements, For example, `set :v={1,2,3};` then `:v;`
returns `{1,2,3}`.

Vector element `vi` can be access with the notation `v[i]`, where the
indexing `i` is from 0 and up. For example `set :v={1,2,3};` then
`:v[2];` returns `3`.

### Records

*Records* represent dynamic associations between keys and values. A
record is a dynamic and associative array. Other commonly used terms
for associative arrays are property lists, key-value pairs,
dictionaries, or hash links. sa.amos uses generalized JSON notation to
construct records. For example the following expression assigns `:r`
to a record where the key (property) 'Greeting' field has the value
'Hello, I am Tore' and the key 'Email' has the value
'Tore.Andersson@it.uu.se':

```
   set :r= {'Greeting':'Hello, I am Tore','Email':'Tore.Andersson@it.uu.se'}
```

A field `f` of a record bound to a variable `r` can be access with the
notation `r[f]`, for example:
`:r['Greeting' ]` returns `Hello, I am Tore`.

## Comments

A *comment* can be placed anywhere in an AmosQL statement outside [identifiers](#identifiers), constants, or variables. 

Syntax:
```
comment ::= 
       '/*' character-list '*/'
```
