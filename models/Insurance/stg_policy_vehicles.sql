{{ config(
    materialized='view',
    tags=['insurance']
) }}

with base as (
    select * from {{ source('raw','policy_vehicles_raw') }}
),
clean as (
    select
        trim(policy_id)                 as policy_id,
        initcap(trim(vehicle_make))     as vehicle_make,
        initcap(trim(vehicle_model))    as vehicle_model,
        try_to_number(vehicle_year)     as vehicle_year,
        upper(trim(vin))                as vin,
        try_to_number(annual_mileage)   as annual_mileage,
        initcap(trim(usage))            as usage
    from base
),
dedup as (
    select *
    from clean
    qualify row_number() over (partition by policy_id order by policy_id) = 1
)
select * from dedup