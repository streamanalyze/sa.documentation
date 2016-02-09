# Tutorial

Start the sa.amos console top loob by running the executable `sa.amos` in the `bin` folder of the downloaded system.
Cut and paste the examples below and observe the effects.

__Documentation of function `sqrt()`__

```sql
doc("sqrt");
```
__Documentation of all functions whose names contain the string `max`:__

```sql
doc(apropos("max"));
```

__Source code of all functions whose names contain the string `max`__
```sql
sourcecode(apropos("max"));
```

__What system version am I running?__

```sql
system_version();
```

__What folder is my current working direcory?__

```sql
pwd();
```
__What is the home folder of the system I am currently running?__

```sql
startup_dir();
```

__Call built-in arithmetic functions__

```sql
1+2+3;

sqrt(1+2+3);

max(1,2);
```

__Vector arithmetics__

```sql
{1,2,3}+{4,5,6};

{1,2,3}*{4,5,6};

5*{1,2,3};

{1,2,3}/4;

{1,2,3}.*{4,5,6};

{1,2,3}./{4,5,6};
```

__String functions__

```sql
"abra" + "kadabra";

upper("abrakadabra");

substring("abrakadabra",2,4);
```

__Define your own type `Person` with a property `name`__

```sql
create type Department properties
  (name Charstring);
```
__Create three department objects. Set property `name`:__

Bind interface variables :d1, :d2, and :d3 to the created departments

```sql
create Department (name) instances :d1 ("Toys"), :d2 ("Food"), :d3 ("Tools");
```
__Get the names of all departments__

```sql
select name(d) from Department d;
```

__What is the name of the department in variable :d1?__

```sql
name(:d1);
```

__Get the objects representing the departments__

```sql
select d from Department d;
```
__Create type 'Person' with property functions 'name', 'dept', and 'income'__

```sql
create type Person properties
  (name Charstring,
   dept Department,
   income Number);
```

__Create some persons and assign them to departments__

```sql
create Person(name, income, dept) instances
  :p1 ("Maja",    100, :d1),
  :p2 ("Bill",    200, :d2),
  :p3 ("Bull",    300, :d3),
  :p4 ("Pelle",   400, :d1),
  :p5 ("Måns",    500, :d2),
  :p6 ("Olle",    500, :d1),
  :p7 ("Birgitta",600, :d3),
  :p8 ("Murre",   700, :d1);
```

__Get the income of the person in variable :p3__

```sql
income(:p3);
```

__Get the names and incomes of all persons in the database__

```sql
select name(p), income(p) from Person p;
```

__Get the names of persons working in department named 'Toys'__

```sql
select name(p)
  from Person p
 where name(dept(p)) = "Toys";
```

__Get the incomes of the persons ordered decreasingly by income__

```sql
select name(p), income(p)
  from Person p
 order by income(p) desc;
```

__Get the two highest paid persons__

```sql
select name(p), income(p)
  from Person p
 order by income(p) desc
 limit 2;
```

__Get the incomes of all persons earning more that 400 ordered by their names__

```sql
select income(p)
  from Person p
 where income(p) > 400
 order by name(p);
```

__How many persons are there in the database?__

```sql
count(select p from Person p);
```

__What is the total sum of the incomes of all persons?__

```sql
sum(select income(p) from Person p);
```

__What is average of the incomes of all persons?__

```sql
avg(select income(p) from Person p);
```
__What is the standard deviation of the incomes of all persons?__

```sql
stdev(select income(p) from Person p);
```

__Create type 'Account' with properties 'id', 'owner', and 'balance'__

```sql
create type Account properties
  (id Number,
   owner Person,
   balance Number);
```

__Create some accounts and assign them to persons__

```sql
create account(id, owner, balance) instances
  (1,:p1, 150),
  (2,:p1, 200),
  (3,:p2, 400),
  (4,:p2,  85),
  (5,:p2,  70),
  (6,:p3,  10),
  (7,:p5, 500),
  (8,:p6,  75),
  (9,:p6,  95),
  (10,:p7,105),
  (11,:p8, 90);
```

__Get the balances of the accounts of the person named 'Bill'__

```sql
select balance(a)
  from Account a
 where name(owner(a)) = "Bill";
```

__Get the names and account balances of all persons in the 'Toys' department__

```sql
select name(p), balance(a)
  from Person p, Account a
 where name(dept(p)) = "Toys"
   and owner(a) = p;
```

__Count the number of accounts per person in 'Toys' department__

```sql
select name(p), count(a)
  from Person p, Account a
 where name(dept(p)) = "Toys"
   and owner(a) = p
 group by name(p);
```

__Compute total balance of accounts per person in 'Toys' department__

```sql
select name(p), sum(balance(a))
  from Person p, Account a
 where name(dept(p)) = "Toys"
   and owner(a) = p
 group by name(p);
```

__Get the total balances for all persons in the database__

```sql
select name(p), sum(balance(a))
  from Person p, Account a
 where owner(a) = p
 group by name(p);
```

__Get the average incomes and standard deviations per department without showing the departments' names__

```sql
select avg(income(p)), stdev(income(p))
  from Department d, Person p
 where dept(p)=d
 group by d;
```
__Get decreasingly ordered total balances of each person in the database__

```sql
select name(p), sum(balance(a))
  from Person p, Account a
 where owner(a) = p
 group by name(p)
 order by sum(balance(a)) desc;
```

__What are the lowest incomes in each department?__

```sql
select name(d), min(income(p))
  from Department d, Person p
 where dept(p) = d
 group by name(d)
 order by min(income(p));
```

__Get the two departments with highest average incomes with standard deviations__

```sql
select name(d), avg(income(p)), stdev(income(p))
  from Department d, Person p
 where dept(p) = d
 group by name(d)
 order by avg(income(p)) desc
 limit 2;
```

__For each person get the name, department name, income, and total balance, ordered by total balance decreasingly__

```sql
select name(p), name(d), income(p), sum(balance(a))
  from Department d, Person p, Account a
 where owner(a) = p
   and dept(p) = d
 group by name(p), name(d), income(p)
 order by sum(balance(a)) desc;
```

## User defined derived functions

__The following function finds the incomes higher than a given threshold. It is a function returning a bag (set with duplicates) of numbers__

```sql
create function higherIncomes (Number thres) -> Bag of Number
  as select income(p)
       from Person p
      where income(p)>thres;
```

__Call function `highIncomes()`__

```sql
higherIncomes(500);
```

__Function highIncomesPers() returns both names and incomes. It is a function returning a bag of tuples (pairs)__

```sql
create function higherIncomePers (Number thres)
                                -> Bag of (Charstring nm, Number inc)
  as select name(p), inc
       from Number inc, Person p
      where income(p)=inc
        and inc > thres;
```

__Call tuple valued function: Get persons earning more than 100__

```sql
higherIncomePers(500);
```

__The following function returns the k highest paid persons__

```sql
create function highestIncomePers(Number k)
                                -> Bag of (Charstring nm, Number inc)
  as select name(p), income(p)
        from Person p
      order by income(p) desc
      limit k;
```

__Get the tho highest earners__

```sql
highestIncomePers(2);
```

## Collections

### Bags

__The function iota() returns a bag of integers in an interval__

```sql
iota(2,6);
```

__You can assign a variable to a bag valued function__

```sql
set :b = iota(1,10);
:b;
```

__Use in() to extract values from bag__

```sql
in(:b);
```
__Alternatively 'in' operator__

```sql
select x from Number x where x in :b;
```

__Aggregate functions over bags__

```sql
set :b = iota(1,100000);

count(:b);
sum(:b);
avg(:b);
stdev(:b);
maxagg(:b);
minagg(:b);

sum(select n
      from Number n
     where n in :b
     limit 20);
```

__Aggregation over bags__

```sql
set :b2 = iota(1,30);

sum(select x from Number x where x in :b2 and x>7);

set :b3 = (select x from Number x where x in :b2 and x > 7);

sum(:b3);

avg(:b3);
```

### Vectors (ordered collections)

__Set interface variable :v0 to value of query forming a VECTOR {1,2,3,4,5,6,7,8,9,10} by using vselect instead of select__

```sql
set :v0 = vselect i from Number i where i in iota(1,10) order by i;
:v0;
```

__Set :v to the square root of elements in :v0__

```sql
set :v = vselect sqrt(i) from Number i where i in :v0 order by i;
:v;
```

__Basic vector aggregation__

```sql
dim(:v);
vsum(:v);
vavg(:v);
vstdev(:v);
```

__The 'in' operator converts vector to bag__

```sql
select n
  from Number n
 where n in {1,2,3}
   and n >= 2;
```

__Represent coordinates as 2D vectors__

```sql
set :c1 = {1,2};
set :c2 = {3,4};
```

__Euclidean coordinate distance__

```sql
euclid(:c1, :c2);
```

__Vectors can hold objects of any datatype__

```sql
{1,3,{3,4}};
{1,"a",{"b","c"}};
```

__Save database in file mydb.dmp__

```sql
save "mydb.dmp";
```

__After saving the interface variables are lost__

```sql
:b;
```

__Quit sa.amos__

```sql
quit;
```

__Run sa.amos again with the save database__

```
sa.amos mydb.dmp
```

__Inspect the database again__

```sql
higherIncomePers(100);
```
