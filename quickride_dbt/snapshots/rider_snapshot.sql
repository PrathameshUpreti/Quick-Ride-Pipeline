{% snapshot rider_snapshot %}

{{
    config(
        target_schema='SNAPSHOT',
        unique_key='rider_id',
        strategy='timestamp',
        updated_at='signup_date'

    )
}}

select * from {{ source('raw','riders')}}

{% endsnapshot %}
