-- macros/cleaning.sql

{% macro normalize_gender(col) -%}
case
  when upper({{ col }}) in ('M','MALE') then 'Male'
  when upper({{ col }}) in ('F','FEMALE') then 'Female'
  else 'Unknown'
end
{%- endmacro %}

{% macro email_is_valid(col) -%}
regexp_like({{ col }}, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
{%- endmacro %}

{% macro income_band(col) -%}
case
  when {{ col }} is null then 'Unknown'
  when {{ col }} < 30000 then '<30k'
  when {{ col }} < 60000 then '30k-60k'
  when {{ col }} < 100000 then '60k-100k'
  when {{ col }} < 150000 then '100k-150k'
  else '>=150k'
end
{%- endmacro %}

{% macro age_from_dob(col) -%}
case when try_to_date({{ col }}) is not null
  then datediff('year', try_to_date({{ col }}), current_date())
  else null
end
{%- endmacro %}
