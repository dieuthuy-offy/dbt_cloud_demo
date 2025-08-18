{{ config(materialized='view', tags=['insurance']) }}

with src as (
  select * from {{ source('raw','policies_raw') }}
),
clean as (
    select
        trim(policy_id)                                                as policy_id,
        trim(customer_id)                                              as customer_id,
        initcap(trim(policy_type))                                     as policy_type,   -- Auto/Home
        upper(trim(state))                                             as state,
        try_to_date(effective_date)                                    as effective_date,
        try_to_date(expiration_date)                                   as expiration_date,
        initcap(trim(status))                                          as status,
        initcap(trim(sales_channel))                                   as sales_channel,
        CAST(ROUND(annual_premium, 2) AS NUMBER(38,2)) AS annual_premium,
        CAST(ROUND(deductible, 2)     AS NUMBER(38,2)) AS deductible,
        CAST(ROUND(coverage_limit, 0) AS NUMBER(38,0)) AS coverage_limit,
        CAST(ROUND(risk_score, 0)     AS NUMBER(38,0)) AS risk_score,
        datediff(day, try_to_date(effective_date), try_to_date(expiration_date)) as policy_term_days,
        case
            when current_date() between try_to_date(effective_date) and try_to_date(expiration_date) then true
            else false
        end                                                            as is_active
    from src
),
dedup as (
    select *
    from clean
    qualify row_number() over (partition by policy_id order by policy_id) = 1
)
select * from dedup
