#!/bin/bash
set -e

echo "Creating SASL admin user..."
rpk acl user create "$RP_ADMIN_USERNAME" \
  --password "$RP_ADMIN_PASSWORD" \
  --api-urls redpanda:9644 || echo "Admin user may already exist"

echo "Creating application SASL user..."
rpk acl user create "$RP_APP_USERNAME" \
  --password "$RP_APP_PASSWORD" \
  --api-urls redpanda:9644 || echo "Application user may already exist"

echo "Applying ACL permissions..."

rpk acl create \
  --allow-principal User:$RP_APP_USERNAME \
  --operation write \
  --topic '*' \
  --allow-host '*' \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

rpk acl create \
  --allow-principal User:$RP_APP_USERNAME \
  --operation read \
  --topic '*' \
  --allow-host '*' \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

rpk acl create \
  --allow-principal User:$RP_APP_USERNAME \
  --operation describe \
  --topic '*' \
  --allow-host '*' \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

rpk acl create \
  --allow-principal User:$RP_APP_USERNAME \
  --operation read \
  --group '*' \
  --allow-host '*' \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

echo "Creating starter topics..."

rpk topic create moveorder.events \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

rpk topic create moveorder.workflow \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

rpk topic create moveorder.deadletter \
  --brokers redpanda:9092 \
  --user $RP_ADMIN_USERNAME \
  --password $RP_ADMIN_PASSWORD \
  --sasl-mechanism SCRAM-SHA-256 || true

echo "Bootstrap completed successfully."
