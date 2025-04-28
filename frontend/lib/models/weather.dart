class Weather {
  final double temperature;
  final String condition;
  final String location;
  final int humidity;
  final double windSpeed;
  
  Weather({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.humidity,
    required this.windSpeed,
  });
  
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['temperature'].toDouble(),
      condition: json['condition'],
      location: json['location'],
      humidity: json['humidity'],
      windSpeed: json['wind_speed'].toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'condition': condition,
      'location': location,
      'humidity': humidity,
      'wind_speed': windSpeed,
    };
  }
}
