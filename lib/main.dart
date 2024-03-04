import 'package:flutter/material.dart';
import 'package:weather/pages/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      theme: ThemeData(
        colorScheme:
            Theme.of(context).colorScheme.copyWith(background: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
