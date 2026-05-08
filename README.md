# StLaTeX

AI-powered strategic tutoring agent that maximizes university entrance exam success probability through long-term learning analysis, past exam trend optimization, and dynamic study strategy generation.

StLaTeX is not a generic AI tutor. The product focuses on deciding what a student should prioritize, postpone, or temporarily deprioritize to maximize expected exam outcomes under limited time.

## What is StLaTeX

StLaTeX is an AI strategy agent for Japanese university entrance exam students. It observes study logs, mock exam results, target university trends, and remaining time, then generates weekly strategy decisions.

The central question is:

```text
What should this student spend time on right now?
```

## Features

- Study log tracking
- Manual mock exam result input
- Priority subject and unit recommendation
- Temporary discard unit suggestion
- Weekly strategy generation
- Risk alerts for pace, weak subjects, and lifestyle issues
- AI reasoning summary for strategy decisions

## Tech Stack

- Frontend: Flutter, Dart, Riverpod, go_router, Dio
- Backend: FastAPI, Python 3.11+, Pydantic, Uvicorn
- Database: Firestore, Firestore Emulator for local development
- AI: Vertex AI Gemini, introduced after mock and rule-based strategy flows
- Deploy: Cloud Run

## Architecture

```text
Flutter App
  -> FastAPI API
    -> Strategy service
      -> Mock strategy service
      -> Rule-based strategy engine
      -> Gemini service
    -> Firestore
```

See [docs/architecture.md](docs/architecture.md) for the full architecture.

## MVP Goal

```text
Mock exam input
  -> AI strategy analysis
  -> priority and discard unit suggestions
  -> weekly study strategy generation
  -> dashboard display
```

The MVP is mock-first. Build the Flutter UI, FastAPI API, Firestore schema, and fixed strategy response before connecting Gemini.

## MVP Scope

The first working version must support:

- Flutter app startup
- Dashboard screen
- Study log input
- Mock exam input
- FastAPI startup
- `GET /strategies/latest`
- Strategy display with priority units, discard units, risk alerts, and reasoning

## Repository Layout

```text
AGENTS.md               Agent-wide project instructions
apps/
  mobile/               Flutter app
services/
  api/                  FastAPI backend
docs/
  architecture.md       System and repository architecture
  product_spec.md       Product specification
  claude_code_design.md Agent-oriented implementation design
  development_manual.md Development manual
infra/                  Firestore, Cloud Run, and deployment config
skills/                 Agent-facing implementation skills
```

## Key Docs

- [Architecture](docs/architecture.md)
- [Product Spec](docs/product_spec.md)
- [Claude Code Design](docs/claude_code_design.md)
- [Development Manual](docs/development_manual.md)

## Agent Skills

- [Flutter skill](skills/flutter_skill.md)
- [FastAPI skill](skills/fastapi_skill.md)
- [Firestore skill](skills/firestore_skill.md)
- [Gemini prompt skill](skills/gemini_prompt_skill.md)
- [Cloud Run skill](skills/cloudrun_skill.md)
- [UI design skill](skills/ui_design_skill.md)
- [Strategy engine skill](skills/strategy_engine_skill.md)

## Setup

This repository is currently in bootstrap phase. Full app setup comes next.

Backend target:

```bash
cd services/api
uvicorn app.main:app --reload
```

Flutter target:

```bash
cd apps/mobile
flutter run
```

## Demo Flow

1. Enter onboarding profile.
2. Add a mock exam result.
3. Add recent study logs.
4. Fetch the latest strategy.
5. Show dashboard recommendations.
6. Explain why one unit is prioritized and another is temporarily deprioritized.
