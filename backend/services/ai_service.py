import os
import logging
import base64
import json
from openai import OpenAI

logger = logging.getLogger(__name__)

# Initialize OpenAI client
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")
openai_client = None

if OPENAI_API_KEY:
    openai_client = OpenAI(api_key=OPENAI_API_KEY)
    logger.info("OpenAI client initialized successfully")
else:
    logger.warning("OPENAI_API_KEY not found. AI features will be limited.")

def analyze_image_with_ai(base64_image, disease_type):
    """
    Use OpenAI's GPT-4o Vision to analyze an image and detect diseases
    
    Args:
        base64_image: Base64 encoded image string
        disease_type: Either 'plant' or 'animal'
    
    Returns:
        dict: Analysis results containing disease name, confidence, symptoms and remedy
    """
    if not openai_client:
        logger.warning("OpenAI client not initialized. Cannot analyze image.")
        return None
    
    try:
        # Create the system prompt based on disease type
        if disease_type == 'plant':
            system_prompt = """
            You are an expert plant pathologist. Analyze the image and identify any plant diseases.
            If you detect a disease, provide:
            1. The most likely disease name
            2. A confidence score between 0 and 1
            3. The key symptoms visible in the image
            4. Recommended remedies or treatments
            
            If you cannot confidently identify a disease, explain what you can see and why diagnosis is difficult.
            Return the information in JSON format with the following keys: disease_name, confidence_score, symptoms, remedy.
            """
        else:  # animal
            system_prompt = """
            You are an expert veterinarian. Analyze the image and identify any animal diseases or health conditions.
            If you detect a health issue, provide:
            1. The most likely disease or condition name
            2. A confidence score between 0 and 1
            3. The key symptoms visible in the image
            4. Recommended remedies or treatments
            
            If you cannot confidently identify a disease, explain what you can see and why diagnosis is difficult.
            Return the information in JSON format with the following keys: disease_name, confidence_score, symptoms, remedy.
            """
        
        # Call OpenAI API
        response = openai_client.chat.completions.create(
            model="gpt-4o",  # the newest OpenAI model is "gpt-4o" which was released May 13, 2024.
            messages=[
                {
                    "role": "system",
                    "content": system_prompt
                },
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text", 
                            "text": f"Analyze this {disease_type} image and identify any diseases or health issues."
                        },
                        {
                            "type": "image_url",
                            "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}
                        }
                    ]
                }
            ],
            response_format={"type": "json_object"},
            max_tokens=1000
        )
        
        # Extract and parse the response
        result = json.loads(response.choices[0].message.content)
        
        # Ensure the response has the expected format
        required_keys = ["disease_name", "confidence_score", "symptoms", "remedy"]
        for key in required_keys:
            if key not in result:
                result[key] = "Not provided by AI"
        
        return result
    
    except Exception as e:
        logger.error(f"Error analyzing image with OpenAI: {str(e)}")
        return None