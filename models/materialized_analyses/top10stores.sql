with transactions as (
    select * from {{ ref ('fct_transactions') }}
    where status = 'accepted'  -- deviation from best practice to improve readability
),
stores as (
    select * from {{ ref ('dim_stores') }}
),
agg_transactions as (
    select 
        store_id,
        sum(amount_eurocents) as amount_eurocents
    from transactions
    group by 1
),
final as (
    select
        stores.name as store_name,
        agg_transactions.amount_eurocents as amount_eurocents
    from agg_transactions
    left join stores on agg_transactions.store_id = stores.id
    order by amount_eurocents desc
    limit 10
)

select * from final