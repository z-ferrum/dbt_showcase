with accepted_transactions as (
    select * from {{ ref ('fct_transactions') }}
),
devices as (
    select * from {{ ref ('dim_devices') }}
),
transactions_by_device_type as (
    select
        device_type_id,
        sum(case when status = 'accepted' THEN 1 ELSE 0 END) AS nb_accepted_transactions,
        sum(case when status != 'accepted' THEN 1 ELSE 0 END) AS nb_non_accepted_transactions
    from accepted_transactions
    group by 1
),
final as (
    select
        transactions_by_device_type.device_type_id,
        round(nb_accepted_transactions::float / (nb_accepted_transactions + nb_non_accepted_transactions),2) as accepted_transactions_rate  -- keeps % with 2 decimals (represented as part of 1, not 100)
    from transactions_by_device_type
    order by accepted_transactions_rate desc
)

select * from final