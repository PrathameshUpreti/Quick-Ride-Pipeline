{{config(materialized='table')}}

SELECT
   {{ dbt_utils.generate_surrogate_key(['rider_id'])}} as rider_sk,
    rider_id,
    name,
    city,
    rating,
    dbt_valid_from,
    dbt_valid_to
FROM {{ ref('rider_snapshot') }}
where dbt_valid_to is null