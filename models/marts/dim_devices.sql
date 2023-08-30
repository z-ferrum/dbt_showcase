with devices as (
    select * from {{ ref ('stg_devices') }}
),
final as (
    select 
        id,
        type_id,
        store_id
    from devices
)

select * from final