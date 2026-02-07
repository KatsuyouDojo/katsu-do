import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/verb.dart';

class VerbService {
  static Future<List<Verb>> loadVerbs() async {
    final jsonString = await rootBundle.loadString('assets/verbi.json');
    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => Verb.fromJson(e)).toList();
  }
}
