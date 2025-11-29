import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

/// Registration page for new users
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _classIdController = TextEditingController();
  final _departmentController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _classroomController = TextEditingController();
  final _blockController = TextEditingController();

  // State variables
  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _classIdController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _classroomController.dispose();
    _blockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildCommonFields(),
                const SizedBox(height: 24),
                _buildRoleToggle(),
                const SizedBox(height: 24),
                _buildRoleSpecificFields(),
                const SizedBox(height: 24),
                _buildAddressSection(),
                const SizedBox(height: 32),
                _buildRegisterButton(),
                const SizedBox(height: 16),
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Tap2Eat',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Your Account',
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCommonFields() {
    return Column(
      children: [
        AppTextField(
          controller: _nameController,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _emailController,
          labelText: 'Email Address',
          hintText: 'yourname@university.edu',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoleToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a...',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: _buildRoleButton(
                  label: 'Student',
                  role: UserRole.student,
                  isSelected: _selectedRole == UserRole.student,
                ),
              ),
              Expanded(
                child: _buildRoleButton(
                  label: 'Teacher',
                  role: UserRole.teacher,
                  isSelected: _selectedRole == UserRole.teacher,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required String label,
    required UserRole role,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected ? AppColors.onPrimary : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSpecificFields() {
    if (_selectedRole == UserRole.student) {
      return Column(
        children: [
          AppTextField(
            controller: _classIdController,
            labelText: 'Class Number/ID',
            hintText: 'e.g., 20251234',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your class ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _departmentController,
            labelText: 'Department',
            hintText: 'e.g., Computer Science',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your department';
              }
              return null;
            },
          ),
        ],
      );
    } else {
      return AppTextField(
        controller: _designationController,
        labelText: 'Designation/Department',
        hintText: 'e.g., Professor, Arts & Sciences',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your designation';
          }
          return null;
        },
      );
    }
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.borderColor),
        const SizedBox(height: 16),
        Text(
          'Address Details',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _classroomController,
          labelText: 'Classroom Number',
          hintText: 'e.g., Room 301',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your classroom number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _blockController,
          labelText: 'Block Name',
          hintText: 'e.g., Science Block',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your block name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        // Error message display
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.errorMessage != null) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Register button with loading state
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return AppButton(
              text: 'Register',
              onPressed: _handleRegister,
              isLoading: authProvider.isLoading,
              width: double.infinity,
            );
          },
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole,
      classId: _selectedRole == UserRole.student
          ? _classIdController.text.trim()
          : null,
      designation: _selectedRole == UserRole.teacher
          ? _designationController.text.trim()
          : null,
      phoneNumber: _phoneController.text.trim(),
      classroomNumber: _classroomController.text.trim(),
      blockName: _blockController.text.trim(),
    );

    if (authProvider.errorMessage == null && mounted) {
      // Navigate to role-based home
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    final role = context.read<AuthProvider>().userRole;

    if (role == UserRole.student) {
      context.go(RouteNames.studentHome);
    } else if (role == UserRole.teacher) {
      context.go(RouteNames.teacherHome);
    } else if (role == UserRole.deliveryStudent) {
      context.go(RouteNames.deliveryStudentHome);
    }
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        GestureDetector(
          onTap: () {
            context.go(RouteNames.login);
          },
          child: Text(
            'Sign In',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
