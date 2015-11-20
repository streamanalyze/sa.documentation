# Updates

Information stored in the database represent mappings between function
arguments and results. These mappings are either defined at object
creation time or altered by one of the function update
statements: `set`, `add`, or `remove`. The extent of a function is the bag
of tuples mapping its arguments to corresponding results. Updating a
stored function means updating its extent.

Syntax:
```
update-stmt ::=
      update-op update-item [from-clause] [where-clause]

update-op ::=
      'set' | 'add' | 'remove'

update-item ::=
      function-name '(' expr-commalist ')' '=' expr
```

The `set` statement sets the value of an updatable function given the
arguments.

For example, assume we have defined the following functions:
```sql
   create function name(Person) -> Charstring as stored;
   create function hobbies(Person) -> Bag of Charstring as stored;
```
Furthermore, assume we have created two objects of type `Person` bound
to the interface variables `:sam` and `:eve`:
```sql
   create Person instances :sam, :eve;
```
To set the names of the two persons, do:

```sql
   set name(:sam) = "Sam";
   set name(:eve) = "Eve";
```

To populate a bag valued function you can use [bag construction:](#Bags)

```sql
   set hobbies(:eve) = bag("Camping","Diving");
```

The `add` statement adds a result object to a bag valued function. 

For example, to make Sam have the hobbies sailing and fishing, do:
```sql
   add hobbies(:sam) = "Sailing";
   add hobbies(:sam) = "Fishing";
```

The `remove` statement removes the specified tuple(s) from the result
of an updatable bag valued function.

Example:
```sql
   remove hobbies(:sam) = "Fishing";
```

The statement
```sql
   set hobbies(:eve) = hobbies(:sam);
```
will update Eve's all hobbies to be the same a Sam's hobbies.

Several object properties can be assigned by queries in update
statements. 

For example, to make Eve have the same hobbies as Sam except sailing,
do:
```sql
   set hobbies(:eve) = h
  from Charstring h
 where h in hobbies(:sam) 
   and h != "Sailing";
```
Here a query first retrieves all hobbies `h` of `:sam` before the
hobbies of `:eve` are set.

A boolean function can be set to either `true` or `false`.

Example:
```sql
   create function married(Person,Person) -> Boolean as stored;

   set married(:sam,:eve) = true;
```

Setting the value of a boolean function to false means that the truth
value is removed from the extent of the function. 

For example, to divorce Sam and Eve you can do either of the
following:
```sql
   set married(:sam,:eve)=false;
```
alternatively
```sql
   remove married(:sam) = :eve;
```

Not every function is updatable. A function is updatable if it is a
stored function, or if it is derived from a single updatable function
with a join that includes all arguments. In particular inverses to
stored functions are updatable.

For example, the following function is updatable:
```sql
   create function marriedto(Person p) -> Person q
     as select q where married(p,q);
```

The user can define [update procedures](#user-update-functions) for
derived functions making also non-updatable functions updatable.

The *multiple assignment statement* assigns several variables to the result of a tuple valued query.

Example:
```
   set (:mother,:father) = parents2(:eve);
```

You can store [records](#records) in stored functions.

Example:
```sql
   create function pdata(Person) -> Record
     as stored;
   create Person(pdata) instances 
   ({'Greeting':'Hello, I am Tore',
        'Email':'Tore.Andersson@it.uu.se'});
```
The query:
```sql
   select r['Greeting']
     from Person p, Record r
    where name(p)='Tore'
      and pdata(p)=r;
```
will return the string `"Hello, I am Tore"`.

## Cardinality constraints

A *cardinality constraint* is a system maintained restriction on the
number of allowed occurrences in the database of an argument or result
of a [stored function](#stored-function). For example, a cardinality
constraint can be that there is at most one salary per person, while a
person may have any number of children. The cardinality constraints
are normally specified by function signatures.

For example, the following restricts each person to have one salary
while many children are allowed:
```sql
   create function salary(Person p) -> Charstring nm
     as stored;
   create function children(Person p) -> Bag of Person
     as stored;
```

The system prohibits database updates that violate the cardinality
constraints. For the function `salary()` an error is raised if one
tries to make a person have two salaries when updating it with the `add`
statement, while there is no such restriction on `children()`. If the
cardinality constraint is violated by a database update the following
error message is printed:
```
Update would violate upper object participation (updating function ...)
```

In general one can maintain four kinds of cardinality constraints for
a function modeling a relationship between types, *many-one*,
*many-many*,*one-one*, and *one-many*:

*many-one* is the default when defining a stored function as in
`salary()`.

*many-many* is specified by prefixing the result type specification
with `Bag of` as in `children()`. In this case there is no cardinality
constraint enforced.

*one-one* is specified by suffixing a result variable with `key`. 

Example:
```sql
   create function name(Person p) -> Charstring nm key
     as stored;
```
will guarantee that a person's name is unique.

*one-many* is normally represented by an inverse function with
cardinality constraint *many-one*. 

For example, suppose we want to represent a *one-many* relationship
between types Department and Employee, i.e. there can be many
employees for a given department but only one department for a given
employee. The recommended way is to define the function `department()`
enforcing a *many-one* constraint between employees as departments:
```sql
   create function department(Employee e) -> Department d
     as stored;
```

The inverse function can then be defined as a derived function:
```sql
   create function employees(Department d) -> Bag of Employee e
     as select e 
         where department(e) = d;
```

Since inverse functions are [updatable](#updates) the function
`employees()` is also updatable and can be used when
[populating](#create-object)the database.

Any variable in a stored function can be specified as key, which will
restrict the updates the stored functions to maintain key uniqueness
for the argument or result of the stored function. 

Cardinality constraints can also be specified for foreign functions,
which is important for optimizing queries involving foreign
functions. However, it is up to the foreign function implementer to
guarantee that specified cardinality constraints hold.

## Changing object types

The `add-type-stmt` changes the type of one or more objects to the
specified type.

Syntax:
```
add-type-stmt ::=
      'add type' type-name ['(' [generic-function-name-commalist] ')'] 'to' variable-commalist
```

The updated objects may be assigned initial values for all the
specified property functions in the same manner as in the `create
object` statement. The `remove type` statement makes one or more
objects no longer belong to the specified type.

Syntax:
```
remove-type-stmt ::=
      'remove type' type-name 'from' variable-commalist
```

Removing a type from an object may also remove properties from the
object. If all user defined types have been removed from an objects,
the object will still be member of type Userobject.

## Dynamic updates

Sometimes it is necessary to be able to create objects whose types are
not known until runtime. Similarly one may wish to update functions
without knowing the name of the function until runtime. For this there
are the following system procedural system functions:

```
   createobject(Type t)->Object
   createobject(Charstring tpe)->Object
   deleteobject(Object o)->Boolean
   addfunction(Function f, Vector argl, Vector resl)->Boolean
   remfunction(Function f, Vector argl, Vector resl)->Boolean
   setfunction(Function f, Vector argl, Vector resl)->Boolean
```

The function `createobject()` creates an object of the type specified
by its argument.

The function `deleteobject()` deletes an object.

The functions `setfunction()`, `addfunction()`, and `remfunction()`
update a function given an argument list and a result tuple as
vectors. They return true if the update succeeded.

To delete all rows in a stored function `fn`, use:
```
   dropfunction(Function fn, Integer permanent)->Function
```
If the parameter `permanent` is the number one the deletion cannot be
rolled back, which saves space if the extent of the function is large.
