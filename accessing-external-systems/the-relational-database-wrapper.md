# The relational database wrapper

There is a predefined wrapper for relational databases using the JDBC standard Java-based relational database interface. The JDBC wrapper is tested with [MySQL Connector](http://www.mysql.com/products/connector/j/) and Microsoft's SQLServer driver. 

An instance of type *Relational* ** represents a relational database and functions of type *Relational* implements the interface to relational databases. The general wrapper *Relational* is an *abstract* wrapper in the sense that it does not implement an interface a a specific relational DBMS therefore has no instances. Several of the database interface functions of type *Relational* are defined as [*abstract functions*](#abstract-functions). In the type hierarchy  there is a specific implemented wrapper for JDBC represented by type *Jdbc*. The type *Jdbc* has one instance for each relational database JDBC connection. The type hierarchy is currently:

     Datasource

     |

     Relational

     |

     Jdbc

If some other interface than JDBC (e.g. ODBC) is used for a relational
database it would require the implementation of a new wrapper also being
subtype to Relational.
\
 The use of abstract functions  type checking to find equivalent
implementations for different relational database interfaces.\

## Connecting

The instances of relational data sources are created using a *datasource
constructor function* that loads necessary drivers. Later the
*connect()* function associates a connection object to a wrapped database using
the driver.

### Creating connections

For creating a relational database connection using JDBC use the constructor:

 <span style="font-family: monospace;">   jdbc(Charstring dsname,
Charstring driver);\
 </span>where ** *dsname*
is the chosen data source name and *driver<span
style="font-family: monospace;"></span>* is the JDBC driver to use for
the access. The created connection is an instance of the wrapper type
*Jdbc*. For example, to create a connection called 'db1' to access a
relational database using JDBC with MySQL call:\

     jdbc("db1","
          com.mysql.jdbc.Driver");

<span style="text-decoration: underline;">Connecting the data source to
a database</span>\
\
 Once the connection object has been created you can open the connection
to a specific relational database:\

     connect(Relational r, Charstring database, Charstring username, Charstring password) -> Relational

where r</span> is the data source
object, db</span> is the identifier of
the database to access, along with user name and password to use when
accessing the database. For example, if the relational database called
'Personnel' resides on the local computer and MySQL is used for the
managing it, the following opens a connection to the database for user
'U1' with password 'PW':\
\
 <span style="font-family: monospace;">   connect(:db,
"jdbc:mysql://localhost:3306/Personnel", "U1", "PW");</span>\
\
 <span style="text-decoration: underline;">Disconnecting from the
database </span>\
\
 Once the connection is open you can use the data source object for
various manipulations of the connected database. The connection is
closed with:\

     disconnect(Relational r) -> Boolean

for example:\
\
 <span style="font-family: monospace;">   disconnect(:a):\
 </span>\
 <span style="text-decoration: underline;">Finding a named data source
</span>\
\
 To get a relational data source object given its name use:\
\

     relational_named(Charstring nm)-> Relational

for example:\
\
 <span style="font-family: monospace;">   relational\_named("db1");
</span>\

## 6.2.2 Accessing meta-data

Relational meta-data are general information about the tables stored in
a relational database.\
\
 <span style="text-decoration: underline;">Tables in database</span>\
\
 To find out what tables there are in a relational database, use\

     tables(Relational r)

     -> Bag of (Charstring table, Charstring catalog,

     Charstring schema, Charstring owner)

for example

     tables(relational_named("db1"));




The function *tables()* ** returns a bag of tuples describing the tables
stored in the relational database.\
\
\
 To test whether a table is present in a database use:\

     has_table(Relational r, Charstring table_name) -> Boolean




for example\

     has_table(relational_named("db1"),"SALES");

\
 <span style="text-decoration: underline;">Columns in table</span>\
\
 To get a description of the columns in a table use:\

     columns(Relational r, Charstring table_name)

     -> Bag of (Charstring column_name, Charstring column_type)

for example\
\
 <span style="font-family: monospace;">   
columns(relational\_named("db1"),"CUSTOMER");\
\
 </span> <span style="text-decoration: underline;">Size of table</span>\
\
 To find out how many rows there are in a table use:\

     cardinality(Relational r, Charstring table_name) -> Integer

for example\

     cardinality(relational_named("db1"),"SALES");

\
 <span style="text-decoration: underline;">Primary keys of table</span>\
\
 To get a description of the primary keys of a table use:\

     primary_keys(relational r, charstring table_name)

     -> Bag of (charstring column_name, charstring constraint_name)

for example:\

     primary_keys(relational_named("db1"),"CUSTOMER");




\
 <span style="text-decoration: underline;">Foreign keys of table</span>\
\
 To get information about the foreign keys referenced from a table use:\

     imported_keys(Jdbc j, Charstring fktable)

     -> Bag of (Charstring pktable, Charstring pkcolumn, Charstring fkcolumn)

for example\

     imported_keys(relational_named("db1"),"PERSON_TELEPHONES");

The elements of the result tuples denote the following:\

-   `pktable` - The table referenced by the foreign key.
-   `pkcolumn` - The column referenced by the foreign key.
-   `fkcolumn` - The foreign key column in the table.

<span style="font-weight: bold;">NOTICE</span> that composite foreign
keys are not supported.\
\
  To find what keys in a table are exported as foreign keys to some
other table use:\

     exported_keys(Jdbc j, Charstring pktable)

     -> Bag of (Charstring pkcolumn, Charstring fktable, Charstring fkcolumn)

for example\
 <span style="font-family: monospace;">    
exported\_keys(relational\_named("db1"),"PERSON"); </span>\
\
 The elements of the result tuples denote the following:\

-   `pkcolumn` - The primary key column in the table.
-   `fktable` - The table whose foreign key references the table.
-   `fkcolumn` - The foreign key column in the table that references
    the table.

<span style="text-decoration: underline;">Deleting tables</span>\
\
 The function *drop\_table()* deletes a table from a wrapped relational
database:\
 <span style="font-family: monospace;">   \
     drop\_table(Relational r, Charstring name) -&gt; Integer</span>\


## 6.2.3 Executing SQL

<span style="text-decoration: underline;">SQL statements</span>\
\
 The function *sql()* ** executes an arbitrary SQL statement as a
string:

<span style="font-family: monospace;">    sql(Relational r, Charstring
query) -&gt; Bag of Vector results </span>\

The result is a bag of results tuples represented as vectors. If the SQL
statement is an update a single tuple containing one number is returned,
being the number of rows affected by the update. Example:\

<span style="font-family: monospace;">    sql(relational\_named("db1"),
"select NAME from PERSON where INCOME &gt; 1000 and AGE&gt;50");\
\
 </span>

<span style="text-decoration: underline;">Parameterized SQL statements
</span>\

To execute the same SQL statement with different parameters use:\

<span style="font-family: monospace;">    sql(Relational r, Charstring
query, Vector params) -&gt; Bag of Vector results</span>\

The parameters *params* <span style="font-family:
          monospace;"></span> are substituted into the corresponding
occurrences in the SQL statement, for example:\

<span style="font-family: monospace;">    sql(relational\_named("db1"),
"select NAME from PERSON where INCOME &gt; ? and AGE&gt;?", {1000,50));\
\
 </span>\
 <span style="text-decoration: underline;">Loading SQL scripts</span>\
\
 SQL statements in a file separated with ';' can be loaded with:\
\
 <span style="font-family: monospace;">    read\_sql(Relational r,
Charstring filename) -&gt; Bag of Vector</span>\
\
 The result from *read\_sql()* <span
style="font-family: Times New Roman;">is a bag containing the result
tuples from executing the read SQL statements.\
\
 **Hint:** If something is wrong in the script you may trace the calls
inside *read\_sql()*</span> <span style="font-family:
      Times New Roman;"> to *sql()*</span> <span
style="font-family: Times New Roman;"> ** by calling\
 <span style="font-family: monospace;">    trace("sql"); </span>\
  </span>

## Object-oriented views of tables

The relational wrapper allows to to define object-oriented views of data
residing in a relational database. Once the view has been defined the
contents of the database can be used in AmosQL queries without any
explicit calls to SQL.\
\
 To regard a relational table as an sa.amos type use:\

     import_table(Relational r, Charstring table_name) -> Mapped_type

for example

     import_table(relational_named("db1"),"SALES");

The view is represented by a [*mapped type*](#mapped) which is a type
whose extent is defined by the rows of the table. Each instance of the
mapped type corresponds to a row in the table. The name of the mapped
type is constructed by concatenating the table name, the character `_`
and the data source name, for example *Person\_db1*. Mapped type names
are internally capitalized, as for other sa.amos types.\

For each columns in the mapped relational database table
*import\_table()* will generate a corresponding derived *wrapper
function* returning the column's value given an instance of the mapped
type. For example, a table named `person` having the column `ssn` will
have a function

returning the social security number of a person from the imported
relational table.\
\
 The system also allows wrapped relational tables to be transparently
updated using an [update statement](#updates) by importing the table
with:\

     import_table(Relational r,

     Charstring table_name,

     Boolean updatable)

     -> Mappedtype mt

for example\

     import_table(relational_named("db1"),"COUNTRY",true);

If the flag updatable</span> is set to
true the functions in the view are transparently updatable so the
relational database is updated when instances of the mapped type are
created or the extent of some wrapper function updated.  For example:\

     create Country_db1(currency,country) instances ("Yen","Japan");

     set currency(c)= "Yen" from Country_db1 c where country(c)= "Japan";




The most general resolvent of *import\_table()* ** is:\

     import_table(Relational r, Charstring catalog_name,

     Charstring schema_name, Charstring table_name,

     Charstring typename, Boolean updatable,

     Vector supertypes) -> Mappedtype mt

The table resides in the given catalog and schema. If *catalog* is "",
the table is assumed not to be in a catalog. If *schema* is "", the
table is assumed not to be in a schema. ``The parameter *typename* is
the desired name of the mapped type created, as alternative to the
system generated concatenation of table and data source name. ``The
parameter *updatable* gives an updatable mapped type. The parameter
*supertypes``* is a [vector](#vector) of either type names or type
objects, or a mixture of both. The effect is that sa.amos will perceive
the mapped type as an immediate subtype of the supertypes.\

There are also two other variants of *import\_table()*  <span
style="font-family: Times New Roman;">to be used for relational
databases where schema and catalog names need not be specified:\
 </span>

     import_table(Relational r,

     Charstring table_name,

     Charstring typename,

     Boolean updatable,

     Vector supertypes) -> Mappedtype mt

     import_table(Relational r,

     Charstring table_name,

     Charstring type_name,

     Boolean updatable) -> Mappedtype mt






#### Importing many-to-many relationships

All tables in relational databases do not correspond to 'entities' in an
ER diagram and therefore cannot be directly mapped to types. The most
common case is tables representing many-to-many relationships between
entities. Typically such tables have two columns, each of which is a
foreign key imported from two other tables, expressing the many-to-many
relationship between the two. Only entities are imported as types and
special types are not generated for such relationship tables. A
many-to-many relationship in a relational database corresponds to a
function returning a *bag* in AmosQL, and can be imported using
`import_relation()` rather than `import_table()`:

    import_relation(Relational r,

     Charstring table_name, Charstring argument_column_name,

     Charstring result_column_name, Charstring function_name,

     Boolean updatable)

     -> Function




-   `table_name` - the name of the table containing the relation.
-   `argument_column_name` - the name of the column which is argument of
    the function.
-   `result_column_name` - the name of the column which is result of
    the function.
-   `function_name` - the desired name of the function.
-   `updatable` - whether the function should be transparently updatable
    via `set`, `add`, and `remove`.

For example, assume we have two entity types, *person* and *telephone*. Most of the time telephones are not regarded as entities in their own respect since nobody would care to know more about a telephone than its number. However, assume that also the physical location of the telephone is kept in the database, so telephones are an entity type of their own.

A person can be reached through several telephones, and every telephone may be answered by several person. The schema looks as follows:

```
  ------- -------- -------
  ssn     name     ...
  ------- -------- -------

  :  `person`

`person_telephones`

`ssn`

`ext_no`

\

\

\

  ---------- ------------ -------
  `ext_no`   `location`   `...`

  \          \            \

  ---------- ------------ -------

  :  `telephone`

Now, this schema can be wrapped by the following commands:

1.  `import_table(my_relational, 'person');`
2.  `import_table(my_relational, 'telephone');`
3.  `import_relation(my_relational, 'telephone', 'ssn','ext_no','phones', false);`\
4.  `create function phones(person@my_relational p) -> telephone@my_relational t as select t where phones(ssn(p)) = ext_no(t);           `\

Notice that only relationship functions with a single argument and
result can be generated, i.e. composite foreign keys are not supported.\
