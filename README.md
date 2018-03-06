# Postgresql Windowing Example
A postgresql windowing example using lag().

This example is meant to show one of those situations where windowing functions -- in this case, one of the simplest -- is
just what you need.   I contrived the example, which is based on a real need, after watching Stephen Frost of Crunchydata
give a talk about advanced SQL at a Postgresql Meetup.

The problem arose for me when I was trying to find out when a particular service was being disrupted.  All I had was a huge
list of eye-numbing timestamps that looked a little like this:
```
 2017-09-04 12:38:06.964214+00
 2017-09-04 12:55:32.083701+00
 2017-09-04 13:03:56.885379+00
 2017-09-04 14:37:04.28902+00
 2017-09-04 15:33:22.580644+00
 2017-09-04 16:12:06.039596+00
 2017-09-04 17:17:21.973623+00
 2017-09-04 17:49:14.212272+00
 2017-09-04 18:34:57.24335+00
 2017-09-04 20:02:12.193719+00
 2017-09-04 21:18:33.548159+00
 2017-09-06 22:20:56.908141+00
 2017-09-06 22:54:21.034902+00
 2017-09-06 23:30:21.775579+00
 2017-09-07 00:22:58.772906+00
 2017-09-07 01:58:02.629848+00
 2017-09-07 02:02:00.154235+00
 2017-09-07 02:03:45.415593+00
``` 
 
 And I wanted to know whether there were any "droughts" in the data -- times when the incoming pings didn't happen for more
 than two hours.   Did the two-day drought in the list above jump out at you?
 
 1_build_ping_table.sql  is used to construct the incoming_pings table -- a bunch of timestamps like those above, with some
 "holes" punched in it.
 
 You'll probably have to add arguments to "psql", but you  can run it as
 ```
 psql <  1_build_ping_table.sql 
 ```
 2_find_outages.sql contains the query that produces the answer.
 
 ```
 psql <  2_find_outages.sql
 ```
 
 
