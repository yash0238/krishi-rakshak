import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/disease.dart';

class DiseaseResultScreen extends StatefulWidget {
  const DiseaseResultScreen({Key? key}) : super(key: key);

  @override
  _DiseaseResultScreenState createState() => _DiseaseResultScreenState();
}

class _DiseaseResultScreenState extends State<DiseaseResultScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  late Disease _disease;
  String _currentLanguageCode = 'mr'; // Default is Marathi

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disease = ModalRoute.of(context)!.settings.arguments as Disease;
    _currentLanguageCode = Localizations.localeOf(context).languageCode;
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_currentLanguageCode);
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      await _flutterTts.setLanguage(_currentLanguageCode);
      await _flutterTts.speak(text);
      setState(() {
        _isSpeaking = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diseaseResult),
        actions: [
          IconButton(
            icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
            onPressed: () {
              // Combine all text to be spoken
              final textToSpeak = 
                '${l10n.diseaseName}: ${_disease.name}. '
                '${l10n.confidence}: ${(_disease.confidenceScore * 100).toStringAsFixed(1)}%. '
                '${l10n.symptoms}: ${_disease.symptoms}. '
                '${l10n.remedy}: ${_disease.remedy}';
              
              _speak(textToSpeak);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Disease Type Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _disease.type == 'plant' 
                                ? Colors.green.shade100 
                                : Colors.brown.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _disease.type == 'plant' ? Icons.grass : Icons.pets,
                            size: 50,
                            color: _disease.type == 'plant' 
                                ? Colors.green.shade700 
                                : Colors.brown.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Disease Name
                      Center(
                        child: Text(
                          _disease.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Confidence Score
                      Center(
                        child: Chip(
                          avatar: const Icon(Icons.check_circle, color: Colors.white),
                          label: Text(
                            '${l10n.confidence}: ${(_disease.confidenceScore * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: _getConfidenceColor(_disease.confidenceScore),
                        ),
                      ),
                      
                      const Divider(height: 32),
                      
                      // Symptoms Section
                      _buildInfoSection(
                        context,
                        l10n.symptoms,
                        _disease.symptoms,
                        Icons.sick,
                        Colors.red.shade700,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Remedy Section
                      _buildInfoSection(
                        context,
                        l10n.remedy,
                        _disease.remedy,
                        Icons.healing,
                        Colors.green.shade700,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/expert_contacts');
                      },
                      icon: const Icon(Icons.contact_phone),
                      label: Text(l10n.contactExpert),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/community_forum');
                      },
                      icon: const Icon(Icons.forum),
                      label: Text(l10n.askCommunity),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: Text(l10n.scanAnother),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.85) {
      return Colors.green.shade700;
    } else if (confidence >= 0.7) {
      return Colors.orange.shade700;
    } else {
      return Colors.red.shade700;
    }
  }
}
