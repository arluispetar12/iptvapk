import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ArluisTV());
}

class ArluisTV extends StatelessWidget {
  const ArluisTV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arluis TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFe03030),
          surface: const Color(0xFF161616),
        ),
        scaffoldBackgroundColor: const Color(0xFF0f0f0f),
        fontFamily: 'sans-serif',
      ),
      home: const LoginScreen(),
    );
  }
}
