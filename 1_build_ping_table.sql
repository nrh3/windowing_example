-- Illustration of use of postgresql window functions arising from Real Life by Nat Howard as an example for Stephen Frost.

-- for reproducible results -- we set the random seed, and instead of "now()" we'll use '2018-03-06 21:54:12.857133+00'::timestamptz

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
        '2018-03-06 21:54:12.857133+00'::timestamptz  as max
        , array['2018-03-06 21:54:12.857133+00'::timestamptz - '1 year'::interval, '2018-03-06 21:54:12.857133+00'::timestamptz - '390 days'::interval] as start_range
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
-- Now the ping table is loaded, simulate a bunch of data "droughts" by a couple of random things
-- For example, just six months ago, we had a two-day outage:
delete from incoming_pings where when_pung between '2018-03-06 21:54:12.857133+00'::timestamptz - '6 months 2 days'::interval and '2018-03-06 21:54:12.857133+00'::timestamptz - '6 months'::interval;

-- And then, because of a peculiar habit of a lab technician we hired a month ago (he prefers to use all the internet bandwidth  between 
-- 8pm and midnight on thursdays) we are also experiencing outages then.

delete   from incoming_pings where extract(dow from when_pung) = 4 and extract(hour from when_pung)  between 20 and 23 and when_pung > '2018-03-06 21:54:12.857133+00'::timestamptz - '1 month'::interval ;


