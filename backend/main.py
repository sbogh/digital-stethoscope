"""
main.py

Minimal FastAPI backend server with a /ping route used
to verify that the server is running and accepting requests.
Includes CORS middleware for cross-origin frontend access.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from user_endpoints import router as user_router
from recording_endpoints import router as recording_router

# Create a new FastAPI application instance
app = FastAPI()

# Add middleware to handle Cross-Origin Resource Sharing (CORS)
# This allows the frontend (e.g., iOS Swift app) to make requests to this backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # Allow all origins (safe for dev only)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/test")
def test():
    return {"msg": "hello from main"}

app.include_router(recording_router)

app.include_router(user_router)
