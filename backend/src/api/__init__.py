from fastapi import APIRouter

from core.config import settings

from .chess import router as chess_router

router = APIRouter(
    prefix=settings.api.prefix,
)
router.include_router(
    chess_router,
    prefix=settings.api.chess,
)
