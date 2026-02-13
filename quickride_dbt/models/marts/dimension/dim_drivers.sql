
{{config(materialized='table')}}
select 
{{ dbt_utils.generate_surrogate_key(['driver_id']) }} as driver_sk,
driver_id,
city,
vehicle_type,

rating,
experience_years,
dbt_valid_from,
dbt_valid_to

from {{ref('driver_snapshot')}}
where dbt_valid_to is null