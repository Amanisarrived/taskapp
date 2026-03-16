import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/dashboard/widgets/statcard.dart';
import '../../main.dart';
import 'headerbutton.dart';

class DashboardHeader extends StatelessWidget {
  final String username;
  final int totalTasks;
  final int pendingTasks;
  final int completedTasks;
  final VoidCallback onLogout;

  const DashboardHeader({
    super.key,
    required this.username,
    required this.totalTasks,
    required this.pendingTasks,
    required this.completedTasks,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6).withAlpha(isDark ? 200 : 230),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $username 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pendingTasks == 0
                          ? 'All caught up! 🎉'
                          : '$pendingTasks tasks remaining',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              HeaderButton(
                icon: isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                onTap: () => context.read<ThemeProvider>().toggle(),
              ),
              const SizedBox(width: 8),
              HeaderButton(icon: Icons.logout_outlined, onTap: onLogout),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              StatCard(
                label: 'Total',
                value: totalTasks,
                colors: const [Color(0xFFFFFFFF), Color(0xFFE0E7FF)],
              ),
              const SizedBox(width: 12),
              StatCard(
                label: 'Pending',
                value: pendingTasks,
                colors: const [Color(0xFFFEF3C7), Color(0xFFFEE2E2)],
              ),
              const SizedBox(width: 12),
              StatCard(
                label: 'Done',
                value: completedTasks,
                colors: const [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
