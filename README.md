# Redpanda OSS Stack Template

Unofficial OSS Redpanda Docker Compose template with SASL authentication, Redpanda Console, Nginx Basic Auth, and bootstrap automation.

## Overview

This repository provides a lightweight enterprise-style event streaming starter stack using:

- Redpanda OSS
- Redpanda Console OSS
- SASL/SCRAM authentication
- Topic and ACL bootstrap automation
- Nginx reverse proxy
- HTTP Basic Authentication
- Docker Compose

The stack is intentionally designed for:

- Local development
- Event-driven architecture PoCs
- Internal platform engineering experiments
- Lightweight enterprise messaging prototypes

## Architecture

Client
  -> Nginx Basic Auth
    -> Redpanda Console
      -> Redpanda Broker (SASL)

## Included Features

### Security

- SASL/SCRAM authentication enabled
- Separate admin and application users
- ACL bootstrap automation
- Console protected behind Nginx Basic Auth

### Platform Bootstrap

- Automatic SASL user creation
- Automatic ACL provisioning
- Automatic starter topic creation
- Dynamic config generation

### Operational Features

- Persistent Docker volumes
- Health checks
- Ordered service startup
- Internal-only management APIs

## Repository Structure

```
.
├── compose/
│   └── docker-compose.yml
├── scripts/
│   ├── bootstrap-redpanda.sh
│   └── generate-config.sh
├── .env.example
└── README.md
```

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/terenyang/redpanda-oss-stack-template.git
cd redpanda-oss-stack-template
```

### 2. Create Environment File

```bash
cp .env.example .env
```

Update passwords before startup.

### 3. Start Stack

```bash
cd compose
docker compose up -d
```

### 4. Open Console

URL:

```text
http://localhost:9090
```

Use the Basic Auth credentials defined in `.env`.

## Kafka Connection Example

```python
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers=['localhost:19092'],
    security_protocol='SASL_PLAINTEXT',
    sasl_mechanism='SCRAM-SHA-256',
    sasl_plain_username='kafka',
    sasl_plain_password='your_password'
)
```

## Default Starter Topics

The bootstrap script automatically creates:

- moveorder.events
- moveorder.workflow
- moveorder.deadletter

## Security Notes

This repository is intended for development and PoC usage.

For production:

- Enable TLS
- Rotate credentials
- Restrict network exposure
- Use external secret management
- Configure granular ACLs
- Add monitoring and metrics collection

## Disclaimer

This is an unofficial community template for running Redpanda OSS with Docker Compose.

Redpanda and Redpanda Console are trademarks or registered trademarks of Redpanda Data, Inc. This project is not affiliated with, sponsored by, or endorsed by Redpanda Data, Inc.

This repository does not redistribute Redpanda binaries. It references publicly available Docker images from Redpanda's official container registry.
