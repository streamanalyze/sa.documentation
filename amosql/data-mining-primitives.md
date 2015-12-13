# Data mining primitives

sa.amos provides primitives for advanced analysis, aggregation, and
visualizations of data collections. This is useful for data mining
applications, e.g. for clustering and identifying patterns in data
collections. Primitives are provided for analyzing both unordered
collections (bags) and ordered collections (vectors). In particular
ordered collections are often used in data mining and for this the
[vselect statement](vector-queries.md#vselect-stmt) provides a powerful way to specify
queries returning vectors. Another important issue is [grouping data](queries.md#group-by) based on some grouping criteria and [top-k-queries](queries.md#top-k-queries), which are handled by the `group by` construct
supported both for [regular queries](queries.md#select-statement) and 
[vector queries](vector-queries.md#vselect-stmt). System functions are provided for basic computations, distance computations, and statisticalcomputations. 
The results of the
analyzes can be visualized by calling an external [data visualization](#plot-fns) package.

## <a name="vector-numerical"> Numerical vector functions

For numerical vectors the `times()` function (infix operator: `*`) is defined as the scalar product:
```
   times(Vector x, Vector y) -> Number r
```
Example:
```
   {1, 2, 3} * {4, 5, 6};
```
returns the number `32`.

For numerical vectors the `elemtimes()` function (infix operator: `.*`) is defined as the element-wise product for vectors of numbers:
```
   elemtimes(Vector x, Vector y) -> Vector of Number r
```
For example:
```
   {1, 2, 3} .* {4, 5, 6};
```
returns `{4, 10, 18}`.

For numerical vectors the `elemdiv()` function (infix operator: `./`) is defined as the element wise fractions:
```
   elemdiv(Vector x, Vector y) -> Vector of Number r
```
Example:
```
   {1, 2, 3} ./ {4, 5, 6};
```
returns `{0.25, 0.4, 0.5}`.

For numerical vectors the `elempower()` function (infix operator: `.^`) is defined as the element wise power:
```
   elempower(Vector of Number x, Number exp) -> Vector of Number r
```
Example:
```
   {1, 2, 3} .^ 2;
```
returns `{1, 4, 9}`.

For numerical vectors the `plus()` and `minus()` functions (infix operators: `+` and `-`) are defined as the element wise sum and difference, respectively:
```
   plus(Vector of number x, Vector of number y) -> Vector of Number r
   minus(Vector of number x, Vector of number y) -> Vector of Number r
```
Examples:
```
   {1, 2, 3} + {4, 5, 6};
```
returns `{5, 7, 9}`
```
   {1, 2, 3} - {4, 5, 6};
```
returns `{-3, -3, -3}`.

The `times()` and `div()` functions (infix operators: `*` and `/`) scale vectors by a scalar:
```
   times(Vector of number x,Number lambda) -> Vector of Number r
   div(Vector of number x,Number lambda) -> Vector of Number r
```
Example:
```
   {1, 2, 3} * 1.5;
```
returns `{1.5, 3.0, 4.5}`.

For user convenience, `plus()` and `minus()` functions (infix operators: `+` and `-`) allow mixing vectors and scalars:
```
  plus(Vector of Number x, Number y) -> Vector of Number r
  minus(Vector of Number x, Number y) -> Vector of Number r
```
Examples:
```
   {1, 2, 3} + 10;
```
returns `{11, 12, 13}`
```
   {1, 2, 3} - 10;
```
returns `{-9, -8, -7}`.

These functions can be used in queries too:
```sql
   select lambda
     from Number lambda
    where {1, 2} - lambda = {11, 12};
```
returns `-10`.

If the equation has no solution, the query will have no result:
```sql
   select lambda
     from Number lambda
    where {1, 3} - lambda = {11, 12};
```

By contrast, note that this query:
```sql
   select lambda
     from Vector of Number lambda
    where {1, 2} - lambda = {11, 12};
```
returns `{-10,-9}`.

The functions `zeros()` and `ones()` generate vectors of zeros and ones, respectively:
```
   zeros(Integer)-> Vector of Number
   ones(Integer)-> Vector of Number
```
Examples:
```
   zeros(5);
```
returns `{0, 0, 0, 0, 0}`.
```
   3.1 * ones(4);
```
returns `{3.1, 3.1, 3.1, 3.1}`.

The function `roundto()` rounds each element in a vector of numbers to the desired number of decimals:
```
   roundto(Vector of Number v, Integer d) -> Vector of Number r
```
Example:
```
   roundto({3.14159, 2.71828}, 2);
```
returns `{3.14, 2.72}`.

The function `vavg()` computes the average value a of a vector of numbers `v`:
```
   vavg(Vector of Number v) -> Real a
```

The function `vstdev()` computes the standard deviation s of a vector of numbers `v`:
```
   vstdev(Vector of Number v) -> Real s
```

The function `median()` computes the median m of a vector of numbers v:
```
   median(Vector of Number v) -> Number m
```

The function `euclid()` computes the Euclidean distance between two points `p1` and `p2` expressed as vectors of numbers:
```
   euclid(Vector of Number p1, Vector of Number p2) -> Real d
```

The function `minkowski()` computes the Minkowski distance between two points `p1` and `p2` expressed as vectors of numbers, with the Minkowski parameter `r`:
```
   minkowski(Vector of Number p1, Vector of Number p2, Real r) -> Real d
```

The function `maxnorm()` computes the Maxnorm distance between two points `p1` and `p2` (conceptually, this is the same as the Minkowski distance with r = infinity):
```
   maxnorm(Vector of Number p1, Vector of Number p2) -> Real d
```

## <a name="vector-aggregate-functions"> Vector aggregate functions

The following functions group and compute aggregate values over collections of numerical vectors.

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

Principal Component Analysis is performed using the function `pca()`:
```
   pca(Bag of Vector data)-> (Vector of Number eigval D, Vector of Vector of Number eigvec W)
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
