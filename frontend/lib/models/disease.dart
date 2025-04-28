class Disease {
  final int id;
  final String name;
  final String type;
  final String symptoms;
  final String remedy;
  final double confidenceScore;
  
  Disease({
    required this.id,
    required this.name,
    required this.type,
    required this.symptoms,
    required this.remedy,
    required this.confidenceScore,
  });
  
  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      symptoms: json['symptoms'],
      remedy: json['remedy'],
      confidenceScore: json['confidence_score'] ?? 1.0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'symptoms': symptoms,
      'remedy': remedy,
      'confidence_score': confidenceScore,
    };
  }
}
