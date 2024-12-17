-- dbt CloudのGitHub連携CIでセットされる環境変数で、CI環境かどうか判定
{% macro is_github_pr_ci() %}
  {% set pr_id = env_var('DBT_CLOUD_PR_ID', 0) | int %}
  {% do return(pr_id != 0) %}
{% endmacro %}
