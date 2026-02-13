{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw','weather') }}
),

cleaned as (
    select cast(date as date) as weather_date,
    upper(trim(city)) as city,
    upper(trim(weather)) as weather_condition,
    upper(trim(traffic_level)) as traffic_level

from source
),
dedup as (
    select *,row_number() over (
               partition by city, weather_date order by weather_date desc
           ) as rn
    from cleaned
)
select *
from dedup
where rn = 1