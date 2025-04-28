import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const SettingsScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  double _fontSize = 1.0; // 1.0 is the default scale
  bool _textToSpeechEnabled = true;
  Locale _currentLocale = const Locale('mr');
  bool _isLoadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = Localizations.localeOf(context);
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        _fontSize = prefs.getDouble('fontSize') ?? 1.0;
        _textToSpeechEnabled = prefs.getBool('textToSpeechEnabled') ?? true;
        _isLoadingPrefs = false;
      });
    } catch (e) {
      print('Error loading preferences: $e');
      setState(() {
        _isLoadingPrefs = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setDouble('fontSize', _fontSize);
      await prefs.setBool('textToSpeechEnabled', _textToSpeechEnabled);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.settingsSaved)),
      );
    } catch (e) {
      print('Error saving preferences: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _changeLanguage(String languageCode) {
    final locale = Locale(languageCode);
    widget.setLocale(locale);
    _flutterTts.setLanguage(languageCode);
    
    setState(() {
      _currentLocale = locale;
    });
  }

  Future<void> _testTextToSpeech() async {
    if (!_textToSpeechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.textToSpeechDisabled)),
      );
      return;
    }
    
    await _flutterTts.setLanguage(_currentLocale.languageCode);
    await _flutterTts.speak(AppLocalizations.of(context)!.textToSpeechTest);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: _isLoadingPrefs
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language Settings
                  _buildSectionHeader(l10n.languageSettings),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.selectLanguage),
                          const SizedBox(height: 16),
                          _buildLanguageRadioTile('mr', l10n.marathi),
                          _buildLanguageRadioTile('hi', l10n.hindi),
                          _buildLanguageRadioTile('en', l10n.english),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Accessibility Settings
                  _buildSectionHeader(l10n.accessibilitySettings),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Font Size
                          Text(l10n.fontSize),
                          Slider(
                            value: _fontSize,
                            min: 0.8,
                            max: 1.5,
                            divisions: 7,
                            label: _getFontSizeLabel(_fontSize),
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.small, style: const TextStyle(fontSize: 12)),
                              Text(l10n.normal, style: const TextStyle(fontSize: 14)),
                              Text(l10n.large, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Text-to-Speech
                          SwitchListTile(
                            title: Text(l10n.textToSpeech),
                            subtitle: Text(l10n.textToSpeechDesc),
                            value: _textToSpeechEnabled,
                            onChanged: (value) {
                              setState(() {
                                _textToSpeechEnabled = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _testTextToSpeech,
                              icon: const Icon(Icons.volume_up),
                              label: Text(l10n.testVoice),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // About App
                  _buildSectionHeader(l10n.aboutApp),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(l10n.appName),
                            subtitle: Text(l10n.appTagline),
                            leading: const Icon(Icons.eco, color: Colors.green),
                          ),
                          const Divider(),
                          ListTile(
                            title: Text(l10n.version),
                            subtitle: const Text('1.0.0'),
                            leading: const Icon(Icons.info_outline),
                          ),
                          const Divider(),
                          const ListTile(
                            title: Text('© 2023'),
                            subtitle: Text('Krishi Rakshak'),
                            leading: Icon(Icons.copyright),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Save Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _savePreferences,
                      icon: const Icon(Icons.save),
                      label: Text(l10n.saveSettings),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _buildLanguageRadioTile(String languageCode, String languageName) {
    return RadioListTile<String>(
      title: Text(languageName),
      value: languageCode,
      groupValue: _currentLocale.languageCode,
      onChanged: (value) {
        if (value != null) {
          _changeLanguage(value);
        }
      },
    );
  }

  String _getFontSizeLabel(double size) {
    if (size <= 0.9) {
      return AppLocalizations.of(context)!.small;
    } else if (size <= 1.1) {
      return AppLocalizations.of(context)!.normal;
    } else if (size <= 1.3) {
      return AppLocalizations.of(context)!.large;
    } else {
      return AppLocalizations.of(context)!.extraLarge;
    }
  }
}
