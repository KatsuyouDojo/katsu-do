import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'models/verb.dart';
import 'home_page.dart'; // Assicurati di aver creato home_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Verb> verbs = [];

  @override
  void initState() {
    super.initState();
    loadVerbs();
  }

  Future<void> loadVerbs() async {
    final String response = await rootBundle.loadString('assets/verbi.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      verbs = data.map((json) => Verb.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verbi Giapponesi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(verbs: verbs), // Passa la lista dei verbi caricata
    );
  }
}
