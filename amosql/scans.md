# Scans

*Scans* provide a way to iterate over a very large result of a
[query](#query-statement), a [function call](#function-call), [variable
value](#variables), or any [expression](#expressions) without explicitly
saving the result in memory. The [open-cursor-stmt](#open-cursor) opens
a new <span style="font-style: italic;">scan</span> on the result of an
expression. A scan is a data structure holding a current element, the
<span style="font-style: italic;">cursor</span>, of a potentially very
large bag of values produced by a query, function call, or variable
binding. The next element in the bag is retrieved by the [fetch
cursor](#fetch-statement) statement. Every time a fetch cursor statement
<span style="font-family: Times New Roman;"> is executed the cursor is
moved forward over the bag. When the end of the scan is reached the
fetch cursor statement</span> <span style="font-family: Times
      New Roman;"> returns empty result. The user can test whether there
is any more elements in a scan by calling one of the functions\
 </span> <span style="font-family: monospace;">   more(Scan s)   -&gt;
Boolean\
    nomore(Scan s) -&gt; Boolean\
 </span> <span style="font-family: Times New Roman;">that test whether
the scan is has more rows or not, respectively. </span> <span
style="font-family: Times New Roman;">\
 </span>

Syntax:

          open-cursor-stmt ::=

            'open' cursor-name 'for' expr



    cursor-name ::= 

            variable 




          fetch-cursor-stmt ::= 

            'fetch' cursor-name [into-clause]




          close-cursor-stmt ::=

            'close' cursor-name

<span style="font-family: Times New Roman;">If the optional *into*
clause is present in a fetch cursor statement, it will bind elements of
the first result tuple to variables. There must be one variable for each
element in the next cursor tuple. <span
style="font-family: Times New Roman;"> </span></span>

If no *into* ** clause is
present in a fetch cursor statement a single result tuple is fetched and
displayed.

For example:

    create person (name,age) instances :Viola ('Viola',38);

    open :c1  for (select p from Person p where name(p) = 'Viola'); 

    fetch :c1 into :Viola1;

    close :c1; 

    name(:Viola1); 

    --> "Viola";



The [close cursor statement](#close-cursor) deallocates the scan.\

Cursors allow iteration over very large bags created by queries or
function calls. For example,\

    set :b = (select iota(1,1000000)+iota(1,1000000));

    /* :b contains a bag with 10**12 elements! */



    open :c for :b;

    fetch :c;

    -> 2

    fetch :c;

    -> 3

    etc.

    close :c;

<span style="font-family: Times New Roman;"></span> <span
style="font-family: Times New Roman;"> </span>

Cursors are implemented using a special datatype called <span
style="font-style: italic;">Scan</span> that allows iterating over very
large bags of tuples. The following functions are available for
accessing the tuples in a scan as vectors:\



<span style="font-family: monospace;">next(Scan s)-&gt;Vector</span>\
 moves the cursor to the next tuple in a scan and returns the cursor
tuple. The [fetch cursor statement](#fetch-statement) is syntactic sugar
for calling *next()*.\



<span style="font-family: monospace;">this(Scan s)-&gt;Vector</span>\
 returns the current tuple in a scan without moving the cursor forward.\

 <span
style="font-family: monospace;">peek(Scan s)-&gt;Vector</span>\


returns the next tuple in a scan without moving the cursor forward.\
