import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/dashboard/task_model.dart';
import 'package:task_app/dashboard/task_title.dart';
import 'package:task_app/provider/task_provider.dart';
import 'animated_task_item.dart';

class SliverTaskSection extends StatelessWidget {
  final String label;
  final List<Task> tasks;
  final EdgeInsets headerPadding;
  final EdgeInsets listPadding;
  final void Function(Task) onEdit;

  const SliverTaskSection({
    super.key,
    required this.label,
    required this.tasks,
    required this.headerPadding,
    required this.listPadding,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: headerPadding,
          sliver: SliverToBoxAdapter(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: listPadding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final task = tasks[index];
              return AnimatedTaskItem(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TaskTile(
                    task: task,
                    onDelete: () =>
                        context.read<TaskProvider>().deleteTask(task.id),
                    onToggle: () =>
                        context.read<TaskProvider>().toggleTask(task),
                    onEdit: () => onEdit(task),
                  ),
                ),
              );
            }, childCount: tasks.length),
          ),
        ),
      ],
    );
  }
}
