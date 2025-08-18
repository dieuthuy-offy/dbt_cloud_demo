{{ config(materialized='view', tags=['insurance']) }}

with src as (
  select * from {{ source('raw','claims_raw') }}
),

clean as (
    select
        trim(claim_id)                                as claim_id,
        trim(policy_id)                                as policy_id,
        initcap(trim(policy_type))                     as policy_type,   -- Auto/Home
        upper(trim(state))                             as state,
        initcap(trim(cause_of_loss))                   as cause_of_loss,
        CAST(claim_amount AS NUMBER(38,2))             as claim_amount,
        CAST(paid_amount  AS NUMBER(38,2))              as paid_amount,
        try_to_date(claim_date)                        as claim_date,
        try_to_date(reported_date)                     as reported_date,
        initcap(trim(status))                          as status,
        try_to_date(closed_date)                       as closed_date,
        case
            when try_to_number(claim_amount) > 0
            then round(try_to_number(paid_amount) / try_to_number(claim_amount), 4)
            else null
        end                                            as paid_ratio,
        datediff(day, try_to_date(reported_date), coalesce(try_to_date(closed_date), current_date())) as days_to_close
    from src
),
dedup as (
    select *
    from clean
    qualify row_number() over (partition by claim_id order by claim_id) = 1
)

select * from dedup
