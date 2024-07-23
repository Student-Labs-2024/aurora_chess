from fastapi import FastAPI
import uvicorn

from core.config import settings

app = FastAPI()


if __name__ == "__main__":
    uvicorn.run(app="main:app", reload=True)
    uvicorn.run(
        "main:app",
        host=settings.run.host,
        port=settings.run.port,
        reload=True,
    )
