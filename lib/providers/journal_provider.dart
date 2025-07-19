import 'package:flutter/cupertino.dart';

import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  final List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => _entries;

  void addEntry(JournalEntry entry) {
    _entries.add(entry);
    notifyListeners();
    // Save to local storage or database
  }

  Future<void> loadEntries() async {
    // Load from local storage or database
    // _entries = await storage.loadEntries();
    notifyListeners();
  }
}