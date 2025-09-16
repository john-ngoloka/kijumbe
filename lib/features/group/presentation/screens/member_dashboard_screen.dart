import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/group_cubit.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../widgets/dashboard/modern_dashboard_app_bar.dart';
import '../widgets/dashboard/modern_balance_card.dart';
import '../widgets/dashboard/quick_actions_section.dart';
import '../widgets/dashboard/modern_stat_card.dart';
import '../widgets/dashboard/section_header.dart';
import '../widgets/dashboard/bottom_app_bar.dart';

class MemberDashboardScreen extends StatefulWidget {
  final User? user;

  const MemberDashboardScreen({super.key, this.user});

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupCubit>(create: (context) => getIt<GroupCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
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
              // Load user groups when screen loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final userId = int.tryParse(state.user.id) ?? 1;
                context.read<GroupCubit>().getUserGroups(userId);
              });

              return CustomScrollView(
                slivers: [
                  // Modern App Bar
                  ModernDashboardAppBar(
                    title: 'Member Dashboard',
                    subtitle: 'Manage your contributions',
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
                          // Member Balance Card
                          _buildMemberBalanceCard(context, state),

                          const SizedBox(height: 24),

                          // Quick Actions
                          _buildQuickActionsSection(context),

                          const SizedBox(height: 24),

                          // My Groups Section
                          _buildMyGroupsSection(context, state),

                          const SizedBox(height: 24),

                          // Member Stats
                          _buildMemberStatsSection(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Please log in to access member dashboard'),
              );
            }
          },
        ),
      ),
    );
  }

  // Member Balance Card
  Widget _buildMemberBalanceCard(BuildContext context, AuthState state) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, groupState) {
        String totalContributions = '${AppColors.currencySymbol}0';
        String groupCount = '0';

        if (groupState is GroupsLoaded && groupState.groups.isNotEmpty) {
          groupCount = groupState.groups.length.toString();
          // Calculate total contributions (simplified)
          totalContributions =
              '${AppColors.currencySymbol}${groupState.groups.length * 1000}';
        }

        return ModernBalanceCard(
          title: 'MY CONTRIBUTIONS',
          value: totalContributions,
          infoItems: [
            BalanceInfo(
              label: 'Active Groups',
              value: groupCount,
              icon: Icons.group,
            ),
            BalanceInfo(
              label: 'Status',
              value: state is AuthAuthenticated && state.user.isActive
                  ? 'Active'
                  : 'Inactive',
              icon: state is AuthAuthenticated && state.user.isActive
                  ? Icons.check_circle
                  : Icons.pause_circle,
            ),
          ],
        );
      },
    );
  }

  // Quick Actions Section
  Widget _buildQuickActionsSection(BuildContext context) {
    return QuickActionsSection(
      title: 'Quick Actions',
      actions: [
        QuickAction(
          title: 'Join Group',
          icon: Icons.group_add,
          color: AppColors.primary,
          onTap: () => Navigator.of(context).pushNamed('/group-selection'),
        ),
        QuickAction(
          title: 'My Profile',
          icon: Icons.person,
          color: AppColors.secondary,
          onTap: () => _showComingSoon(context, 'Profile'),
        ),
      ],
    );
  }

  // My Groups Section
  Widget _buildMyGroupsSection(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'My Groups',
          subtitle: 'Groups you are a member of',
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
            } else if (groupState is GroupsLoaded &&
                groupState.groups.isNotEmpty) {
              return Column(
                children: groupState.groups
                    .map((group) => _buildGroupCard(context, group))
                    .toList(),
              );
            } else {
              return _buildEmptyGroupsCard(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildGroupCard(BuildContext context, dynamic group) {
    return GestureDetector(
      onTap: () => _navigateToGroupDetail(context, group),
      child: Container(
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
              child: const Icon(
                Icons.group,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.description.isNotEmpty
                        ? group.description
                        : 'No description',
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
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${AppColors.currencySymbol}${group.contributionAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
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
                          group.frequency,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyGroupsCard(BuildContext context) {
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
            'No groups found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are not a member of any groups yet.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed('/group-selection'),
            icon: const Icon(Icons.group_add),
            label: const Text('Join a Group'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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

  // Member Stats Section
  Widget _buildMemberStatsSection(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'My Statistics',
          subtitle: 'Overview of your activity',
        ),
        BlocBuilder<GroupCubit, GroupState>(
          builder: (context, groupState) {
            List<StatCardData> stats = [];

            if (groupState is GroupsLoaded) {
              stats = [
                StatCardData(
                  icon: Icons.group,
                  title: 'Groups',
                  value: groupState.groups.length.toString(),
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Contributed',
                  value:
                      '${AppColors.currencySymbol}${groupState.groups.length * 1000}',
                  color: AppColors.warning,
                ),
                StatCardData(
                  icon: Icons.calendar_today,
                  title: 'Member Since',
                  value: '${DateTime.now().day}/${DateTime.now().month}',
                  color: AppColors.info,
                ),
                StatCardData(
                  icon: Icons.check_circle,
                  title: 'Status',
                  value: state is AuthAuthenticated && state.user.isActive
                      ? 'Active'
                      : 'Inactive',
                  color: state is AuthAuthenticated && state.user.isActive
                      ? AppColors.secondary
                      : AppColors.error,
                ),
              ];
            } else {
              stats = [
                StatCardData(
                  icon: Icons.group,
                  title: 'Groups',
                  value: '0',
                  color: AppColors.secondary,
                ),
                StatCardData(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Contributed',
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

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Home - already on member dashboard
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

  void _navigateToGroupDetail(BuildContext context, dynamic group) {
    Navigator.of(context).pushNamed(
      '/group-detail',
      arguments: {
        'groupId': group.id.toString(),
        'groupName': group.name,
        'isAdmin': false, // Members are not admins
      },
    );
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
