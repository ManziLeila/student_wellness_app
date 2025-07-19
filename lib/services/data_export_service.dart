import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';

import 'database_service.dart';

class DataExportService {
  final DatabaseService _db;

  DataExportService(this._db);

  Future<String> createUserDataExport(String userId) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final exportDir = Directory('${tempDir.path}/export_$userId');
      
      // Clean up existing directory if it exists
      if (await exportDir.exists()) {
        await exportDir.delete(recursive: true);
      }
      await exportDir.create(recursive: true);

      // Export journals
      final journals = await _db.getJournalEntries(userId);
      final journalsFile = File('${exportDir.path}/journals.json');
      await journalsFile.writeAsString(jsonEncode(journals));

      // Export moods
      final moods = await _db.getMoods(userId);  // Fixed typo from getWoods to getMoods
      final moodsFile = File('${exportDir.path}/moods.json');
      await moodsFile.writeAsString(jsonEncode(moods));

      // Zip the files
      final zipFile = File('${tempDir.path}/user_${userId}_data.zip');
      final encoder = ZipFileEncoder();  // Fixed case and proper constructor
      
      encoder.create(zipFile.path);
      encoder.addDirectory(exportDir);
      encoder.close();

      return zipFile.path;
    } catch (e) {
      throw Exception('Failed to create data export: ${e.toString()}');
    }
  }
}