# The SQL processor

Amos II databases can be manipulated using SQL as an alternative to
AmosQL. The SQL preprocessor translates SQL commands to corresponding
AmosQL statements. The SQL preprocessor is called using a special
foreign function:\

    sql(Charstring query)->Bag of vector result

<span style="font-family: Times New Roman;"> </span>

To make it possible to use an Amos II function in SQL queries, its name
must be prefixed with ' <span style="font-family:
          monospace;">sql:</span>'. Thus an Amos II function whose name
is <span style="font-family: monospace;">sql:</span> <span
style="font-style: italic;">&lt;table&gt;</span> is regarded from SQL as
a table named <span style="font-style: italic;">&lt;table&gt;</span> and
can be queried and updated using SQL statements passed as argument to
the foreign function <span style="font-style:
          italic;">sql</span>.\
\
 For example, assume we define the stored functions:\

    create function sql:employee(Integer ssn) -> (Charstring name, Number Income, Integer dept) as stored;

<span style="font-family: Times New Roman;"></span>

    create function sql:dept(Integer dno) -> Charstring dname as stored;




<span style="font-family: Times New Roman;"> </span>

Then we can populate the tables by the following calls to the sql
function:\

    sql("insert into employee values (12345, "Kalle", 10000, 1)");

<span style="font-family: Times New Roman;"></span>

    sql("insert into employee values (12386, "Elsa", 12000, 2)");

<span style="font-family: Times New Roman;"></span>

    sql("insert into employee values (12493, "Olof", 5000, 1)");

<span style="font-family: Times New Roman;"></span>

    sql("insert into dept values(1,"Toys")");

<span style="font-family: Times New Roman;"></span>

    sql("insert into dept values(2,"Cloths")");




<span style="font-family: Times New Roman;"> </span>

Examples of SQL queries are:\

    sql("select ssn from employee where name = "Kalle"");

<span style="font-family: Times New Roman;"></span>

    sql("select dname from dept, employee where dept = dno and name="Kalle"");




<span style="font-family: Times New Roman;"> </span>

The parser is based on the SQL-92 version of SQL. <span
style="font-family: Times New Roman;">Thus, the SQL processor allows an
Amos II database be both updated and queried using SQL-92. The
parser</span> passes most of the SQL-92 validation test.  However, SQL
views are not supported. For further details see
<http://www.it.uu.se/research/group/udbl/Theses/MarkusJagerskoghMSc.pdf>.\

The command line option\

     amos2 ... -q sql...

<span style="font-family: Times New Roman;"> </span>

will make Amos II accept SQL as query language in the top loop rather
than AmosQL.\
