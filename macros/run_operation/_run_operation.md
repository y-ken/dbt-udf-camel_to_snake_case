{% docs run_operation_create_udfs_description %}

## 概要

macros/udf/* で管理している udf を `$ dbt run-operation run_operation_create_udfs` で作成

## 運用方法

下記を実行して、`var('udfs')` で指定した `ユーザー定義関数(UDF)` を作成する。

```shell
$ dbt run-operation run_operation_create_udfs
```

{% enddocs %}
