import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/disease.dart';
import '../models/forum_post.dart';
import '../utils/constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  
  // Predict disease from image
  Future<Disease?> predictDisease(String base64Image, String type) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict/$type'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['prediction'] != null) {
          return Disease(
            id: 0, // Not needed for prediction result
            name: data['prediction']['disease_name'],
            type: data['prediction']['type'],
            symptoms: data['prediction']['symptoms'],
            remedy: data['prediction']['remedy'],
            confidenceScore: data['prediction']['confidence_score'],
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error predicting disease: $e');
      return null;
    }
  }
  
  // Fetch all diseases
  Future<List<Disease>> fetchDiseases() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/diseases'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['diseases'] != null) {
          return (data['diseases'] as List)
              .map((diseaseJson) => Disease(
                    id: diseaseJson['id'],
                    name: diseaseJson['name'],
                    type: diseaseJson['type'],
                    symptoms: diseaseJson['symptoms'],
                    remedy: diseaseJson['remedy'],
                    confidenceScore: 1.0, // Default for stored diseases
                  ))
              .toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching diseases: $e');
      return [];
    }
  }
  
  // Fetch forum posts
  Future<List<ForumPost>> fetchForumPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/forum/posts'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['posts'] != null) {
          return (data['posts'] as List)
              .map((postJson) {
                // Parse comments
                final comments = (postJson['comments'] as List)
                    .map((commentJson) => ForumComment(
                          id: commentJson['id'],
                          content: commentJson['content'],
                          authorName: commentJson['author_name'],
                          createdAt: DateTime.parse(commentJson['created_at']),
                        ))
                    .toList();
                
                // Create post with comments
                return ForumPost(
                  id: postJson['id'],
                  title: postJson['title'],
                  content: postJson['content'],
                  authorName: postJson['author_name'],
                  createdAt: DateTime.parse(postJson['created_at']),
                  comments: comments,
                );
              })
              .toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching forum posts: $e');
      return [];
    }
  }
  
  // Create new forum post
  Future<bool> createForumPost(String title, String content, String authorName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forum/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'content': content,
          'author_name': authorName,
        }),
      );
      
      return response.statusCode == 201 && 
             jsonDecode(response.body)['success'] == true;
    } catch (e) {
      print('Error creating forum post: $e');
      return false;
    }
  }
  
  // Add comment to forum post
  Future<bool> addCommentToPost(int postId, String content, String authorName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forum/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': content,
          'author_name': authorName,
        }),
      );
      
      return response.statusCode == 201 && 
             jsonDecode(response.body)['success'] == true;
    } catch (e) {
      print('Error adding comment: $e');
      return false;
    }
  }
}
