{{ config(materialized='view') }}

{{ config(materialized='view') }}

with source as (
 select * from {{ source('raw','riders') }}
),
cleaned as (
    select rider_id,
        trim(name) as rider_name,
        upper(trim(city)) as city,
        cast(signup_date as timestamp) as signup_date,
        coalesce(rating, 0) as rating
    from source
),
dedup as (
    select *,row_number() over ( partition by rider_id order by signup_date desc
           ) as rn
    from cleaned
)

select *
from dedup
where rn = 1