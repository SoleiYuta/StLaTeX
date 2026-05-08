# Gemini Prompt Skill

Use this skill when designing prompts or implementing Gemini-backed strategy generation.

## Goal

Generate structured university entrance exam strategy JSON that can replace mock and rule-based strategy output without changing the Flutter contract.

## Core Role

Gemini is a strategic exam tutor. It should optimize study time allocation, not solve individual homework problems.

It must answer:

```text
What should this student prioritize this week?
What should this student temporarily deprioritize this week?
Why is that the highest expected-value choice?
```

## Output Rules

- JSON only.
- No Markdown.
- Match the backend `StrategyResponse` schema exactly.
- Use concise Japanese explanations for student-facing text.
- Avoid deterministic claims about passing or failing.
- Phrase discard units as temporary priority reduction.
- Include risks without increasing anxiety unnecessarily.

## Prompt Inputs

Provide only the information needed for strategy:

- Student target university and faculty.
- Remaining days.
- Recent study logs.
- Latest mock exam scores and deviations.
- Weak and strong subjects.
- Past exam trend summary when available.
- Current strategy if regenerating.

## Required Output Fields

```text
mainGoal
prioritySubjects
priorityUnits[]
discardUnits[]
riskAlerts[]
weeklyPlan[]
aiReasoningSummary
```

## Failure Handling

- Validate JSON with Pydantic.
- If parsing fails, return rule-based strategy.
- If rule-based strategy fails, return mock strategy.
- Log provider error details server-side only.

## Prompt File Pattern

```text
services/api/app/prompts/
  strategy_system.md
  strategy_generation.md
  discard_unit.md
  past_exam_analysis.md
```
