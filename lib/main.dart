import 'package:flutter/material.dart';
import 'package:project/TechServicePage.dart';

import 'TechServicePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech News',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TechNewsPage(),
    );
  }
}