from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from datetime import timedelta

# Create Flask app instance
app = Flask(__name__)

# Configure CORS
CORS(app, 
     resources={r"/api/*": {
         "origins": ["http://localhost:3000"],
         "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
         "allow_headers": ["Content-Type", "Authorization"],
         "expose_headers": ["Content-Type", "Authorization"],
         "supports_credentials": True,
         "max_age": 120
     }},
     supports_credentials=True)

# Configure app
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=5)
app.config['CORS_HEADERS'] = 'Content-Type'

jwt = JWTManager(app)

# Import routes at the end
from app import routes

def run():
    app.run(host='0.0.0.0', port=5000)