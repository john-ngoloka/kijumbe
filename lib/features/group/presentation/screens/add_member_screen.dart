import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../cubit/group_member_cubit.dart';
import '../../../authentication/data/datasources/local/auth_local_datasource.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../../authentication/domain/usecases/create_user_with_phone_password_usecase.dart';
import '../../data/datasources/local/dao/group_member_dao.dart';
import '../widgets/dashboard/modern_dashboard_app_bar.dart';

class AddMemberScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const AddMemberScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _payoutOrderController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _payoutOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<GroupMemberCubit, GroupMemberState>(
        listener: (context, state) {
          if (state is GroupMemberLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is GroupMemberAdded) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Member added successfully! They can login with their phone number as password.',
                ),
                backgroundColor: AppColors.secondary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 4),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is GroupMemberError) {
            setState(() {
              _isLoading = false;
            });
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
              title: 'Add Member',
              subtitle: 'Add a new member to ${widget.groupName}',
              onLogout: () => Navigator.of(context).pop(),
              actions: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group Info Card
                      _buildGroupInfoCard(),

                      const SizedBox(height: 24),

                      // Add Member Form
                      _buildAddMemberForm(),

                      const SizedBox(height: 32),

                      // Add Member Button
                      _buildAddMemberButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfoCard() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.group, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Group ID: ${widget.groupId}',
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
    );
  }

  Widget _buildAddMemberForm() {
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
            'Member Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Name Field
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter member\'s full name',
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
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
                return 'Please enter full name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Phone Number Field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter member\'s phone number',
              prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
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
                return 'Please enter phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Payout Order Field
          TextFormField(
            controller: _payoutOrderController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Payout Order (Optional)',
              hintText: 'Order in contribution cycle',
              prefixIcon: const Icon(Icons.sort, color: AppColors.primary),
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
              if (value != null && value.isNotEmpty) {
                final order = int.tryParse(value);
                if (order == null || order < 1) {
                  return 'Payout order must be a positive number';
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'If the member doesn\'t have an account, a new account will be created with their phone number as the default password.',
                    style: TextStyle(fontSize: 14, color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMemberButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _addMember,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Add Member',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  void _addMember() {
    if (_formKey.currentState!.validate()) {
      // Normalize phone number format
      String phoneNumber = _phoneController.text.trim();

      if (phoneNumber.startsWith('+255')) {
        phoneNumber = phoneNumber.substring(4);
      }
      if (phoneNumber.startsWith('255')) {
        phoneNumber = phoneNumber.substring(3);
      }
      if (!phoneNumber.startsWith('0')) {
        phoneNumber = '0$phoneNumber';
      }

      // Get user by phone number first
      _findUserByPhone(phoneNumber);
    }
  }

  void _findUserByPhone(String phone) async {
    try {
      // Get the auth local data source to find user by phone
      final authLocalDataSource = getIt<AuthLocalDataSource>();
      UserModel? userModel = await authLocalDataSource.getUserByPhone(phone);

      // If user doesn't exist, create a new user with phone number as password
      if (userModel == null) {
        final createUserUseCase = getIt<CreateUserWithPhonePasswordUseCase>();
        final result = await createUserUseCase(
          phone: phone,
          name: _nameController.text.trim(),
        );

        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create user: ${failure.message}'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            return;
          },
          (tokens) async {
            // User created successfully, get the user data
            userModel = await authLocalDataSource.getUserByPhone(phone);
            if (userModel != null) {
              _addMemberToGroup(userModel!);
            }
          },
        );
        return;
      }

      // User exists, proceed to add to group
      _addMemberToGroup(userModel);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _addMemberToGroup(UserModel userModel) async {
    try {
      // Check if user is already a member of this group
      final groupMemberDAO = getIt<GroupMemberDAO>();
      final isAlreadyMember = await groupMemberDAO.isUserMemberOfGroup(
        int.parse(userModel.id),
        int.parse(widget.groupId),
      );

      if (isAlreadyMember) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${userModel.firstName} is already a member of this group.',
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Add member to group
      final payoutOrder = _payoutOrderController.text.isNotEmpty
          ? int.tryParse(_payoutOrderController.text)
          : null;

      context.read<GroupMemberCubit>().addMemberToGroup(
        groupId: int.parse(widget.groupId),
        userId: int.parse(userModel.id),
        payoutOrder: payoutOrder,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
