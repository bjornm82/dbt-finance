-- Use the `ref` function to select from other model

select *
from {{ ref('my_second_dbt_model') }}
