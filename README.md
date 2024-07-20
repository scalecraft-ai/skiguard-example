# <img src="./docs/snowguard-logo.png" alt="Snowguard" width=40 class="center"/> [Snowguard](https://scalecraft.dev/snowguard)

This repo contains an example of how to use the Snowguard application. It also contains an example Kustomize base to deploy the application to a Kubernetes cluster.

## Quick Start

1. Sign up for a [Snowguard trial account](https://buy.stripe.com/00g6s58je5Xn6T6cMM). You will receive an email with your license key. No payment required for trial.
2. Create a Snowflake user for Snowguard. [Example](./docs/snowguard-account-setup.sql) script.
3. Configure your environment variables. You can use the [.env.example file](./docs/.env.example) as a template.
4. Create a Slackbot and get the token and channel ID. [Slack API](https://api.slack.com/apps). [App manifest example](./docs/slackbot-manifest.json). (Optional)
5. Run the Snowguard application.

    ```bash
    docker run -it --rm \
    -e SNOWFLAKE_ACCOUNT=${SNOWFLAKE_ACCOUNT} \
    -e SNOWFLAKE_USER=${SNOWFLAKE_USER} \
    -e SNOWFLAKE_PASSWORD=${SNOWFLAKE_PASSWORD} \
    -e SNOWFLAKE_WAREHOUSE=${SNOWFLAKE_WAREHOUSE} \
    -e SNOWFLAKE_ROLE=${SNOWFLAKE_ROLE} \
    -e SLACK_TOKEN=${SLACK_TOKEN} \
    -e SLACK_CHANNEL_ID=${SLACK_CHANNEL_ID} \
    -e SNOWGUARD_LICENSE_KEY=${SNOWGUARD_LICENSE_KEY} \
    -p 8088:8088 \
    scalecraft/snowguard:latest
    ```

6. Access the Snowguard account health dashboard at [http://localhost:8088](http://localhost:8088). The default username is `admin` and the default password is `admin`.

## Snowflake Configuration

You will need to create a Snowflake user for Snowguard. The user will need the following permissions on the `SNOWFLAKE` database. You can read more about database roles in the [Snowflake documentation](https://docs.snowflake.com/en/sql-reference/account-usage#account-usage-views-by-database-role). It is also recommended to use a network policy to restrict access to the server where Snowguard is running.
  
```sql
create user snowguard;
alter user snowguard set password = '<password_here>';
create role snowguard;

grant role snowguard to user snowguard;
grant usage on warehouse compute_wh to role snowguard;

use snowflake;

grant database role usage_viewer to role snowguard;
grant database role security_viewer to role snowguard;

-- All password accounts should use a network policy to restrict access.
create network rule snowguard_ingress
  mode = INGRESS
  type = IPV4
  value_list = ('<Snowguard server IP>');

create network policy snowguard
  allowed_network_rule_list = ('snowguard_ingress');

alter user snowguard set network_policy = snowguard;
```

## Slackbot Configuration

You can optionally create a Slackbot to receive notifications from Snowguard. The app manifest below will create a bot with the name `snowguard`. You can use the [Snowguard logo](./docs/snowguard-logo.png) as the bot avatar.

```json
{
    "display_information": {
        "name": "Snowguard",
        "description": "Snowflake security monitoring app",
        "background_color": "#0f0f0f",
        "long_description": "Snowguard monitors Snowflake for abnormal activity and posts alerts to slack for awareness. The following Snowflake activity is monitored.\r\n\r\n* User Deletion\r\n* User Creation\r\n* Number of rows copied out of Snowflake\r\n* Number of copy actions out of Snowflake\r\n* Failed Logins\r\n* Total Logins"
    },
    "features": {
        "bot_user": {
            "display_name": "Snowguard",
            "always_online": true
        }
    },
    "oauth_config": {
        "redirect_urls": [
            "https://slack.com/oauth/v2/authorize?scope=channels:join,chat:write&client_id=7392377040533.7393531471575"
        ],
        "scopes": {
            "bot": [
                "channels:join",
                "chat:write"
            ]
        }
    },
    "settings": {
        "org_deploy_enabled": false,
        "socket_mode_enabled": false,
        "token_rotation_enabled": false
    }
}
```

## Kubernetes Deployment

You can deploy the Snowguard application to a Kubernetes cluster using the Kustomize base in the [k8s directory](./k8s). You will need to create a secret with the environment variables for the Snowguard application. An example secret is provided in the [k8s directory](./k8s/secrets.sh).
