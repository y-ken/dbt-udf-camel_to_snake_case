{% macro run_operation_test_udfs() -%}
  -- ユーザー定義関数(UDF) をテスト
  {% set test_failed = false %}

  {% for udf in var('udfs') -%}
    {%- set query = context['test_'+udf]() -%}
    {%- set results = run_query(query) -%}
    {% if results.rows | length > 0 %}
      {% set test_failed = true %}
      {{ log("UDF Test [" ~ udf ~ "] failed: Query returned " ~ results.rows | length ~ " row(s)", info=True) }}
      {% for row in results.rows %}
        {{ log("Row data: " ~ row, info=True) }}
      {% endfor %}
      {{ log(query, info=True) }}
    {% else %}
      {{ log("UDF Test [" ~ udf ~ "] passed: Query returned no rows", info=True) }}
    {% endif %}
  {% endfor %}

  {% if test_failed %}
    {{ return(1) }}  -- 1つ以上のテストが失敗
  {% else %}
    {{ return(0) }}  -- すべてのテストが成功
  {% endif %}
{%- endmacro %}
