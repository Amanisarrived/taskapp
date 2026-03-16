import 'package:flutter/material.dart';
import 'gradientbutton.dart';

class TaskBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final String initialValue;
  final void Function(String title) onSubmit;

  const TaskBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onSubmit,
    this.initialValue = '',
  });

  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required void Function(String) onSubmit,
    String initialValue = '',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => TaskBottomSheet(
        title: title,
        subtitle: subtitle,
        buttonLabel: buttonLabel,
        onSubmit: onSubmit,
        initialValue: initialValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: initialValue.isEmpty
                  ? 'What do you need to do?'
                  : 'Task title',
            ),
            onSubmitted: (_) {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              onSubmit(value);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: buttonLabel,
            onTap: () {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              onSubmit(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
