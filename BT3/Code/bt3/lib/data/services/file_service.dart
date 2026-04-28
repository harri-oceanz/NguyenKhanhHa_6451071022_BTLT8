import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class FileService {
  static Future<void> export(List<Task> tasks) async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final file = File('${dir.path}/tasks.json');

    final jsonData = tasks.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
    final content = await file.readAsString();
    print("FILE CONTENT: $content");
  }

  static Future<List<Task>> import() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final file = File('${dir.path}/tasks.json');

    if (!file.existsSync()) return [];

    final content = await file.readAsString();
    final data = jsonDecode(content);

    return (data as List).map((e) => Task.fromJson(e)).toList();
  }
}