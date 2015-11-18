# The SQL processor

sa.amos databases can be manipulated using SQL as an alternative to AmosQL. The SQL preprocessor translates SQL commands to corresponding AmosQL statements. The SQL preprocessor is called using a special foreign function:
```sql
sql(Charstring query)->Bag of vector result
```
To make it possible to use an sa.amos function in SQL queries, its name must be prefixed with `sql:`. Thus an sa.amos function whose name is `sql: <table>` is regarded from SQL as a table named `<table>` and can be queried and updated using SQL statements passed as argument to the foreign function sql.

For example, assume we define the stored functions:
```
create function sql:employee(Integer ssn) -> (Charstring name, Number Income, Integer dept) as stored;
create function sql:dept(Integer dno) -> Charstring dname as stored;
```

Then we can populate the tables by the following calls to the sql function:
```sql
sql("insert into employee values (12345, "Kalle", 10000, 1)");
sql("insert into employee values (12386, "Elsa", 12000, 2)");
sql("insert into employee values (12493, "Olof", 5000, 1)");
sql("insert into dept values(1,"Toys")");
sql("insert into dept values(2,"Cloths")");
```
Examples of SQL queries are:
```sql
sql("select ssn from employee where name = "Kalle"");
sql("select dname from dept, employee where dept = dno and name="Kalle"");
```  

The parser is based on the SQL-92 version of SQL. Thus, the SQL processor allows an sa.amos database be both updated and queried using SQL-92. The parser passes most of the SQL-92 validation test.  However, SQL views are not supported. For further details see http://www.it.uu.se/research/group/udbl/Theses/MarkusJagerskoghMSc.pdf.
The command line option
```
sa.amos ... -q sql...
```
will make sa.amos accept SQL as query language in the top loop rather than AmosQL.
