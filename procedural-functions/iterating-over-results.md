# Iterating over results

The `for each` statement iterates over the result
of a query by executing the [for-each body](README.md) for each
result variable binding of the query. For example the following
procedural function adds *inc* to the incomes of all persons with
salaries higher than *limit* and returns their *old* incomes:

```sql
   create function increase_incomes(Integer inc,Integer thres) -> Integer oldinc
     as for each Person p, Integer i
           where i > thres
             and i = income(p)
            begin return i;
                  set income(p) = i + inc;
            end;
```

The `for each` statement does not return any value at all unless a
`return` statement is called within its body as in
`increase_incomes()`.

The [for-each-option](README.md) specifies how to treat the
result of the query iterated over. If it is omitted the system default
is to iterate directly over the result of the query while immediately
applying the `for-each-body` on each retrieved
element.

If `distinct` is specified in the for-each option the iteration is over
a copy where duplicates in addition have been removed.

If `copy` is specified the iteration is over a *copy* of the result of
the query. This options may be needed if the body updates the same
collections as it is iterating over. 

**Notice** that the `copy` options may cause memory overflow if the
bag iterated over is very large.

**Notice** that scans can be used as an alternative to the `for-each
statement` for iterating over the result of a
bag. However, the for-each statement is faster than iterating with
cursors, but it cannot be used for simultaneously iterating over
multiple bags such as is done by the [sumb2 function](README.md#multiple-scan).
