class ForumPost {
  final int id;
  final String title;
  final String content;
  final String authorName;
  final DateTime createdAt;
  final List<ForumComment> comments;
  
  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.createdAt,
    required this.comments,
  });
  
  factory ForumPost.fromJson(Map<String, dynamic> json) {
    final commentsList = (json['comments'] as List)
        .map((commentJson) => ForumComment.fromJson(commentJson))
        .toList();
    
    return ForumPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorName: json['author_name'],
      createdAt: DateTime.parse(json['created_at']),
      comments: commentsList,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author_name': authorName,
      'created_at': createdAt.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class ForumComment {
  final int id;
  final String content;
  final String authorName;
  final DateTime createdAt;
  
  ForumComment({
    required this.id,
    required this.content,
    required this.authorName,
    required this.createdAt,
  });
  
  factory ForumComment.fromJson(Map<String, dynamic> json) {
    return ForumComment(
      id: json['id'],
      content: json['content'],
      authorName: json['author_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author_name': authorName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
