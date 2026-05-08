from pydantic import BaseModel


class PriorityUnit(BaseModel):
    subject: str
    unit: str
    reason: str
    recommendedMinutes: int


class DiscardUnit(BaseModel):
    subject: str
    unit: str
    reason: str
    risk: str
    reviewTiming: str


class RiskAlert(BaseModel):
    type: str
    message: str
    severity: str


class WeeklyPlanItem(BaseModel):
    day: str
    tasks: list[str]


class StrategyResponse(BaseModel):
    mainGoal: str
    prioritySubjects: list[str]
    priorityUnits: list[PriorityUnit]
    discardUnits: list[DiscardUnit]
    riskAlerts: list[RiskAlert]
    weeklyPlan: list[WeeklyPlanItem]
    aiReasoningSummary: str
