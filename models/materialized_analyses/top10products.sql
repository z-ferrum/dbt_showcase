with transactions as (
    select * from {{ ref ('fct_transactions') }}
    where status = 'accepted'  -- deviation from best practice to improve readability
),
agg_transactions as (
    select
        product_sku,
        sum(amount_eurocents) as amount_eurocents
    from transactions
    group by 1
),
final as (
    select
    *
    from agg_transactions
    order by amount_eurocents desc
    limit 10
)

select * from final