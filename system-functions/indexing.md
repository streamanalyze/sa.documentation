# Indexing

The system supports indexing on any single argument or result of a
stored function. Indexes can be *unique* or *non-unique*. A unique
index disallows storing several values for the indexed argument or
result. The cardinality constraint `key` of stored functions
([Cardinality Constraints](../amosql/updates.md#cardinality-constraints)) is implemented
as unique indexes. By default the system puts a unique index on the
first argument of stored functions. That index can be made non-unique
by suffixing the first argument declaration with the keyword `nonkey`
or specifying `Bag of` for the result, in which case a non-unique
index is used instead.

For example, in the following function there can be only one name per person:
```
   create function name(Person)->Charstring as stored;
```
By contrast, `names()` allow more than one name per person:
```
   create function names(Person p)->Bag of Charstring nm as stored;
```

Any other argument or result declaration can be suffixed with the
keyword `key` to indicate the position of a unique index. For example,
the following definition puts a unique index on *nm* to prohibit two
persons to have the same name:
```
   create function name(Person p)->Charstring nm key as stored;
```

Indexes can also be explicitly created on any argument or result with a
procedural system function `create_index()`:
```
   create_index(Charstring fn, Charstring arg, Charstring index_type,
                Charstring uniqueness)
```
For example:
```
   create_index("person.name->charstring ", "nm ", "hash ", "unique ");
   create_index("names ", "charstring ", "mbtree ", "multiple ");
```
The parameters of `create_index()` are:

`fn`: The name of a stored function. Use the resolvent name for
[overloaded](../amosql/defining-functions.md#overloaded-functions) functions.

`arg`: The name of the argument/result parameter to be indexed. When
unambiguous, the names of types of arguments/results can also be used
here.

`index_type`: The kind of index to put on the argument/result. The
supported index types are currently hash indexes (type *hash*),
ordered main-memory B-tree indexes (type *mbtree*), and X-tree
multidimensional indexes (type *xtree*). The default index for
key/nonkey declarations is `hash`.

`uniqueness`: Index uniqueness indicated by `unique` for unique
indexes and `multiple` for non-unique indexes.

Descriptors of all indexes for a resolvent `f` can be retrieved by:
```
   indexes(Function f) -> Bag of Vector
```
`indexes()` will return vectors containing `create_index()` parameters for all indexes on function `f`.

Indexes are deleted by the procedural system function:
```
   drop_index(Charstring functioname, Charstring argname);
```
The meaning of the parameters are as for function
`create_index()`. There must always be at least one index left on each
stored function and therefore the system will never delete the last
remaining index on a stored function.

To save space it is possible to delete the default index on the first argument of a stored function. For example, the following stored function maps parts to unique identifiers through a unique hash index on the identifier:
```
   create type Part;

   create function partid(Part p) -> Integer id as stored;
```
`partid()` will have two indexes, one on `p` and one on `id`. To drop the index on `p` do the following:
```
   drop_index('partid', 'p');
```
