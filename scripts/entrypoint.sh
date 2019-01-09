#!/bin/bash

cat << EOF > /etc/gitlab/gitlab.rb
external_url 'https://${DOMAIN}'
nginx['listen_port'] = 80

nginx['listen_https'] = false

nginx['proxy_set_headers'] = {

"X-Forwarded-Proto" => "https",

"X-Forwarded-Ssl" => "on"

}
gitlab_rails['gitlab_shell_ssh_port'] = ${SSH_PORT}
unicorn['worker_processes'] = 1
sidekiq['concurrency'] = 1
nginx['real_ip_header'] = 'X-Real-IP'
nginx['set_real_ip_from'] = '172.20.0.0/12'
postgresql['shared_buffers'] = "1MB"
prometheus_monitoring['enable'] = false
EOF

exec "$@"
