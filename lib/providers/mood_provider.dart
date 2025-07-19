import 'package:flutter/material.dart';
import 'package:student_wellness_app/models/mood.dart';
import 'package:student_wellness_app/services/database_service.dart';

class MoodProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  List<Mood> _moods = [];
  String? _userId;

  MoodProvider(this._databaseService);

  List<Mood> get moods => _moods;

  void updateUserId(String? userId) {
    _userId = userId;
    if (userId != null) _loadMoods();
  }

  Future<void> _loadMoods() async {
    _moods = await _databaseService.getMoods(_userId!);
    notifyListeners();
  }

  Future<void> addMood(Mood mood) async {
    await _databaseService.addMood(_userId!, mood);
    _moods.add(mood);
    notifyListeners();
  }
}