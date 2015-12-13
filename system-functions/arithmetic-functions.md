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
The following arithmetic functions are predefined:
```
   abs(Number x) -> Number                       |x|
   acos(Number x) -> Real                        arc-sine 
   asin(Number x) -> Real                        arc-cosine
   atan(Number x) -> Real                        arc-tangent
   ceiling(Number x) -> Integer                  Nearest larger integer
   cos(Number x) -> Real                         cosine
   div(Number x, Number y) -> Number             Same as x/y
   exp(Number x) -> Real                         e^x
   floor(Number x) -> Integer                    Nearest smaller integer
   integer(Number x) -> Integer                  Round x to nearest integer
   iota(Number l, Number u) -> Bag of Integer    See below
   log10(Number x) -> Real                       Logarithm with base 10
   ln(Number x) -> Real                          Natural logarithm, base e
   max(Object x, Object y) -> Object             The largest of x and y
   min(Object x, Object y) -> Object             The smallest of x and y
   minus(Number x, Number y) -> Number           Same as x-y
   mod(Number x, Number y) -> Number             Modulous x/y
   pi() -> Real                                  3.14159...
   plus(Number x, Number y)  -> Number           Same as x+y
   times(Number x, Number y) -> Number           Same as x*y
   power(Number x, Number y) -> Number           Same as x^y
   real(Number x) -> Real                        Convert x to real number
   sin(Number x) -> Real                         Sine
   tan(Number x) -> Real                         Tangent
   round(Number x) -> Integer                    Round to nearest integer
   roundto(Number x, Integer d) -> Number        Round x to d decimals
   sqrt(Number x) -> Number                      Positive root
```

`iota(l,u)` constructs a bag of integers between `l` and `u`. For example, to execute `n` times the AmosQL statement `print(1)` do:
```sql
   for each Integer i where i in iota(1,n)
            print(1);
```
