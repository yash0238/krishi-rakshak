import os
import logging
from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
from werkzeug.middleware.proxy_fix import ProxyFix
from backend.models import db  # Import db instance from models.py

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Create the Flask app with templates from frontend directory
app = Flask(__name__, 
            static_folder="../frontend/static",
            template_folder="../frontend/templates")
app.secret_key = os.environ.get("SESSION_SECRET", "krishi_rakshak_secret")
app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)

# Configure database (SQLite for development)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///krishi_rakshak.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

# Log database connection details
logger.info(f"Using SQLite database: krishi_rakshak.db")

# Enable CORS for all routes
CORS(app)

# Initialize SQLAlchemy with the app
db.init_app(app)

# Import routes after app initialization
with app.app_context():
    # Import models to ensure they're registered with SQLAlchemy
    from backend import models
    
    # Create all tables
    db.create_all()
    
    # Import routes and initialization functions
    from backend.services.prediction_service import prediction_routes
    from backend.services.disease_service import disease_routes, init_diseases
    from backend.services.forum_service import forum_routes, init_forum_posts
    
    # Register blueprints
    app.register_blueprint(prediction_routes)
    app.register_blueprint(disease_routes)
    app.register_blueprint(forum_routes)
    
    # Initialize sample data
    init_diseases()
    init_forum_posts()
    
    logger.debug("All routes registered and tables created")

# Basic error handling
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Resource not found"}), 404

@app.errorhandler(500)
def server_error(error):
    logger.error(f"Server error: {error}")
    return jsonify({"error": "Internal server error"}), 500

# Health check endpoint
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "service": "Krishi Rakshak API"}), 200

# Root endpoint
@app.route('/', methods=['GET'])
def home():
    return render_template('index.html')

# API information endpoint
@app.route('/api', methods=['GET'])
def api_info():
    return jsonify({
        "name": "Krishi Rakshak API",
        "description": "AI-powered plant and animal disease diagnosis API",
        "endpoints": [
            "/predict/plant",
            "/predict/animal",
            "/diseases",
            "/forum/posts"
        ]
    }), 200
