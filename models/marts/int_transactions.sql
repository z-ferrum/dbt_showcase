with 

-- SOURCE TABLES
transactions as (
    select * from {{ ref ('stg_transactions') }}
),
devices as (
    select * from {{ ref ('stg_devices') }}
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
                                                                  -- yet helps to avoid future joins, as this fields are used in most of the analyses
                                                                  -- approx. storage cost: (8 bytes store_id + 1 byte type_id) * 1.000.000.000 rows = 9GB (To be compared with computing cost for all analysis)
  )

select * from final