# Defining functions

The *create function* statement defines a new user function stored in the database. Functions can be one of the following kinds:

- [Stored functions](#stored-function) are stored in the sa.amos database as a table.
- [Derived functions](#derived-function) are defined by a single [query](#query-statement) that returns the result of the a function call for given parameters. 
- [Foreign functions](#foreign-functions) are defined in an external programming language. Foreign functions can be defined in the programming languages C/C++ [^Ris12], Java[^ER00], or Lisp[^Ris06].
- [Procedural functions](#procedures) are defined using procedural AmosQL statements that can have side effects changing the state of the database. Procedural functions make AmosQL computationally complete.
- [Overloaded functions](#overloaded-functions) have different implementations depending on the argument types in a function call.

Syntax:

```
create-function-stmt ::=
      'create function' generic-function-name argument-spec '->' result-spec [fn-implementation]

   E.g. create function born(Person) -> Integer as stored;

generic-function-name ::= identifier

function-name ::= generic-function-name |
                   type-name-list '.' generic-function-name '->' type-name-list

   E.g. plus
```
Function names are **not** case sensitive and are internally stored *upper-cased*.

```
type-name-list ::= type-name |
                   type-name '.' type-name-list
```

All types used in the function definitions must be previously defined.
```
argument-spec ::='(' [argument-declaration-commalist] ')'  

argument-declaration ::=
     type-spec [local-variable] [key-constraint]
```
The names of the argument and result parameters of a function definition must be distinct.
```
key-constraint ::= ('key' | 'nonkey')

result-spec ::=   argument-spec | tuple-result-spec  

tuple-result-spec ::=
   ['Bag of'] '(' argument-declaration-commalist ')'  

fn-implementation ::=
  'as' query |
       'stored' |
       procedural-function-definition |
       foreign-function-definition
```

The `argument-spec` and the `result-spec` together specify the *signature* of the function, i.e. the types and optional names of formal parameters and results.

## Stored functions

A *stored function* is defined by the implementation `as stored`, for example:
```
create function age(Person p) -> Integer a
  as stored;
```

The name of an argument or result parameter can be left unspecified if it is not referenced in the function's implementation, for example:
```
create function name(Person) -> Charstring
  as stored;
```

*Bag of* specifications on a single result parameter of a stored function declares the function to return a bag of values, i.e. a set with tuples allowed, for example:
     
```
create function parents(Person) ->   Bag of Person
  as stored;
```

**Notice** that stored functions cannot have arguments declared `Bag of`.

AmosQL functions may also have tuple valued results by using the [tuple-result-spec](#tuple-result) notation. For example:
```
create function parents2(Person p) -> (Person m, Person f)
  as stored;

create function marriages(Person p)
                -> Bag of (Person spouse, Integer year)
  as stored;
```

[Tuple expressions](#tuple-expr)are used for binding the results of tuple valued functions in queries, for example:
```
select s,y
  from Person s, Integer y
 where (s,y) in marriages(:p);
```

The *multiple assignment statement* assigns several variables to the result of a tuple valued query, for example:
```
set (:mother,:father) = parents2(:eve);
```

You can store [records](#records) in stored functions, for example:
```
create function pdata(Person) -> Record
  as stored;
create Person(pdata)
instances ({'Greeting':'Hello, I am Tore',
            'Email':'Tore.Andersson@it.uu.se'});
```
Possible query:
```
select r['Greeting']
  from Person p, Record r
 where name(p)='Tore'
   and pdata(p)=r;
```

## Derived functions

A *derived function* is defined by a single AmosQL [query](#query-statement), for example:
```
create function taxincome(Person p) -> Number
 as select income(p) - taxes(p)
     where taxes(p) < 0;
```

Functions with result type `Boolean` implement predicates and return `true` when the condition is fulfilled. For example:
```
create function child(Person p) -> Boolean
    as select true where age(p)<18;
```
alternatively:
```
create function child(Person p) -> Boolean
     as age(p) < 18;
```

Since the select statement returns a bag of values, derived functions also often return a *Bag of* results. If you know that a function returns a bag of values you should indicate that in the signature. For example:
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
you indicate to the system that `youngFriends()` returns a single value. However, this constraint is **not** enforced by the system so if there are more that one `youngFriends()` the system will treat the result as a bag.

Variables declared in the result of a derived function need not be declared again in the from clause, their types are inferred from the function signature. For example, `youngFriends()` can also be defined as:
```
create function youngFriends(Person p) -> Bag of Person f
as select f
  where age(f) < 18
and f in friends(p);
```

**Notice** that the variable `f` is bound to the elements of the bag, not the bag itself. This definition is equivalent:

```
create function youngFriends(Person p) -> Bag of (Person f)
   as select f
       where age(f) < 18
         and f in friends(p);
```

Derived functions whose *arguments* are declared `Bag of` are user defined [aggregate functions](#aggregate-functions). For example:
```
create function myavg(Bag of Number x) -> Number
     as sum(x)/count(x);
```

[Aggregate functions](#aggregate-functions) do not flatten the argument bag. For example, the following query computes the average age of Carl's grandparents:

```
select myavg(age(grandparents(q)))
  from Person p
 where name(q)="Carl";
```

When functions returning tuples are called the results are bound by enclosing the function result within parentheses (..) through the [tuple-expr](#tuple-expr) syntax. For example:
```
select age(m), age(f)
  from Person m, Person f, Person p
where (m,f) = parents2(p)
  and name(p) = "Oscar";
```

## Overloaded functions

Function names may be overloaded, i.e., functions having the same name may be defined differently for different argument types. This allows generic functions applicable on objects of several different argument types. Each specific implementation of an overloaded function is called a resolvent.

For example, assume the following two sa.amos function definitions having the same generic function name less():
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

When overloaded function names are encountered in AmosQL function bodies, the system will use local variable declarations to choose the correct resolvent (early binding). For example:

```
create function younger(Person p,Person q)->Boolean
    as less(age(p),age(q));
```
will choose the resolvent `NUMBER.NUMBER.LESS->BOOLEAN`, since age returns integers and the resolvent `NUMBER.NUMBER.LESS->BOOLEAN` is applicable to integers by inheritance. The other function resolvent `CHARSTRING.CHARSTRING.LESS->BOOLEAN` does not qualify since it is not legal to apply to arguments of type `Integer`.
On the other hand, this function:
```
create function nameordered(Person p,Person q)->Boolean
    as less(name(p),name(q));
```

On the other hand, this function:
```
create function nameordered(Person p,Person q)->Boolean
    as less(name(p),name(q));
```

will choose the resolvent `NUMBER.NUMBER.LESS->BOOLEAN` since the function `name()` returns a `string`. In both cases the type resolution (selection of resolvent) will be done at compile time.

### Late binding
Dynamic type resolution at run time, late binding, is sometimes required to choose the correct resolvent. For example, the query
```
less(1,2);
```
will choose `NUMBER.NUMBER.LESS->BOOLEAN` based on the numeric types the the arguments.

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

Since the detection of the necessity of dynamic resolution is often at compile time, overloading a function name may lead to a cascading recompilation of functions defined in terms of that function name. For a more detailed presentation of the management of late bound functions see [^FR95].

## Casting

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

## Second order functions

sa.amos functions are internally represented as any other objects and stored in the database. Object representing functions can be used in functions and queries too. An object representing a function is called a functional. Second order functions take functionals as arguments or results. The system function `functionnamed()` retrieves the functional `fno` having a given name `fn`:

```
functionnamed(Charstring fn) -> Function fno
```

The name `fn` is not case sensitive. For example:
```
functionnamed("plus");
=> #[OID 155 "PLUS"]
```
returns the object representing the generic function plus , while
```
functionnamed("number.number.plus->number");   
=> #[OID 156 "NUMBER.NUMBER.PLUS->NUMBER"]
```  
returns the object representing the resolvent named NUMBER.NUMBER.PLUS->NUMBER.

Another example of a second order function is the system function
```
apply(Function fno, Vector argl) -> Bag of Vector
```
It calls the functional `fno` with the vector `argl` as argument list. The result tuples are returned as a bag of vectors, for example:
```
apply(functionnamed("number.number.plus->number"),{1,3.4});
=> {4.4}
```  

Notice how `apply()` represents argument lists and result tuples as vectors. When using second order functions one often needs to retrieve a functional fno given its name and the function `functionnamed()` provides one way to achieve this. A simpler way is often to use functional constants with syntax:
```
functional-constant ::= '#' string-constant
```  
for example
```
#'mod';
```

A functional constant is translated into the functional with the name uniquely specified by the string constant. For example, the following expression
```
apply(#'mod',{4,3});
=> {1}
```  

Notice that an error is raised if the function name specified in the functional constant is not uniquely identifying the functional. This happens if it is the generic name of an overloaded function. For example, the functional constant `#'plus'` is illegal, since `plus()` is overloaded. For overloaded functions the name of a resolvent has to be used instead, for example:
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

The last call using `functionnamed("plus")` will be somewhat slower than using `#'number.number.plus->number'` since the functional for the generic function `plus()` is selected and then the system uses late binding to determine dynamically which resolvent of `plus()` to apply.

## Transitive closures

The transitive closure functions `tclose()` is a second order function to explore graphs where the edges are expressed by a transition function specified by argument `fno`:
```
   tclose(Function fno, Object o) -> Bag of Object
```
`tclose()` applies the transition function `fno(o)`, then `fno(fno(o))`, then `fno(fno(fno(o)))`, etc until fno returns no new result. Because of the Daplex semantics, if the transition function `fno` returns a bag of values for some argument `o`, the successive applications of `fno` will be applied on each element of the result bag. The result types of a transition function must either be the same as the argument types or a bag of the argument types. Such a function that has the same arguments and (bag of) result types is called a closed function. For example, assume the following definition of a graph defined by the transition function `arcsto()`:
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
In general the function `tclose()` traverses a graph where the edges (arcs) are defined by the transition function. The vertices (nodes) are defined by the arguments and results of calls to the transition function `fno`, i.e. a call to the transition function `fno` defines the neighbors of a node in the graph. The graph may contain loops and `tclose()` will remember what vertices it has visited earlier and stop further traversals for vertices already visited. You can also query the inverse of `tclose()`, i.e. from which nodes `f` can be reached, by the query:
```
Amos 6> select f from Integer f where 1 in tclose(#'arcsto',f);
1
5
2
```

If you know that the graph to traverse is a tree or a directed acyclic graph (DAG) you can instead use the faster function:
```
traverse(Function fno, Object o) -> Bag of Object
```

The children in the tree to traverse is defined by the transition function `fno`. The tree is traversed in pre-order depth first. Leaf nodes in the tree are nodes for which `fno` returns nothing. The function `traverse()` will not terminate if the graph is circular. Nodes are visited more than once for acyclic graphs having common subtrees.
A transition function may have extra arguments and results, as long as it is closed. This allows to pass extra parameters to a transitive closure computation. For example, to compute not only the transitive closure, but also the distance from the root of each visited graph node, specify the following transition function:

```
create function arcstod(Integer node, Integer d) -> Bag of (Integer,Integer)
  as select arcsto(node),1+d;
```
and call
```
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
Notice that only the first argument and result in the transition function define graph vertices, while the remaining arguments and results are extra parameters for passing information through the traversal, as with `arcstod()`. Notice that there may be no more than three extra parameters in a transition function.

### 2.6.7 Iteration

The function `iterate()` applies a function `fn()` repeadely. Signature:
```
iterate(Function fn, Number maxdepth, Object x) -> Object r
```
The iteration is initialized by setting x0=x. Then xi+1= fn(xi) is repeadedly computed until one of the following conditions hold:
1. there is no change (xi = xi+1), or
2. fn() returns nil (xi+1 = nil), or
3. an upper limit  maxdepth of the number of iterations is reached for xi.

There is another overloaded variant of `iterate()` that accepts an extra parameter `p` passed into `fn(xi,p)` in the iterations. Signature:
```
iterate(Function fn, Number maxdepth, Object x0, Object p) -> Object r
```
This enables flexible termination of the iteration since `fn(x,p)` can return `nil` based on both `x` and `p`.

## Abstract functions

Sometimes there is a need to have a function defined for subtypes of a common supertype, but the function should never be used for the supertype itself. For example, one may have a common supertype `Dog` with two subtypes `Beagle` and `Poodle`. One would like to have the function bark defined for different kinds of dogs, but not for dogs in general. In this case one defines the bark function for type Dog as an abstract function, for example:
```
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
Now you can use bark() as a function over dogs in general, but only if the object is a subtype of Dog:

```
Amos 15> select bark(d) from dog d;
"arf arf"
"yip yip"
```

An abstract function is defined by:
```
create function foo(...)->... as foreign 'abstract-function'.
```
An abstract functions are implemented as a foreign function whose implementation is named `abstract-function`. If an abstract function is called it gives an informative error message. For example, if one tries to call `bark()` for an object of type Dog, the following error message is printed:
```
Amos 16> create Dog instances :buggy;
NIL
Amos 17> bark(:buggy);
BARK(DOG)->CHARSTRING
is an abstract function requiring a more specific argument signature than
 (DOG) for arguments
 (#[OID 1009])
```
## Deleting functions

Functions are deleted with the delete function statement. Syntax:
```
delete-function-stmt ::= 'delete function' function-name
```
For example:
```
delete function married;
```
Deleting a function also deletes all functions calling the deleted function.
