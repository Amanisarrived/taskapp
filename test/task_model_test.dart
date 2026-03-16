import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/dashboard/task_model.dart';

void main() {
  group('Task model', () {
    final mockJson = {
      'id': 'abc-123',
      'title': 'Buy groceries',
      'is_completed': false,
      'created_at': '2024-03-16T10:00:00.000Z',
    };

    test('fromJson creates Task correctly', () {
      final task = Task.fromJson(mockJson);

      expect(task.id, 'abc-123');
      expect(task.title, 'Buy groceries');
      expect(task.isCompleted, false);
      expect(task.createdAt, DateTime.parse('2024-03-16T10:00:00.000Z'));
    });

    test('toJson returns correct map', () {
      final task = Task.fromJson(mockJson);
      final json = task.toJson();

      expect(json['id'], 'abc-123');
      expect(json['title'], 'Buy groceries');
      expect(json['is_completed'], false);
    });

    test('copyWith updates only given fields', () {
      final task = Task.fromJson(mockJson);
      final updated = task.copyWith(title: 'Buy vegetables', isCompleted: true);

      expect(updated.title, 'Buy vegetables');
      expect(updated.isCompleted, true);
      expect(updated.id, task.id);
    });

    test('default isCompleted is false', () {
      final json = {
        'id': 'xyz-456',
        'title': 'Test task',
        'created_at': '2024-03-16T10:00:00.000Z',
      };
      final task = Task.fromJson(json);
      expect(task.isCompleted, false);
    });
  });
}