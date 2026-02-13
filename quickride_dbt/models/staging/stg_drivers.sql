{{ config(materialized='view') }}


with source as (

    select * from {{ source('raw','drivers') }}

),

cleaned as (

    select
        driver_id,

        upper(trim(city)) as city,
        upper(trim(vehicle_type)) as vehicle_type,

        cast(join_date as timestamp) as join_date,

        coalesce(rating, 0) as rating,
        coalesce(experience_years, 0) as experience_years

    from source
),

dedup as (

    select *,
           row_number() over (
               partition by driver_id
               order by join_date desc
           ) as rn
    from cleaned
)

select *
from dedup
where rn = 1