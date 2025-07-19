import 'package:flutter/foundation.dart';

class ModerationService {
  final List<String> _bannedWords = [
    'hate',
    'kill',
    // Add more sensitive words
  ];

  Future<bool> checkForInappropriateContent(String text) async {
    final lowerText = text.toLowerCase();

    // Local check
    if (_bannedWords.any((word) => lowerText.contains(word))) {
      return true;
    }

    // Cloud check (example using Firebase ML Kit)
    try {
      // TODO: Implement FirebaseNL or ML Kit language detection if needed
      // final result = await FirebaseNL.instance.identifyLanguage(text);
      // if (result.isEvident) {
      //   return true;
      // }
    } catch (e) {
      debugPrint('Moderation error: $e');
    }

    return false;
  }
}

class ModerationException implements Exception {
  final String message;
  const ModerationException(this.message);
  @override
  String toString() => 'ModerationException: $message';
}