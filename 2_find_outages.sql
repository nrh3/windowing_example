-- Here is the query you use to find the outages -- that is, periods of more than two hours with no ping.

-- The core of the answer is this: 

-- select when_pung, when_pung - lag(when_pung)  over ( order by when_pung)  from incoming_pings;
-- which will give you an answer that starts like this:

--            when_pung           |        ?column?        
-- -------------------------------+------------------------
--  2017-02-14 22:47:45.256124+00 | 
--  2017-02-14 23:49:58.69385+00  | 01:02:13.437726
--  2017-02-14 23:58:47.676487+00 | 00:08:48.982637
--  2017-02-15 01:06:24.487166+00 | 01:07:36.810679
--  2017-02-15 01:06:48.133524+00 | 00:00:23.646358
--  2017-02-15 02:49:55.658395+00 | 01:43:07.524871
--  2017-02-15 03:54:29.091539+00 | 01:04:33.433144
--  2017-02-15 05:02:32.368627+00 | 01:08:03.277088
-- 



-- The final answer, which is a select-within-a-select so as to conveniently relabel things and 
-- avoid having to refer to a window function item within a where clause is this:

select when_pung - time_since_last_ping as when_drought_began, 
       when_pung as time_drought_ended, 
       time_since_last_ping as how_long_drought_was  from 
	( select when_pung, 
	  when_pung - lag(when_pung)  over ( order by when_pung)  as time_since_last_ping  
          from incoming_pings)
	as x
where time_since_last_ping > '2 hours'::interval order by
when_drought_began;


