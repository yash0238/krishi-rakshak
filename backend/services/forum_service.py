import logging
from flask import Blueprint, request, jsonify
from backend.models import ForumPost, ForumComment, db
from datetime import datetime

logger = logging.getLogger(__name__)

# Create blueprint for forum routes
forum_routes = Blueprint('forum_routes', __name__)

# Get all forum posts
@forum_routes.route('/forum/posts', methods=['GET'])
def get_forum_posts():
    try:
        posts = ForumPost.query.order_by(ForumPost.created_at.desc()).all()
        result = [post.to_dict() for post in posts]
        
        return jsonify({
            "success": True,
            "count": len(result),
            "posts": result
        }), 200
    
    except Exception as e:
        logger.error(f"Error getting forum posts: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Get forum post by ID
@forum_routes.route('/forum/posts/<int:post_id>', methods=['GET'])
def get_forum_post(post_id):
    try:
        post = ForumPost.query.get(post_id)
        
        if not post:
            return jsonify({
                "success": False,
                "error": f"Post with id {post_id} not found"
            }), 404
        
        return jsonify({
            "success": True,
            "post": post.to_dict()
        }), 200
    
    except Exception as e:
        logger.error(f"Error getting forum post: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Create new forum post
@forum_routes.route('/forum/posts', methods=['POST'])
def create_forum_post():
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['title', 'content', 'author_name']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    "success": False,
                    "error": f"Missing required field: {field}"
                }), 400
        
        # Create new post
        post = ForumPost(
            title=data['title'],
            content=data['content'],
            author_name=data['author_name']
        )
        
        db.session.add(post)
        db.session.commit()
        
        return jsonify({
            "success": True,
            "message": "Post created successfully",
            "post": post.to_dict()
        }), 201
    
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error creating forum post: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Add comment to forum post
@forum_routes.route('/forum/posts/<int:post_id>/comments', methods=['POST'])
def add_comment(post_id):
    try:
        post = ForumPost.query.get(post_id)
        
        if not post:
            return jsonify({
                "success": False,
                "error": f"Post with id {post_id} not found"
            }), 404
        
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['content', 'author_name']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    "success": False,
                    "error": f"Missing required field: {field}"
                }), 400
        
        # Create new comment
        comment = ForumComment(
            content=data['content'],
            author_name=data['author_name'],
            post_id=post_id
        )
        
        db.session.add(comment)
        db.session.commit()
        
        return jsonify({
            "success": True,
            "message": "Comment added successfully",
            "comment": comment.to_dict()
        }), 201
    
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error adding comment: {str(e)}")
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# Initialize some sample forum posts
def init_forum_posts():
    logger.debug("Checking if forum posts need to be initialized...")
    if ForumPost.query.count() == 0:
        logger.info("No forum posts found in database. Initializing sample posts...")
        try:
            # Create sample posts
            sample_posts = [
                {
                    'title': 'टमाटरच्या रोगांबद्दल सल्ला हवा आहे',
                    'content': 'माझ्या टमाटरच्या झाडांवर काही चिन्हे दिसत आहेत. पाने पिवळी होत आहेत आणि फळांवर काळे डाग दिसत आहेत. कोणाला या समस्येबद्दल माहिती आहे का?',
                    'author_name': 'रमेश पाटील'
                },
                {
                    'title': 'गाईला बुखार आला आहे, मदत करा',
                    'content': 'माझ्या गाईला गेल्या दोन दिवसांपासून बुखार आहे आणि ती खात नाही. कोणाला या समस्येबद्दल माहिती आहे का? कोणत्या औषधांची गरज आहे?',
                    'author_name': 'सुनील जाधव'
                }
            ]
            
            for post_data in sample_posts:
                post = ForumPost(
                    title=post_data['title'],
                    content=post_data['content'],
                    author_name=post_data['author_name']
                )
                db.session.add(post)
            
            db.session.commit()
            
            # Add comments to the first post
            post = ForumPost.query.first()
            comments = [
                {
                    'content': 'हे कदाचित उशीरा मुरझवणे रोग असू शकतो. रोगनाशक फवारणी करून पहा.',
                    'author_name': 'अनिल शिंदे'
                },
                {
                    'content': 'माझ्या शेतात सुद्धा हाच प्रॉब्लेम होता. मी 5ml/L बाविस्टिन वापरले आणि रोग नियंत्रणात आला.',
                    'author_name': 'विजय कदम'
                }
            ]
            
            for comment_data in comments:
                comment = ForumComment(
                    content=comment_data['content'],
                    author_name=comment_data['author_name'],
                    post_id=post.id
                )
                db.session.add(comment)
            
            db.session.commit()
            logger.info("Successfully initialized sample forum posts and comments")
        
        except Exception as e:
            db.session.rollback()
            logger.error(f"Error initializing forum posts: {str(e)}")

# Initialize forum posts will be called from app.py
