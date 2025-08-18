{{ config(
    materialized='view', 
    tags=['insurance']
    ) }}

with src as (
  select * from {{ source('raw','customers_raw') }}
)

select
  customer_id,
  trim(full_name)                                  as full_name,
  {{ normalize_gender('gender') }}                 as gender,
  try_to_date(dob)                                 as dob,
  {{ age_from_dob('dob') }}                        as age,
  lower(email)                                     as email,
  {{ email_is_valid('lower(email)') }}             as is_email_valid,
  upper(state)                                     as state,
  initcap(city)                                    as city,
  lpad(regexp_replace(zip_code,'[^0-9]',''),5,'0') as zip_code,
  annual_income,
  {{ income_band('annual_income') }}               as income_band
from src
