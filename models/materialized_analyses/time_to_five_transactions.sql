with accepted_transactions as (
    select * from {{ ref('fct_transactions') }}
    where status = 'accepted' -- deviation from best practice to improve readability
),
stores as (
    select * from {{ ref('dim_stores') }}
),
numbered_transactions as (
    select
        id,
        store_id,
        created_at,
        row_number() over (partition by store_id order by created_at asc) as transaction_number  -- order by transaction_date - check if heavy
    from accepted_transactions
),
fifth_transactions as (
    select * from numbered_transactions
    where transaction_number = 5
),
stores_with_fifth_transactions as (
    select
        stores.id as store_id,
        stores.name as store_name,
        stores.created_at as store_joined_date,
        fifth_transactions.created_at as fifth_transaction_date
    from fifth_transactions
    left join stores on fifth_transactions.store_id = stores.id
),
cte_days_to_fifth_transaction as (
    select
        *,
        datediff('day',store_joined_date,fifth_transaction_date)::int as days_to_fifth_transaction
    from stores_with_fifth_transactions
),
final as (
    select
        round(avg(days_to_fifth_transaction)) as avg_days_to_fifth_transaction
    from cte_days_to_fifth_transaction
)


select * from cte_days_to_fifth_transaction