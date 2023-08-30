with stores as (
    select * from {{ ref ('stg_stores') }}
),
transactions as (
    select * from {{ ref ('int_transactions') }}
),
first_transaction as (
    select
        store_id,
        min(created_at) as first_transaction_at
    from transactions
    group by 1
),
final as (
    select 
        stores.id,
        stores.customer_id,
        stores.name,
        stores.address,
        stores.city,
        stores.country,
        stores.typology,
        first_transaction.first_transaction_at as first_transaction_at,
        case 
            when stores.created_at < first_transaction.first_transaction_at  -- some db require null check, snowflake should not
            then stores.created_at 
            else first_transaction.first_transaction_at 
            end as created_at
    from stores
    left join first_transaction on stores.id = first_transaction.store_id
)

select * from final