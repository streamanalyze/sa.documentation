# Data mining primitives

sa.amos provides primitives for advanced analysis, aggregation, and
visualizations of data collections. This is useful for data mining
applications, e.g. for clustering and identifying patterns in data
collections. Primitives are provided for analyzing both unordered
collections (bags) and ordered collections (vectors). In particular
ordered collections are often used in data mining and for this the
[vselect statement](#vselect) provides a powerful way to specify queries
returning vectors. Another important issue is [grouping
data](#grouped-selection) based on some grouping criteria and [top-k
queries](#top-k-queries), which are handled by the group by construct
supported both for [regular queries](#select-statement)and [vector
queries](#vselect). System functions are provided for basic [numerical
vector](#vector-numerical) computations, [distance](#distance-functions)
computations, and  [statistical](#statistical-functions)computations .
The results of the analyzes can be visualized by calling an external
[data visualization](#plot) package.\

### 2.8.1 Numerical vector functions

For numerical vectors the <span style="font-style: italic;">times()
</span>function (infix operator: **\*** ) is defined as the scalar
product:\
 <span style="font-family: monospace;">  times(Vector x, Vector y) -&gt;
Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **\*** {4, 5,
6};</span>\
 returns the number 32.\
\
 For numerical vectors the <span style="font-style: italic;">elemtimes()
</span>function (infix operator: **.\***) is defined as the element wise
product for vectors of numbers:\
 <span style="font-family: monospace;">  elemtimes(Vector x, Vector y)
-&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **.\*** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{4, 10, 18}</span>.\
\
 For numerical vectors the <span style="font-style: italic;">elemdiv()
</span>function (infix operator: **./**) is defined as the element wise
fractions:\
 <span style="font-family: monospace;">  elemdiv(Vector x, Vector y)
-&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **./** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{0.25, 0.4, 0.5}</span>.\
\
 For numerical vectors the <span style="font-style: italic;">elempower()
</span>function (infix operator: **.\^**) is defined as the element wise
power:\
 <span style="font-family: monospace;">  elempower(Vector of Number x,
Number exp) -&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **.\^** 2;</span>\
 returns `{1, 4, 9}`.\
\
 For numerical vectors the <span style="font-style: italic;">plus()
</span> and <span style="font-style: italic;">minus() </span>functions
(infix operators: + and - ) are defined as the element wise sum and
difference, respectively:\
 <span style="font-family: monospace;">  plus(Vector of number x, Vector
of number y) -&gt; Vector of Number r</span>\
 <span style="font-family: monospace;">  minus(Vector of number x,
Vector of number y) -&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **+** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{5, 7, 9}</span> and\
 <span style="font-family: monospace;">  {1, 2, 3} **-** {4, 5,
6};</span>\
 returns <span style="font-family: monospace;">{-3, -3, -3}</span>.\
\
 The *times()* and *div()* functions (infix operators: \* and / ) scale
vectors by a scalar:\
 `  times(Vector of number x,Number y) -> Vector of Number r`\
 `  div(Vector of number x,Number y) -> Vector of Number r`\
 For example:\
 <span style="font-family: monospace;">  {1, 2, 3} **\*** 1.5; </span>\
 returns <span style="font-family: monospace;">{1.5, 3.0, 4.5}</span>\
\
 For user convenience, *plus()* and *minus()* functions (infix
operators: + and -) allow mixing vectors and scalars:\
 `  plus(Vector of Number x, Number y) -> Vector of Number r`\
 `  minus(Vector of Number x, Number y) -> Vector of Number r `\
 For example:\
 `  {1, 2, 3} + 10;`\
 returns `{11, 12, 13}` and\
 `  {1, 2, 3} - 10;`\
 returns `{-9, -8, -7}`.\
\
 These functions can be used in queries too:\

`  select lambda        from number lambda       where {1, 2} - lambda = {11, 12};`\
 returns `-10`.\
\
 If the equation has no solution, the query will have no result:\

`  select lambda        from number lambda       where {1, 3} - lambda = {11, 12};`\
\
 By contrast, note that this query:\

`  select lambda       from vector of number lambda      where {1, 2} - lambda = {11, 12};`\
 returns `{-10,-9}`.\
\
 <span style="font-family: Times New Roman;">The functions *zeros()* and
*ones()* generate vectors of zeros and ones, respectively:\
 <span style="font-family: monospace;">   zeros(Integer)-&gt; Vector of
Number\
   ones(Integer)-&gt; Vector of Number</span>\
 For example:\
 <span style="font-family: monospace;">  **zeros**(5);\
 </span> results in <span style="font-family: monospace;">{0, 0, 0, 0,
0}</span>\
 <span style="font-family: monospace;">  3.1 \* **ones**(4);\
 </span> results in <span style="font-family: monospace;">{3.1, 3.1,
3.1, 3.1}</span>\
\
 </span>The function *roundto()* rounds each element in a vector of
numbers to the desired number of decimals:\
 <span style="font-family: monospace;">  roundto(Vector of Number v,
Integer d) -&gt; Vector of Number r</span>\
 For example:\
 <span style="font-family: monospace;">  **roundto**({3.14159, 2.71828},
2);\
 </span> returns <span style="font-family: monospace;">{3.14, 2.72}
</span>\
\
 The function *vavg()* computes the average value <span
style="font-style: italic;">a</span> of a vector of numbers <span
style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  vavg(Vector of Number v) -&gt;
Real a</span>\
\
 The function *vstdev()* computes the standard deviation <span
style="font-style: italic;">s</span> of a vector of numbers <span
style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  vstdev(Vector of Number v)
-&gt; Real s</span>\
\
 The function <span style="font-style: italic;">median() </span>computes
the median <span style="font-style: italic;">m</span> of a vector of
numbers <span style="font-style: italic;">v</span>:\
 <span style="font-family: monospace;">  median(Vector of Number v)
-&gt; Number m\
\
 </span> <span style="font-family: Times New Roman;"> The function
*euclid()* computes the Euclidean distance between two points <span
style="font-style: italic;">p1</span> and <span
style="font-style: italic;">p2</span> expressed as vectors of numbers:\
 </span> <span style="font-family: monospace;">  euclid(Vector of Number
p1, Vector of Number p2) -&gt; Real d</span> <span
style="font-family: Times New Roman;">\
\
 The function *minkowski()* computes the Minkowski distance between two
points *p1* and *p2* expressed as vectors of numbers, with the Minkowski
parameter *r*:\
 <span style="font-family: monospace;">  minkowski(Vector of Number p1,
Vector of Number p2, Real r) -&gt; Real d</span>\
\
 The function *maxnorm()* computes the Maxnorm distance between two
points *p1* and *p2* (conceptually, this is the same as the Minkowski
distance with *r* = infinity):\
 <span style="font-family: monospace;">  maxnorm(Vector of Number p1,
Vector of Number p2) -&gt; Real d</span> </span>\

### <span style="font-family: Times New Roman;"> 2.8.2 Vector aggregate functions</span>

<span style="font-family: Times New Roman;">The following functions
group and compute aggregate values over collections of numerical
vectors.\
\
 Dimension-wise aggregates over bags of vectors can be computed using
the function *aggv*:\
 <span style="font-family: monospace;">  aggv(Bag of Vector, Function)
-&gt; Vector</span>\
 For example:\
 <span style="font-family: monospace;">  **aggv**((select {i, i + 10}\
           from integer i\
          where i in [iota](#iota)(1, 10)),
[\#'avg'](#functional-constant));\
 </span> returns in <span style="font-family: monospace;">{5.5, 15.5}
</span>\
\
 Each dimension in a bag of vector of number can be normalized using one
of the normalization functions *meansub()*, *zscore()*, or *maxmin()*.
They all have the same signature:\
 </span>

    meansub(Bag of Vector of Number b) -> Bag of Vector of Number

    zscore(Bag of Vector of Number b) -> Bag of Vector of Number

    maxmin(Bag of Vector of Number b) -> Bag of Vector of Number




*meansub()* transforms each dimension to a *N(0, s)* distribution
(assuming that the dimension was *N(u, s)* distributed) by subtracting
the mean *u* of each dimension. *zscore()* transforms each dimension to
a *N(0, 1)* distribution by also dividing by the standard deviation of
each dimension. *maxmin()* transforms each dimension to be on the \[0,
1\] interval by applying the transformation <span
style="font-family: monospace;">(w - min) ./ (max - min)</span> to each
vector *w* in bag *b* where *max* and *min* are computed using <span
style="font-family: monospace;">aggv(b, \#' [maxagg](#maxagg)')</span>
and <span style="font-family: monospace;">aggv(b,
\#'[minagg](#minagg)')</span> respectively.\
 For example:\

    meansub((select {i, i/2 + 10}

     from integer i

     where i in iota(1, 5)));


returns

    {-2.0,-1.0}

    {-1.0,-0.5}

    {0.0,0.0}

    {1.0,0.5}

    {2.0,1.0}


Principal Component Analysis is performed using the function *pca()*:\
 <span style="font-family: monospace;">   pca(Bag of Vector data)-&gt;
(Vector of Number eigval D, Vector of Vector of Number eigvec W)</span>\
 *pca()* takes a bag of *M*-dimensional vectors in *data* and computes
the *M*x*M* covariance matrix *C* of the input vectors. Then, *pca()*
computes the *M* eigenvalues *D* and the *M*x*M* eigenvector matrix *W*
of the covariance matrix. *pca()* returns the eigenvalues *D* and their
corresponding eigenvectors *W*.\
\
 To use *pca()* to reduce the dimensionality to the *L* most significant
dimensions, each input vector must be projected onto the eigenvectors
corresponding to the *L* greatest eigenvalues using the scalar product.
This is done using the function *pcascore()*:\

`  pcascore(Bag of Vector of Number, Integer d) -> Vector of Number score`\
 *pcascore()* performs PCA on *data*, and projects each data vector in
*data* onto the *d* first eigenvectors. Each projected vector in *data*
is emitted.\
 The function *LPCASCORE* allows a label to be passed along with each
vector:\

`  lpcascore(Bag of (Vector of Number, Object label), Integer d) -> (Vector of Number score, Object label)`\
 The label of each vector remains unchanged during projection.\
\
 Note that the input data might have to be pre-processed, using some
[vector normalization](#vnorm).\

### 2.8.3 Plotting numerical data

AmosII can utilize GNU Plot (v 4.2 or above), to plot numerical data.
The *plot()* function is used to plot a line connecting two-dimensional
points. Each vector in the vector `v` is a data point. *plot()* will
plot the points in the order they appear in the *v*.\
 `  plot(Vector of Vector v) -> Integer`\
 The return value is the exit code of the plot program. A nonzero value
indicates error.\
 If the data points have a higher dimensionality than two, the optional
argument *projs* is used to select the dimension to be plotted.\
 `  plot(Vector of Integer projs, Vector of Vector v) -> Integer`\
 The `projs` vector lists the dimensions onto which each data vector is
to be projected. The first dimension has number 0 (zero).\
\
 Scatter plots of bags of two-dimensional vectors are generated using
*scatter2()*.\
 *scatter2p()* and *scatter2l*() plots three-dimensional data in two
dimensions. *scatter2p()* assigns a color temperature of each point
according to the value of its value in the third dimension.
*scatter2l*() labels each point in the two-dimensional plot with the its
value of the third dimension. The value of the third dimension in
*scatter2l()* could be numerical or textual.\
\
 Three-dimensional scatter plots are generated using *scatter3()*,
*scatter3l()*, and *scatter3p()*. *scatter3()* plots 3-dimensional data,
whereas *scatter3l()* and *scatter3p()* plot 4-dimensional data in the
same fashion as *scatter2p()* and *scatter2l()*.\
 Each scatter plot function have two different signatures:

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
