with source_store as (
    select * from {{ ref ('src_store') }}
),

final as (
    select
        id::int as id,
        customer_id::int as customer_id,
        name::varchar(255) as name,
        address::varchar(255) as address,
        city::varchar(255) as city,
        country::varchar(255) as country,
        typology::varchar(255) as typology,
        created_at::timestamp_ntz as created_at
    from source_store
)

select * from final

-- table is assumed not to be too large to limit rows for dev runs