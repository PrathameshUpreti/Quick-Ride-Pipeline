{{ config(materialized='view') }}


with source as(
    select * from {{ source('raw','payments')}}

),

cleaned as(
    select trip_id,
    trim(payment_type) as payment_type,
    coalesce(amount,0) as amount,
    coalesce(tip,0) as tip,
    amount + tip as total_amount

from source

),
dedup as (
    select * , row_number() over ( partition by trip_id order by total_amount desc) as rn
    from cleaned

)
select * from dedup
where rn=1
