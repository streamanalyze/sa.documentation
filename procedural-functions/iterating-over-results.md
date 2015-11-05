# Iterating over results

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
