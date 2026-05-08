from fastapi import APIRouter

from app.schemas.strategy import StrategyResponse
from app.services.mock_strategy_service import load_mock_strategy


router = APIRouter(prefix="/strategies", tags=["strategies"])


@router.get("/latest", response_model=StrategyResponse)
def get_latest_strategy() -> StrategyResponse:
    return load_mock_strategy()
