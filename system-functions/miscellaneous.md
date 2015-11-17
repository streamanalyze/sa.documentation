# Miscellaneous
```
apply(Function fn, Vector args) -> Bag of Vector r
```
calls the AmosQL function fn with elements in vector args as arguments and returns the result tuples as vectors r.
```
evalv(Charstring stmt) -> Bag of Vector r
```
evaluates the AmosQL statement  stmt and returns the result tuples as vectors r.
```
error(Charstring msg) -> Boolean
```
prints an error message on the terminal and raises an exception. Transaction aborted.
```
print(Object x) -> Boolean
```
prints x. Always returns true. The printing is by default to the standard output (console) of the sa.amos server where print() is executed but can be redirected to a file by the function openwritefile:
```
openwritefile(Charstring filename)->Boolean
```
`openwritefile()` changes the output stream for `print()` to the specified filename. The file is closed and output directed to standard output by calling `closewritefile()`.
```
filedate(Charstring file) -> Date
```
returns the time for modification or creation of a file.
```
amos_version() -> Charstring
```
returns string identifying the current version of sa.amos.
```
quit;
```
quits sa.amos. If the system is registered as a peer it will be removed from the name server.
```
exit;
```
returns to the program that called sa.amos if the system is embedded in some other system.
```
goovi();
```
starts the multi-database browser GOOVI[^CR01]. This works only under JavaAmos. The redirect statement reads AmosQL statements from a file:
```
redirect-stmt ::= '<' string-constant
```
For example
```
< 'person.amosql';
```
```
load_amosql(Charstring filename)->Charstring
```
loads a file containing AmosQL statements as the redirect statement.
```
loadSystem(Charstring dir, Charstring filename)->Charstring
```
loads a master file, filename, containing an AmosQL script defining a subsystem. The current directory is temporarily set to dir while loading. The file is not loaded if it was previously loaded into the database. To see what master files are currently loaded, call `loadedSystems()`.
```
getenv(Charstring var)->Charstring value
```
retrieves the value of OS environment variable var. Generates an error of variable not set.

The `trace()` and `untrace()` functions are used for tracing foreign function calls:
```
trace(Function fno)->Bag of Function r
trace(Charstring fn)->Bag of Function r
untrace(Function fno)->Bag of Function r
untrace(Charstring fn)->Bag of Function r
```
If an overloaded functions is (un)traced it means that all its resolvents are (un)traced. Results are the foreign functions (un)traced. For example:
```
Amos 2> trace("iota ");
#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]
Amos 2> iota(1,3);
>>#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 *)
<<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 1)
1
<<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 2)
2
<<#[OID 116 "INTEGER.INTEGER.IOTA->INTEGER "]#(1 3 3)
3
```
```
dp(Object x, Number priority)-> Boolean
```
For debug printing in where clauses. Prints x on the console. Always returns true. The placement of dp in the execution plan is regulated with priority which must be positive numeric constant. The higher priority the earlier in the execution plan.
