"""WSGI entrypoint for gunicorn / Docker / PaaS deploys."""
import os
import threading

if not os.environ.get("EGM_API_TOKEN") and os.environ.get("EGM_DEV_MODE") != "1":
    os.environ["EGM_DEV_MODE"] = "1"

from app import app, ensure_ffmpeg  # noqa: E402

threading.Thread(target=ensure_ffmpeg, daemon=True, name="ffmpeg-setup").start()
