# StLaTeX Architecture

## Product Intent

StLaTeX is a strategic university entrance exam agent. Its core job is to answer:

```text
What should this student spend time on right now?
What should this student temporarily deprioritize?
```

The product should feel like a long-term strategic tutor, not a homework chatbot. The main value is expected-score optimization through learning logs, mock exam results, target university trends, and remaining time.

## Architecture Principles

- Build mock-first. Do not connect Gemini until UI, API contracts, and schemas are stable.
- Optimize for a working hackathon MVP before advanced prediction accuracy.
- Keep strategy output structured as JSON so Flutter, FastAPI, Firestore, and Gemini can share the same contract.
- Treat "discard units" as temporary deprioritization, not permanent abandonment.
- Keep fallback behavior available whenever AI generation fails.

## System Overview

```text
Flutter App
  -> FastAPI on Cloud Run
    -> Strategy service
      -> Mock strategy service
      -> Rule-based strategy engine
      -> Gemini service
    -> Firestore
    -> Vertex AI / Gemini
    -> FCM notifications
```

## MVP Flow

```text
Onboarding
  -> Study log input
  -> Mock exam input
  -> GET /strategies/latest
  -> Dashboard strategy display
  -> Strategy detail display
```

The first implementation should use `services/api/app/mocks/mock_strategy.json`. Later phases can replace the data source with rule-based generation and then Gemini generation without changing the Flutter presentation contract.

## Repository Structure

```text
stlatex/
  README.md
  CLAUDE.md
  .env.example

  docs/
    architecture.md
    api_spec.md
    firestore_schema.md
    prompt_design.md
    demo_script.md

  skills/
    flutter_skill.md
    fastapi_skill.md
    firestore_skill.md
    gemini_prompt_skill.md
    cloudrun_skill.md
    ui_design_skill.md
    strategy_engine_skill.md

  apps/
    mobile/
      lib/
        main.dart
        app.dart
        core/
          constants/
          routing/
          theme/
          utils/
        features/
          onboarding/
          dashboard/
          study_log/
          mock_exam/
          strategy/
          past_exam/
          interview/
          settings/
        shared/
          models/
          services/
          widgets/

  services/
    api/
      app/
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
          strategy_system.md
          strategy_generation.md
          discard_unit.md
          past_exam_analysis.md
        mocks/
          mock_strategy.json
        tests/
      requirements.txt
      Dockerfile

  infra/
    firestore.rules
    firestore.indexes.json
    cloudrun.yaml
```

## Frontend Responsibilities

The Flutter app owns user workflows and strategy presentation.

- Onboarding: target university, exam type, strengths, weaknesses, available study time.
- Dashboard: current main goal, priority subjects, priority units, discard units, risk alerts, reasoning summary.
- Study log: date, subject, unit, minutes, accuracy, material, mood, sleep.
- Mock exam: manual score and deviation input for MVP.
- Strategy detail: weekly plan, priority rationale, discard rationale, risk alerts.

Use Riverpod for state, go_router for navigation, and Dio for API access.

## Backend Responsibilities

FastAPI owns validation, persistence coordination, and strategy generation orchestration.

- `GET /health`: liveness check.
- `POST /users/me/onboarding`: profile setup.
- `POST /study-logs`: create study log.
- `GET /study-logs/recent`: recent logs.
- `POST /mock-exams`: create mock exam result.
- `GET /strategies/latest`: return latest strategy, initially mock JSON.
- `POST /strategies/generate`: generate strategy, initially rule-based then Gemini-backed.

The backend should expose stable Pydantic schemas and keep AI providers behind service interfaces.

## Data Model

Primary Firestore paths:

```text
users/{userId}
users/{userId}/studyLogs/{logId}
users/{userId}/mockExams/{mockExamId}
users/{userId}/strategies/{strategyId}
universities/{universityId}
universities/{universityId}/pastExamTrends/{trendId}
```

Strategy records should preserve the complete generated JSON, source (`mock`, `rule`, or `gemini`), creation timestamp, and input summary used for generation.

## Strategy Contract

```json
{
  "mainGoal": "数学III 微積分を重点強化する",
  "prioritySubjects": ["math", "english"],
  "priorityUnits": [
    {
      "subject": "math",
      "unit": "微積分",
      "reason": "志望校頻出かつ現在の正答率が低いため",
      "recommendedMinutes": 420
    }
  ],
  "discardUnits": [
    {
      "subject": "math",
      "unit": "整数",
      "reason": "頻度が低く、短期得点期待値が低いため",
      "risk": "出題された場合に失点リスクあり",
      "reviewTiming": "7月以降に再評価"
    }
  ],
  "riskAlerts": [
    {
      "type": "pace_delay",
      "message": "化学の学習量が2週間連続で不足しています",
      "severity": "medium"
    }
  ],
  "weeklyPlan": [
    {
      "day": "Monday",
      "tasks": ["数学 微積分 90分", "英語 長文 60分"]
    }
  ],
  "aiReasoningSummary": "数学IIIの微積分は志望校で頻出かつ現在の正答率が低いため、今週の最優先に設定しました。"
}
```

## Implementation Phases

1. Repository bootstrap: docs, skills, empty app/service/infra skeletons.
2. Backend mock API: health check, strategy mock, study log and mock exam endpoints.
3. Flutter mock UI: dashboard, study log, mock exam, strategy screens.
4. Firestore Emulator: local persistence for logs, exams, and strategies.
5. Rule-based strategy engine: simple priority and risk logic from inputs.
6. Gemini integration: JSON-only prompt, schema validation, fallback strategy.
7. Demo polish: realistic sample data, dashboard clarity, before/after strategy story.

## Non-Goals for MVP

- Generic homework solving.
- High-accuracy admission probability modeling.
- Fully automatic OCR.
- Complex social features.
- Heavy gamification.
- Custom ML training.
