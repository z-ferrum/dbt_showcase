with source_device as (
    select * from {{ ref ('src_device') }}
),

final as (
    select
        id::int as id,
        type::tinyint as type_id,
        store_id::int as store_id
    from source_device
)

select * from final

-- table is assumed not to be too large to limit rows for dev runs