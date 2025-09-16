import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../cubit/group_cubit.dart';
import '../cubit/group_member_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/dashboard/modern_dashboard_app_bar.dart';
import '../widgets/dashboard/modern_balance_card.dart';
import '../widgets/dashboard/quick_actions_section.dart';
import '../widgets/dashboard/modern_stat_card.dart';
import '../widgets/dashboard/modern_action_card.dart';
import '../widgets/dashboard/section_header.dart';
import '../widgets/dashboard/bottom_app_bar.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupCubit>(create: (context) => getIt<GroupCubit>()),
        BlocProvider<GroupMemberCubit>(
          create: (context) => getIt<GroupMemberCubit>(),
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
              // Load admin groups when screen loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final adminId = int.tryParse(state.user.id) ?? 1;
                context.read<GroupCubit>().getAdminGroups(adminId);
              });

              return CustomScrollView(
                slivers: [
                  // Modern App Bar
                  ModernDashboardAppBar(
                    title: 'Admin Dashboard',
                    subtitle: 'Manage your group efficiently',
                    onLogout: () => context.read<AuthCubit>().logout(),
                    actions: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
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
                          // Total Balance Card (inspired by financial apps)
                          _buildTotalBalanceCard(context, state),

                          const SizedBox(height: 24),

                          // Quick Actions (inspired by financial app quick transfer)
                          _buildQuickActionsSection(context),

                          const SizedBox(height: 24),

                          // Group Overview Stats
                          _buildGroupOverviewSection(context, state),

                          const SizedBox(height: 24),

                          // Management Actions
                          _buildManagementActionsSection(context),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Please log in to access admin dashboard'),
              );
            }
          },
        ),
      ),
    );
  }

  // Total Balance Card (inspired by financial apps)
  Widget _buildTotalBalanceCard(BuildContext context, AuthState state) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, groupState) {
        String totalBalance = '${AppColors.currencySymbol}0';
        String memberCount = '0';

        if (groupState is AdminGroupsLoaded && groupState.groups.isNotEmpty) {
          final group = groupState.groups.first;
          totalBalance =
              '${AppColors.currencySymbol}${group.contributionAmount.toStringAsFixed(0)}';
          memberCount = '1'; // TODO: Get actual member count
        }

        return ModernBalanceCard(
          title: 'TOTAL GROUP VALUE',
          value: totalBalance,
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

  // Quick Actions Section (inspired by financial app quick transfer)
  Widget _buildQuickActionsSection(BuildContext context) {
    return QuickActionsSection(
      title: 'Quick Actions',
      actions: [
        QuickAction(
          title: 'Add Member',
          icon: Icons.person_add,
          color: AppColors.primary,
          onTap: () => _navigateToAddMember(context),
        ),
        QuickAction(
          title: 'View Group',
          icon: Icons.visibility,
          color: AppColors.secondary,
          onTap: () => _navigateToGroupDetail(context),
        ),
      ],
    );
  }

  // Group Overview Section
  Widget _buildGroupOverviewSection(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Group Overview',
          subtitle: 'Key metrics and statistics',
        ),
        BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            if (groupState is AdminGroupsLoaded &&
                groupState.groups.isNotEmpty) {
              final group = groupState.groups.first;
              final stats = [
                StatCardData(
                  icon: Icons.group,
                  title: 'Members',
                  value: '1', // TODO: Get actual member count
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.account_balance_wallet,
                  title: 'Contribution',
                  value:
                      '${AppColors.currencySymbol}${group.contributionAmount.toStringAsFixed(0)}',
                  color: AppColors.warning,
                ),
                StatCardData(
                  icon: Icons.repeat,
                  title: 'Frequency',
                  value: group.frequency,
                  color: AppColors.purple,
                ),
                StatCardData(
                  icon: Icons.calendar_today,
                  title: 'Created',
                  value: '${group.createdAt.day}/${group.createdAt.month}',
                  color: AppColors.info,
                ),
              ];
              return StatCardGrid(stats: stats);
            } else if (groupState is GroupLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              final stats = [
                StatCardData(
                  icon: Icons.group,
                  title: 'Members',
                  value: '0',
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Contributions',
                  value: '${AppColors.currencySymbol}0',
                  color: AppColors.warning,
                ),
              ];
              return StatCardGrid(stats: stats);
            }
          },
        ),
      ],
    );
  }

  // Management Actions Section
  Widget _buildManagementActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Group Management',
          subtitle: 'Manage your group settings and members',
        ),
        ActionCardGrid(
          actions: [
            ActionCardData(
              icon: Icons.group_add,
              title: 'Manage Members',
              subtitle: 'Add or remove members',
              color: AppColors.secondary,
              onTap: () => _navigateToAddMember(context),
            ),
            ActionCardData(
              icon: Icons.repeat,
              title: 'Start Cycle',
              subtitle: 'Begin new contribution cycle',
              color: AppColors.primary,
              onTap: () => _showComingSoon(context, 'Cycle Management'),
            ),
            ActionCardData(
              icon: Icons.settings,
              title: 'Group Settings',
              subtitle: 'Configure group details',
              color: AppColors.warning,
              onTap: () => _showComingSoon(context, 'Group Settings'),
            ),
            ActionCardData(
              icon: Icons.analytics,
              title: 'Reports',
              subtitle: 'View group analytics',
              color: AppColors.purple,
              onTap: () => _showComingSoon(context, 'Reports'),
            ),
          ],
        ),
      ],
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Home - already on admin dashboard
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

  void _navigateToAddMember(BuildContext context) {
    final groupState = context.read<GroupCubit>().state;
    if (groupState is AdminGroupsLoaded && groupState.groups.isNotEmpty) {
      final group = groupState.groups.first;
      Navigator.of(context).pushNamed(
        '/add-member',
        arguments: {'groupId': group.id.toString(), 'groupName': group.name},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No group found. Please create a group first.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _navigateToGroupDetail(BuildContext context) {
    final groupState = context.read<GroupCubit>().state;
    if (groupState is AdminGroupsLoaded && groupState.groups.isNotEmpty) {
      final group = groupState.groups.first;
      Navigator.of(context).pushNamed(
        '/group-detail',
        arguments: {
          'groupId': group.id.toString(),
          'groupName': group.name,
          'isAdmin': true, // Admin is viewing their group
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No group found. Please create a group first.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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
