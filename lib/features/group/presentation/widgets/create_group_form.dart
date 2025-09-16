import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/authentication/presentation/cubit/auth_cubit.dart';
import '../cubit/group_cubit.dart';

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({super.key});

  @override
  State<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupCreated) {
          print(
            '🏗️ CREATE GROUP SUCCESS: Group created - ${state.group.name} (ID: ${state.group.id})',
          );
          print('🏗️ CREATE GROUP: Admin ID: ${state.group.adminId}');
          print(
            '🏗️ CREATE GROUP: Contribution amount: ${state.group.contributionAmount}',
          );
          print('🏗️ CREATE GROUP: Frequency: ${state.group.frequency}');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group created successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigation will be handled by the group selection screen
        } else if (state is GroupError) {
          print('🏗️ CREATE GROUP ERROR: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating group: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GroupLoading) {
          print('🏗️ CREATE GROUP: Loading...');
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create New Group',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              // Group Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  prefixIcon: Icon(Icons.group),
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Family Savings Group',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a group name';
                  }
                  if (value.trim().length < 3) {
                    return 'Group name must be at least 3 characters';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Group Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Group Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  hintText: 'Describe the purpose of this group...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a group description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Create Group Button
              ElevatedButton.icon(
                onPressed: state is GroupLoading ? null : _handleCreateGroup,
                icon: state is GroupLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_circle),
                label: Text(
                  state is GroupLoading ? 'Creating...' : 'Create Group',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info Text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'As the group creator, you will be the administrator and can manage group settings, members, and cycles.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCreateGroup() async {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        // Convert user ID from string to int for now
        final adminId = int.tryParse(authState.user.id) ?? 1;

        print('🏗️ CREATE GROUP: Starting group creation...');
        print('🏗️ CREATE GROUP: Admin ID: $adminId');
        print('🏗️ CREATE GROUP: Group name: ${_nameController.text.trim()}');
        print(
          '🏗️ CREATE GROUP: Group description: ${_descriptionController.text.trim()}',
        );

        context.read<GroupCubit>().createGroup(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          adminId: adminId,
        );
      } else {
        print('🏗️ CREATE GROUP ERROR: User not authenticated');
      }
    }
  }
}
