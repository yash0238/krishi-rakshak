import os
import json
import logging
from flask import Blueprint, jsonify, request
from backend.models import Disease, db

logger = logging.getLogger(__name__)

# Create blueprint for disease routes
disease_routes = Blueprint('disease_routes', __name__)

# Initialize diseases from JSON file if database is empty
def init_diseases():
    logger.debug("Checking if diseases need to be initialized...")
    if Disease.query.count() == 0:
        logger.info("No diseases found in database. Initializing from sample data...")
        try:
            with open('backend/static/sample_diseases.json', 'r', encoding='utf-8') as f:
                diseases_data = json.load(f)
                
            for disease_data in diseases_data:
                disease = Disease(
                    name=disease_data['name'],
                    type=disease_data['type'],
                    symptoms=disease_data['symptoms'],
                    remedy=disease_data['remedy']
                )
                db.session.add(disease)
            
            db.session.commit()
            logger.info(f"Successfully initialized {len(diseases_data)} diseases")
        except Exception as e:
            db.session.rollback()
            logger.error(f"Error initializing diseases: {str(e)}")

# Get all diseases
@disease_routes.route('/diseases', methods=['GET'])
def get_diseases():
    try:
        # Get query parameters
        disease_type = request.args.get('type')  # 'plant' or 'animal'
        search_term = request.args.get('search')
        
        # Start with base query
        query = Disease.query
        
        # Apply filters if provided
        if disease_type:
            query = query.filter(Disease.type == disease_type)
        
        if search_term:
            search_pattern = f"%{search_term}%"
            query = query.filter(Disease.name.ilike(search_pattern) | 
                                Disease.symptoms.ilike(search_pattern) |
                                Disease.remedy.ilike(search_pattern))
        
        # Execute query and convert to dict
        diseases = query.all()
        result = [disease.to_dict() for disease in diseases]
        
        return jsonify({
            "success": True,
            "count": len(result),
            "diseases": result
        }), 200
    
    except Exception as e:
        logger.error(f"Error getting diseases: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Get disease by ID
@disease_routes.route('/diseases/<int:disease_id>', methods=['GET'])
def get_disease(disease_id):
    try:
        disease = Disease.query.get(disease_id)
        
        if not disease:
            return jsonify({
                "success": False,
                "error": f"Disease with id {disease_id} not found"
            }), 404
        
        return jsonify({
            "success": True,
            "disease": disease.to_dict()
        }), 200
    
    except Exception as e:
        logger.error(f"Error getting disease: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Create new disease
@disease_routes.route('/diseases', methods=['POST'])
def create_disease():
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['name', 'type', 'symptoms', 'remedy']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    "success": False,
                    "error": f"Missing required field: {field}"
                }), 400
        
        # Validate disease type
        if data['type'] not in ['plant', 'animal']:
            return jsonify({
                "success": False,
                "error": "Type must be either 'plant' or 'animal'"
            }), 400
        
        # Create new disease
        disease = Disease(
            name=data['name'],
            type=data['type'],
            symptoms=data['symptoms'],
            remedy=data['remedy']
        )
        
        db.session.add(disease)
        db.session.commit()
        
        return jsonify({
            "success": True,
            "message": "Disease created successfully",
            "disease": disease.to_dict()
        }), 201
    
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error creating disease: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Initialize diseases will be called from app.py
