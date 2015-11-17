# Searching source code

The source codes of all functions except some basic system functions are stored in the database. You can retrieve the source code for a particular function, search for functions whose names contain some string, or make searches based on the source code itself. Some system functions are available to do this.
```
apropos(Charstring str) -> Bag of Function
```
returns all functions in the system whose names contains the string str. Only the generic name of the function is used in the search. The string is not case sensitive. For example:
```
apropos("qrt ");
```    
returns all functions whose generic name contains `qrt`.
```
doc(Charstring str) -> Bag of Charstring
```
returns the available documentations of all functions in the system whose names contain the (non case sensitive) string str. For example:
```
doc("qrt ");
sourcecode(Function f) -> Bag of Charstring
sourcecode(Charstring fname) -> Bag of Charstring
```
returns the source code of a function `f`, if available. For generic functions the sources of all resolvents are returned. For example:
```
sourcecode("sqrt ");
```
To find all functions whose definitions contain the string `tclose` use:
```
select sc
from Function f, Charstring sc
where like_i(sc,"*tclose* ") and source_text(f)=sc;
```
```
usedwhere(Function f) -> Bag of Function c
```
returns the functions calling the function `f`.
```
useswhich(Function f) -> Bag of Function c
```
returns the functions called from the function `f`.
```
userfunctions() -> Bag of Function
```
returns all user defined functions in the database.
```
usertypes() -> Bag of Type
```
returns all user defined types in the database.
```
allfunctions(Type t)-> Bag of Function
```
returns all functions where one of the arguments are of type `t`.
