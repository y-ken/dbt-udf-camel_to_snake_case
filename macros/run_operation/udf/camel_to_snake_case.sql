{% macro camel_to_snake_case(input, create_udf=false) -%}
  {%- set target_dataset = target.dataset if is_github_pr_ci() or is_not_prod() else target.dataset + '_udfs' -%}
  {%- if create_udf -%}
    create or replace function `{{target.project}}`.`{{ target_dataset }}`.`camel_to_snake_case`(input STRING)
    returns string
    language js 
    options (description="camelCaseをsnake_caseにする文字列変換UDFです。\n\nex)\n* createdAt -> created_at\n* isEnabledDM -> is_enabled_dm\n* dynamicLinkRESTApiKey -> dynamic_link_rest_api_key")
    as """
      return input.replace(/([a-z0-9])([A-Z])/g, '$1_$2')
                  .replace(/([A-Z])([A-Z][a-z])/g, '$1_$2')
                  .toLowerCase();
    """;
  {%- else -%}
    `{{ target.project }}`.`{{ target_dataset }}`.`camel_to_snake_case`({{ input }})
  {%- endif %}
{%- endmacro -%}
{%- macro test_camel_to_snake_case() -%}
with test_datalab_hmac_signature as (
  select
      test_cases.test_camel_case,
      test_cases.expected_result,
      {{ camel_to_snake_case('test_cases.test_camel_case') }} as actual_result
  from 
      UNNEST(ARRAY<STRUCT<test_camel_case STRING, expected_result STRING>>[
      ('createdAt', 'created_at'),
      ('isEnabledDM', 'is_enabled_dm'),
      ('dynamicLinkRESTApiKey', 'dynamic_link_rest_api_key')
    ]) AS test_cases
)
select * from test_datalab_hmac_signature where actual_result != expected_result
{%- endmacro -%}
