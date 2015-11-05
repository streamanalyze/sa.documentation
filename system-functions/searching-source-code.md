# Searching source code

The source codes of all functions except some basic system functions are
stored in the database. You can retrieve the source code for a
particular function, search for functions whose names contain some
string, or make searches based on the source code itself. Some system
functions are available to do this.\
\
 <span style="font-family: monospace; ">apropos(Charstring str) -&gt;
Bag of Function</span>\
 returns all functions in the system whose names contains the string
<span style="font-style: italic; ">str</span>. Only the
[generic](#overloaded-functions%20) name of the function is used in the
search. The string is not case sensitive. For example:\
 <span style="font-family: monospace; ">     apropos("qrt ");</span>\
 returns all functions whose generic name contains 'qrt'.\
\
 `doc(Charstring str) -> Bag of Charstring`\
 returns the available documentations of all functions in the system
whose names contain the (non case sensitive) string *str*. For example:\
 `doc("qrt ");`\

<span style="font-family: monospace; ">sourcecode(Function f) -&gt; Bag
of Charstring\
 sourcecode(Charstring fname) -&gt; Bag of Charstring\
 </span>returns the sourcecode of a function *f*, if available. For
[generic](#overloaded-functions%20) functions the sources of all
resolvents are returned. For example:\
 `sourcecode("sqrt ");`\

To find all functions whose definitions contain the string 'tclose'
use:\
 <span style="font-family: monospace; ">     select sc\
      from Function f, Charstring sc\
      where like\_i(sc,"\*tclose\* ") and source\_text(f)=sc;\
 </span>

`usedwhere(Function f) -> Bag of Function c`\
 returns the functions calling the function `f`.

`useswhich(Function f) -> Bag of Function c`\
 returns the functions called from the function `f`.

<span style="font-family: monospace; ">userfunctions() -&gt; Bag of
Function</span>\
 returns all user defined functions in the database.\

<span style="font-family: monospace; ">usertypes() -&gt; Bag of
Type</span><span style="font-family: monospace; "></span>\
 returns all user defined types in the database.\

`allfunctions(Type t)-> Bag of Function`\
 returns all functions where one of the arguments are of type <span
style="font-style: italic; ">t</span>.\
