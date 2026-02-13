{% snapshot driver_snapshot %}

{{
    config(
        target_schema='SNAPSHOT',
        unique_key='driver_id',
        strategy='check',
        check_cols=['city','vehicle_type','rating','experience_years']
    )
}}
select * from {{source('raw','drivers')}}

{% endsnapshot %}