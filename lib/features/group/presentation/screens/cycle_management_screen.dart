import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../cubit/cycle_cubit.dart';
import '../widgets/dashboard/modern_dashboard_app_bar.dart';

class CycleManagementScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const CycleManagementScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<CycleManagementScreen> createState() => _CycleManagementScreenState();
}

class _CycleManagementScreenState extends State<CycleManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetAmountController = TextEditingController();
  final _deadlineController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _targetAmountController.dispose();
    _deadlineController.dispose();
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
            if (state is CycleStarted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cycle ${state.cycle.cycleNumber} started successfully!',
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
                title: 'Cycle Management',
                subtitle: 'Manage cycles for ${widget.groupName}',
                onLogout: () => Navigator.of(context).pop(),
                actions: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.repeat,
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
                      // Current Cycle Status
                      _buildCurrentCycleStatus(),

                      const SizedBox(height: 24),

                      // Start New Cycle Form
                      _buildStartCycleForm(),

                      const SizedBox(height: 24),

                      // Cycle Actions
                      _buildCycleActions(),
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

  Widget _buildCurrentCycleStatus() {
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
                            'Started: ${_formatDate(cycle.startDate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusItem(
                        'Target',
                        '${AppColors.currencySymbol}${cycle.targetAmount.toStringAsFixed(0)}',
                        Icons.flag,
                        AppColors.warning,
                      ),
                    ),
                    Expanded(
                      child: _buildStatusItem(
                        'Collected',
                        '${AppColors.currencySymbol}${cycle.currentAmount.toStringAsFixed(0)}',
                        Icons.account_balance_wallet,
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                if (cycle.deadline != null) ...[
                  const SizedBox(height: 12),
                  _buildStatusItem(
                    'Deadline',
                    _formatDate(cycle.deadline!),
                    Icons.schedule,
                    AppColors.info,
                  ),
                ],
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
                    Icons.repeat_outlined,
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
                  'Start a new cycle to begin collecting contributions.',
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

  Widget _buildStatusItem(
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

  Widget _buildStartCycleForm() {
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
              'Start New Cycle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Target Amount Field
            TextFormField(
              controller: _targetAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Amount',
                hintText: 'Enter total target amount',
                prefixIcon: const Icon(Icons.flag, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textLight),
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
                  return 'Please enter target amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Deadline Field
            TextFormField(
              controller: _deadlineController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Contribution Deadline',
                hintText: 'Select deadline date',
                prefixIcon: const Icon(
                  Icons.schedule,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textLight),
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
              onTap: () => _selectDeadline(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select deadline';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Start Cycle Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startCycle,
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
                  'Start New Cycle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleActions() {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cycle Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _viewContributions(state.cycle.id),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Contributions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _completeCycle(),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Complete Cycle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
        _deadlineController.text = _formatDate(picked);
      });
    }
  }

  void _startCycle() {
    if (_formKey.currentState!.validate() && _selectedDeadline != null) {
      final targetAmount = double.parse(_targetAmountController.text);
      context.read<CycleCubit>().startNewCycle(
        groupId: int.parse(widget.groupId),
        targetAmount: targetAmount,
        deadline: _selectedDeadline!,
      );
    }
  }

  void _viewContributions(int cycleId) {
    // Navigate to contributions view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View contributions feature coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  void _completeCycle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Cycle'),
        content: const Text(
          'Are you sure you want to complete this cycle? This will distribute payouts to all members.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CycleCubit>().completeCycle(
                int.parse(widget.groupId),
              );
            },
            child: const Text(
              'Complete',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
