# Temporal functions

sa.amos supports three data types for referencing `Time`, `Timeval`,
and `Date`. Type `Timeval` is for specifying absolute time points
including year, month, and time-of-day. It is internally represented
as number of mictoseconds since 1970-01-01.

The type `Date` specifies just year and date, and type `Time`
specifies time of day. A limitation is that the internal operating
system representation is used for representing `Timeval` values, which
means that one cannot specify value too far in the past or future.

Constants of type `Timeval` are written as
`|year-month-day/hour:minute:second|`, e.g. `|1995-11-15/12:51:32|`.
Constants of type `Time` are written as `|hour:minute:second|`,
e.g. `|12:51:32|`.  Constants of type `Date` are written as
`|year-month-day|`, e.g. `|1995-11-15|`.

The following functions exist for types Timeval, Time, and Date:

The current absolute time:
```
   now() -> Timeval
```

The number of seconds since 1970-01-01
```
   rnow() -> Real
```

The number of seconds since the system was started:
```
   clock() -> Real
```

Compute difference in seconds between two time values `t1` and `t2`:
```
   real(t1) - real(t2)
```

The current time-of-day:
```
   time() -> Time
```

The current year and date:
```
   date() -> Date
```

Construct a Timeval:
```
   timeval(Integer year,Integer month,Integer day,
           Integer hour,Integer minute,Integer second) -> Timeval
```

Construct a Time:
```
   time(Integer hour,Integer minute,Integer second) -> Time
```

Construct a Date:
```
   date(Integer year,Integer month,Integer day) -> Date
```

Extract Time from Timeval:
```
   time(Timeval) -> Time
```

Extract Date from Timeval.
```
   date(Timeval) -> Date
```

Combine Date and Time to Timeval:
```
   date_time_to_timeval(Date, Time) -> Timeval
```

Extract year from Timeval:
```
   year(Timeval) -> Integer
```

Extract month from Timeval:
```
   month(Timeval) -> Integer
```

Extract day from Timeval:
```
   day(Timeval) -> Integer
```

Extract hour from Timeval:
```
   hour(Timeval) -> Integer
```

Extract minute from Timeval:
```
   minute(Timeval) -> Integer
```

Extract second from Timeval:
```
   second(Timeval) -> Integer
```

Extract year from Date:
```
   year(Date) -> Integer
```

Extract month from Date:
```
   month(Date) -> Integer
```

Extract day from Date:
```
   day(Date) -> Integer
```

Extract hour from Time:
```
   hour(Time) -> Integer
```

Extract minute from Time:
```
   minute(Time) -> Integer
```

Extract second from Time:
```
   second(Time) -> Integer
```
