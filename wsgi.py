#!/usr/bin/env python
import os
import sys

# Add the application directory to the Python path
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from app import app

if __name__ == "__main__":
    app.run()
