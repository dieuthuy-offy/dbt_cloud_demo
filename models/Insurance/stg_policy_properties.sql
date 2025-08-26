{{ config(
    materialized='view',
    tags=['insurance']
) }}

with base as (
    select * from {{ source('raw','policy_properties_raw') }}
),
clean as (
    select
        trim(policy_id)                         as policy_id,
        initcap(trim(property_type))            as property_type,   
        try_to_number(year_built)               as year_built,
        try_to_number(sqft)                     as sqft,
        cast(estimated_value as number(38, 2))  as estimated_value,
        initcap(trim(construction_type))        as construction_type,
        try_to_number(num_stories)              as num_stories,
        initcap(trim(roof_material))            as roof_material
    from base
),
dedup as (
    select *
    from clean
    qualify row_number() over (partition by policy_id order by policy_id) = 1
)
select * from dedup
