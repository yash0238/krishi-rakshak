import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onChanged;
  
  const LanguageSelector({
    Key? key,
    required this.currentLocale,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) {
        // Save the selected language code
        LanguageService.setLanguageCode(languageCode);
        // Update the app locale
        onChanged(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) => [
        _buildLanguageItem('mr', 'मराठी'),
        _buildLanguageItem('hi', 'हिंदी'),
        _buildLanguageItem('en', 'English'),
      ],
    );
  }
  
  PopupMenuItem<String> _buildLanguageItem(String code, String name) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          // Show a check mark for the current language
          if (currentLocale.languageCode == code)
            const Icon(Icons.check, size: 16, color: Colors.green)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
    );
  }
}
