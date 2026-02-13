{{config(materialized='table')}}

select distinct date(pickup_time) as date_day,
extract(year from pickup_time) as year,
extract(month from pickup_time) as month,
extract(day from pickup_time) as day,
DAYNAME(pickup_time) as weekday

from {{ref('stg_trips')}}