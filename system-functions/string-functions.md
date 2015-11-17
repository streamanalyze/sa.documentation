# String functions

String concatenation is made using the `+` operator, e.g.
```
"ab" + "cd" + "ef";  returns "abcdef"
"ab"+12+"de"; returns "ab12de"
1+2+"ab"; is illegal since the first argument of '+' must be a string.
"ab"+1+2; returns "ab12" since '+' is left associative.
```
```
char_length(Charstring)->Integer
```
Count the number of characters in string.

```
like(Charstring string, Charstring pattern) -> Boolean
```
Test if string matches regular expression pattern where `*` matches sequence of characters and `?` matches single character. For example:
```
like("abc","??c") returns TRUE
like("ac","a*c") returns TRUE
like("ac","a?c") fails
like("abc","a[bd][dc]"); returns TRUE
like("abc","a[bd][de]"); fails
```
```
like_i(Charstring string, Charstring pattern) -> Boolean
```
Case insensitive `like()`.
```
locate(Charstring substr, Charstring str) -> Integer
```
The position of the first occurrence of substring `substr` in string `str`.
```
lower(Charstring str)->Charstring
```
Lowercase string.
```
ltrim( Charstring chars, Charstring str) -> Charstring
```
Remove characters in `chars` from beginning of `str`.
```
not_empty(Charstring s) -> Boolean
```
Returns `true` if string `s` contains only whitespace characters (space, tab, or new line).
```
replace(Charstring str, Charstring from_str, Charstring to_str) -> Charstring
```
Returns the string str with all occurrences of the string from_str replaced by the string to_str. `replace()` is case sensitive.
```
rtrim(Charstring chars, Charstring str) -> Charstring
```
Remove characters in chars from end of str.
```
stringify(Object x)->Charstring s
```
Convert any object x into a string.
```
substring(Charstring string,Integer start, Integer end)->Charstring
```
Extract substring from given character positions. First character has position 0.
```
trim(Charstring chars, Charstring str) -> Charstring
```
Remove characters in chars from beginning and end of str.
```
unstringify(Charstring s) -> Object x
```
Convert string s to object x. Inverse of stringify().
```
upper(Charstring s)->Charstring
```
Uppercase string s. 
