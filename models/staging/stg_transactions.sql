with source_transaction as (
    select * from {{ ref ('src_transaction') }}
),

final as (
    select
        id::int as id,
        device_id::int as device_id,
        {{ clean_product_sku('product_sku') }} as product_sku, 
        -- Cleans from 'v' in the sku code. (Ctrl + left click on the macro name to see the code)
        -- assumes this 'v' is the only common error in the real data (which is unlikely)
        -- Yet preventing all the possible errors is more compute consuming
        -- Actually, there is no need for a marcos, but I wanted to use a macros somewhere :)
        category_name,  -- not useful, completely random. It is only kept to show it's random with int_products draft.
        product_name,  -- same as category name
        status::varchar(255) as status,  -- may consider switching to TINYINT (with seed-dictionary) or CHAR
        amount::int as amount_eurocents,
        created_at::timestamp_ntz as created_at  -- I've been told to only use created_at for all purposes in the analysis
    from source_transaction
)

select * from final

-- limits records for dev runs. Nb of days to be adjusted based on data volume
-- only placed on stg models, as other will refer to stg
-- for limiting records on multiple models should use date fields instead of "limit",
-- however, in a given dataset date fields seem to be random and model subsets might not 
-- have matching records in downstream models if limited by date fields
-- {% if target.name == 'dev' %}
-- limit 100
-- {% endif %}