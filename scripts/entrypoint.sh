#!/bin/bash
set -x

cat << EOF > /etc/gitlab/gitlab.rb
external_url 'https://${DOMAIN}'
nginx['listen_port'] = 80

nginx['listen_https'] = false

nginx['proxy_set_headers'] = {

"X-Forwarded-Proto" => "https",

"X-Forwarded-Ssl" => "on"

}
gitlab_rails['gitlab_shell_ssh_port'] = ${SSH_PORT}
unicorn['worker_processes'] = 2
sidekiq['concurrency'] = 2
unicorn['worker_timeout'] = 180
nginx['real_ip_header'] = 'X-Real-IP'
nginx['set_real_ip_from'] = '172.20.0.0/12'
postgresql['shared_buffers'] = "1MB"
prometheus_monitoring['enable'] = false
EOF

if [[ ! $(cat /assets/wrapper | grep 'Cylo') ]]; then
sed '/tail/a \
\
echo "Calling back to Cylo API..." \
if [ ! -f /etc/app_configured ]; then \
    touch /etc/app_configured \
    until [[ $(curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST "https://api.cylo.io/v1/apps/installed/${INSTANCE_ID}" | grep "200") ]] \
        do \
        sleep 5 \
    done \
fi' /assets/wrapper
fi

exec "$@"
