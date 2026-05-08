# Strategy Engine Skill

Use this skill when implementing StLaTeX strategy logic, rule-based generation, risk detection, or AI strategy validation.

## Goal

Generate the highest expected-value weekly study strategy from limited MVP inputs.

## Strategy Mindset

The engine is not a tutor chat. It is a prioritization and expected-score optimization system.

It should decide:

- Which subject deserves time this week.
- Which unit has the best score improvement potential.
- Which unit should be temporarily deprioritized.
- Which risk needs intervention.
- How the weekly plan should change.

## Input Signals

- Remaining days.
- Target university and faculty.
- Subject scores and deviations.
- Recent study minutes by subject.
- Accuracy rate by unit.
- Strong and weak subjects.
- Sleep and mood trends.
- Past exam frequency when available.

## Rule-Based MVP Heuristics

- Prioritize weak subjects if they are important for the target exam.
- Prioritize frequent past-exam units with low current accuracy.
- Deprioritize low-frequency units with high improvement cost.
- Alert if a subject receives too little study time for two weeks.
- Alert if sleep shortage continues.
- Prefer concrete weekly actions over broad advice.

## Strategy Output Contract

Every strategy must include:

```text
mainGoal
prioritySubjects
priorityUnits
discardUnits
riskAlerts
weeklyPlan
aiReasoningSummary
```

## Safety and Tone

- Do not overstate precision.
- Do not say a student will fail.
- Explain tradeoffs using time, frequency, score impact, and current weakness.
- Treat discard units as a reversible weekly strategy.

## Evolution Path

1. Fixed mock strategy.
2. Rule-based generation.
3. Rule-based generation with Firestore history.
4. Gemini generation with strict schema validation.
5. Gemini plus fallback rule strategy.
