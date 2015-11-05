# Arithmetic functions

```
    abs(Number x) -> Number y
    div(Number x, Number y)   -> Number z Infix operator /
    max(Object x, Object y)   -> Object z
    minus(Number x, Number y) -> Number z Infix operator - 
    mod(Number x, Number y) -> Number z
    plus(Number x, Number y)  -> Number z Infix operator +
    times(Number x, Number y) -> Number z Infix operator * 
    power(Number x, Number y) -> Number z Infix operator ^
    iota(Integer l, Integer u)-> Bag of Integer z
    sqrt(Number x) -> Number z
    integer(Number x) -> Integer i Round
            x to nearest integer
    real(Number x) -> Real r Convert x to real number
    roundto(Number x, Integer d) -> Number Round
            x to
            d decimals
    log10(Number x) -> Real y
```



*iota()* constructs a bag of integers between `l`and `u`. For example, to execute n times the AmosQL statement `print(1)`do: 

```sql
for each Integer i where i in iota(1,n) 
         print(1);
```
