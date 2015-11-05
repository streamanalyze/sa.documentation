# Clustering

Functions can be *clustered* by creating multiple result stored functions, and then each individual function can be defined as a derived function. 
For example, to cluster the properties name and address of persons one can define:  

```sql
create function personprops(Person p) -> 
        (Charstring name,Charstring address) as stored; 
create function name(Person p) -> Charstring nm 
  as select nm
       from Charstring a 
      where personprops(p) = (nm,a); 
create function address(Person p) -> Charstring a 
  as select a
       from Charstring nm 
      where personprops(p) = (nm,a);
```
Clustering does not improve the execution time performance significantly. However, clustering can decrease the database size considerably. 
