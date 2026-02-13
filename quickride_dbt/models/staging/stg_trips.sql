{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'trips')}}

),
cleaned as (
    select
        trip_id,
        rider_id,
        driver_id,
        cast(pickup_time as timestamp)  as pickup_time,
        cast(drop_time as timestamp) as drop_time,
        coalesce(fare_amount, 0) as fare_amount,
        coalesce(distance_km, 0)        as distance_km,
        coalesce(surge_multiplier, 1)   as surge_multiplier,
        coalesce(status, 'UNKNOWN') as status,
        upper(trim(payment_method))     as payment_method,
        datediff(minute, pickup_time, drop_time) as trip_duration_min,
        fare_amount * surge_multiplier as total_fare

from source
where trip_id is not null
),
dedup as(
    select * , row_number() over( partition by trip_id order by pickup_time desc) as rn 
    from cleaned
)
select * from dedup 
where rn=1