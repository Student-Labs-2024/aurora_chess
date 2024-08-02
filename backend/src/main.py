from fastapi import FastAPI
import uvicorn

from api import router as api_router
from core.config import settings

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
