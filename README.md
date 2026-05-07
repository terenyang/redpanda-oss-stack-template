# Redpanda OSS Stack Template

Unofficial OSS Redpanda Docker Compose template with SASL authentication, Redpanda Console, Nginx Basic Auth, and bootstrap automation.

## Design Philosophy

This repository intentionally prioritizes:

- One-command startup
- Self-contained deployment
- Minimal external dependencies
- Enterprise-inspired architecture patterns
- Fast PoC onboarding

The primary `docker-compose.yml` is designed to run without requiring:

- Local shell scripts
- External configuration files
- Manual bootstrap steps
- Separate environment variable management

This makes the stack ideal for:

- Internal demos
- Event-driven architecture PoCs
- Platform engineering experiments
- Local Kafka-compatible development
- Lightweight enterprise messaging prototypes

## Architecture

```text
Client
  -> Nginx Basic Auth
    -> Redpanda Console
      -> Redpanda Broker (SASL/SCRAM)
```

## Included Components

### Redpanda OSS

- Kafka-compatible streaming platform
- SASL/SCRAM enabled
- Persistent storage
- Health checks enabled

### Redpanda Console OSS

- Web UI for topics, consumers, and messages
- Authenticated using SASL/SCRAM
- Internal-only exposure behind Nginx

### Nginx Reverse Proxy

- HTTP Basic Authentication
- Reverse proxy for Console
- WebSocket-compatible proxy configuration

### Bootstrap Automation

Automatically performs:

- SASL user creation
- ACL provisioning
- Console config generation
- Nginx config generation

## Repository Structure

```text
.
├── docker-compose.yml                  # Primary one-command deployment
├── compose/
│   └── docker-compose.modular.yml      # Advanced modular version
├── scripts/
│   ├── bootstrap-redpanda.sh
│   └── generate-config.sh
├── .env.example
└── README.md
```

## Quick Start

### Start Stack

```bash
docker compose up -d
```

### Open Console

```text
http://localhost:9090
```

## Configure Nginx Basic Auth

The root compose intentionally contains a placeholder htpasswd entry:

```text
admin:REPLACE_WITH_HTPASSWD_HASH
```

Before using the Console UI, generate a valid htpasswd hash.

### Option 1 - Using Docker (Recommended)

```bash
docker run --rm httpd:2.4-alpine htpasswd -nbB admin your_password
```

Example output:

```text
admin:$2y$05$...
```

Replace this line inside `docker-compose.yml`:

```text
admin:REPLACE_WITH_HTPASSWD_HASH
```

### Option 2 - Using Local htpasswd Tool

```bash
htpasswd -nbB admin your_password
```

## Kafka Connection Example

### SASL Credentials

```text
Username: kafka
Password: change_me_kafka_password
Mechanism: SCRAM-SHA-256
```

### Python Example

```python
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers=['localhost:19092'],
    security_protocol='SASL_PLAINTEXT',
    sasl_mechanism='SCRAM-SHA-256',
    sasl_plain_username='kafka',
    sasl_plain_password='change_me_kafka_password'
)
```

## Modular Version

An advanced modular version is also included:

```text
compose/docker-compose.modular.yml
```

The modular version is intended for:

- Teams managing multiple environments
- Environment-variable-based configuration
- Easier password rotation
- Script maintainability
- Extended customization

## Security Notes

This repository is intended for development and PoC usage.

The included credentials are intentionally public demo credentials and MUST be changed before any real deployment.

For production usage:

- Enable TLS
- Rotate credentials
- Restrict network exposure
- Use external secret management
- Configure granular ACLs
- Add monitoring and metrics collection
- Avoid exposing broker ports publicly

## Version Compatibility

This repository intentionally pins:

- Redpanda OSS: `v22.2.7`
- Redpanda Console OSS: `v2.6.0`

These versions were selected based on verified compatibility and stability testing.

## Disclaimer

This is an unofficial community template for running Redpanda OSS with Docker Compose.

Redpanda and Redpanda Console are trademarks or registered trademarks of Redpanda Data, Inc. This project is not affiliated with, sponsored by, or endorsed by Redpanda Data, Inc.

This repository does not redistribute Redpanda binaries. It references publicly available Docker images from Redpanda's official container registry.
