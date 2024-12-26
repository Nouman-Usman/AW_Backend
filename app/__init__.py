from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from datetime import timedelta

app = Flask(__name__)
CORS(app)

# Move JWT configuration here
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=5)
jwt = JWTManager(app)

# Import routes after app configuration
from app import routes