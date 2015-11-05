# Extents

The local Amos II database can be regarded as a set of *extents*. There are two kinds of extents:

-   *Type extents* represent surrogate objects belonging to a
    particular type.

    -   The *deep extent* of a type is defined as the set of all
        surrogate objects belonging to that type and to all its
        descendants in the type hierarchy. The deep extent of a type is
        retrieved with:

            extent(Type t)->Bag of Object

        For example, to count how many functions are defined in the
        database call:\

               count(extent(typenamed("function ")));

        To get all surrogate objects in the database call:\
         <span style="font-family: monospace; ">  
        extent(typenamed("object "))</span>\
        \
         The function <span
        style="font-family: monospace; ">allobjects();</span> does the
        same.\

    -   The *shallow extent* of a type is defined as all surrogate
        objects belonging only to that type but <span
        style="font-style: italic; ">not</span> to any of
        its descendants. The shallow extent is retrieved with:

            shallow_extent(Type t) -> Bag of Object

        For example:

               shallow_extent(typenamed("object "));

        returns nothing since type `Object` has no own instances.

-   *Function extents* represent the state of stored functions. The
    extent of a function is the bag of tuples mapping its argument(s) to
    the corresponding result(s). The function *extent()* returns the
    extent of the function `fn`. The extent tuples are returned as a bag
    of [vectors](#vector%20). The function can be any kind of function.\
    \

        extent(Function fn) -> Bag of Vector

    For example, 

           extent(#'coercers');

    For stored functions the extent is directly stored in the
    local database. The example query thus returns the state of all
    stored functions. The state of the local database is this state plus
    the deep extent of type `Object`.

    The extent is always defined for stored functions and can also be
    computed for derived functions through their function definitions.
    The extent of a derived function may not be computable, *unsafe*, in
    which case the extent function returns nothing.

    The extent of a foreign function is always empty.

    The extent of a [generic](#overloaded-functions%20) function is the
    union of the extents of its resolvents.
