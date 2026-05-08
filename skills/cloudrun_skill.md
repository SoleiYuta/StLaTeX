# Cloud Run Skill

Use this skill when preparing StLaTeX backend deployment to Google Cloud Run.

## Goal

Deploy the FastAPI backend only after local mock API and Firestore Emulator flows work.

## Deployment Scope

Cloud Run should host `services/api`. Flutter should call the Cloud Run API endpoint in deployed environments.

## Required Files

```text
services/api/Dockerfile
services/api/requirements.txt
infra/cloudrun.yaml
infra/firestore.rules
infra/firestore.indexes.json
```

## Runtime Rules

- API listens on `$PORT`.
- Configuration comes from environment variables.
- Secrets do not live in repository files.
- Gemini credentials and Firestore production access are configured through GCP service account permissions.
- Keep mock strategy available in production as fallback.

## Deployment Readiness Checklist

- `GET /health` passes locally.
- `/strategies/latest` returns valid JSON locally.
- Docker image builds.
- Firestore project and rules are configured.
- CORS allows the intended app clients.
- Logs do not expose personal learning data or model prompts with sensitive information.

## MVP Bias

Do not spend early time on complex infrastructure. Prefer one Cloud Run service, Firestore, and clear environment variables.
