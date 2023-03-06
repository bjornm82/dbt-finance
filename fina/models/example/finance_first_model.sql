-- Use the `ref` function to select from other models

select *
from {{ ref('marketing_first_model') }}
where id = 1
