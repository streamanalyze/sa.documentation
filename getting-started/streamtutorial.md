# Streams

Start the sa.engine app.
Enter the examples below into the command field and observe the effects.

__Execute numerical expressions__
```sql
1+2

1+2*sqrt(4)

sin(3.2)+ln(2.1)

max(1,2);

roundto(sin(3.2)+ln(2.1),2)

```

__Documentation of function `roundto()`__

```sql
doc("roundto")
```

__Form a vector of three numbers__
```sql
{1,2,3}
```

__Vector arithmetics__

```sql
{1,2,3}+{4,5,6}

{1,2,3}*{4,5,6}

5*{1,2,3}

{1,2,3}/4

{1,2,3}.*{4,5,6}

{1,2,3}./{4,5,6}
```

__Form the bag (set with duplicates) of all numbers between 1 and 10__

```sql
iota(1,10)
```

__Add one to elements of a bag__

```sql
iota(1,10)+1
```

__Arithmetics over elements of a bag__

```sql
sin(iota(1,10))+1
```

__Visualize a bag of numbers__

```sql
sin(iota(1,100))
```

__Run a stream returning a number every 0.5 seconds__

Terminate the result rendering by pressing the Stop button.

```sql
heartbeat(0.5)
```

__Visualize the following faster stream of numbers__

```sql
sin(heartbeat(0.1))
```

__Make a function mixing sinus values__

```sql
create function mymix(Number x) -> Number
  as sin(1.1*x)+sin(1.7*x)+sin(2.8*x)
```

__Visualize a mixed sinus stream__
```sql
mymix(heartbeat(0.1))
```

__Run a stream of tumbling windows__
```sql
winagg(mymix(heartbeat(0.1)),5,5)
```

__Visualize moving average of tumbling window having 5 elements every 0.05 s__
```sql
vavg(winagg(mymix(heartbeat(0.01)),5,5))
```

__Visualize moving average of sliding window having 10 elements every 0.05 s__
```sql
vavg(winagg(mymix(heartbeat(0.01)),10,5))
```

