# Temporal functions

Amos II supports three data types for referencing *Time, Timeval,* and
*Date*.\
 Type *Timeval*  is for specifying absolute time points including year,
month, and time-of-day.\
\
 The type *Date* specifies just year and date, and type *Time* specifies
time of day. A limitation is that the internal operating system
representation is used for representing *Timeval* values, which means
that one cannot specify value too far in the past or future.\
\
 Constants of type *Timeval* are written as
|*year-month-day*/*hour:minute*:*second*|, e.g. |1995-11-15/12:51:32|.\
 Constants of type *Time* are written as |*hour*:*minute*:*second*|,
e.g. |12:51:32|.\
 Constants of type *Date* are written as |*year*-*month*-*day*|, e.g.
|1995-11-15|.\
\
 The following functions exist for types *Timeval, Time,* and *Date*:\
\
 `now() -> Timeval`\
 The current absolute time.\
\
 `time() -> Time     `The current time-of-day.\
\
 <span style="font-family: monospace; ">clock() -&gt; Real</span>\
 The number of seconds since the system was started.\
\
 `date() -> Date`\
 The current year and date.\
\

`timeval(Integer year,Integer month,Integer day,               Integer hour,Integer minute,Integer       second) -> Timeval`\
 Construct *Timeval.*\
\
 `time(Integer hour,Integer minute,Integer second) -> Time`\
 Construct *Time.*\
\
 `date(Integer year,Integer month,Integer day) -> Date`\
 Construct *Date.*\
\
 `time(Timeval) -> Time`\
 Extract *Time* from *Timeval.*\
\
 `date(Timeval) -> Date`\
 Extract *Date* from *Timeval.*\
\
 `date_time_to_timeval(Date, Time) -> Timeval`\
 Combine *Date* and *Time* to *Timeval.*\
\
 `year(Timeval) -> Integer`\
 Extract year from *Timeval.*\
\
 `month(Timeval) -> Integer`\
 Extract month from *Timeval.*\
\
 `day(Timeval) -> Integer`\
 Extract day from *Timeval.*\
\
 `hour(Timeval) -> Integer`\
 Extract hour from *Timeval.*\
\
 `minute(Timeval) -> Integer`\
 Extract minute from *Timeval.*\
\
 `second(Timeval) -> Integer`\
 Extract second from *Timeval.*\
\
 `year(Date) -> Integer`\
 Extract year from *Date.*\
\
 `month(Date) -> Integer`\
 Extract month from *Date.*\
\
 `day(Date) -> Integer`\
 Extract day from *Date.*\
\
 `hour(Time) -> Integer`\
 Extract hour from *Time.*\
\
 `minute(Time) -> Integer`\
 Extract minute from *Time.*\
\
 `second(Time) -> Integer`\
 Extract second from *Time.*\
\
 `timespan(Timeval, Timeval) -> (Time, Integer usec)     `Compute
difference in *Time* and microseconds between two time values\
\
