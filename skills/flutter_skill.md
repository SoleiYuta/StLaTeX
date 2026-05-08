# Flutter Skill

Use this skill when implementing or reviewing the StLaTeX Flutter mobile app.

## Goal

Ship the MVP screens quickly while keeping the app modular enough to replace mock data with API and Firestore data.

## Stack

- Flutter
- Dart
- Riverpod
- go_router
- Dio
- Firebase packages after the UI/API contract is stable

## Directory Pattern

```text
apps/mobile/lib/
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
```

## Implementation Rules

- Build feature-first folders. Keep widgets, providers, and screen code near the feature they serve.
- Use shared widgets only after the second real duplication appears.
- Keep API models aligned with backend Pydantic schemas.
- Dashboard is the most important screen. Make strategy status readable at a glance.
- Keep forms short for MVP. Prefer manual mock exam input before OCR.
- Do not block the UI on Gemini. Show mock or fallback strategy when needed.

## MVP Screens

- `OnboardingScreen`: target university, faculty, exam type, strengths, weaknesses, daily study hours.
- `DashboardScreen`: main goal, priority subjects, priority units, discard units, risk alerts, reasoning.
- `StudyLogScreen`: subject, unit, minutes, accuracy, material, mood, sleep.
- `MockExamScreen`: exam name, date, subject scores, deviations, judgement.
- `StrategyScreen`: weekly plan, priority rationale, discard rationale, risk details.

## API Integration

- Keep all Dio configuration in a shared API client.
- Expose typed repository methods per feature.
- Treat `/strategies/latest` as the first integration target.
- Surface backend fallback responses as normal strategies, not as errors.

## UI Tone

The app should feel strategic, calm, analytical, and trustworthy. Avoid noisy dashboards, excessive animation, and game-like visuals.
