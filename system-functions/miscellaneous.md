# Miscellaneous

String identifying the current version of sa.amos:
```
amos_version() -> Charstring
```

Quit sa.amos: 
```
   quit;
```
If the system is registered as a peer it will be removed from the name server.

Return to the program that called sa.amos if the system is embedded in some other system:
```
   exit;
```

Start the database browser GOOVI[^CR01].
```
   goovi();
```

The redirect statement reads AmosQL statements from a file:
```
redirect-stmt ::= '<' string-constant
```
Example
```
   < 'person.amosql';
```

Load a file containing AmosQL statements as the redirect statement:
```
   load_amosql(Charstring filename)->Charstring
```

loads a master file, filename, containing an AmosQL script defining a
subsystem:
```
   loadSystem(Charstring dir, Charstring filename)->Charstring
```
The current directory is temporarily set to dir while
loading. The file is not loaded if it was previously loaded into the
database. To see what master files are currently loaded, call:
```
   loadedSystems() -> Bag of Charstring
```

The value of OS environment variable `var`. 
```
   getenv(Charstring var)->Charstring value
```
Generates an error of variable not set.

Print an error message `msg` on the console and raises an exception:
```
   error(Charstring msg) -> Boolean
```

Print object `x` on console:
```
   print(Object x) -> Boolean
```
`print()` always returns true. The printing is by default to the standard output (console) of the sa.amos server where print() is executed but can be redirected to a file by the function `openwritefile()`:
```
   openwritefile(Charstring filename) -> Boolean
```
`openwritefile()` changes the output stream for `print()` to the specified filename. The file is closed and output directed to standard output by calling `closewritefile()`.

The time for modification or creation of a file:
```
   filedate(Charstring file) -> Date
```

Call the function `fn` with elements in vector `args` as arguments:
```
   apply(Function fn, Vector args) -> Bag of Vector r
```
The result is a bag of tuples represented as vectors `r`.

Evaluate the AmosQL statement `stmt` and return the result tuples as tuples represented as vectors `r`:
```
   evalv(Charstring stmt) -> Bag of Vector r
```

The `trace()` and `untrace()` functions are used for tracing foreign function calls:
```
   trace(Function fno)->Bag of Function r
   trace(Charstring fn)->Bag of Function r
   untrace(Function fno)->Bag of Function r
   untrace(Charstring fn)->Bag of Function r
```
If an overloaded functions is (un)traced it means that all its resolvents are (un)traced. Results are the foreign functions (un)traced. 
