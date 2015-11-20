# Defining types

The `create type` statement creates a new type stored in the database.

Syntax:
```
create-type-stmt ::=
      'create type' type-name ['under' type-name-commalist]

                    ['properties' '(' attr-function-commalist ')']

type-spec ::= 
      type-name | 'Bag of' type-spec | 'Vector of' type-spec

type-name ::= identifier

attr-function ::= 
      generic-function-name type-spec ['key']

generic-function-name ::= identifier
```
Examples:
```
   create type Course properties
   (name Charstring key);

   create type Person properties
   (name Charstring key,
    income Number,
    parents Bag of Person);

   create type Student under Person properties
   (courses Bag of Course);
```

Type names are **not** case sensitive and the type names are always
internally *upper-cased*. For clarity all type names used in examples
in this manual have the first letter capitalized. Type names must be
unique in the database.

The `attr-function-commalist` clause is optional, and provides a way
to define properties of the new type, for example:

Each property is a [function](#function-definitions) having a single
argument and a single result. The argument type of a property function
is the type being created and the result type is specified by the
`type-spec`. The result type must be previously defined. In the above
example the function `name()` has argument type `Person` and result
type `Charstring`, i.e. signatures `name(Person)->Charstring` and
`income(Person)->Number`, respectively.

The new type will be a subtype of all the supertypes in the under
clause. For example, after executing the following statement type
`Student` is subtype of type `Person` and type `Person` is supertype
of type `Student`:

```
   create type Student under Person;
```

If no supertypes are specified the new type becomes a subtype of the
system type named `Userobject`.

If *key* is specified for a property, it indicates that each value of
the attribute is unique and the system will raise an error if this
[uniqueness is violated](#cardinality-constraints). In the following
example, two objects of type `Employee` cannot have the same value of
property `emp_no`:

```
   create type Employee under Person properties
          (emp_no Number key);
```

*Multiple inheritance* is defined by specifying more than one
supertype, for example:

```
create type TA under Student, Employee;
```

## Deleting types

The `delete type` statement deletes a type and all its subtypes.

Syntax:
```
delete-type-stmt ::= 'delete type' type-name
```
Example:
```
   delete type Employee;
```

If the deleted type has subtypes they will be deleted as well. Functions
using the deleted types will be deleted as well, in this case
`emp_no()`.
