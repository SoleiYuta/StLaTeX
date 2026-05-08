import json
from pathlib import Path

from app.schemas.strategy import StrategyResponse


MOCK_STRATEGY_PATH = Path(__file__).resolve().parents[1] / "mocks" / "mock_strategy.json"


def load_mock_strategy() -> StrategyResponse:
    with MOCK_STRATEGY_PATH.open(encoding="utf-8") as file:
        data = json.load(file)
    return StrategyResponse.model_validate(data)
