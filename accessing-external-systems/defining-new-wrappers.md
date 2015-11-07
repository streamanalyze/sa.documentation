# Defining new wrappers

Wrappers make data sources queryable. Some wrapper functionality is completely data source independent while other functionality is specific for a particular kind of data source. Therefore, to share wrapper functionality sa.amos contains a type hierarchy of wrappers. In this section we describe common functionality used for defining any kind of wrapper.

## Data sources

Objects of type *Datasource* describe properties of different kinds of data sources accessible through sa.amos. A wrapper interfacing a particular external data manager is defined as a subtype of *Datasource*. For example, the types *Amos*, *Relational*, and *Jdbc* define interfaces to sa.amos peers, relational databases, and relational data bases accessed through JDBC, respectively. These types are all subtypes of type *Datasource*. Each *instance* of a data source type represents a particular database of that kind, e.g. a particular relational database accessed trough JDBC are instances of type *Jdbc*.

## Mapped types

A *mapped type* is a type whose instances are identified by a *key* consisting of one or several other objects [^FR97]. Mapped types are needed when proxy objects corresponding to external values from some data source are created in a peer. For example, a wrapped relational database may have a table PERSON(SSN,NAME,AGE) where SSN is the key. One may then wish to define a mapped type named *Pers* representing proxy objects for the persons in the table. The instances of the proxy objects are identified by an SSN. The type *Pers* should furthermore have the following property functions derived from the contents of the wrapped table `PERSON`:

```sql
ssn(Pers)->Integer
name(Pers)->Charstring
age(Pers)->Integer
```

 The instances and primary properties of a mapped type are defined through a *source function* that returns these as a set of tuples, one for each instance. In our example the source function should return tuples of three elements `(ssn,name,age)`. The [relational database wrapper](#relational) will automatically generate  a source function for table PERSON (type `Pers`) with signature:

```
pers_cc()->Bag of (Integer ssn, Charstring name, Integer age) as ...
```

A mapped type is defined through a system function with signature:

```
create_mapped_type(Charstring name, Vector keys, Vector attrs, Charstring ccfn)-> Mappedtype
```

where:

 - `name` is the name of the mapped type\
 - `keys` is a [vector](#vector) of the names of the keys identifying each instance of the mapped type.
 - `attrs` is a vector of the names of the properties of the mapped type.
 - `ccfn` is the name of the core cluster function.

In our example the relational database wrapper will automatically define the mapped type `Pers` through this call:

```
create_mapped_type("Pers",{"ssn"},{"ssn","name","age"},"pers_cc");
```

Notice that the implementor of a mapped type must guarantee key uniqueness.
Once the mapped type is defined it can be queried as any other type, e.g.:

```
select name(p) from Pers p where age(p)>45;
```

## Type translation

Types in a specific data source are translated to corresponding types in sa.amos using the following system functions:

```
amos_type(Datasource ds, Charstring native_type_name) -> Type;
wrapped_type(Datasource ds, Type t) -> Charstring typename;
```

The most common relational types *and* their sa.amos counterparts are provided by default. Both functions are stored functions that can be updated as desired for future wrappers.
