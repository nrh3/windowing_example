-- Illustration of use of window functions arising from Real Life by Nat Howard for Stephen Frost  3/6/18.

-- for reproducible results -- we set the random seed

set seed to 0.5;


drop table if exists incoming_pings;

create table incoming_pings (
	when_pung	timestamptz -- not primary key because it could be non-unique in the "real" case!
);


-- Fill the incoming_pings table with timestamps in  generate a list of ascending time stamps
-- Adapted from https://gist.github.com/palpha/8333162 - thanks Palpha!
with recursive t (ts) as (
  with base as (
    with settings as (
      select
        now() as max
        , array[now() - '1 year'::interval, now() - '390 days'::interval] as start_range
        , array['0 seconds'::interval , '2 hours'::interval] as step_range
    )
    select
      (random() * (start_range[2] - start_range[1]) + start_range[1]) as start
      , step_range
      , max
    from settings
  )
  select start from base
  union all
  select ts + (random() * (step_range[2] - step_range[1]) + step_range[1])
  from t cross join base
  where ts < max
)
insert into incoming_pings 
select ts 
from t;

-- You might want to keep this part secret from the audience
-- Now the ping table is loaded, simulate a bunch of data failures by a couple of random things
-- For example, just six months ago, we had a two-day outage:
delete from incoming_pings where when_pung between now() - '6 months 2 days'::interval and now() - '6 months'::interval;

-- And then, because of a peculiar habit of a lab technician we hired a month ago (he prefers to use all the internet bandwidth  between 
-- 8pm and midnight on thursdays) we are also experiencing outages then.

-- select * from incoming_pings where extract(dow from when_pung) = 4 and extract(hour from when_pung) is between 20 and 23 and when_pung > now() - '1 month'::interval ;

delete   from incoming_pings where extract(dow from when_pung) = 4 and extract(hour from when_pung)  between 20 and 23 and when_pung > now() - '1 month'::interval ;


