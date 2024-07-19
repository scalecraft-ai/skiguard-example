kubectl create secret generic snowguard \
  -n snowguard \
  --save-config \
  --from-literal=SNOWFLAKE_USER=${SNOWFLAKE_USER} \
  --from-literal=SNOWFLAKE_PASSWORD=${SNOWFLAKE_PASSWORD} \
  --from-literal=SNOWFLAKE_ACCOUNT=${SNOWFLAKE_ACCOUNT} \
  --from-literal=SNOWFLAKE_WAREHOUSE=${SNOWFLAKE_WAREHOUSE} \
  --from-literal=SNOWFLAKE_ROLE=${SNOWFLAKE_ROLE} \
  --from-literal=SLACK_TOKEN=${SLACK_TOKEN} \
  --from-literal=SLACK_CHANNEL_ID=${SLACK_CHANNEL_ID}
