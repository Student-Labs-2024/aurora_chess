from fastapi import APIRouter

from core.config import settings

from .chess_router import router as chess_router
from .auth_router import router as auth_router


router = APIRouter(
    prefix=settings.api.prefix,
)
router.include_router(
    chess_router,
    prefix=settings.api.chess,
)

router.include_router(
    auth_router,
)

