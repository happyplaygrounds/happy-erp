
DB_URL="$(heroku config:get DATABASE_URL -a happy-erp-prod)"

pg_dump "$DB_URL" \
  --format=custom \
  --no-owner --no-privileges \
  --table=public.happy_quotes \
  --table=public.happy_quote_lines \
  -f quotes_only.dump

