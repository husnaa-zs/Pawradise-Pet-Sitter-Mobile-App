import 'package:flutter/material.dart';

import 'screens/auth.dart';
import 'state.dart';
import 'theme.dart';

void main() => runApp(const PawradiseApp());

class PawradiseApp extends StatefulWidget {
  const PawradiseApp({super.key});

  @override
  State<PawradiseApp> createState() => _PawradiseAppState();
}

class _PawradiseAppState extends State<PawradiseApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'Pawradise',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const WelcomeScreen(),
      ),
    );
  }
}
