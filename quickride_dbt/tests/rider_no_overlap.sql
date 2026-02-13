with ordered as (
    select
        rider_id,
        dbt_valid_from,
        dbt_valid_to,

        lead(dbt_valid_from) over (
            partition by rider_id
            order by dbt_valid_from
        ) as next_valid_from

    from {{ ref('rider_snapshot') }}
)
select *
from ordered
where dbt_valid_to is not null
and dbt_valid_to > next_valid_from