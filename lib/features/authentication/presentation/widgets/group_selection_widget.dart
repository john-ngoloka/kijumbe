import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../../../group/presentation/widgets/create_group_form.dart';
import '../../../group/presentation/widgets/join_group_form.dart';

enum GroupSelectionMode { none, create, join }

class GroupSelectionWidget extends StatefulWidget {
  const GroupSelectionWidget({super.key});

  @override
  State<GroupSelectionWidget> createState() => _GroupSelectionWidgetState();
}

class _GroupSelectionWidgetState extends State<GroupSelectionWidget> {
  GroupSelectionMode _selectedMode = GroupSelectionMode.none;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Check if user is already a member of any group
          _checkUserGroupMembership(context, state.user.id);
        }
      },
      builder: (context, state) {
        // Only show group selection if user is authenticated
        if (state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Choose Your Next Step',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Would you like to create a new group or join an existing one?',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Group Selection Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSelectionButton(
                        icon: Icons.group_add,
                        title: 'Create Group',
                        subtitle: 'Start a new group',
                        isSelected: _selectedMode == GroupSelectionMode.create,
                        onTap: () {
                          setState(() {
                            _selectedMode = GroupSelectionMode.create;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSelectionButton(
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

                const SizedBox(height: 24),

                // Show appropriate form based on selection
                if (_selectedMode == GroupSelectionMode.create) ...[
                  const CreateGroupForm(),
                ] else if (_selectedMode == GroupSelectionMode.join) ...[
                  const JoinGroupForm(),
                ] else ...[
                  const SizedBox(height: 20),
                  Text(
                    'Select an option above to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.blue : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _checkUserGroupMembership(BuildContext context, String userId) {
    // TODO: Implement check for existing group membership
    // This should call a use case to check if user is already a member of any group
    // If they are, navigate them to the appropriate group screen
    // For now, we'll just show the selection options
  }
}
