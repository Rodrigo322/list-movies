import 'package:flutter/material.dart';

import 'app/modules/Home/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MoviesPage(),
    );
  }
}
