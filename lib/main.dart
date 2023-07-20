import 'package:chatbot/constants/pallete.dart';
import 'package:chatbot/screen/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBot',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.blackColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.blackColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}
