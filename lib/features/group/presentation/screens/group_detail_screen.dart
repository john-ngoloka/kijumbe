import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../cubit/group_cubit.dart';
import '../cubit/group_member_cubit.dart' as member_cubit;
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../widgets/dashboard/modern_dashboard_app_bar.dart';
import '../widgets/dashboard/modern_balance_card.dart';
import '../widgets/dashboard/quick_actions_section.dart';
import '../widgets/dashboard/modern_stat_card.dart';
import '../widgets/dashboard/section_header.dart';
import '../widgets/dashboard/bottom_app_bar.dart';
import 'contribution_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final bool isAdmin;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.isAdmin = false,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupCubit>(create: (context) => getIt<GroupCubit>()),
        BlocProvider<member_cubit.GroupMemberCubit>(
          create: (context) => getIt<member_cubit.GroupMemberCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: DashboardBottomAppBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _handleBottomNavTap(index);
          },
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              // Load group details and members when screen loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<GroupCubit>().getGroupMembers(widget.groupId);
              });

              return CustomScrollView(
                slivers: [
                  // Modern App Bar
                  ModernDashboardAppBar(
                    title: widget.groupName,
                    subtitle: widget.isAdmin
                        ? 'Admin Dashboard - Manage your group'
                        : 'Member Dashboard - View group details',
                    onLogout: () => Navigator.of(context).pop(),
                    actions: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.isAdmin
                              ? Icons.admin_panel_settings
                              : Icons.group,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // Main Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Group Balance Card
                          _buildGroupBalanceCard(context, state),

                          const SizedBox(height: 24),

                          // Quick Actions
                          _buildQuickActionsSection(context),

                          const SizedBox(height: 24),

                          // Group Members Section
                          _buildGroupMembersSection(context),

                          const SizedBox(height: 24),

                          // Group Stats Section
                          _buildGroupStatsSection(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Please log in to access group details'),
              );
            }
          },
        ),
      ),
    );
  }

  // Group Balance Card
  Widget _buildGroupBalanceCard(BuildContext context, AuthState state) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, groupState) {
        String totalValue = '${AppColors.currencySymbol}0';
        String memberCount = '0';

        if (groupState is GroupMembersLoaded && groupState.members.isNotEmpty) {
          memberCount = groupState.members.length.toString();
          // Calculate total value based on member count and contribution amount
          // This is a simplified calculation - in real app, you'd get this from group data
          totalValue =
              '${AppColors.currencySymbol}${groupState.members.length * 1000}';
        }

        return ModernBalanceCard(
          title: 'GROUP VALUE',
          value: totalValue,
          infoItems: [
            BalanceInfo(
              label: 'Active Members',
              value: memberCount,
              icon: Icons.group,
            ),
            BalanceInfo(
              label: 'Status',
              value: 'Active',
              icon: Icons.check_circle,
            ),
          ],
        );
      },
    );
  }

  // Quick Actions Section
  Widget _buildQuickActionsSection(BuildContext context) {
    List<QuickAction> actions = [];

    if (widget.isAdmin) {
      actions = [
        QuickAction(
          title: 'Add Member',
          icon: Icons.person_add,
          color: AppColors.primary,
          onTap: () => _navigateToAddMember(context),
        ),
        QuickAction(
          title: 'Start Cycle',
          icon: Icons.play_circle,
          color: AppColors.secondary,
          onTap: () => _showComingSoon(context, 'Start Cycle'),
        ),
      ];
    } else {
      actions = [
        QuickAction(
          title: 'Make Contribution',
          icon: Icons.payment,
          color: AppColors.primary,
          onTap: () => _navigateToContribution(context),
        ),
        QuickAction(
          title: 'View History',
          icon: Icons.history,
          color: AppColors.secondary,
          onTap: () => _showComingSoon(context, 'Contribution History'),
        ),
      ];
    }

    return QuickActionsSection(title: 'Quick Actions', actions: actions);
  }

  // Group Members Section
  Widget _buildGroupMembersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Group Members',
          subtitle: widget.isAdmin
              ? 'Manage group members and their details'
              : 'View other group members',
        ),
        BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            if (groupState is GroupLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (groupState is GroupError) {
              return _buildErrorCard(groupState.message);
            } else if (groupState is GroupMembersLoaded &&
                groupState.members.isNotEmpty) {
              return Column(
                children: groupState.members
                    .map((member) => _buildMemberCard(context, member))
                    .toList(),
              );
            } else {
              return _buildEmptyMembersCard(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, dynamic member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Member ID: ${member.userId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Joined: ${member.joinedAt.day}/${member.joinedAt.month}/${member.joinedAt.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: member.isActive
                            ? AppColors.secondary.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        member.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: member.isActive
                              ? AppColors.secondary
                              : AppColors.error,
                        ),
                      ),
                    ),
                    if (member.payoutOrder != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Order: ${member.payoutOrder}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (widget.isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleMemberAction(context, member, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: const Icon(
                Icons.more_vert,
                color: AppColors.textLight,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyMembersCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.group_outlined,
              size: 48,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No members found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This group has no members yet.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Group Stats Section
  Widget _buildGroupStatsSection(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Group Statistics',
          subtitle: 'Overview of group performance',
        ),
        BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            List<StatCardData> stats = [];

            if (groupState is GroupMembersLoaded) {
              stats = [
                StatCardData(
                  icon: Icons.group,
                  title: 'Total Members',
                  value: groupState.members.length.toString(),
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.check_circle,
                  title: 'Active Members',
                  value: groupState.members
                      .where((m) => m.isActive)
                      .length
                      .toString(),
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Value',
                  value:
                      '${AppColors.currencySymbol}${groupState.members.length * 1000}',
                  color: AppColors.warning,
                ),
                StatCardData(
                  icon: Icons.calendar_today,
                  title: 'Created',
                  value: '${DateTime.now().day}/${DateTime.now().month}',
                  color: AppColors.info,
                ),
              ];
            } else {
              stats = [
                StatCardData(
                  icon: Icons.group,
                  title: 'Total Members',
                  value: '0',
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Value',
                  value: '${AppColors.currencySymbol}0',
                  color: AppColors.warning,
                ),
              ];
            }

            return StatCardGrid(stats: stats);
          },
        ),
      ],
    );
  }

  void _navigateToAddMember(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/add-member',
      arguments: {'groupId': widget.groupId, 'groupName': widget.groupName},
    );
  }

  void _navigateToContribution(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContributionScreen(
          groupId: widget.groupId,
          groupName: widget.groupName,
        ),
      ),
    );
  }

  void _handleMemberAction(
    BuildContext context,
    dynamic member,
    String action,
  ) {
    switch (action) {
      case 'edit':
        _showComingSoon(context, 'Edit Member');
        break;
      case 'remove':
        _showRemoveMemberDialog(context, member);
        break;
    }
  }

  void _showRemoveMemberDialog(BuildContext context, dynamic member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove this member from the group?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<member_cubit.GroupMemberCubit>()
                  .removeMemberFromGroup(
                    groupId: int.parse(widget.groupId),
                    userId: member.userId,
                  );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Home - already on group detail
        break;
      case 1:
        _showComingSoon(context, 'Cards');
        break;
      case 2:
        _showComingSoon(context, 'Savings');
        break;
      case 3:
        _showComingSoon(context, 'Analytics');
        break;
      case 4:
        _showComingSoon(context, 'More');
        break;
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
