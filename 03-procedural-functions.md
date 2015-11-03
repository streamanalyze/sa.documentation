## 3 Procedural functions


A *procedural function* is an
Amos II function defined as a sequence of AmosQL statements that may
have side effects (e.g. database update statements). Procedural
functions may iteratively return elements of a result bag by using a
[return](#result) statement. Each time *return* is executed another
result element is emitted from the function. Procedural functions should be
avoided in queries since procedural functions may change the
data, and since the execution order of function calls in queries is
undefined.  Most, but not all, AmosQL statements are allowed in
procedure bodies as can be seen by the syntax below.

Syntax: 

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




For example, the procedural function *creperson()* creates a new person
and sets the properties *name()* and *income()*, i.e. it is a
*constructor* for persons: 

     create function creperson(Charstring nm,Integer inc) -> Person p 

                    as 

                    begin 

                      create Person instances p; 

                      set name(p)=nm; 

                      set income(p)=inc; 

                      return p; 

                    end;



     set :p = creperson('Karl',3500);




<span style="font-family: Times New Roman;">The procedural function
*makestudent()* makes a person a student and sets the student's
*score()* property:\
\
 </span> <span style="font-family: Times New Roman;"> <span
style="font-family: Times New Roman;"></span>
`create function makestudent(Object o,Integer sc) -> Boolean `
`            ` `  as add type Student(score) to o (sc); `
`            `\
 Call: `            ` ` makestudent(:p,30); `\
\
 The function *flatten\_incomes()* updates the incomes of all persons
having higher income than a threshold value:\
\
 ` create function flatten_incomes(Integer threshold) -> Boolean      `
`            `
`    as for each Person p                  where income(p) > threshold `
`            ` `          set income(p) = income(p) - ` `            `
`              (income(p) - threshold) / 2;`\
 Call:\
 ` flatten_incomes(1000);`\
\
 The function *sumb2()* multiplies the elements of two bags:\
\
 `            `
`create function sumb2(Bag of Number b1, Bag of Number b2) -> Number`
`            `
`   as begin declare Number r, Number x1, Number x2,                            Scan c1, Scan c2;`
`            ` `      open c1 for b1;` `            `
`      open c2 for b2;` `            ` `      set r = 0;` `            `
`      while more(c1) and more(c2)     ` `            `
`       do fetch c1 into x1;` `            `
`          fetch c2 into x2;` `            `
`          set r = r + x1*x2;` `            ` `          return r;`
`            ` `      end while;` `            ` `      end;`\
 Call:\
 `sumb2(` `iota` `(1,10),iota(10,20));`\
\
 *sumb2()* illustrates the use of [while statements](#while-stmt) in
procedural functions to iterate over several [scans](#cursors)
simultaneously.\
\
 Queries and updates embedded in procedure bodies are optimized at
compile time. The compiler saves the optimized query plans in the
database so that dynamic query optimization is not needed when
procedural functions are executed. \
\
 </span> <span style="font-weight: bold;"></span>A procedural function
may return a bag of result values iteratively by executing the [return
statement](#result) several times in a procedural function returning a
bag. Every time the return statement is executed an element of the
result bag <span style="font-family:
      monospace;"></span> is emitted from the function.  <span
style="font-family: Times New Roman;">The return statement does not not
abort the control flow (different from, e.g., *return* in C), but it
only specifies that a value is to be emitted to the result bag of the
function and then the procedure evaluation is continued as usual. 
</span>For example,\

`      create function myiota(Number l, Number u) -> Bag of Integer        as begin declare Integer r;           set r = l;           while r <= u           do return r;              set r = r + 1;           end while;           end;        `Call:\
 `myiota(3,5)` `;`\
 returns\
 `3` `        ` `4` `        ` `5`\
\
 Notice that [scans](#cursors) can be used for iterating over functions
producing very large bags by many executions of the return statement.
For example:\
 `open :c for myiota(1,10000000);` `        ` `fetch :c;` `        `
`fetch :c;`\
 etc.\
\
 If the return statement [<span style="font-family:
        Times New Roman;"></span>](#result) is never called in a
procedural function, the result of the procedural function is empty. If
a procedural function is used for its side effects only, not returning
any value, the result type *Boolean* can be specified.\
 <span style="font-family: Times New Roman;"> </span>

3.1 Iterating over results\
---------------------------

The [for-each statement](#for-each) statement iterates over the result
of a query by executing the [for-each body](#for-each-body) for each
result variable binding of the query. For example the following
procedural function adds *inc* to the incomes of all persons with
salaries higher than *limit* and returns their *old* incomes: 

    create function increase_incomes(Integer inc,Integer thres)

                                   -> Integer oldinc 

      as for each Person p, Integer i 

            where i > thres

              and i = income(p) 

         begin 

           return i; 

           set income(p) = i + inc 

         end;

The for-each statement does not return any value at all unless a
*return* statement is called within its body as in
*increase\_incomes()*.  \
\
 The [for-each option](#for-each-option) specifies how to treat the
result of the query iterated over. If it is omitted the system default
is to iterate directly over the result of the query while immediately
applying the [for-each body](#for-each-body) on each retrieved element.\
\
 If *distinct* is specified in a for-each statement the iteration is
over a copy where duplicates in addition have been removed.\
\
 If  *copy* is specified the code is applied on a copy of the result of
the query. This options may be needed if the body updates the same
collections as it is iterating over.\
\
 <span style="font-weight: bold;">Notice</span> that scans can be used
as an alternative to the [for-each statement](#foreach-statement) for
iterating over the result of a bag. However, the for-each statement is
faster than iterating with cursors, but it cannot be used for
simultaneously iterating over several bags such as is done by the 
[sumb2()](#sumb2). <span style="font-family: Times New Roman;"></span>
<span style="font-family: Times New Roman;"></span>

3.2 User update procedures
--------------------------

It is possible to register user defined *user update procedures* for any
function. The user update procedures are [procedural
functions](#procedures) which are transparently invoked when update
statements are executed for the function.

    
`set_addfunction(Function f, Function up)->Boolean            set_remfunction(Function f, Function up)->Boolean            set_setfunction(Function f, Function up)->Boolean                `\
 The function *f* is the function for which we wish to declare a user
update function and *up* ** is the actual update procedure. The
arguments of a user update procedures is the concatenation of argument
and result tuples of  *f*. For example, assume we have a function\

<span style="font-family: monospace;">  create function
netincome(Employee e) -&gt; Number\
     as income(e)-taxes(e);</span>\

Then we can define the following user update procedure:\

<span style="font-family: monospace;">create function
set\_netincome(Employee e, Number i) -&gt; Boolean\
   as begin\
      set taxes(e)= i\*taxes(e)/income(e) + taxes(e);\
      set income(e) = i\*(1-taxes(e))/income(e) +\
                      income(e);\
      end;\
 </span>

The following declaration makes *netincome()* <span
style="font-family: monospace;"> </span>updatable with the [set<span
style="font-family: monospace;"></span>](#updates) statement:\

<span style="font-family: monospace;"> 
set\_setfunction([\#'employee.netincome-&gt;number'](#functional-constant),\
                   \#'employee.number-&gt;boolean');\
 </span>

Now one can update *netincome()* with, e.g.:\

<span style="font-family: monospace;">   set netincome(p)=32000\
   from Person p\
  where name(p)="Tore";</span> <span style="font-family: Times
      New Roman;"> </span>
