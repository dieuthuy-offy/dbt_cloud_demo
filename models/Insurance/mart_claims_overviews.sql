{{ config(
    materialized='table',
    tags=['insurance','mart']
) }}

with
claims   as (select * from {{ ref('stg_claims') }}),
policies as (select * from {{ ref('stg_policies') }}),
cust     as (select * from {{ ref('stg_customers') }}),
veh      as (select * from {{ ref('stg_policy_vehicles') }}),
prop     as (select * from {{ ref('stg_policy_properties') }}),

joined as (
    select
        c.claim_id,
        c.policy_id,

        p.customer_id,
        cust.full_name as customer_name,
        cust.state as customer_state,

        p.policy_type,
        p.state as policy_state,
        p.effective_date,
        p.expiration_date,
        p.status as policy_status,
        p.annual_premium,
        p.deductible,
        p.coverage_limit,
        p.risk_score,
        p.is_active,
        p.policy_term_days,

        c.cause_of_loss,
        c.claim_amount,
        c.paid_amount,
        c.paid_ratio,
        c.status as claim_status,
        c.claim_date,
        c.reported_date,
        c.closed_date,
        c.days_to_close,

        /* nullable theo policy_type */
        v.vehicle_make,
        v.vehicle_model,
        v.vehicle_year,
        pr.property_type,
        pr.year_built,
        pr.sqft,
        pr.estimated_value
    from claims c
    join policies p on p.policy_id = c.policy_id
    join cust on cust.customer_id = p.customer_id
    left join veh v on v.policy_id  = p.policy_id and p.policy_type = 'Auto'
    left join prop pr on pr.policy_id = p.policy_id and p.policy_type = 'Home'
)
select * from joined
