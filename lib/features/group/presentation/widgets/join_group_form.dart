import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/authentication/presentation/cubit/auth_cubit.dart';
import '../cubit/group_cubit.dart';

enum JoinGroupMethod { code, search }

class JoinGroupForm extends StatefulWidget {
  const JoinGroupForm({super.key});

  @override
  State<JoinGroupForm> createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<JoinGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _groupCodeController = TextEditingController();
  final _searchController = TextEditingController();
  JoinGroupMethod _selectedMethod = JoinGroupMethod.code;

  @override
  void dispose() {
    _groupCodeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupJoined) {
          print(
            '🔗 JOIN GROUP SUCCESS: Successfully joined group - ${state.group.name} (ID: ${state.group.id})',
          );
          print('🔗 JOIN GROUP: Group admin ID: ${state.group.adminId}');
          print(
            '🔗 JOIN GROUP: Group contribution amount: ${state.group.contributionAmount}',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully joined the group!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigation will be handled by the group selection screen
        } else if (state is GroupError) {
          print('🔗 JOIN GROUP ERROR: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error joining group: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GroupLoading) {
          print('🔗 JOIN GROUP: Loading...');
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join Existing Group',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              // Method Selection
              Row(
                children: [
                  Expanded(
                    child: _buildMethodButton(
                      icon: Icons.qr_code,
                      title: 'Group Code',
                      isSelected: _selectedMethod == JoinGroupMethod.code,
                      onTap: () {
                        setState(() {
                          _selectedMethod = JoinGroupMethod.code;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMethodButton(
                      icon: Icons.search,
                      title: 'Search',
                      isSelected: _selectedMethod == JoinGroupMethod.search,
                      onTap: () {
                        setState(() {
                          _selectedMethod = JoinGroupMethod.search;
                          _groupCodeController.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form based on selected method
              if (_selectedMethod == JoinGroupMethod.code) ...[
                _buildGroupCodeForm(),
              ] else ...[
                _buildSearchForm(),
              ],

              const SizedBox(height: 16),

              // Info Text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can join multiple groups. Each group has its own contribution cycles and payouts.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
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

  Widget _buildMethodButton({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.green.shade50 : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.green : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.green : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCodeForm() {
    return Column(
      children: [
        TextFormField(
          controller: _groupCodeController,
          decoration: const InputDecoration(
            labelText: 'Group Code',
            prefixIcon: Icon(Icons.tag),
            border: OutlineInputBorder(),
            hintText: 'Enter group invitation code',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a group code';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 16),
        BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            return ElevatedButton.icon(
              onPressed: groupState is GroupLoading ? null : _handleJoinByCode,
              icon: groupState is GroupLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.group_add),
              label: Text(
                groupState is GroupLoading ? 'Joining...' : 'Join Group',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchForm() {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Groups',
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
            hintText: 'Enter group name to search',
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {});
            if (value.trim().length >= 3) {
              _performSearch(value.trim());
            }
          },
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: 16),

        // Search Results
        BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            if (groupState is GroupsSearchResults &&
                groupState.groups.isNotEmpty) {
              return Column(
                children: [
                  const Text(
                    'Search Results:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...groupState.groups.map(
                    (group) => _buildSearchResultItem({
                      'id': group.id,
                      'name': group.name,
                      'description': group.description,
                    }),
                  ),
                ],
              );
            } else if (groupState is GroupsSearchResults &&
                groupState.groups.isEmpty &&
                _searchController.text.isNotEmpty &&
                _searchController.text.length >= 3) {
              return const Text(
                'No groups found matching your search.',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              );
            } else if (groupState is GroupLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.group, color: Colors.white),
        ),
        title: Text(group['name'] ?? 'Unknown Group'),
        subtitle: Text(group['description'] ?? 'No description'),
        trailing: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            return ElevatedButton(
              onPressed: groupState is GroupLoading
                  ? null
                  : () => _handleJoinGroup(group['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(80, 36),
              ),
              child: groupState is GroupLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Join'),
            );
          },
        ),
      ),
    );
  }

  void _handleJoinByCode() async {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthCubit>().state;
      print('🔗 JOIN GROUP BY CODE: Auth state: ${authState.runtimeType}');
      if (authState is AuthAuthenticated) {
        final userId = int.tryParse(authState.user.id) ?? 1;
        final groupCode = _groupCodeController.text.trim();
        print(
          '🔗 JOIN GROUP BY CODE: User authenticated - ID: $userId, Phone: ${authState.user.phone}',
        );

        print('🔗 JOIN GROUP BY CODE: Starting join process...');
        print('🔗 JOIN GROUP BY CODE: User ID: $userId');
        print('🔗 JOIN GROUP BY CODE: Group code: $groupCode');

        context.read<GroupCubit>().joinGroupByCode(
          groupCode: groupCode,
          userId: userId,
        );
      } else {
        print(
          '🔗 JOIN GROUP BY CODE ERROR: User not authenticated - State: ${authState.runtimeType}',
        );
      }
    }
  }

  void _handleJoinGroup(String groupId) async {
    final authState = context.read<AuthCubit>().state;
    print('🔗 JOIN GROUP BY ID: Auth state: ${authState.runtimeType}');
    if (authState is AuthAuthenticated) {
      final userId = int.tryParse(authState.user.id) ?? 1;
      print(
        '🔗 JOIN GROUP BY ID: User authenticated - ID: $userId, Phone: ${authState.user.phone}',
      );

      print('🔗 JOIN GROUP BY ID: Starting join process...');
      print('🔗 JOIN GROUP BY ID: User ID: $userId');
      print('🔗 JOIN GROUP BY ID: Group ID: $groupId');

      context.read<GroupCubit>().joinGroupById(
        groupId: groupId,
        userId: userId,
      );
    } else {
      print(
        '🔗 JOIN GROUP BY ID ERROR: User not authenticated - State: ${authState.runtimeType}',
      );
    }
  }

  void _performSearch(String query) async {
    if (query.trim().isNotEmpty) {
      print('🔍 SEARCH GROUPS: Searching for: $query');
      context.read<GroupCubit>().searchGroups(query);
    }
  }
}
