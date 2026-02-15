{{ config(
    materialized='incremental',
    unique_key='trip_id',
    incremental_strategy='merge',
    cluster_by=['trip_date']
) }}

with trips as (

    select *
    from {{ ref('stg_trips') }}

)

select
    t.trip_id,

    r.rider_sk,
    d.driver_sk,
    date(t.pickup_time) as trip_date,
    t.distance_km,
    t.fare_amount,
    t.surge_multiplier,
    p.amount as payment_amount,
    p.tip,
    t.trip_duration_min,
    t.total_fare

from trips t
left join {{ ref('dim_riders') }} r
       using (rider_id)

left join {{ ref('dim_drivers') }} d
       using (driver_id)

left join {{ ref('stg_payments') }} p
       using (trip_id)

left join {{ ref('dim_weather') }} w
       on date(t.pickup_time) = w.weather_date
      and d.city = w.city
      
{% if is_incremental() %}
where date(t.pickup_time) >= (
    select max(ft.trip_date)
    from {{ this }} as ft
)
{% endif %}