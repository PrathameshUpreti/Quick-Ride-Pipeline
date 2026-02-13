{{config(materialized='table')}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['city','weather_date']) }} as weather_sk,
    weather_date,
    city,
    weather_condition,
    traffic_level
FROM {{ ref('stg_weather') }}