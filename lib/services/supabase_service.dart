import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/constants.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  Future<List<Task>> getTasks() async {
    final response = await _client
        .from(AppConstants.tasksTable)
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> addTask(String title) async {
    final response = await _client
        .from(AppConstants.tasksTable)
        .insert({'title': title, 'user_id': _userId, 'is_completed': false})
        .select()
        .single();

    return Task.fromJson(response);
  }

  Future<void> deleteTask(String id) async {
    await _client
        .from(AppConstants.tasksTable)
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }

  Future<void> updateTask(String id, bool isCompleted) async {
    await _client
        .from(AppConstants.tasksTable)
        .update({'is_completed': isCompleted})
        .eq('id', id)
        .eq('user_id', _userId);
  }

  Future<void> editTask(String id, String newTitle) async {
    await _client
        .from(AppConstants.tasksTable)
        .update({'title': newTitle})
        .eq('id', id)
        .eq('user_id', _userId);
  }
}
