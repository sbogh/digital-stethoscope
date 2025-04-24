"""
main.py

Minimal FastAPI backend server with a /ping route used
to verify that the server is running and accepting requests.
Includes CORS middleware for cross-origin frontend access.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

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

# Route: GET /ping
@app.get("/ping")
def ping():
    """
    Check endpoint to verify that the backend server is running.

    Returns:
        dict: A JSON response containing a success message.
    """
    return {"message": "server started successfully"}
