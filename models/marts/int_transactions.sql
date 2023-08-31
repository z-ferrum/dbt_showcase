{{ config(
    'materialized': 'incremental',
    'unique_key'='id'  -- although transactions are not expected to be updated, it is safer to use a unique key
                       -- just in case of errors from the source system
                       -- for large tables we might gain performance removing this key, subject to testing
) }}
-- having an incremental model joining another model that receives new records introduces a more complex logic

with 

-- SOURCE TABLES
transactions as (
    select * from {{ ref ('stg_transactions') }}
    -- Only insert new transactions created after the last transaction that is already in the model
    -- Placed before the join to avoid joining with the whole table / for some dw could be placed after final
    {% if is_incremental() %}
        where created_at > (select max(created_at) from {{ this }})  -- beware {this} checks records in the courrent, not stg model
    {% endif %}
),
devices as (
    select * from {{ ref ('stg_devices') }}  -- no need for incremental filter here
                                             -- as we left-join to new records only
                                             -- and we need existing device ids as well
),

-- LOGIC
final as (
    select
        transactions.id,
        transactions.device_id,
        transactions.product_sku,
        transactions.status,
        transactions.amount_eurocents,
        transactions.created_at,
        devices.type_id as device_type_id,
        devices.store_id as store_id
    from transactions
    left join devices on transactions.device_id = devices.id  -- joining store and device type ids de-normalizes the data
                                                              -- but since ids are int, it doesn't take much space and storage is often cheaper than computing
                                                              -- yet helps to avoid future joins, as these fields are used in most of the analyses
                                                              -- approx. storage cost: (8 bytes store_id + 1 byte type_id) * 1.000.000.000 rows = 9GB (To be compared with computing cost for all analysis)
  )

select * from final

