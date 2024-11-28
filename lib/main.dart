import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MySimpleNotes());
}

class MySimpleNotes extends StatelessWidget {
  const MySimpleNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Simple Note",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(color: Colors.black87),
      ),
      home: const HomeScreen(),
    );
  }
}
