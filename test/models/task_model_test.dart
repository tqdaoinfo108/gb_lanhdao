import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';

void main() {
  group('Task Model - displayProgress', () {
    test('should return raw progress when subtasks are empty', () {
      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 0.75,
        date: DateTime.now(),
        statusLabel: 'Đang thực hiện',
        avatarUrls: [],
      );

      expect(task.displayProgress, 0.75);
    });

    test('should calculate progress based on subtasks when available', () {
      final subTasks = [
        SubTask(
          id: 's1',
          title: 'Sub 1',
          assignee: 'A',
          dueDate: DateTime.now(),
          status: SubTaskStatus.hoanThanh,
          priority: SubTaskPriority.trungBinh,
        ),
        SubTask(
          id: 's2',
          title: 'Sub 2',
          assignee: 'B',
          dueDate: DateTime.now(),
          status: SubTaskStatus.dangLam,
          priority: SubTaskPriority.trungBinh,
        ),
      ];

      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 0.1, // This should be ignored
        date: DateTime.now(),
        statusLabel: 'Đang thực hiện',
        avatarUrls: [],
        subTasks: subTasks,
      );

      expect(task.displayProgress, 0.5);
    });

    test('should return 0.0 when there are subtasks but none are completed', () {
      final subTasks = [
        SubTask(
          id: 's1',
          title: 'Sub 1',
          assignee: 'A',
          dueDate: DateTime.now(),
          status: SubTaskStatus.chuaLam,
          priority: SubTaskPriority.trungBinh,
        ),
      ];

      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 0.9,
        date: DateTime.now(),
        statusLabel: 'Đang thực hiện',
        avatarUrls: [],
        subTasks: subTasks,
      );

      expect(task.displayProgress, 0.0);
    });
  });

  group('Task Model - progressColor', () {
    test('should return red for status containing "chậm tiến độ"', () {
      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 1.0,
        date: DateTime.now(),
        statusLabel: 'Chậm tiến độ (5 ngày)',
        avatarUrls: [],
      );

      expect(task.progressColor, const Color(0xFFE74C3C));
    });

    test('should return orange for status containing "có rủi ro"', () {
      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 1.0,
        date: DateTime.now(),
        statusLabel: 'Có rủi ro',
        avatarUrls: [],
      );

      expect(task.progressColor, const Color(0xFFF2994A));
    });

    test('should return green for progress >= 100%', () {
      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 1.0,
        date: DateTime.now(),
        statusLabel: 'Hoàn thành',
        avatarUrls: [],
      );

      expect(task.progressColor, const Color(0xFF20C46A));
    });

    test('should return blue for progress >= 80%', () {
      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 0.85,
        date: DateTime.now(),
        statusLabel: 'Đang thực hiện',
        avatarUrls: [],
      );

      expect(task.progressColor, const Color(0xFF2F6CE1));
    });

    test('should return yellow for progress < 80%', () {
      final task = Task(
        id: '1',
        title: 'Task 1',
        department: 'Dept',
        owner: 'Owner',
        progress: 0.5,
        date: DateTime.now(),
        statusLabel: 'Đang thực hiện',
        avatarUrls: [],
      );

      expect(task.progressColor, const Color(0xFFF2C94C));
    });
  });
}
