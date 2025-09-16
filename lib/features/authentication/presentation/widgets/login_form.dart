import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Normalize phone number format to match database format
      String phoneNumber = _phoneController.text.trim();
      print('🔐 LOGIN: Original phone input: ${_phoneController.text}');

      if (phoneNumber.startsWith('+255')) {
        phoneNumber = phoneNumber.substring(4); // Remove +255
        print('🔐 LOGIN: Removed +255 prefix');
      }
      if (phoneNumber.startsWith('255')) {
        phoneNumber = phoneNumber.substring(3); // Remove 255
        print('🔐 LOGIN: Removed 255 prefix');
      }
      if (!phoneNumber.startsWith('0')) {
        phoneNumber = '0$phoneNumber'; // Add leading 0 if not present
        print('🔐 LOGIN: Added leading 0');
      }

      print('🔐 LOGIN: Final normalized phone: $phoneNumber');
      print('🔐 LOGIN: Attempting login...');

      context.read<AuthCubit>().login(
        phone: phoneNumber,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          print('🔐 LOGIN ERROR: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AuthAuthenticated) {
          print(
            '🔐 LOGIN SUCCESS: User authenticated - ${state.user.firstName} (ID: ${state.user.id})',
          );
          print('🔐 LOGIN: User phone: ${state.user.phone}');
          print('🔐 LOGIN: User active status: ${state.user.isActive}');
          // Navigation is now handled in main.dart BlocBuilder
          print(
            '🔐 LOGIN: Authentication successful - navigation will be handled by main.dart',
          );
        } else if (state is AuthLoading) {
          print('🔐 LOGIN: Loading...');
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Mobile Number Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mobile Number',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    prefixIcon: Container(
                      width: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        '+255',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: Validators.validatePhone,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Password Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter password or phone number',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: Validators.validatePassword,
                ),
              ],
            ),

            // Helpful info text about flexible login
            Container(
              margin: const EdgeInsets.only(top: 8),
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
                    color: Colors.blue.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can use your custom password or your phone number to login',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Forgot Password and Keep me logged in
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: false, // TODO: Implement keep me logged in
                      onChanged: (value) {
                        // TODO: Handle keep me logged in
                      },
                      activeColor: const Color(0xFF1E3A8A),
                    ),
                    const Text(
                      'Keep me logged in',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to forgot password page
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Login Button
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
