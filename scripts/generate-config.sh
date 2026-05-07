#!/bin/sh
set -e

echo "Generating console-config.yaml..."
cat > /config/console-config.yaml <<EOF
kafka:
  brokers:
    - redpanda:9092
  sasl:
    enabled: true
    mechanism: SCRAM-SHA-256
    username: ${RP_ADMIN_USERNAME}
    password: ${RP_ADMIN_PASSWORD}

redpanda:
  adminApi:
    enabled: true
    urls:
      - http://redpanda:9644
EOF

echo "Generating nginx.conf..."
cat > /config/nginx.conf <<'EOF'
events {
    worker_connections 1024;
}

http {
    server {
        listen 8081;
        server_name _;

        auth_basic "Restricted Area";
        auth_basic_user_file /config/htpasswd;

        location / {
            proxy_pass http://console:8080;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

echo "Generating htpasswd file..."
printf '%s\n' "$CONSOLE_BASIC_AUTH_HTPASSWD" > /config/htpasswd

echo "Generated config files:"
ls -la /config/
