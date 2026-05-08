# Firestore Skill

Use this skill when designing or implementing StLaTeX Firestore persistence.

## Goal

Store student profile, learning history, mock exam results, generated strategies, and university trend data with simple paths that work in local Emulator and production.

## Primary Paths

```text
users/{userId}
users/{userId}/studyLogs/{logId}
users/{userId}/mockExams/{mockExamId}
users/{userId}/strategies/{strategyId}
universities/{universityId}
universities/{universityId}/pastExamTrends/{trendId}
```

## Data Rules

- Keep user-owned data under `users/{userId}`.
- Store generated strategy snapshots, not only the latest derived fields.
- Include `createdAt`, `updatedAt`, and `source` where relevant.
- Keep enum values stable and lowercase, such as `math`, `english`, `normal`, `medium`.
- Avoid deeply nested mutable maps when a subcollection is clearer.

## Strategy Document

Recommended fields:

```text
mainGoal
prioritySubjects
priorityUnits
discardUnits
riskAlerts
weeklyPlan
aiReasoningSummary
source              mock | rule | gemini
inputSummary
createdAt
```

## Local Development

- Use Firestore Emulator before production Firestore.
- Keep `.env.example` updated with emulator variables.
- Backend code should read configuration from environment variables.
- Do not require GCP credentials for mock-first local API work.

## Security Rules Direction

- Users can read and write only their own nested documents.
- University trend data is read-only to clients.
- Backend service account can write generated strategy records.
