# Scans

Scans provide a way to iterate over a very large result of a query, a
function call, variable value, or any expression, without explicitly
saving the result in memory. The `open` statement opens a new scan on
the result of an expression. A *scan* is a data structure holding a a
*cursor* to the current element in a scan of a potentially very large
bag of values returned from a query, function call, or variable
binding. An element can be any kind of object.

The next element in a scan is retrieved by the `fetch`
statement. Every time a fetch cursor statement is executed the cursor
is moved forward to the next element in the scan. If the end of the
scan is reached the `fetch` statement returns no more result.

Syntax:
```
open-stmt ::=
      'open' variable 'for' expr;

fetch-stmt ::=
      'fetch' cursor-name ['into' variable-commalist]

close-stmt ::=
      'close' cursor-name
```
Example:
```sql
   create person (name,age) instances :Viola ('Viola',38);  
   open :c1  for (select p, age(p) from Person p where name(p) = 'Viola');
   fetch :c1 into :vo, :a;  
```
The result from calling `name(:vo);` is `"Viola"` and the value of
`:a` is 38.

The optional `into` clause binds elements of the current element in
the scan to one or several variables. If no `into` is present the row
is displayed on standard output. If the element is a tuple several
variables can be bound as in the example.

The `close` statement deallocates the scan. 

Example:
```sql
   set :b = (select iota(1,1000000)+iota(1,1000000));    
   /* :b contains a bag with 10**12 elements! */
   open :c for :b;
   fetch :c; /* displays 2 */
   fetch :c; /* displays 3 */
   close :c; /* closes the scan */
```

Cursors are implemented using a special datatype called `Scan` that
allows iterating over very large bags of tuples. The following
functions are available for accessing the tuples in a scan as vectors:

The user can test whether there is any more elements in a scan by
calling one of the following functions:
```
   more(Scan s)   -> Boolean
   nomore(Scan s) -> Boolean
```
They test whether the scan is has more rows or not, respectively.

The following function moves the cursor forward and returns the next scan
element:
```
   next(Scan s)->Vector
```
The `fetch` statement calls `next()` internally.

```
this(Scan s)->Vector
```
returns the current row in a scan without moving the cursor forward.

```
peek(Scan s)->Vector
```
returns the next row in a scan without moving the cursor forward.
