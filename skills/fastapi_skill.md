# FastAPI Skill

Use this skill when implementing or reviewing the StLaTeX backend API.

## Goal

Provide stable typed endpoints for the Flutter app while keeping strategy generation mock-first and replaceable.

## Stack

- Python 3.11+
- FastAPI
- Pydantic
- Uvicorn
- firebase-admin / google-cloud-firestore
- google-genai only after mock and rule-based flows work

## Directory Pattern

```text
services/api/app/
  main.py
  config.py
  routers/
    health.py
    users.py
    study_logs.py
    mock_exams.py
    strategies.py
    past_exams.py
  services/
    firestore_service.py
    mock_strategy_service.py
    strategy_engine.py
    gemini_service.py
    risk_detector.py
    past_exam_analyzer.py
  schemas/
    user.py
    study_log.py
    mock_exam.py
    strategy.py
    past_exam.py
  prompts/
  mocks/
    mock_strategy.json
  tests/
```

## API Rules

- Define request and response shapes with Pydantic.
- Keep routers thin. Put business logic in services.
- Keep Gemini behind `gemini_service.py`; routers should not call model APIs directly.
- Return deterministic mock data before adding dynamic generation.
- Always provide a fallback strategy when generation fails.
- Prefer explicit field names that match Flutter models.

## MVP Endpoints

- `GET /health`
- `POST /users/me/onboarding`
- `POST /study-logs`
- `GET /study-logs/recent`
- `POST /mock-exams`
- `GET /strategies/latest`
- `POST /strategies/generate`

## Strategy Generation Order

1. Return `mocks/mock_strategy.json`.
2. Add rule-based generation in `strategy_engine.py`.
3. Store generated strategy snapshots in Firestore.
4. Add Gemini JSON generation.
5. Validate Gemini output and fall back to rule/mock output on failure.

## Testing Focus

- Health endpoint.
- Strategy schema validation.
- `/strategies/latest` returns the expected mock shape.
- Invalid study logs and mock exams return useful 422 responses.
