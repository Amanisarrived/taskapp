import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/dashboard/widgets/shimmer.dart';
import 'package:task_app/dashboard/widgets/silver_task_screen.dart';
import 'package:task_app/dashboard/widgets/task_bottom_sheet.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../provider/task_provider.dart';
import 'task_model.dart';
import 'widgets/dashboard_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    Future.microtask(() {
      if (mounted) context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showAddSheet() {
    TaskBottomSheet.show(
      context: context,
      title: 'New Task',
      subtitle: 'Add a task to your list',
      buttonLabel: 'Add Task',
      onSubmit: (title) => context.read<TaskProvider>().addTask(title),
    );
  }

  void _showEditSheet(Task task) {
    TaskBottomSheet.show(
      context: context,
      title: 'Edit Task',
      subtitle: 'Update your task title',
      buttonLabel: 'Save Changes',
      initialValue: task.title,
      onSubmit: (title) =>
          context.read<TaskProvider>().editTask(task.id, title),
    );
  }

  Future<void> _logout() async {
    final cs = Theme.of(context).colorScheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Logout', style: TextStyle(color: cs.error)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final cs = Theme.of(context).colorScheme;
    final username = (_authService.currentUser?.email ?? '').split('@').first;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        child: const Icon(Icons.add),
      ),
      body: provider.loading
          ? const ShimmerLoader()
          : FadeTransition(
              opacity: _fadeAnim,
              child: RefreshIndicator(
                onRefresh: provider.fetchTasks,
                child: CustomScrollView(
                  slivers: [
                    // header
                    SliverToBoxAdapter(
                      child: DashboardHeader(
                        username: username,
                        totalTasks: provider.tasks.length,
                        pendingTasks: provider.pendingTasks.length,
                        completedTasks: provider.completedTasks.length,
                        onLogout: _logout,
                      ),
                    ),

                    // empty state
                    if (provider.tasks.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.task_alt_outlined,
                                size: 72,
                                color: cs.onSurfaceVariant.withAlpha(100),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap + to add your first task',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      if (provider.pendingTasks.isNotEmpty)
                        SliverTaskSection(
                          label: 'PENDING',
                          tasks: provider.pendingTasks,
                          headerPadding: const EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            10,
                          ),
                          listPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          onEdit: _showEditSheet,
                        ),
                      if (provider.completedTasks.isNotEmpty)
                        SliverTaskSection(
                          label: 'COMPLETED',
                          tasks: provider.completedTasks,
                          headerPadding: const EdgeInsets.fromLTRB(
                            24,
                            16,
                            24,
                            10,
                          ),
                          listPadding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            100,
                          ),
                          onEdit: _showEditSheet,
                        ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
