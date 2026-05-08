# CLAUDE.md

## Project

StLaTeX

AI-powered strategic tutoring agent for university entrance exams.

The goal of this project is NOT to create a generic AI tutor. The core value is:

- strategic optimization
- discardable unit suggestion
- expected score maximization
- long-term study observation
- dynamic study strategy generation

The AI should behave like a strategic university entrance exam tutor.

---

# Purpose

This file contains ONLY global shared rules.

Detailed implementation knowledge should be separated into reusable skills.

Examples:

- Flutter skill
- FastAPI skill
- Firestore skill
- Gemini prompt skill
- Cloud Run deployment skill
- UI design skill
- Strategy generation skill

Keep CLAUDE.md minimal.

---

# Development Philosophy

## Prioritize shipping

This is a hackathon project.

Priorities:

1. Working MVP
2. Strong demo experience
3. AI agent feeling
4. UI/UX clarity
5. Clean architecture

Do NOT overengineer.

---

# PR Method (Problem → Resolution)

Always use PR Method when implementing features.

## P = Problem

Before implementation, clarify:

- What problem exists?
- Why is it important?
- What user experience is missing?

## R = Resolution

Then implement:

- Minimal solution first
- Reusable structure
- Simple architecture
- Maintainable code

Avoid unnecessary abstraction.

---

# File Editing Policy

You are allowed to:

- create files
- modify files
- refactor files
- reorganize directories
- update configs
- generate boilerplate

WITHOUT asking for permission every time.

Do not repeatedly ask:

- “Can I create this file?”
- “Can I modify this file?”
- “Should I continue?”

Act proactively.

However:

- explain major architectural changes
- explain destructive operations
- explain dependency changes
- explain schema-breaking changes

before executing them.

---

# Coding Style

## General

- Keep code simple
- Prefer readability over cleverness
- Prefer explicitness over magic
- Avoid premature optimization
- Keep functions small
- Use clear naming

---

# Skill-based Development

Detailed domain-specific instructions should NOT live in CLAUDE.md.

Move specialized knowledge into skills.

CLAUDE.md should only define:

- project-wide rules
- architecture philosophy
- workflow principles
- collaboration rules
- coding standards

Examples of things that belong in skills:

- Flutter widget patterns
- FastAPI router structure
- Firestore schema conventions
- Prompt engineering templates
- Gemini JSON schema handling
- Cloud Run deployment steps
- OCR processing flows

---

# Frontend Rules

## Flutter

Keep UI modular and responsive.

Avoid giant widgets and tightly coupled state.

---

# UI Philosophy

The product should feel:

- strategic
- intelligent
- calm
- analytical
- trustworthy

Avoid:

- noisy UI
- excessive animations
- gamer aesthetics
- cluttered dashboards

Preferred style:

- dark mode friendly
- clean cards
- clear hierarchy
- strong typography
- simple charts

---

# AI Agent Philosophy

StLaTeX is NOT:

- a chatbot
- a homework solver
- a generic tutor

StLaTeX IS:

- a strategic exam agent
- a long-term study observer
- a prioritization engine
- an expected-value optimizer

The AI should continuously answer:

```text
What should this student spend time on right now?
```

---

# MVP Priorities

Highest priority:

1. Dashboard
2. Study logs
3. Mock exam analysis
4. Strategy generation
5. Discard unit suggestion
6. AI reasoning display

Lower priority:

- voice mode
- advanced OCR
- social features
- complex ML
- gamification

---

# Architecture Priorities

Prefer:

- simple APIs
- stable JSON
- deterministic outputs
- clean separation
- mock-first development

Before Gemini integration:

- use mock\_strategy.json
- stabilize frontend flow
- stabilize schemas
- stabilize API contracts

---

# Prompt Engineering

Prompt implementation details should live inside dedicated prompt skills.

CLAUDE.md should only define shared high-level constraints.

Global rule:

```text
Prefer structured and deterministic outputs.
```

---

# Git Rules

## Commit Style

Use clear commits:

```text
feat: add strategy generation endpoint
fix: stabilize firestore schema
refactor: split dashboard widgets
```

---

# Team Rules

Assume a 4-person team:

- AI Engineer
- Backend Engineer
- Flutter Engineer
- PM / Designer

Keep responsibilities separated.

Avoid tightly coupling frontend and backend logic.

---

# Demo Priority

The demo is extremely important.

Always optimize for:

```text
Input
↓
AI reasoning
↓
Strategic decision
↓
Visible impact
```

The audience should feel:

```text
The AI is actively thinking.
```

---

# Important Constraint

Do NOT turn this project into:

- a generic AI tutor
- an AI chat app
- a question answering bot

Keep the project focused on:

- strategic optimization
- prioritization
- expected value maximization
- discard decisions
- long-term planning

---

# Final Principle

A working simple product is better than an unfinished complex system.

Prioritize:

- completion
- clarity
- demo quality
- strategic UX

over technical perfection.

