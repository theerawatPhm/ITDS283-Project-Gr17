import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/home_page.dart';
import 'package:flutter/material.dart';

Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3D Now App',
      theme: ThemeData(
        fontFamily: 'Noto',
        
        scaffoldBackgroundColor: const Color(0xFFF8F8F8), 
      ),
      
      home: const HomePage(), 
    );
  }
}