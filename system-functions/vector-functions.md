# Vector functions

There is a library of numerical vector functions for numerical
computations and analyses described in the [data mining
section](data-mining-primitives.md). 

The function `project()` constructs a new vector by extracting from
the vector v the elements in the positions in pv:
```
   project(Vector v, Vector of Number pv) -> Vector r
```
Example:
```
   project({10, 20, 30, 40},{0, 3, 2});
```
returns `{10, 40, 30}`

The function `substv()` replaces `x` with `y` in any collection `v`:
```
   substv(Object x, Object y, Object v) -> Object r
```

The system function `dim()` computes the size `d` of a vector `v`:
```
   dim(Vector v) -> Integer d
```

The function `concat()` concatenates two vectors:
```
   concat(Vector x, Vector y) -> Vector r
```
