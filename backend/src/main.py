from contextlib import asynccontextmanager

from fastapi import FastAPI
import uvicorn

from api import router as api_router
from core.config import settings
from core.database.db_helper import db_helper


@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    yield
    # shutdown
    await db_helper.dispose()


app = FastAPI()

app.include_router(
    api_router,
)

if __name__ == "__main__":
    uvicorn.run(app="main:app", reload=True)
    uvicorn.run(
        "main:app",
        host=settings.run.host,
        port=settings.run.port,
        reload=True,
    )
