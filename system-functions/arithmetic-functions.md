# Arithmetic functions

The system supports the usual basic arithmetic operators:
```
   x + y
   x - y
   -x
   x * y
   x / y
   x ^ y
```
There is a library of arihmetic functions:
```
   abs(Number x) -> Number y                     |x|
   acos(Number x) -> Real                        arc-sine 
   asin(Number x) -> Real                        arc-cosine
   atan(Number x) -> Real                        arc-tangent
   ceiling(Number x) -> Integer
   cos(Number x) -> Real                         cosine
   div(Number x, Number y) -> Number z           Same as x / y
   exp(Number x) -> Real                         e ^ x
   floor(Number x) -> Integer
   integer(Number x) -> Integer i                Round x to nearest integer
   iota(Number l, Number u) -> Bag of Integer    See below
   log10(Number x) -> Real y                     Logarithm with base 10
   ln(Number x) -> Real                          Natural logarithm, base e
   max(Object x, Object y) -> Object z           The largest of x and y
   min(Object x, Object y) -> Object z           The smallest of x and y
   minus(Number x, Number y) -> Number z         Same as x - y
   mod(Number x, Number y) -> Number z           Modulous x/y
   pi() -> Real                                  3.14159...
   plus(Number x, Number y)  -> Number z         Same as x + y
   times(Number x, Number y) -> Number z         Same as x * y
   power(Number x, Number y) -> Number z         Same as x ^ y
   real(Number x) -> Real r                      Convert x to real number
   sin(Number x) -> Real                         Sine
   tan(Number x) -> Real                         Tangent
   round(Number x) -> Integer                    Round to nearest integer
   roundto(Number x, Integer d) -> Number        Round x to d decimals
   sqrt(Number x) -> Number z                    Positive square root
```

`iota(l,u)` constructs a bag of integers between `l` and `u`. For example, to execute `n` times the AmosQL statement `print(1)` do:
```sql
   for each Integer i where i in iota(1,n)
            print(1);
```
