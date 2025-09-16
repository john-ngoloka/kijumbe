import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../group/presentation/cubit/group_cubit.dart';
import '../../../group/presentation/widgets/create_group_form.dart';
import '../../../group/presentation/widgets/join_group_form.dart';
import '../../presentation/cubit/auth_cubit.dart';

enum GroupSelectionMode { none, create, join }

class GroupSelectionScreen extends StatefulWidget {
  const GroupSelectionScreen({super.key});

  @override
  State<GroupSelectionScreen> createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  GroupSelectionMode _selectedMode = GroupSelectionMode.none;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GroupCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode_outlined, color: Colors.black),
              onPressed: () {
                // TODO: Implement dark mode toggle
              },
            ),
          ],
        ),
        body: BlocListener<GroupCubit, GroupState>(
          listener: (context, state) {
            if (state is GroupCreated) {
              print(
                '🧭 GROUP SELECTION: Group created, navigating to admin dashboard',
              );
              Navigator.of(context).pushReplacementNamed('/admin-dashboard');
            } else if (state is GroupJoined) {
              print(
                '🧭 GROUP SELECTION: Group joined, navigating to member dashboard',
              );
              Navigator.of(context).pushReplacementNamed('/member-dashboard');
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Title Section
                  const Text(
                    'Choose Your Next Step',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Would you like to create a new group or join an existing one?',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Group Selection Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionCard(
                          icon: Icons.group_add,
                          title: 'Create Group',
                          subtitle: 'Start a new group',
                          isSelected:
                              _selectedMode == GroupSelectionMode.create,
                          onTap: () {
                            setState(() {
                              _selectedMode = GroupSelectionMode.create;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSelectionCard(
                          icon: Icons.group,
                          title: 'Join Group',
                          subtitle: 'Join existing group',
                          isSelected: _selectedMode == GroupSelectionMode.join,
                          onTap: () {
                            setState(() {
                              _selectedMode = GroupSelectionMode.join;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Show appropriate form based on selection
                  if (_selectedMode == GroupSelectionMode.create) ...[
                    const CreateGroupForm(),
                  ] else if (_selectedMode == GroupSelectionMode.join) ...[
                    const JoinGroupForm(),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select an option above to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? const Color(0xFF1E3A8A).withOpacity(0.05)
              : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1E3A8A)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFF1E3A8A)
                    : Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? const Color(0xFF1E3A8A).withOpacity(0.8)
                    : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
