# User update procedures

It is possible to register user defined *user update procedures* for any function. The user update procedures are [procedural functions](#procedures) which are transparently invoked when update statements are executed for the function.

    
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
