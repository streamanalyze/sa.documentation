# Extents

The local sa.amos database can be regarded as a set of
*extents*. There are two kinds of extents:

## Type Extents

*Type extents* represent surrogate objects belonging to a particular type.

The *deep extent* of a type is defined as the set of all surrogate
objects belonging to that type and to all its descendants in the type
hierarchy. The deep extent of a type is retrieved with:
```
   extent(Type t)->Bag of Object
```
For example, to count how many functions are defined in the database call:
```
   count(extent(typenamed("function ")));
```

To get all surrogate objects in the database call:
```
   extent(typenamed("object "))
```
The function `allobjects();` does the same.

The *shallow extent* of a type is defined as all surrogate objects
belonging only to that type but *not* to any of its descendants. The
shallow extent is retrieved with:
```
shallow_extent(Type t) -> Bag of Object
```

For example:
```
shallow_extent(typenamed("object "));
```
returns nothing since type `Object` has no own instances.

## Function Extents

*Function extents* represent the state of stored functions. The extent
of a function is the bag of tuples mapping its argument(s) to the
corresponding result(s). The function `extent()` returns the extent of
the function `fn`. The extent tuples are returned as a bag of
vectors. The function can be any kind of function.
```
   extent(Function fn) -> Bag of Vector
```
For example:
```
   extent(#'coercers');
```

The extent is always defined for stored functions. It can also be
computed for derived functions through their function definitions. The
extent of a derived function may not be computable, *unsafe*, in which
case the extent function returns nothing. The extent of a foreign
function is always empty.

The extent of a generic function is the union of the extents of its
resolvents.
