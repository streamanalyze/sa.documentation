# Functions

The *create function* statement defines a new user function stored in
the database. Functions can be one of the following kinds:

- [Stored functions](#stored-function) are stored in the sa.amos
database as a table.

- [Derived functions](#derived-function) are defined by a single
[query](#query-statement) that returns the result of the a function
call for given parameters. 

- [Foreign functions](#foreign-functions) are defined in an external
programming language. Foreign functions can be defined in the
programming languages C/C++ [^Ris12], Java[^ER00], or Lisp[^Ris06].

- [Procedural functions](#procedures) are defined using procedural
AmosQL statements that can have side effects changing the state of the
database. Procedural functions make AmosQL computationally complete.

- [Overloaded functions](#overloaded-functions) have different
implementations depending on the argument types in a function call.

Syntax:

```
create-function-stmt ::= 
      'create function' function-signature [function-definition]

function-signature ::=
      generic-function-name argument-spec '->' result-spec [fn-implementation]

argument-spec ::= 
      '(' [argument-declaration-commalist] ')'  

argument-declaration ::=
      type-spec [local-variable] [key-constraint]

key-constraint ::= 
      'key' | 'nonkey'

result-spec ::=
      argument-spec | tuple-result-spec  

tuple-result-spec ::=
      ['Bag of'] '(' argument-declaration-commalist ')'  

fn-body ::=
      'as' query |
      'stored' |
      procedural-function-definition |
      foreign-function-definition
```
Examples:
```sql
   create function name(Person p) -> Charstring key
     as stored;
   create function born(Person) -> Integer
     as stored;
   create function children(Person p) -> Bag of Person c
     as stored;
   create function parents(Person c) -> Bag of Person p
     as select p 
          from Person p 
         where c in children(p); 
```

Function names are **not** case sensitive and are internally stored
upper-cased.

##Function signatures

The *function signature* defines the types of the arguments and
results of a function. 

Examples:
```
   born(Person) -> Integer
   name(Person p) -> Charstring key
   children(Person p) -> Bag of Person c
```

All types used in the function signature must be previously defined.

The optional names of arguments and result parameters of a function
signature must be unique. 

`Bag of` specifications on the result of a function sugnature declares
that the function returns a bag of values, rather than a single value.

Functions may returns tuples specified by using the
[tuple-result-spec](#tuple-result) notation. For example:
```sql
   create function marriages(Person p) -> Bag of (Person spouse, Integer year)
     as stored;
```
has the signature `marriages(Person p) -> Bag of (Person spouse, Integer year)`.

## Function implementations

The `function-implementation` defines how values relate to arguments in a
function defintion.

### Stored functions

A *stored function* is defined by the implementation `as stored`.

Examples:
```sql
   create function name(Person p) -> Charstring key
     as stored;
   create function born(Person) -> Integer
     as stored;
```

A stored function is represented as a table in the database.

**Notice** that stored functions cannot have arguments declared `Bag of`.

### Derived functions

A *derived function* is defined by a single [query](#query-statement).

Examples:
```sql
   create function taxed_income(Person p) -> Number
     as income(p) - taxes(p);
   create function parents(Person c) -> Bag of Person p
     as select p 
          from Person p 
         where c in children(p); 
```

Functions with result type `Boolean` implement predicates and return
`true` when the condition is fulfilled.

Example:
```sql
   create function child(Person p) -> Boolean
     as select true where age(p)<18;
   create function child(Person p) -> Boolean
     as age(p) < 18;
```

Since the select statement returns a bag of values, derived functions
also often return `Bag of` results. If you know that a function
returns a bag of values you should indicate that in the signature. 

Example:
```sql
   create function youngFriends(Person p)-> Bag of Person
     as select f
          from Person f
         where age(f) < 18
           and f in friends(p);
```

If you had written:
```sql
   create function youngFriends(Person p) -> Person
     as select f
          from Person f
         where age(f) < 18
           and f in friends(p);
```
you would assume that `youngFriends()` returns a single
value. However, this constraint is **not** enforced by the system so
if there are more that one `youngFriends()` the system will treat the
result as a bag.

Variables declared in the result of a derived function need not be
declared again in the from clause, their types are inferred from the
function signature. 

Alternative definition of `youngFriends()`:
```sql
   create function youngFriends(Person p) -> Bag of Person f
     as select f
         where age(f) < 18
           and f in friends(p);
```

**Notice** that the variable `f` is bound to the elements of the bag,
not the bag itself.

Alternative definition of `youngFriends()`:
```sql
   create function youngFriends(Person p) -> Bag of (Person f)
     as select f
         where age(f) < 18
           and f in friends(p);
```

Derived functions whose *arguments* are declared `Bag of` define
[aggregate functions](#aggregate-functions). Aggregate functions do
not use Daplex semantics but compute values over their entire
arguments bag.

Example:
```sql
   create function myavg(Bag of Number x) -> Number
     as sum(x)/count(x);
```
The following query computes the average
age of Carl's grandparents:
```sql
   select myavg(age(grandparents(q)))
     from Person p
    where name(q)="Carl";
```

When functions returning tuples are called in queries the results are
bound by enclosing the function result within parentheses (..) through
the [tuple-expr](#tuple-expr) syntax.

Example:
```sql
   select name(s), y
     from Person m, Person f, Person p
    where (s,y) in marriages(p)
      and name(p) = "Oscar";
```

## Overloaded functions

Function names may be *overloaded*, i.e., functions having the same
name may be defined differently for different argument types. This
allows to define generic functions applicable on objects of several
different argument types. Each specific implementation of an
overloaded function is called a *resolvent*.

For example, the following two function definitions define the
resolvents of the overloaded function `less()`:
```sql
   create function less(Number i, Number j)->Boolean
     as i < j;

   create function less(Charstring s,Charstring t)->Boolean
     as s < t;
```

Internally the system stores the resolvents under different internal
function names. The name of a resolvent is obtained by concatenating
the type names of its arguments with the name of the overloaded
function followed by the symbol `->` and the type of the result. The
two resolvents above will be given the internal resolvent names
`NUMBER.NUMBER.LESS->BOOLEAN` and
`CHARSTRING.CHARSTRING.LESS->BOOLEAN`.

The query compiler resolves the correct resolvent to apply based on
the types of the arguments; the type of the result is not
considered. If there is an ambiguity, i.e. several resolvents qualify
in a call, or if no resolvent qualify, an error will be generated by
the query compiler.

When overloaded function names are encountered in function
bodies, the system will use local variable declarations to choose the
correct resolvent (early binding). 

Example:
```sql
   create function younger(Person p,Person q)->Boolean
     as less(age(p),age(q));
```
will choose the resolvent `NUMBER.NUMBER.LESS->BOOLEAN`, since `age()`
returns integers and the resolvent `NUMBER.NUMBER.LESS->BOOLEAN` is
applicable to integers by inheritance. The other function resolvent
`CHARSTRING.CHARSTRING.LESS->BOOLEAN` does not qualify since it cannot
have integer arguments.

The function:
```sql
   create function nameordered(Person p,Person q)->Boolean
     as less(name(p),name(q));
```
will choose the resolvent `CHARSTRING.CHARSTRING.LESS->BOOLEAN` since the
function `name()` returns a string. In both cases the type
resolution (selection of resolvent) will be done at compile time.

### Late binding

Sometimes it is not possible to determine the resolvent to choose
based on its arguments, so the type resolution has to at run
time. This is called *late binding*.

For example, suppose that managers are employees whose incomes are the
sum of the income as a regular employee plus some manager bonus:
```sql
   create type Employee under Person;
   create type Manager under Employee;
   create function mgrbonus(Manager)->Integer as stored;
   create function income(Employee)->Integer as stored;
   create function income(Manager m)->Integer i
     as select income(e) + mgrbonus(m)
          from Employee e
         where e = m;
```
In the example the equality `e = m` is used for selecting the salary of
the manager as a regular employee.

Now, suppose that we need a function that returns the gross incomes of
all persons in the database, i.e. we use `MANAGER.INCOME->INTEGER` for
managers and `EMPLOYEE.INCOME->INTEGER` for non-manager. Such a
function is defined as:
```sql
   create function grossincomes() -> Integer i
     as select income(p)
          from Employee p;
```
Since `income` is overloaded with resolvents `EMPLOYEE.INCOME->INTEGER`
and `MANAGER.INCOME->INTEGER` and both qualify to apply to employees,
the resolution of `income(p)` will be done at run time. To avoid the
overhead of late binding one may use casting.

## Casting

The type of an expression can be explicitly defined using the *casting*
statement:
```
casting ::= 
      'cast' (expr 'as' type-spec)
```  
Example:
```sql
   create function income(Manager m)->Integer i
     as income(cast(m as Employee)) + mgrbonus(m);
```

## Second order functions

sa.amos functions are internally represented as any other objects and
stored in the database. Object representing functions can be used in
functions and queries too. An object representing a function is called
a *functional*. *Second order functions* are functions that take
functionals as arguments or results.

For example, the second order system function `functionnamed()` retrieves the
functional `fno` having a given name `fn`:
```
   functionnamed(Charstring fn) -> Function fno
```

Another example of a second order function is the system function
```
   apply(Function fno, Vector argl) -> Bag of Vector
```
`apply()` calls the functional `fno` with the vector `argl` as argument list. The result tuples are returned as a bag of vectors.

Example:
```
   apply(functionnamed("number.number.plus->number"),{1,3.4});
```  
returns the vector `{4.4}` Notice how `apply()` represents argument
lists and result tuples as vectors.

When using second order functions one often needs to retrieve
a functional `fno` given its name and the function `functionnamed()`
provides one way to achieve this. A simpler way is often to use
*functional constants* with syntax:
```
functional-constant ::= '#' string-constant
```  
Example:
```
#'mod';
```

A functional constant is translated into the functional with the name
uniquely specified by the string constant. For example, the following
expression `apply(#'mod',{4,3});` returns the vector `{1}`.

**Notice** that an error is raised if the function name specified in
a functional constant does not uniquely identifying the
functional. This happens if it is the generic name of an overloaded
function. For example, the functional constant `#'plus'` is illegal,
since `plus()` is overloaded. For overloaded functions the name of a
resolvent has to be used instead.

For example, `apply(#'plus',{2,3.5});` generates an error, while
`apply(#'number.number.plus->number', {2,3.5});` returns the vector 
`{5.5}`. 

You can use generic functions when applying non-unique resolvents, in
which case apply will dynamically choose the correct resolvent based
on the types in the argument vector.


For example, `apply(functionnamed("plus"),{2,3.5});` returns `{5.5}`.
This call will be somewhat slower than
`apply(#'number.number.plus->number',{2,3.5})` since the resolvent is
selected using late binding.

## Transitive closures

The *transitive closure* function `tclose()` is a second order function
to explore graphs where the edges are expressed by a transition
function specified by argument `fno`:
```
   tclose(Function fno, Object o) -> Bag of Object
```
`tclose()` applies the transition function `fno(o)`, then
`fno(fno(o))`, then `fno(fno(fno(o)))`, etc. until `fno` returns the
empty result. Because of the Daplex semantics, if the transition
function `fno` returns a bag of values for some argument `o`, the
successive applications of `fno` will be applied on each element of
the result bag. The result types of a transition function must either
be the same as the argument types or a bag of the argument types. Such
a function that has the same arguments and (bag of) result types is
called a *closed function*. 

For example, assume the following definition
of a graph defined by the transition function `arcsto()`:
```sql
   create function arcsto(Integer node)-> Bag of Integer n as stored;
   set arcsto(1) = bag(2,3);
   set arcsto(2) = bag(4,5);
   set arcsto(5) = bag(1);
```
The query `tclose(#'arcsto', 1);` traverses the graph starting in node 1. It will return the bag:
```
   1
   3
   2
   5
   4
```

In general the function `tclose()` traverses a graph where the edges
(arcs) are defined by the transition function. The vertices (nodes)
are defined by the transition function `fno`, where a call to the
transition function `fno(n)` defines the neighbors of the node `n` in
the graph. The graph may contain loops and `tclose()` will remember
what vertices it has visited earlier and stop further traversals for
vertices already visited. You can also query the inverse of
`tclose()`, i.e. from which nodes `f` can be reached.

Example:
```sql
   select f 
     from Integer f 
    where 1 in tclose(#'arcsto',f);
```
will return the bag
```
   1
   5
   2
```

If you know that the graph to traverse is a tree or a directed acyclic
graph (DAG) you can instead use the faster function:
```
   traverse(Function fno, Object o) -> Bag of Object
```

As for `tclose()`, the children in the tree to traverse is defined by
the transition function `fno`. The tree is traversed in pre-order
depth first. Leaf nodes in the tree are nodes for which `fno` returns
empty result. The function `traverse()` will not terminate if the graph is
circular. Nodes are visited more than once for acyclic graphs having
common subtrees.

A transition function may have extra arguments and results, as long as
the function is closed. This allows to pass extra parameters to a
transitive closure computation. 

For example, to compute not only the transitive closure, but also the
distance from the root of each visited graph node, specify the
following transition function:
```sql
   create function arcstod(Integer node, Integer d) -> Bag of (Integer,Integer)
     as select arcsto(node),1+d;
```
The query `tclose(#'arcstod',1,0);` will return the bag:
```
   (1,0)
   (3,1)
   (2,1)
   (5,2)
   (4,2)
```

Notice that only the first argument and result in the transition
function define graph vertices, while the remaining arguments and
results are extra parameters for passing information through the
traversal, as with `arcstod()`. Notice that there may be no more than
three extra parameters in a transition function.

### 2.6.7 Iteration

The function `iterate()` applies a function `fn()` repeadely. 

Signature:
```
   iterate(Function fn, Number maxdepth, Object x) -> Object r
```

The iteration is initialized by setting <i>x<sub>0</sub>=x</i>. Then <i>x<sub>i+1</sub>= fn(x<sub>i</sub>)</i> is repeadedly computed until one of the following conditions hold:
1. there is no change (<i>x<sub>i</sub></i> <i>= </i><i>x<sub>i+1</sub></i>), or
2. `fn()` returns nil (<i>x<sub>i+1 </sub></i><i>=nil</i>), or
3. an upper limit *maxdepth* of the number of iterations is reached for <i>x<sub>i</sub></i>.

There is another overloaded variant of `iterate()` that accepts an extra parameter `p` passed into *fn(x<sub>i</sub>,p)* in the iterations. 

Signature:
```
iterate(Function fn, Number maxdepth, Object x0, Object p) -> Object r
```
This enables flexible termination of the iteration since `fn(x,p)` can return `nil` based on both `x` and `p`.

## Abstract functions

Sometimes there is a need to have a function defined for subtypes of a
common supertype, but the function should never be used for the
supertype itself. For example, one may have a common supertype `Dog`
with two subtypes `Beagle` and `Poodle`. One would like to have the
function `bark()` defined for different kinds of dogs, but not for dogs in
general. In this case one defines the `bark()` function for type Dog as an
abstract function.

Example:
```sql
   create type Dog;
   create function name(Dog)->Charstring as stored;
   create type Beagle under Dog;
   create type Poodle under Dog;
   create function bark(Dog d) -> Charstring as foreign 'abstract-function';
   create function bark(Beagle d) -> Charstring;
   create function bark(Poodle d) -> Charstring;
   create Poodle(name,bark) instances ('Fido','yip yip');
   create Beagle(name,bark) instances ('Snoopy','arf arf');
```
Now you can use `bark()` as a function over dogs in general, but only
if the object is a subtype of Dog:
```sql
   select bark(d) 
     from dog d;
```
will return the bag:
```
"arf arf"
"yip yip"
```

An abstract function is defined by:
```
   create function foo(...)->... as foreign 'abstract-function'.
```

If an abstract function is called it gives an informative error
message. For example, if one tries to call `bark()` for an object of
type Dog, an error message is printed.


## Deleting functions

Functions are deleted with the `delete function` statement. 

Syntax:
```
delete-function-stmt ::= 
      'delete function' function-name

function-name ::= 
      generic-function-name |
      type-name-list '.' generic-function-name '->' type-name-list

type-name-list ::= type-name |
                   type-name '.' type-name-list
```

Examples:
```sql
   delete function married;
   delete function Person.name->Charstring;
```

Deleting a function also deletes all functions calling the deleted function.

