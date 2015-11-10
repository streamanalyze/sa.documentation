# Procedural functions


A *procedural function* is an sa.amos function defined as a sequence of AmosQL statements that may have side effects (e.g. database update statements). Procedural functions may iteratively return elements of a result bag by using a [return](#result) statement. Each time *return* is executed another result element is emitted from the function. Procedural functions should be avoided in queries since procedural functions may change the data, and since the execution order of function calls in queries is undefined.  Most, but not all, AmosQL statements are allowed in procedure bodies as can be seen by the syntax below.

Syntax:

```
procedural-function-definition ::=
        block | procedure-stmt

    procedure-stmt ::=
        create-object-stmt |
        delete-object-stmt |
        for-each-stmt |
        update-stmt |
        add-type-stmt |
        remove-type-stmt |
        set-local-variable-stmt |
        query |
        if-stmt |
        commit-stmt |
        abort-stmt |
        loop-stmt |
        while-stmt |
        open-cursor-stmt |
        fetch-cursor-stmt |
        close-cursor-stmt

    block ::=  
        'begin'
               ['declare' variable-declaration-commalist ';']
               procedure-stmt-semicolonlist
        'end'        

    return-stmt ::=
        'return' expr

    for-each-stmt ::=
        'for each' [for-each-option] variable-declaration-commalist
                   [where-clause] for-each-body

    for-each-option ::= 'distinct' | 'copy'

    for-each-body ::= procedure-body

    if-stmt ::=
        'if' expr
        'then' procedure-body
        ['else' procedure-body]

     set-local-variable-stmt ::=
        'set' local-variable '=' expr

    while-stmt ::=
        'while' expr 'do' procedure-stmt-semicolonlist 'end while'

    loop-stmt ::=
        'loop' procedure-stmt-semicolonlist 'end loop'

    leave-stmt ::=
        'leave'
```

For example, the procedural function `creperson()` creates a new person and sets the properties `name()` and `income()`, i.e. it is a *constructor* for persons: 

```sql
create function creperson(Charstring nm,Integer inc) -> Person p
               as
               begin
                 create Person instances p;
                 set name(p)=nm;
                 set income(p)=inc;
                 return p;
               end;

set :p = creperson('Karl',3500);
```

The procedural function `makestudent()` makes a person a student and sets the student's `score()` property:

```
create function makestudent(Object o,Integer sc) -> Boolean
  as add type Student(score) to o (sc);
```

Call:

```
makestudent(:p,30);
```

The function `flatten_incomes()` updates the incomes of all persons having higher income than a threshold value:

```
create function flatten_incomes(Integer threshold) -> Boolean
   as for each Person p
         where income(p) > threshold
         set income(p) = income(p) -
             (income(p) - threshold) / 2;
```
Call:

```
 flatten_incomes(1000);
```

The function `sumb2()` multiplies the elements of two bags:

```
create function sumb2(Bag of Number b1, Bag of Number b2) -> Number
   as begin declare Number r, Number x1, Number x2,
                    Scan c1, Scan c2;
      open c1 for b1;
      open c2 for b2;
      set r = 0;
      while more(c1) and more(c2)
       do fetch c1 into x1;
          fetch c2 into x2;
          set r = r + x1*x2;
          return r;
      end while;
      end;
```
Call:

```
sumb2(iota(1,10),iota(10,20));
```

 `sumb2()` illustrates the use of [while statements](#while-stmt) in procedural functions to iterate over several [scans](#cursors) simultaneously.

Queries and updates embedded in procedure bodies are optimized at compile time. The compiler saves the optimized query plans in the database so that dynamic query optimization is not needed when procedural functions are executed.

A procedural function may return a bag of result values iteratively by executing the [return statement](#result) several times in a procedural function returning a bag. Every time the return statement is executed an element of the result bag is emitted from the function. The return statement does not not abort the control flow (different from, e.g., *return* in C), but it only specifies that a value is to be emitted to the result bag of the function and then the procedure evaluation is continued as usual. For example:

```
create function myiota(Number l, Number u) -> Bag of Integer
  as begin declare Integer r;
     set r = l;
     while r <= u
     do return r;
        set r = r + 1;
     end while;
     end;
```

Call:

```
myiota(3,5);
```
returns:
```
3
4
5
```

Notice that [scans](#cursors) can be used for iterating over functions producing very large bags by many executions of the return statement. For example:

```
open :c for myiota(1,10000000);
fetch :c;
fetch :c;
```

If the return statement is never called in a procedural function, the result of the procedural function is empty. If a procedural function is used for its side effects only, not returning any value, the result type *Boolean* can be specified.