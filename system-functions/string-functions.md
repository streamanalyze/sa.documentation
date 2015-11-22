# String functions

String concatenation is made using the `+` operator. Examples:
```
   "ab" + "cd" + "ef";  returns "abcdef"
   "ab"+12+"de"; returns "ab12de"
   1+2+"ab"; is illegal since the first argument of '+' must be a string.
   "ab"+1+2; returns "ab12" since '+' is left associative.
```

Count the number of characters in string:
```
   char_length(Charstring)->Integer
```

Test if string matches regular expression pattern where `*` matches
sequence of characters and `?` matches single character:
```
   like(Charstring string, Charstring pattern) -> Boolean
```
Examples:
```
   like("abc","??c") returns TRUE
   like("ac","a*c") returns TRUE
   like("ac","a?c") fails
   like("abc","a[bd][dc]"); returns TRUE
   like("abc","a[bd][de]"); fails
```

Case insensitive `like()`:
```
   like_i(Charstring string, Charstring pattern) -> Boolean
```

The position of the first occurrence of substring `substr` in string `str`:
```
   locate(Charstring substr, Charstring str) -> Integer
```

Lowercase string:
```
   lower(Charstring str)->Charstring
```

Remove characters in `chars` from beginning of `str`:
```
   ltrim( Charstring chars, Charstring str) -> Charstring
```

Return `true` if string `s` contains only whitespace characters
(space, tab, or new line):
```
   not_empty(Charstring s) -> Boolean
```

Return the string `str` with all occurrences of the string `from_str`
replaced by the string `to_str`. `replace()` is case sensitive.
```
   replace(Charstring str, Charstring from_str, Charstring to_str) -> Charstring
```

Remove characters in chars from end of str:
```
   rtrim(Charstring chars, Charstring str) -> Charstring
```

Convert any object x into a string:
```
   stringify(Object x)->Charstring s
```

Extract substring from given character positions. First character has position 0:
```
   substring(Charstring string,Integer start, Integer end)->Charstring
```

Remove characters in `chars` from beginning and end of `str`.
```
   trim(Charstring chars, Charstring str) -> Charstring
```

Convert string `s` to object `x`. Inverse of `stringify()`:
```
   unstringify(Charstring s) -> Object x
```

Uppercase string s:
```
   upper(Charstring s)->Charstring
```
