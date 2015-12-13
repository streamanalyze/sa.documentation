# String functions

String concatenation is made using the `+` operator. Examples:
```
   "ab" + "cd" + "ef";  returns "abcdef"
   "ab"+12+"de"; returns "ab12de"
   "ab"+1+2; returns "ab12"
   1+2+"ab"; is illegal since the first argument of '+' must be a string!
```

The following functions operate on strings (type `Charstring`):
```
   char_length(Charstring) -> Integer                       Characters in string
   like(Charstring string, Charstring pattern) -> Boolean   Pattern matching
   like_i(Charstring string, Charstring pattern) -> Boolean Case insensitive pattern matching
   locate(Charstring substr, Charstring str) -> Integer     Locate substring
   lower(Charstring str) -> Charstring                      Lowercase string
   ltrim(Charstring chars, Charstring str) -> Charstring    Trim charaters at beginning
   newline() -> Charstring                                  New line character
   not_empty(Charstring s) -> Boolean                       Test if any non-space characters
   replace(Charstring str, Charstring from_str, Charstring to_str)
         -> Charstring                                      Substitute substrings
   rtrim(Charstring chars, Charstring str) -> Charstring    Remove characters at the end
   stringify(Object x) -> Charstring                        Convert to string
   substring(Charstring string,Integer start, Integer end) -> Charstring
                                                            Compute substring
   trim(Charstring chars, Charstring str) -> Charstring     Remove characters in both ends
   unstringify(Charstring s) -> Object                      Convert string to object
   upper(Charstring s)->Charstring                          Uppercase string
```

### Descriptions:

__Count the number of characters in string:__
```
   char_length(Charstring) -> Integer
```

__Match string against regular expression:__
```
   like(Charstring string, Charstring pattern) -> Boolean
```
In a pattern string `*` matches
sequence of characters and `?` matches a single character.

Examples:
```
   like("abc","??c") returns TRUE
   like("ac","a*c") returns TRUE
   like("ac","a?c") fails
   like("abc","a[bd][dc]"); returns TRUE
   like("abc","a[bd][de]"); fails
```

__Case insensitive regular expression match:__
```
   like_i(Charstring string, Charstring pattern) -> Boolean
```

__The position of the first occurrence of substring in string:__
```
   locate(Charstring substr, Charstring str) -> Integer
```

__Lowercase string:__
```
   lower(Charstring str)->Charstring
```

__Remove characters in `chars` from beginning of string__:
```
   ltrim(Charstring chars, Charstring str) -> Charstring
```

__New line:__
```
   newline() -> Charstring
```

__Test if string contains not only whitespace characters:__
```
   not_empty(Charstring s) -> Boolean
```
The characters space, tab, or new line are counted as whitespace.

__Substitute substrings in string:__
```
   replace(Charstring str, Charstring from_str, Charstring to_str) -> Charstring
```
All occurrences of the string `from_str` in `str` is
replaced by the string `to_str`. `replace()` is case sensitive.


__Remove characters in `chars` from end of string:__
```
   rtrim(Charstring chars, Charstring str) -> Charstring
```

__Convert object into a string:__
```
   stringify(Object x) -> Charstring s
```

__Extract substring from given character positions:__
```
   substring(Charstring string,Integer start, Integer end) -> Charstring
```
First character has position 0:

__Remove characters in `chars` from both beginning and end of string:__
```
   trim(Charstring chars, Charstring str) -> Charstring
```

__Convert string to object:__
```
   unstringify(Charstring s) -> Object x
```
Inverse of `stringify(x)`:

__Uppercase string:__
```
   upper(Charstring s)->Charstring
```
