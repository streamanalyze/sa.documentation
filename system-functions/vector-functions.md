# Vector functions

Functions over vectors are divided into:
- [Numerical vector functions](#numerical-vector-functions) operate on numerical vectors.
- [Vector aggregate functions](#vector-aggregate-functions) operate on collections (bags) of vectors.
- [PCA functions](#PCA-functions) do principal component analyses over collections (bags) of vectors.
- [Sequence functions](#sequence-functions) operate on vectors whose elements can be of aritrary type and need not be numerical.
- [Plot functions](#plot-fns) utilize an external plot system (GNU-plot) to visualize the contents of collections of vectors.

Notice that the [vselect statement](../amosql/vector-queries.md) provide a powerful mechanism for constructing new vectors through queries in terms of functions.

## <a name="numerical-vector-functions"> Numerical vector functions

The following *operators* over vectors `x` and `y` and number `lambda` are defined:

| operation     | description                  | implemented as function
|:-------------:|:----------------------------:|-------------------------|
| `x + y`       | element-wise addition        | plus
| `lambda + x`  | add number to elements       | plus
| `x + lambda`  |         -"-                  | plus
| `x - y`       | element-wise subtractions    | minus
| `-x`          | negate elements              | uminus
| `x - lambda`  | subtract number from elements| minus
| `lambda - x`  | subtract elements from number| minus
| `x * y`       | scalar product               | times
| `x .* y`      | element-wise multiplications | elemtimes
| `lambda * x`  | multiply elements with number| times
| `x * lambda`  |            -"-               | times
| `x ./ y`      | element-wise divisions       | elemdiv
| `x / lambda`  | divide elements with number  | div
| `lambda / x`  | divide number with elements  | div
| `x .^ lambda` | make power of elements       | elempower


The following functions operate on vectors of numbers:

| signature | description 
|-----------|----------
|`dim(Vector v) -> Integer`|number of elements|
|`div(Number lambda, Vector of number x) -> Vector of Number`|same as lambda/x
|`div(Vector of number x, Number lambda) -> Vector of Number`|same as x/lambda
|`elemdiv(Vector x, Vector y) -> Vector of Number`|same as x./y
|`elempower(Vector of Number x, Number exp) -> Vector of Number`|same as x.^exp
|`elemtimes(Vector x, Vector y) -> Vector of Number`|same as x.*y
|`euclid(Vector of Number p1, Vector of Number p2) -> Real`|Euclidean distance
|`maxnorm(Vector of Number p1, Vector of Number p2) -> Real`|maxnorm distance
|`median(Vector of Number v) -> Number`|median of elements
|`minkowski(Vector of Number p1, Vector of Number p2, Real r) -> Real`| Minkowski distance
|`minus(Vector of Number x, Vector of Number y) -> Vector of Number`| same as x-y
|`minus(Number lambda, Vector of Number x) -> Vector of Number`|same as lambda-x
|`minus(Vector of Number x, Number lambda) -> Vector of Number`|same as x-lambda
|`ones(Number n) -> Vector of Number`|vector of n ones
|`plus(Vector of Number x, Vector of Number y) -> Vector of Number`|same as x+y
|`plus(Number lambda, Vector of Number x) ->  Vector of Number`|same as lambda*x
|`plus(Vector of Number x, Number lambda) ->  Vector of Number`|same as x*lambda
|`roundto(Vector of Number v, Integer d) -> Vector of Number`|round elements to d digits
|`times(Vector x, Vector y) -> Number`|same as x*y
|`times(Number lambda, Vector of Number x) -> Vector of Number`|same as lambda*x
|`times(Vector of Number x, Number lambda) -> Vector of Number`|same as x*lambda
|`vavg(Vector of Number v) -> Real`|average of elements
|`vstdev(Vector of Number v) -> Real`|standard deviation of elements
|`zeros(Number n) -> Vector of Number`|vector of n zeros  

### Descriptions:

__Compute the size of a vector:__
```
   dim(Vector v) -> Integer d
```
For example `dim({1,2,3});` returns `3`.

__Division between vector elements and number:__
```
   div(Vector of number x, Number lambda) -> Vector of Number
   div(Number lambda, Vector of number x) -> Vector of Number
```
Same as `x/lambda` and `lambda/x`. 

Examples:

`{1,2,3}/2;` returns `{0.5,1.0,1.5}`

`3/{1,2,3};` returns `{3,1.5,1}`

__Divide vectors element by element:__
```
   elemdiv(Vector x, Vector y) -> Vector of Number r
```
Same as `x./y`. 

Example:

`{1,2,3}./{4,5,6};` returns `{0.25,0.4,0.5}`.

__Raise each element to a given exponent:__
```
   elempower(Vector of Number x, Number exp) -> Vector of Number r
```
Same as `x.^exp`. 

Example: 

`{1,2,3}.^2;` returns `{1,4,9}`.


__Multiply vectors element by element:__
```
   elemtimes(Vector x, Vector y) -> Vector of Number r
```
Same as  `x.*y`. 

Example:

`{1,2,3}.*{4,5,6};` returns `{4,10,18}`.

__Compute the Euclidean distance between two points `p1` and `p2`:__
```
   euclid(Vector of Number p1, Vector of Number p2) -> Real d
```
Example:

`euclid({1,10},{-1,2});` returns `8.24621125123532`.

__Compute the maxnorm distance between two points:__
```
   maxnorm(Vector of Number p1, Vector of Number p2) -> Real d
```
Conceptually, this is the same as the Minkowski distance with `r = infinity`.

Example:

`maxnorm({1,10},{-1,2});` returns `8.0`.

__Compute the median of a vector of numbers:__
```
   median(Vector of Number v) -> Number m
```
Example:

`median({1,2,4});` returns `2.0`.

__Compute the Minkowski distance between two points:__
```
   minkowski(Vector of Number p1, Vector of Number p2, Real r) -> Real d
```
Examples:

`minkowski({1,10},{-1,2},2);` returns `8.24621125123532`, same as `euclid({1,10},{-1,2});`.

`minkowski({1,10},{-1,2},8);` returns `8.0000152586872`.

__Subtract vectors and numbers:__
```
   minus(Vector of number x, Vector of number y) -> Vector of Number
   minus(Number lambda, Vector of Number x) -> Vector of Number
   minus(Vector of Number x, Number lambda) -> Vector of Number
```
Same as `x-y`, `lambda-x`, and `x-lambda`.

Examples:

`{1,2,3}-{4,5,6};` returns `{-3,-3,-3}`.

`5-{1,2,3};` returns `{4,3,2}`.

`{1,2,3}-5;` returns `{-4,-3,-2}`.

__Make vector of ones:__
```
   ones(Number dim)-> Vector of Number
```
Example:

`ones(3);` returns `{1,1,1}`.

__Add vectors and numbers:__
```
   plus(Vector of Number x, Vector of Number y) -> Vector of Number
   plus(Number lambda, Vector of Number x) ->  Vector of Number
   plus(Vector of Number x, Number lambda) ->  Vector of Number
```
Same as `x+y`, `lambda+x`, and `x+lambda`. 

Examples:

`{1,2,3}+{4,5,6};` returns `{5,7,9}`.

`4+{1,2,3};` returns `{5,6,7}`.

`{1,2,3}+4;` returns `{5,6,7}`.

__Round each element in a vector of numbers a number of decimals:__
```
   roundto(Vector of Number v, Integer d) -> Vector of Number r
```
Example:

`roundto({3.14159,2.71828},2);` returns `{3.14,2.72}`.

__Multiply vectors and numbers:__
```
   times(Vector of Number x, Vector of Number y) -> Number
   times(Number lambda, Vector of Number x) -> Vector of Number
   times(Vector of Number x, Number lambda) -> Vector of Number
```
Same as `x*y`, `lambda*x`, and `x*lambda`.

Examples:

`{1,2,3}*{4,5,6};` returns `32`.

`4*{1,2,3};` returns `{4,8,12}`.

`{1,2,3}*4;` returns `{4,8,12}`.


__Compute the average value a vector elements:__
```
   vavg(Vector of Number v) -> Real a
```
Example:

`vavg({1,2,3});` returns `2.0`.


__Compute the standard deviation vector elements:__
```
   vstdev(Vector of Number v) -> Real s
```
Example:

`vstdev({1,2,3});` returns `1.0`.


__Make vector of zeros:__
```
   zeros(Number dim)-> Vector of Number
```
Example:

 `zeros(3);` return `{0,0,0}`.

## <a name="vector-aggregate-functions"> Vector aggregate functions

The following functions group and compute aggregate values over collections of numerical vectors:
```
   aggv(Bag of Vector v, Function aggfn) -> Vector      Roll up 
   maxmin(Bag of Vector of Number b) -> Bag of Vector of Number
   meansub(Bag of Vector of Number b) -> Bag of Vector of Number
   zscore(Bag of Vector of Number b) -> Bag of Vector of Number

```


Dimension-wise aggregates over bags of vectors can be computed using the function `aggv()`:
```
   aggv(Bag of Vector, Function) -> Vector
```
Example:
```sql
   aggv((select {i, i + 10}
           from Integer i
          where i in iota(1, 10)), #'avg');
```
returns `{5.5, 15.5}`.

Each dimension in a bag of vector of number can be normalized using one of the normalization functions `meansub()`, `zscore()`, or `maxmin()`:
```
   meansub(Bag of Vector of Number b) -> Bag of Vector of Number
   zscore(Bag of Vector of Number b) -> Bag of Vector of Number
   maxmin(Bag of Vector of Number b) -> Bag of Vector of Number
```

`meansub()` transforms each dimension to a `N(0, s)` distribution
(assuming that the dimension was `N(u, s)` distributed) by subtracting
the mean u of each dimension.

`zscore()` transforms each dimension to a `N(0, 1)` distribution by
also dividing by the standard deviation of each dimension.

`maxmin()` transforms each dimension to be on the `[0, 1]` interval by
applying the transformation `(w - min) ./ (max - min)` to each vector
w in bag b where max and min are computed using `aggv(b, #' maxagg')`
and `aggv(b, #'minagg')` respectively. 

Example:
```
   meansub((select {i, i/2 + 10}
              from Integer i
             where i in iota(1, 5)));
```
returns the bag:
```
   {-2.0,-1.0}
   {-1.0,-0.5}
   {0.0,0.0}
   {1.0,0.5}
   {2.0,1.0}
```

## <a name="PCA-functions"> Principal Component Analysis 

Principal Component Analysis is performed using these functions:
```
   lpcascore(Bag of (Vector of Number, Object label), Integer d) 
      -> (Vector of Number score, Object label)
   pca(Bag of Vector data) 
      -> (Vector of Number eigval D, Vector of Vector of Number eigvec W)
   pcascore(Bag of Vector of Number, Integer d) -> Vector of Number score
```

`pca()` takes a bag of M-dimensional vectors in data and computes the
*MxM* covariance matrix *C* of the input vectors. Then, `pca()` computes
the *M* eigenvalues *D* and the *MxM* eigenvector matrix *W* of the covariance
matrix. `pca()` returns the eigenvalues *D* and their corresponding
eigenvectors *W*.

To use `pca()` to reduce the dimensionality to the *L* most significant dimensions, each input vector must be projected onto the eigenvectors corresponding to the *L* greatest eigenvalues using the scalar product. This is done using the function `pcascore()`:
```
   pcascore(Bag of Vector of Number, Integer d) -> Vector of Number score
```
`pcascore()` performs PCA on data, and projects each data vector in data onto the d first eigenvectors. Each projected vector in data is emitted.

The function `lpcascore()` allows a label to be passed along with each vector:
```
   lpcascore(Bag of (Vector of Number, Object label), Integer d) -> (Vector of Number score, Object label)
```
The label of each vector remains unchanged during projection.

Note that the input data might have to be pre-processed, using some vector normalization.


## <a name="sequence-functions"> Non-numerical vector functions

The following functions work of vectors (i.e. sequences) containing
any kinds of elements:

```
   concat(Vector x, Vector y) -> Vector              concatenate vectors
   project(Vector v, Vector of Number pv) -> Vector  project positions
```

__Concatenate two vectors:__
```
   concat(Vector x, Vector y) -> Vector r
```
Example:

`concat({1,2,3},{4,5,6});` returns `{1,2,3,4,5,6}`.

__Project vector elements:__
```
   project(Vector v, Vector of Number pv) -> Vector r
```
`pv` is a vector of indices of the projected elements in `v`.

Example:

`project({10,20,30,40},{0,3,2});` returns `{10,40,30}`.

## <a name="plot-fns"> Plotting numerical data

sa.amos can utilize GNU Plot (v 4.2 or above), to plot numerical
data. The `plot()` function is used to plot a line connecting
two-dimensional points. Each vector in the vector `v` is a data
point. `plot(v)` will plot the points in the order they appear in `v`.
Signature:
```
   plot(Vector of Vector v) -> Integer
```
The return value is the exit code of the plot program. A nonzero value
indicates error. 

If the data points have a higher dimensionality than two, the optional
argument projs is used to select the dimension to be plotted. Signature:
```
   plot(Vector of Integer projs, Vector of Vector v) -> Integer
```
The `projs` vector lists the dimensions onto which each data vector
`v` is to be projected. The first dimension has number 0 (zero).

Scatter plots of bags of two-dimensional vectors are generated using `scatter2()`.
`scatter2p()` and `scatter2l()` plots three-dimensional data in two dimensions. `scatter2p()` assigns a color temperature of each point according to the value of its value in the third dimension. `scatter2l()` labels each point in the two-dimensional plot with the its value of the third dimension. The value of the third dimension in `scatter2l()` could be numerical or textual.

Three-dimensional scatter plots are generated using `scatter3()`, `scatter3l()`, and `scatter3p()`. `scatter3()` plots 3-dimensional data, whereas `scatter3l()` and `scatter3p()` plot 4-dimensional data in the same fashion as `scatter2p()` and `scatter2l()`. 

Signatures
```
   scatter2(Bag of Vector v) -> Integer
   scatter2l(Bag of Vector v) -> Integer
   scatter2p(Bag of Vector v) -> Integer
   scatter3(Bag of Vector v) -> Integer
   scatter3l(Bag of Vector v) -> Integer
   scatter3p(Bag of Vector v) -> Integer
   scatter2(Vector of Integer projs, Bag of Vector v) -> Integer
   scatter2l(Vector of Integer projs, Bag of Vector v) -> Integer
   scatter2p(Vector of Integer projs, Bag of Vector v) -> Integer
   scatter3(Vector of Integer projs, Bag of Vector v) -> Integer
   scatter3l(Vector of Integer projs, Bag of Vector v) -> Integer
   scatter3p(Vector of Integer projs, Bag of Vector v) -> Integer
```
