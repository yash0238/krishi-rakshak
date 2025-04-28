import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'dart:convert';
import '../services/weather_service.dart';
import '../models/weather.dart';
import '../services/api_service.dart';
import '../widgets/language_selector.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const HomeScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final ApiService _apiService = ApiService();
  Weather? _currentWeather;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getCurrentWeather();
      setState(() {
        _currentWeather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _scanImage(String type) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isLoading = true;
      });

      // Read the image file as bytes
      final File imageFile = File(image.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Call API to predict disease
      final result = await _apiService.predictDisease(base64Image, type);

      setState(() {
        _isLoading = false;
      });

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorProcessingImage)),
        );
        return;
      }

      // Navigate to result screen
      Navigator.pushNamed(
        context,
        '/disease_result',
        arguments: result,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _scanFromGallery(String type) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isLoading = true;
      });

      // Read the image file as bytes
      final File imageFile = File(image.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Call API to predict disease
      final result = await _apiService.predictDisease(base64Image, type);

      setState(() {
        _isLoading = false;
      });

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorProcessingImage)),
        );
        return;
      }

      // Navigate to result screen
      Navigator.pushNamed(
        context,
        '/disease_result',
        arguments: result,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showImageSourceSelector(String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.selectImageSource,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.camera),
                onTap: () {
                  Navigator.pop(context);
                  _scanImage(type);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.gallery),
                onTap: () {
                  Navigator.pop(context);
                  _scanFromGallery(type);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          LanguageSelector(
            currentLocale: Localizations.localeOf(context),
            onChanged: widget.setLocale,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo and Tagline
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.eco,
                            size: 80,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.appTagline,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Scan Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildScanButton(
                            context,
                            l10n.scanCrop,
                            Icons.grass,
                            Colors.green.shade600,
                            () => _showImageSourceSelector('plant'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildScanButton(
                            context,
                            l10n.scanAnimal,
                            Icons.pets,
                            Colors.brown.shade600,
                            () => _showImageSourceSelector('animal'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Weather Widget
                    if (_currentWeather != null)
                      _buildWeatherWidget(context, _currentWeather!),
                    
                    const SizedBox(height: 24),

                    // Feature Buttons
                    _buildFeatureButton(
                      context,
                      l10n.diseaseLibrary,
                      Icons.medical_services,
                      Colors.red.shade600,
                      () => Navigator.pushNamed(context, '/disease_library'),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureButton(
                      context,
                      l10n.expertContacts,
                      Icons.contact_phone,
                      Colors.blue.shade600,
                      () => Navigator.pushNamed(context, '/expert_contacts'),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureButton(
                      context,
                      l10n.communityForum,
                      Icons.forum,
                      Colors.purple.shade600,
                      () => Navigator.pushNamed(context, '/community_forum'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildScanButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, Weather weather) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.currentWeather,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchWeather,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    _getWeatherIcon(weather.condition),
                    const SizedBox(height: 4),
                    Text(weather.condition),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${weather.temperature}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${weather.location}'),
                  ],
                ),
                Column(
                  children: [
                    Text('${AppLocalizations.of(context)!.humidity}: ${weather.humidity}%'),
                    Text('${AppLocalizations.of(context)!.wind}: ${weather.windSpeed} km/h'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    IconData iconData;
    
    condition = condition.toLowerCase();
    if (condition.contains('cloud')) {
      iconData = Icons.cloud;
    } else if (condition.contains('rain')) {
      iconData = Icons.water_drop;
    } else if (condition.contains('snow')) {
      iconData = Icons.ac_unit;
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      iconData = Icons.flash_on;
    } else if (condition.contains('mist') || condition.contains('fog')) {
      iconData = Icons.cloud_queue;
    } else {
      iconData = Icons.wb_sunny;
    }
    
    return Icon(iconData, size: 40);
  }

  Widget _buildFeatureButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
