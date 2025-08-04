// shared/utils/file_utils.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Utility-Klasse für Datei-Operationen
/// Verbessert die Wartbarkeit durch zentrale Datei-Funktionen
class FileUtils {
  static const String _documentsDir = 'documents';
  static const String _evidenceDir = 'evidence';
  static const String _backupsDir = 'backups';
  static const String _tempDir = 'temp';

  /// Generiert eine eindeutige Datei-ID
  static String generateFileId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Formatiert Dateigröße für bessere Lesbarkeit
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Prüft ob eine Datei existiert
  static Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Erstellt Verzeichnisse falls sie nicht existieren
  static Future<void> createDirectories() async {
    final appDir = await getApplicationDocumentsDirectory();

    final directories = [
      '${appDir.path}/$_documentsDir',
      '${appDir.path}/$_evidenceDir',
      '${appDir.path}/$_backupsDir',
      '${appDir.path}/$_tempDir',
    ];

    for (final dirPath in directories) {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }
  }

  /// Speichert eine Datei im lokalen Speicher
  static Future<String> saveFile({
    required String fileName,
    required Uint8List data,
    required String directory,
  }) async {
    await createDirectories();

    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$directory/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(data);

    return filePath;
  }

  /// Lädt eine Datei aus dem lokalen Speicher
  static Future<Uint8List?> loadFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Löscht eine Datei
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Kopiert eine Datei
  static Future<String?> copyFile({
    required String sourcePath,
    required String destinationPath,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      final destinationFile = File(destinationPath);

      if (await sourceFile.exists()) {
        await sourceFile.copy(destinationFile.path);
        return destinationFile.path;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Erstellt ein Backup einer Datei
  static Future<String?> createBackup(String filePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = '${appDir.path}/$_backupsDir';
      final backupPath =
          '$backupDir/backup_${DateTime.now().millisecondsSinceEpoch}_${filePath.split('/').last}';

      return await copyFile(
        sourcePath: filePath,
        destinationPath: backupPath,
      );
    } catch (e) {
      return null;
    }
  }

  /// Validiert Datei-Typen
  static bool isValidFileType(String fileName, List<String> allowedExtensions) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  /// Generiert einen sicheren Dateinamen
  static String generateSafeFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = originalName.split('.').last;
    final baseName = originalName.split('.').first;

    // Entferne ungültige Zeichen
    final safeBaseName = baseName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

    return '${safeBaseName}_$timestamp.$extension';
  }

  /// Berechnet die Größe eines Verzeichnisses
  static Future<int> getDirectorySize(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      if (!await dir.exists()) return 0;

      int totalSize = 0;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Löscht temporäre Dateien
  static Future<void> cleanupTempFiles() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final tempDir = Directory('${appDir.path}/$_tempDir');

      if (await tempDir.exists()) {
        await for (final entity in tempDir.list()) {
          if (entity is File) {
            final fileAge =
                DateTime.now().difference(await entity.lastModified());
            if (fileAge.inHours > 24) {
              await entity.delete();
            }
          }
        }
      }
    } catch (e) {
      // Ignoriere Fehler beim Cleanup
    }
  }

  /// Zeigt einen Datei-Picker Dialog
  static Future<String?> showFilePicker({
    required BuildContext context,
    required String title,
    List<String> allowedExtensions = const [],
  }) async {
    // Mock-Implementierung für Demo-Zwecke
    // In einer echten App würde hier ein Datei-Picker verwendet
    await Future.delayed(const Duration(milliseconds: 500));

    return '/mock/path/to/selected/file.pdf';
  }

  /// Zeigt einen Speichern-Dialog
  static Future<String?> showSaveDialog({
    required BuildContext context,
    required String fileName,
    String? suggestedName,
  }) async {
    // Mock-Implementierung für Demo-Zwecke
    await Future.delayed(const Duration(milliseconds: 300));

    return suggestedName ?? fileName;
  }
}
