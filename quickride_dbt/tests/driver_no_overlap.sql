with ordered as(
    select driver_id,
       dbt_valid_from,
       dbt_valid_to,

       lead(dbt_valid_from) over( partition by driver_id order by dbt_valid_from) as next_valid
       from {{ ref('driver_snapshot')}}

)
select * from ordered
where dbt_valid_to is not null 
and dbt_valid_to > next_valid