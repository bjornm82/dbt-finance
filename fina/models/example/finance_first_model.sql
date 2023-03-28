-- Use the `ref` function to select from other models

{{ config(alias='first_model') }}

select *
from {{ ref('marketing_first_model') }}
where id = 1
