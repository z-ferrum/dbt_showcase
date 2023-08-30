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
        sum(amount_eurocents) as amount_eurocents,
        count(id) as nb_transactions
    from transactions
    group by 1
),
agg_transactions_with_stores as (
    select
        stores.typology as store_typology,
        stores.country as store_country,
        sum(agg_transactions.amount_eurocents) as amount_eurocents,
        sum(agg_transactions.nb_transactions) as nb_transactions
    from agg_transactions
    left join stores on agg_transactions.store_id = stores.id
    group by 1,2
),
final as (
    select
        store_typology,
        store_country,
        (amount_eurocents / nb_transactions)::int as avg_transaction_amount_eurocents  -- since we count in cents, rounding is not needed as such precision is not needed.
                                                                                    -- INT division is faster that floats, ::INT is faster than ROUND()
                                                                                    -- division by 0 is not possible as we have a count of transactions (yet mb makes sense to add in case preceeding logic changes)
    from agg_transactions_with_stores
    order by avg_transaction_amount_eurocents desc  -- generally good practice to sort analytical outputs
)

select * from final  -- mb should format currency.

"""
The model assumes that aggregating transactions by store then joining store data then aggregating again but smaller table is more performant (more operations, but smaller tables)
than joining transactions and stores directly and then aggregating. Subject to test depending on real size data.
"""