import 'package:flutter/material.dart';
import '../dashboard/task_model.dart';
import '../services/supabase_service.dart';

class TaskProvider extends ChangeNotifier {
  final _service = SupabaseService();

  List<Task> _tasks = [];
  bool _loading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get loading => _loading;
  String? get error => _error;

  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  Future<void> fetchTasks({bool silent = false}) async {
    if (!silent) {
      _loading = true;
      notifyListeners();
    }
    _error = null;

    try {
      _tasks = await _service.getTasks();
    } catch (e) {
      _error = e.toString();
      debugPrint('fetchTasks error: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    try {
      await _service.addTask(title);
      await fetchTasks(silent: true); // no spinner
    } catch (e) {
      _error = e.toString();
      debugPrint('addTask error: $e');
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _service.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('deleteTask error: $e');
      notifyListeners();
    }
  }

  Future<void> toggleTask(Task task) async {
    try {
      await _service.updateTask(task.id, !task.isCompleted);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('toggleTask error: $e');
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> editTask(String id, String newTitle) async {
    try {
      await _service.editTask(id, newTitle);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(title: newTitle);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('editTask error: $e');
      notifyListeners();
    }
  }
}
