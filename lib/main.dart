import 'package:flutter/material.dart';
import 'services/tts_service.dart';
import 'ui/screens/subjects_screen.dart';
import 'ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Text to Speech service (Auto CI/CD verified)
  await TtsService().init();
  runApp(const BlooketLearnApp());
}

class BlooketLearnApp extends StatelessWidget {
  const BlooketLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blooket Flag Cards Học Tập',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SubjectsScreen(),
    );
  }
}
