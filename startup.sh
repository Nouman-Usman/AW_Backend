#!/bin/bash
cd /home/site/wwwroot
export PORT=${PORT:-8000}
export PYTHONPATH=/home/site/wwwroot
python -m pip install -r requirements.txt
exec gunicorn --bind=0.0.0.0:$PORT --timeout 600 --workers 4 app:app
