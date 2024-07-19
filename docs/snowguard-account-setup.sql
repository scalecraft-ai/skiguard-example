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