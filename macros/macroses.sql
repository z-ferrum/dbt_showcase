-- Override default_schema prefix for all objects
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}


-- Cleas product_sku
{% macro clean_product_sku(column_name) %}
  (case 
    when left({{ column_name }}, 1) = 'v'  -- scanning just first letter should be faster than scanning the whole string with replace/regex, 
                                           -- check if trimming is faster (subject to profiling for a specific db)
                                           -- check if regex against all non-numercial characters is not too heavy on snowflake
    then right({{ column_name }}, len({{ column_name }}) - 1)
    else {{ column_name }}
  end)::bigint
{% endmacro %}