{% macro run_operation_create_udfs() -%}
  -- データセットを作成
  {% set target_dataset = target.dataset if is_github_pr_ci() or is_not_prod() else target.dataset + '_udfs' %}
  {% set create_udf_dataset_query -%}
    create schema if not exists `{{ target.project }}`.`{{ target_dataset }}`
    options (
      description = 'dbtで運用し利用しているUDFを格納するデータセット',
      location = '{{ target.location }}'
    );
  {%- endset %}
  {%- do run_query(create_udf_dataset_query) -%}

  -- ユーザー定義関数(UDF) を作成
  {% for udf in var('udfs') -%}
    {%- do run_query(context[udf](create_udf=true)) -%}
    {{ log("UDF Creation [" ~ target_dataset ~ "." ~ udf ~ "] has succeeded", info=True) }}
  {% endfor %}
{%- endmacro %}
