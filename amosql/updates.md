# Updates

Information stored in sa.amos represent mappings between function
arguments and results. These mappings are either defined at object
creation time ([Objects](#create-object)), or altered by one of the
function *update statements:* *set*, *add*, or *remove*. The 
[extent](#function-extent)  of a function is the bag of tuples mapping
its arguments to corresponding results. Updating a stored function means
updating its extent.

Syntax:

    update-stmt ::=

            update-op update-item [from-clause] [where-clause] 



    update-op ::= 

            'set' | 'add' | 'remove' 



    update-item ::= 

            function-name '(' expr-commalist ')' '=' expr

\
 For example, assume we have defined the following functions:\

        create function name(Person) -> Charstring as stored;

     create function hobbies(Person) -> Bag of Charstring as stored;

Furthermore, assume we have created two objects of type <span
style="font-style: italic;">Person</span> bound to the interface
variables <span style="font-style: italic;">:sam</span> and <span
style="font-style: italic;">:eve</span>:\

        create Person instances :sam, :eve;

The <span style="font-style: italic;">set </span>statement sets the
value of an updatable function given the arguments.\
 For example, to set the names of the two persons, do:\

        set name(:sam) = "Sam";

     set name(:eve) = "Eve";

<span style="font-family: monospace;"> </span>To populate a bag valued
function you can use [bag construction:](#Bags)\

    set hobbies(:eve) = bag("Camping","Diving");

The <span style="font-style: italic;">add </span>statement adds a result
object to a bag valued function.\
 For example, to make Sam have the hobbies sailing and fishing, do:\

        add hobbies(:sam) = "Sailing";

     add hobbies(:sam) = "Fishing";

The <span style="font-style: italic;">remove </span>statement removes
the specified tuple(s) from the result of an updatable bag valued
function, for example:\

        remove hobbies(:sam) = "Fishing";

The statement\

        set hobbies(:eve) = hobbies(:sam);

will update Eve's all hobbies to be the same a Sam's hobbies.\
\
 Several object properties can be assigned by queries in update <span
style="font-style: italic;"></span> statements. For example, to make Eve
have the same hobbies as Sam except sailing, do:\

        set hobbies(:eve) = h

     from Charstring h

     where h in hobbies(:sam) and

     h != "Sailing";

 <span
style="font-family: monospace;"></span>Here a query first retrieves all
hobbies *h* of *:sam* before the hobbies of *:eve* are set.\
\
 A boolean function can be set to either <span style="font-style:
      italic;">true</span> or <span
style="font-style: italic;">false</span>.\

        create function married(Person,Person)->Boolean as stored;

     set married(:sam,:eve) = true;

Setting the value of a boolean function to <span style="font-style:
      italic;">false</span> means that the truth value is removed from
the extent of the function. For example, to divorce Sam and Eve you can
do either of the following:\

        set married(:sam,:eve)=false;




 or

        remove married(:sam) = :eve;

Not every function is updatable. sa.amos defines a function to be
updatable if it is a stored function, or if it is derived from a single
updatable function with a join that includes all arguments. In
particular inverses to stored functions are updatable. For example, the
following function is updatable:\

        create function marriedto(Person p) -> Person q

     as select q where married(p,q);

The user can define [update procedures](#user-update-functions) for
derived functions making also non-updatable functions updatable.\

### 2.7.1 Cardinality constraints

A *cardinality constraint* is a system maintained restriction on the
number of allowed occurrences in the database of an argument or result
of a [stored function](#stored-function). For example, a cardinality
constraint can be that there is at most one salary per person, while a
person may have any number of children. The cardinality constraints are
normally specified by the result part of a stored function's signature.\
\
 For example, the following restricts each person to have one salary
while many children are allowed:\
\
 <span style="font-family: monospace;">   create function salary(Person
p) -&gt; Charstring nm\
      as stored;\
    create function children(Person p) -&gt; Bag of Person\
      as stored;\
 </span>\
 The system prohibits database updates that violate the cardinality
constraints.  For the function *salary()* an error is raised if one
tries to make a person have two salaries when updating it with the [add
statement](#updates), while there is no such restriction on *children()*
<span style="font-family:
      monospace;"></span>. If the cardinality constraint is violated by
a database update the following error message is printed:\
\
 <span style="font-family: monospace;">   Update would violate upper
object participation (updating function ...)</span>\
\
 In general one can maintain four kinds of cardinality constraints for a
function modeling a relationship between types, <span
style="font-style: italic;">many-one, many-many, one-one,</span> and
<span style="font-style: italic;">one-many</span>:\

-   <span style="font-style: italic;">many-one</span> is the default
    when defining a stored function as in *salary()* <span
    style="font-family: monospace;"></span>.\
    \
-   <span style="font-style: italic;">many-many</span> is specified by
    prefixing the result type specification with 'Bag of' as in
    *children()<span style="font-family:
                monospace;"></span>*. In this case there is no
    cardinality constraint enforced.\
    \
-   <span style="font-style: italic;">one-one</span> is specified by
    suffixing a result variable with ' <span
    style="font-family: monospace;">key</span>'\
     For example:\
     <span style="font-family: monospace;">   create function
    name(Person p) -&gt; Charstring nm key\
          as stored;\
     </span>will guarantee that a person's name is unique.\
    \
-   <span style="font-style: italic;">one-many</span> is normally
    represented by an inverse function with cardinality constraint
    *many-one*. For example, suppose we want to represent a one-many
    relationship between types *Department* ** and *Employee*, i.e.
    there can be many employees for a given department but only one
    department for a given employee. The recommended way is to define
    the function *department()* enforcing a many-one constraint between
    employees as departments:\
    \
     <span style="font-family: monospace;">  create function
    department(Employee e) -&gt; Department d\
         as stored;\
     </span>\
     The inverse function can then be defined as a derived function:\
    \
     <span style="font-family: monospace;">  create function
    employees(Department d) -&gt; Bag of Employee e</span>\
     <span style="font-family: monospace;">    as select e
    where department(e) = d;</span>\
    \
     Since inverse functions are [updatable](#updates) the function
    *employees()* is also updatable and can be used when
    [populating](#create-object)the database.\

Any variable in a stored function can be specified as <span
style="font-style: italic;">key</span>, which will restrict the updates
the stored functions to maintain key uniqueness for the argument or
result of the stored function. For example, the cardinality constraints
on the following function *distance()* <span
style="font-family: monospace;"> ** </span>prohibits more than one
distance between two cities:\
 <span style="font-family: monospace;"> \
   create function distance(City x key, City y  key) -&gt;  Integer d\
     as stored;</span>\
\
 Cardinality constraints can also be specified for [foreign
functions](#foreign-functions), which is important for optimizing
queries involving foreign functions. However, it is up to the foreign
function implementer to guarantee that specified cardinality constraints
hold.\

### 2.7.2 Changing object types\

The `add-type-stmt` changes the type of one or more objects to the
specified type.

Syntax:

    add-type-stmt ::=

            'add type' type-name ['(' [generic-function-name-commalist] ')'] 

            'to' variable-commalist

The updated objects may be assigned initial values for all the specified
property functions in the same manner as in the [create object
statement](#create-object).

The `remove-type-stmt` makes one or more objects no longer belong to the
specified type.\

Syntax:

    remove-type-stmt ::= 

            'remove type' type-name 'from' variable-commalist

Removing a type from an object may also remove properties from the
object.   If all user defined types have been removed from an objects,
the object will still be member of type *Userobject*.\

###

### 2.7.3 Dynamic updates

Sometimes it is necessary to be able to create objects whose types are
not known until runtime. Similarly one may wish to update functions
without knowing the name of the function until runtime. For this there
are the following system procedural system functions:

`createobject(Type t)->Object      createobject(Charstring tpe)->Object      deleteobject(Object o)->Boolean      addfunction(Function f, Vector argl, Vector resl)->Boolean      remfunction(Function f, Vector argl, Vector resl)->Boolean      setfunction(Function f, Vector argl, Vector resl)->Boolean        `\
 *createobject()* creates an object of the type specified by its
argument.

*deleteobject()* deletes an object.

The [procedural](#procedures) system functions *setfunction()*,
*addfunction()*, and *remfunction()* update a function given an argument
list and a result tuple as vectors. They return `TRUE` if the update
succeeded.\

To delete all rows in a stored function <span style="font-style:
        italic;">fn</span>, use\

    dropfunction(Function fn, Integer permanent)->Function

If the parameter <span style="font-style: italic;">permanent</span> is
the number one the deletion cannot be rolled back, which saves space if
the extent of the function is large.\
