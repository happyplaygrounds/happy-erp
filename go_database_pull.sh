# export from Heroku
psql "$(heroku config:get DATABASE_URL -a happy-erp-prod)" -c "\copy public.happy_customer_companies to 'happy_customer_companies.csv' csv header"
psql "$(heroku config:get DATABASE_URL -a happy-erp-prod)" -c "\copy public.happy_customers to 'happy_customers.csv' csv header"

# import to local
#psql "postgres://localhost/local_db_name" -c "\copy public.table1 from 'table1.csv' csv header"
#psql "postgres://localhost/local_db_name" -c "\copy public.table2 from 'table2.csv' csv header"

