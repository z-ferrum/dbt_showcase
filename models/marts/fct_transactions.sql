-- The model is identical to int_transactions
-- int_transactions 'layer' is created so that dim_stores references an intermediate table instead of a fact table as a matter of good practice.
-- Int transactions model is materialized at 'table' since it's being referenced multiple times and includes large join
-- Fct transactions model is materialized as 'view' (not a general practice) since it doesn't include any operations and just provides a proper "window" to the data
-- Such approach should not affect performance even with large data, as snowflake should be able to pass filters through the view when executing querries, subject to testing/profiling.
-- Might make sence to split successful and other transactions into separate models as successful transactions are referenced a lot more ofter, subject to testing.
  
{{ config(materialized='view') }}

select * from {{ ref ('int_transactions') }}