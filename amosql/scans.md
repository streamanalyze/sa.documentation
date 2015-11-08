# Scans

Scans provide a way to iterate over a very large result of a query, a function call, variable value, or any expression without explicitly saving the result in memory. The open-cursor-stmt opens a new scan on the result of an expression. A scan is a data structure holding a current element, the cursor, of a potentially very large bag of values produced by a query, function call, or variable binding. The next element in the bag is retrieved by the fetch cursor statement. Every time a fetch cursor statement is executed the cursor is moved forward over the bag. When the end of the scan is reached the fetch cursor statement returns empty result. The user can test whether there is any more elements in a scan by calling one of the functions.
```
more(Scan s)   -> Boolean
nomore(Scan s) -> Boolean
```
that test whether the scan is has more rows or not, respectively.

Syntax:
```
open-cursor-stmt ::=
  'open' cursor-name 'for' expr

cursor-name ::=
  variable

fetch-cursor-stmt ::=
  'fetch' cursor-name [into-clause]

close-cursor-stmt ::=
  'close' cursor-name
```

If the optional into clause is present in a fetch cursor statement, it will bind elements of the first result tuple to variables. There must be one variable for each element in the next cursor tuple. If no into clause is present in a fetch cursor statement a single result tuple is fetched and displayed.

For example:
```
create person (name,age) instances :Viola ('Viola',38);  
open :c1  for (select p from Person p where name(p) = 'Viola');       
fetch :c1 into :Viola1;  
close :c1;   
name(:Viola1);   
--> "Viola";
```

The close cursor statement deallocates the scan.
Cursors allow iteration over very large bags created by queries or function calls. For example:
```
set :b = (select iota(1,1000000)+iota(1,1000000));    
/* :b contains a bag with 10**12 elements! */

open :c for :b;

fetch :c;
-> 2

fetch :c;
-> 3

close :c;
```

Cursors are implemented using a special datatype called Scan that allows iterating over very large bags of tuples. The following functions are available for accessing the tuples in a scan as vectors:
```
next(Scan s)->Vector
```
moves the cursor to the next tuple in a scan and returns the cursor tuple. The fetch cursor statement is syntactic sugar for calling `next()`.
```
this(Scan s)->Vector
```
returns the current tuple in a scan without moving the cursor forward.
```
peek(Scan s)->Vector
```
returns the next tuple in a scan without moving the cursor forward.
