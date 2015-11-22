# Query optimizer tuning

Set the optimization method used for cost-based optimization in
sa.amos to the method named m. 
```
   optmethod(Charstring m) -> Charstring old
```
Three optimization modes for AmosQL
queries can be chosen:
`ranksort`: (default) is fast but not always optimal.  
`exhaustive`: is optimal but it may slow down the optimizer considerably.
`randomopt`: is a combination of two random optimization heuristics:
Iterative improvement and sequence heuristics [^Nas93]. `optmethod` returns the old setting of the optimization method.

Random optimization can be tuned by using the function:
```
   optlevel(Integer i,Integer j);
```
where `i` and `j` are integers specifying number of iterations in
iterative improvement and sequence heuristics, respectively. Default
settings is `i=5` and `j=5`.

Reoptimize function `f`:
```
   reoptimize(Function f) -> Boolean
```

Reoptimize function named `fn`:
```
   reoptimize(Charstring fn) -> Boolean
```
