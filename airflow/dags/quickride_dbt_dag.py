from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    "owner": "prathamesh",
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
    "email": ["prathameshupreti1@gmail.com"],
    "email_on_failure": True,
    "email_on_retry": True,
}


with DAG(
    dag_id="quickride_dbt_pipeline",
    start_date= datetime(2024,1,1),
    schedule="@daily",
    catchup=False,
    default_args=default_args,
    tags=["quickride", "dbt", "snowflake"],

) as dag:
    
    start = BashOperator(
        task_id="start",
        bash_command="echo 'Starting QuickRide DBT Pipeline'"
    )

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command="cd /opt/airflow/dbt && dbt deps"
    )
    

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/airflow/dbt && dbt run"
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/airflow/dbt && dbt test"
    )

    end = BashOperator(
        task_id="end",
        bash_command="echo 'Pipeline finished successfully'"
    )

    start >> dbt_deps >> dbt_run >> dbt_test >> end

    