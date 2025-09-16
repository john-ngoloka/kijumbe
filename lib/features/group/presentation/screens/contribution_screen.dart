import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../cubit/cycle_cubit.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../widgets/dashboard/modern_dashboard_app_bar.dart';

class ContributionScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const ContributionScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isPaid = true;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CycleCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<CycleCubit, CycleState>(
          listener: (context, state) {
            if (state is ContributionRecorded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Contribution of ${AppColors.currencySymbol}${state.contribution.amount.toStringAsFixed(0)} recorded successfully!',
                  ),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.of(context).pop();
            } else if (state is CycleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: CustomScrollView(
            slivers: [
              // Modern App Bar
              ModernDashboardAppBar(
                title: 'Make Contribution',
                subtitle: 'Contribute to ${widget.groupName}',
                onLogout: () => Navigator.of(context).pop(),
                actions: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.payment,
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
                      // Current Cycle Info
                      _buildCurrentCycleInfo(),

                      const SizedBox(height: 24),

                      // Contribution Form
                      _buildContributionForm(),

                      const SizedBox(height: 24),

                      // Recent Contributions
                      _buildRecentContributions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentCycleInfo() {
    return BlocBuilder<CycleCubit, CycleState>(
      builder: (context, state) {
        if (state is CycleLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Load active cycle when screen loads
        if (state is CycleInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CycleCubit>().getActiveCycle(
              int.parse(widget.groupId),
            );
          });
        }

        if (state is CycleLoaded) {
          final cycle = state.cycle;
          return Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.repeat,
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
                            'Cycle ${cycle.cycleNumber}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Deadline: ${_formatDate(cycle.deadline ?? cycle.startDate.add(const Duration(days: 30)))}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'Target',
                        '${AppColors.currencySymbol}${cycle.targetAmount.toStringAsFixed(0)}',
                        Icons.flag,
                        AppColors.warning,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'Collected',
                        '${AppColors.currencySymbol}${cycle.currentAmount.toStringAsFixed(0)}',
                        Icons.account_balance_wallet,
                        AppColors.secondary,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'Progress',
                        '${((cycle.currentAmount / cycle.targetAmount) * 100).toStringAsFixed(0)}%',
                        Icons.trending_up,
                        AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is CycleNoActive) {
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
                    Icons.pause_circle_outline,
                    size: 48,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Active Cycle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'There is no active cycle to contribute to. Please wait for the admin to start a new cycle.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionForm() {
    return BlocBuilder<CycleCubit, CycleState>(
      builder: (context, state) {
        if (state is CycleLoaded) {
          return Container(
            padding: const EdgeInsets.all(20),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Record Contribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter contribution amount',
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.textLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.textLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Notes Field
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Add any notes about this contribution',
                      prefixIcon: const Icon(
                        Icons.note,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.textLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.textLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payment Status
                  Row(
                    children: [
                      Checkbox(
                        value: _isPaid,
                        onChanged: (value) {
                          setState(() {
                            _isPaid = value ?? true;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Mark as paid',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitContribution,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Record Contribution',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRecentContributions() {
    return BlocBuilder<CycleCubit, CycleState>(
      builder: (context, state) {
        if (state is CycleLoaded) {
          // Load contributions for current cycle
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CycleCubit>().getCycleContributions(
              int.parse(widget.groupId),
              state.cycle.id,
            );
          });
        }

        if (state is CycleContributionsLoaded) {
          final contributions = state.contributions;

          return Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Contributions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                if (contributions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'No contributions yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...contributions.map(
                    (contribution) => _buildContributionItem(contribution),
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContributionItem(dynamic contribution) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: contribution.isPaid ? AppColors.secondary : AppColors.warning,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  (contribution.isPaid
                          ? AppColors.secondary
                          : AppColors.warning)
                      .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              contribution.isPaid ? Icons.check_circle : Icons.pending,
              color: contribution.isPaid
                  ? AppColors.secondary
                  : AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppColors.currencySymbol}${contribution.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(contribution.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (contribution.notes != null &&
                    contribution.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    contribution.notes!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  (contribution.isPaid
                          ? AppColors.secondary
                          : AppColors.warning)
                      .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              contribution.isPaid ? 'Paid' : 'Pending',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: contribution.isPaid
                    ? AppColors.secondary
                    : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitContribution() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      // Get current user and active cycle
      final authState = context.read<AuthCubit>().state;
      final cycleState = context.read<CycleCubit>().state;

      if (authState is AuthAuthenticated && cycleState is CycleLoaded) {
        context.read<CycleCubit>().recordContribution(
          groupId: int.parse(widget.groupId),
          memberId: int.parse(authState.user.id),
          cycleId: cycleState.cycle.id,
          amount: amount,
          notes: notes,
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
