import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/disease_result_screen.dart';
import 'screens/disease_library_screen.dart';
import 'screens/expert_contacts_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/settings_screen.dart';
import 'services/language_service.dart';

void main() {
  runApp(const KrishiRakshakApp());
}

class KrishiRakshakApp extends StatefulWidget {
  const KrishiRakshakApp({Key? key}) : super(key: key);

  @override
  _KrishiRakshakAppState createState() => _KrishiRakshakAppState();
}

class _KrishiRakshakAppState extends State<KrishiRakshakApp> {
  Locale _locale = const Locale('mr'); // Default is Marathi

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishi Rakshak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green.shade700,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: Colors.orange,
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('mr'), // Marathi
        Locale('hi'), // Hindi
        Locale('en'), // English
      ],
      routes: {
        '/': (context) => HomeScreen(setLocale: setLocale),
        '/disease_result': (context) => const DiseaseResultScreen(),
        '/disease_library': (context) => const DiseaseLibraryScreen(),
        '/expert_contacts': (context) => const ExpertContactsScreen(),
        '/community_forum': (context) => const CommunityForumScreen(),
        '/settings': (context) => SettingsScreen(setLocale: setLocale),
      },
    );
  }
}
