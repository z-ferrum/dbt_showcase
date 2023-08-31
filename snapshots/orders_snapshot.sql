{% snapshot orders_snapshot %}

{{
    config(
      target_database='showcase',
      target_schema='snapshots',
      unique_key='id',

      strategy='check', 
      check_cols=['status'],
      invalidate_hard_deletes=True  
    )
}}

select * from {{ ref('dim_orders') }}

{% endsnapshot %}

 -- since we don't have a reliable updated_at column we use 'check' and not 'timestamp' strategy
 -- "invalidate_hard_deletes" - to track orders that have been deleted