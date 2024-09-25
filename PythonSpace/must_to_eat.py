from fastapi import FastAPI
from user_data import router as user_router
from must_eat_data import router as must_eat_router

app = FastAPI()

app.include_router(user_router, prefix="/user", tags=["user"])
app.include_router(must_eat_router, prefix="/must_eat", tags=["must_eat"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000)