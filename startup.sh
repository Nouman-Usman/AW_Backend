#!/bin/bash
cd /home/site/wwwroot

# Set up Python path and environment
export PORT=${PORT:-8000}
export PYTHONPATH=/home/site/wwwroot
export FLASK_APP=wsgi.py

# Install dependencies
python -m pip install -r requirements.txt

# Start the application
exec gunicorn --bind=0.0.0.0:$PORT "wsgi:application"
