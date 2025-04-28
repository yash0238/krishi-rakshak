import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import '../models/weather.dart';

class WeatherService {
  final Location _location = Location();
  
  // Get the current location
  Future<LocationData?> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    
    // Check if location service is enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    
    // Check if location permission is granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    
    // Get the current location
    return await _location.getLocation();
  }
  
  // Get the current weather
  Future<Weather> getCurrentWeather() async {
    try {
      // Get the current location
      final locationData = await _getCurrentLocation();
      
      if (locationData == null) {
        // Return a default weather if location is not available
        return Weather(
          temperature: 0,
          condition: 'Unknown',
          location: 'Unknown',
          humidity: 0,
          windSpeed: 0,
        );
      }
      
      // For a real implementation, you would use a weather API
      // like OpenWeatherMap, AccuWeather, etc.
      // For this MVP, we'll simulate weather data based on the month
      final now = DateTime.now();
      final month = now.month;
      
      // Simulate weather based on month (for India's climate)
      String condition;
      double temperature;
      int humidity;
      double windSpeed;
      
      if (month >= 11 || month <= 2) {
        // Winter
        temperature = 10 + (now.day % 10);
        condition = 'Clear';
        humidity = 40 + (now.day % 20);
        windSpeed = 5 + (now.day % 5);
      } else if (month >= 3 && month <= 5) {
        // Summer
        temperature = 30 + (now.day % 12);
        condition = 'Sunny';
        humidity = 30 + (now.day % 15);
        windSpeed = 8 + (now.day % 7);
      } else if (month >= 6 && month <= 9) {
        // Monsoon
        temperature = 25 + (now.day % 8);
        condition = 'Rainy';
        humidity = 70 + (now.day % 20);
        windSpeed = 10 + (now.day % 10);
      } else {
        // Autumn
        temperature = 20 + (now.day % 10);
        condition = 'Partly Cloudy';
        humidity = 50 + (now.day % 20);
        windSpeed = 7 + (now.day % 6);
      }
      
      // Try to get a location name from the coordinates using reverse geocoding
      // In a real app, use a service like Google Maps Geocoding API
      final locationName = await _getLocationName(
        locationData.latitude ?? 0, 
        locationData.longitude ?? 0
      );
      
      return Weather(
        temperature: temperature,
        condition: condition,
        location: locationName,
        humidity: humidity,
        windSpeed: windSpeed,
      );
    } catch (e) {
      print('Error getting weather: $e');
      // Return a default weather on error
      return Weather(
        temperature: 25,
        condition: 'Unknown',
        location: 'Unknown',
        humidity: 50,
        windSpeed: 5,
      );
    }
  }
  
  // Get location name from coordinates using OpenStreetMap Nominatim
  Future<String> _getLocationName(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10'
        ),
        headers: {'Accept-Language': 'en-US,en;q=0.9'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data.containsKey('address')) {
          // Try to extract city, town, or village
          final address = data['address'];
          final city = address['city'] ?? 
                      address['town'] ?? 
                      address['village'] ?? 
                      address['county'] ??
                      address['state'] ??
                      'Unknown';
          
          return city;
        }
      }
      
      return 'Unknown Location';
    } catch (e) {
      print('Error getting location name: $e');
      return 'Unknown Location';
    }
  }
}
