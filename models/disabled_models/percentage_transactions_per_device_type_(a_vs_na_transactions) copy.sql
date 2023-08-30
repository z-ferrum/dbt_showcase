with accepted_transactions as (
    select * from {{ ref ('fct_transactions') }}
    where status = 'accepted'  -- deviation from best practice to improve readability
),
non_accepted_transactions as (
     select * from {{ ref ('fct_non_accepted_transactions') }}
),
devices as (
    select * from {{ ref ('dim_devices') }}
),
accepted_transactions_by_device_type as (
    select
        device_type_id,
        count(accepted_transactions.id) as accepted_transactions_count
    from accepted_transactions
    group by 1
),
non_accepted_transactions_by_device_type as (
    select
        device_type_id,
        count(non_accepted_transactions.id) as non_accepted_transactions_count
    from non_accepted_transactions
    group by 1
),
all_transactions_by_device_type as (
    select 
        accepted_transactions_by_device_type.device_type_id,
        accepted_transactions_count,
        non_accepted_transactions_count
    from accepted_transactions_by_device_type
    left join non_accepted_transactions_by_device_type on accepted_transactions_by_device_type.device_type_id = non_accepted_transactions_by_device_type.device_type_id
),
final as (
    select
        all_transactions_by_device_type.device_type_id,
        round(accepted_transactions_count::float / (accepted_transactions_count + non_accepted_transactions_count),2) as accepted_transactions_percentage  -- keeps % with 2 decimals (represented as part of 1, not 100)
    from all_transactions_by_device_type
    order by accepted_transactions_percentage desc
)

select * from final