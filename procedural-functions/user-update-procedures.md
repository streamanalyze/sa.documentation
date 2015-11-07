# User update procedures

It is possible to register user defined *user update procedures* for any function. The user update procedures are [procedural functions](#procedures) which are transparently invoked when update statements are executed for the function.

```sql
set_addfunction(Function f, Function up)->Boolean
set_remfunction(Function f, Function up)->Boolean
set_setfunction(Function f, Function up)->Boolean
```

The function `f` is the function for which we wish to declare a user update function and `up` is the actual update procedure. The arguments of a user update procedures is the concatenation of argument and result tuples of `f`. For example, assume we have a function

```sql
create function netincome(Employee e) -> Number
  as income(e)-taxes(e);
```

Then we can define the following user update procedure:

```sql
create function set_netincome(Employee e, Number i) -> Boolean
  as begin
     set taxes(e)= i*taxes(e)/income(e) + taxes(e);
     set income(e) = i*(1-taxes(e))/income(e) +
                     income(e);
     end;
```

The following declaration makes `netincome()` updatable with the [set](#updates) statement:

```
set_setfunction(#'employee.netincome->number',
                #'employee.number->boolean');
```

Now one can update `netincome()` with, e.g.:

```
set netincome(p)=32000 
from Person p
where name(p)="Tore";
```
