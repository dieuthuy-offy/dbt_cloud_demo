
{{
    config 
        (materialized = 'table')
}}

WITH source AS (

    SELECT
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount
    FROM 
        dbt_cloud.raw_schema.orders

),

transformed AS (

    SELECT
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount,
    FROM source
    WHERE order_status != 'Cancelled'

)

SELECT * FROM transformed