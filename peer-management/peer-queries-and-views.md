# Peer queries and views

Once you have established connections to sa.amos peers you can define views of data from your peers. You first have to import the meta-data about selected types and functions from the peers. This is done by defining *proxy types* and *proxy functions* [^RJK03] using the system function `import_types`:

`import_types(Vector of Charstring typenames,  Charstring p)-> Bag of Type pt`

Defines proxy types `pt` for types named `typenames` in peer `p`. Proxy functions are defined for the functions in `p` having the imported types as only argument. Inheritance among defined proxy types  is imported according to the corresponding  inheritance relationships between imported types in the peer `p`.

Once the proxy types and functions are defined they can transparently be queried. Proxy types can be references using `@` notation to reference types in other peers. For example:

`select name(p) from Person@p1;`

Selects the `name` property of objects of type Person in peer `p1`.

`import_types` only imports those functions having one of `typenames` as its single arguments. You can import other functions using system function `import_func`:

`import_func(Charstring fn, Charstring p)->Function pf`

imports a function named `fn` from peer `p` returning proxy function `pf`.

On top of the imported types object-oriented multi-peer views can be defined, as described in [^RJK03] consisting of derived types [^JR99a] whose extents are derived through queries intersecting extents of other types, and IUTs [^JR99b] whose extents reconciles unions of other type extents. Notice that the implementation of IUTs is limited. (In particular the system flag `latebinding('OR');` must be set before IUTs can be used and this may cause other problems).
