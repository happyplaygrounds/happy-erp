curl -i -X POST https://happy-erp-staging-06aaab13bac9.herokuapp.com/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "brian.collins@happyplaygrounds.com",
      "password": "Happy-8601"
    }
  }'

