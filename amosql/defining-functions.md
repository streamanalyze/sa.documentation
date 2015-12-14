# Functions

The *create function* statement defines a new user function stored in
the database. Functions can be one of the following kinds:

- [Stored functions](#stored-function) are stored in the sa.amos
database as a table.

- [Derived functions](#derived-function) are defined by a single
[query](../amosql/queries.md#query-statement) that returns the result of the a function call for given parameters.

- [Foreign functions](../accessing-external-systems/foreign-and-multi-directional-functions.md) are defined in an external
programming language. Foreign functions can be defined in the
programming languages C/C++ [Ris12](<http://user.it.uu.se/~torer/publ/externalC.pdf>) or Java [ER00](<http://user.it.uu.se/~torer/publ/javaapi.pdf>).

- [Procedural functions](../procedural-functions/README.md) are defined using procedural
AmosQL statements that can have side effects changing the state of the
database. Procedural functions make AmosQL computationally complete.

- [Overloaded functions](#overloaded-function) have different
implementations depending on the argument types in a function call.

Syntax:

```
create-function-stmt ::= 
      'create function' function-signature [function-body]

function-signature ::=
      generic-function-name argument-spec '->' result-spec 

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

function-body ::=
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

## <a name="function-signatures"> Function signatures

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

<a name="tuple-result">

Functions may return more than a single value as *tuples* specified by using the `tuple-result-spec` notation. 

For example:
```sql
   create function marriages(Person p) -> Bag of (Person spouse, Integer year)
     as stored;
```
has the signature `marriages(Person p) -> Bag of (Person spouse, Integer year)`.

Tuple valued functions can be called in queries using the [tuple-expression](queries.md#tuple-expression) notation.
 
## <a name="function-implementation"> Function implementations

The `function-body` notation specifies how values relate to arguments in a
function defintion.

### <a name="stored-function"> Stored functions

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

### <a name="derived-function"> Derived functions

A *derived function* is defined by a single [query](../amosql/queries.md#query-statement).

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
declared again in the `from` clause; their types are inferred from the
function signature. 

Alternative definition of `youngFriends()`:
```sql
   create function youngFriends(Person p) -> Bag of Person f
     as select f
         where age(f) < 18
           and f in friends(p);
```

**Notice** that the variable `f` is bound to the elements of the bag,
not the entire bag itself.

Alternative definition of `youngFriends()`:
```sql
   create function youngFriends(Person p) -> Bag of (Person f)
     as select f
         where age(f) < 18
           and f in friends(p);
```

Derived functions whose *arguments* are declared `Bag of` define
[aggregate functions](queries.md#aggregate-function). Aggregate functions do
not use [Daplex semantics](queries.md#daplex-semantics) but compute values over their entire arguments bag.

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
the [tuple-expr](../amosql/queries.md#tuple-expression) syntax.

Example:
```sql
   select name(s), y
     from Person m, Person f, Person p
    where (s,y) in marriages(p)
      and name(p) = "Oscar";
```

## <a name="overloaded-function"> Overloaded functions

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

<a name="resolvent-name">
Resolvent name syntax:
```
function-name ::= 
      generic-function-name | resolvent-name

resolvent-name ::= 
      type-name-list '.' generic-function-name '->' type-name-list

type-name-list ::= type-name |
                   type-name '.' type-name-list
```

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

For example, the function:
```sql
   create function nameordered(Person p,Person q)->Boolean
     as less(name(p),name(q));
```
will choose the resolvent `CHARSTRING.CHARSTRING.LESS->BOOLEAN` since the
function `name()` returns a string. In both cases the type
resolution (selection of resolvent) will be done at compile time.

### <a name="late-bind"> Late binding

Sometimes it is not possible to determine the resolvent to choose
based on its arguments, so the type resolution has to be done at run
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
overhead of late binding one may use casting, as explained in the next section.

## <a name="casting-expression"> Casting

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

## <a name="abstract-function"> Abstract functions

Sometimes there is a need to have a function defined for subtypes of a
common supertype, but the function should never be used for the
supertype itself. For example, one may have a common supertype `Dog`
with two subtypes `Beagle` and `Poodle`. One would like to have the
function `bark()` defined for different kinds of dogs, but not for dogs in
general. In this case one defines the `bark()` function for type `Dog` as an
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
if the object is a subtype of `Dog`:
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
type `Dog`, an error message is printed.


## <a name="deleting-function"> Deleting functions

Functions are deleted with the `delete function` statement. 

Syntax:
```
delete-function-stmt ::= 
      'delete function' function-name
```

Examples:
```sql
   delete function married;
   delete function Person.name->Charstring;
```

Deleting a function also deletes all functions calling the deleted function.

