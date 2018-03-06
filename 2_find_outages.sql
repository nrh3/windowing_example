-- Here is the query you use to find the outages -- that is, periods of more than two hours with no ping.

-- The core of the answer is this: 

-- select when_pung, when_pung - lag(when_pung)  over ( order by when_pung)  from incoming_pings;
-- which will give you an answer that starts like this:



-- The final answer, which is a select-within-a-select to as to conveniently relabel things and 
-- avoid having to refer to a window function item within a where clause is this:

select when_pung as time_drought_ended, time_since_last_ping as how_long_drought_was  from 
	( select when_pung, when_pung - lag(when_pung)  over ( order by when_pung)  as time_since_last_ping  from incoming_pings) as x 
where time_since_last_ping > '2 hours'::interval;


