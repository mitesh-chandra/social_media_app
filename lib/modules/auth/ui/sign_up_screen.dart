import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/message_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  DateTime? _selectedDate;
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case SignUpSuccess():
              context.go(AppRouter.mainFeed);
              toast(state.message);
            case AuthError():
              showMessageDialog(context: context, message: state.error);
            default:
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: keyboardHeight > 0 ? 16 : 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.top - 32,
                ),
                child: IntrinsicHeight(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),

                            // Welcome Header - More compact
                            _buildHeader(theme),

                            const SizedBox(height: 24),

                            // Profile Image Section - More compact
                            _buildProfileImageSection(context, state, theme),

                            const SizedBox(height: 24),

                            // Form Fields
                            _buildFormFields(context, state, theme),

                            const SizedBox(height: 24),

                            // Sign Up Button
                            _buildSignUpButton(context, state, theme),

                            const SizedBox(height: 16),

                            // Login Link
                            _buildLoginLink(context, theme),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Create Account',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Join our community and connect with friends',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileImageSection(BuildContext context, AuthState state, ThemeData theme) {
    return Column(
      children: [
        Text(
          'Add Profile Photo',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final media = await context.push('${AppRouter.galleryPage}?onlyImage=true&singleSelect=true');
            final imagePath = (media as List<MediaModel>?)?.firstOrNull?.url;
            context.read<AuthBloc>().setSignUpTextEvent(profilePath: imagePath);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.surface,
              child: state.store.signUpProfilePath != null
                  ? ClipOval(
                child: Image.file(
                  File(state.store.signUpProfilePath!),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap to add',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context, AuthState state, ThemeData theme) {
    return Column(
      children: [
        // Name Field
        _buildTextField(
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: Icons.person_outline_rounded,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter your name'
              : null,
          textCapitalization: TextCapitalization.words,

          onChanged: (v) {
            context.read<AuthBloc>().setSignUpTextEvent(name: v);
          },
        ),

        const SizedBox(height: 16),

        // Email Field
        _buildTextField(
          labelText: 'Email Address',
          hintText: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
          onChanged: (v) {
            context.read<AuthBloc>().setSignUpTextEvent(email: v);
          },
        ),

        const SizedBox(height: 16),

        // Date of Birth Field
        _buildDatePickerField(context, state, theme),

        const SizedBox(height: 16),

        // Gender Dropdown
        _buildGenderDropdown(context, state, theme),

        const SizedBox(height: 16),

        // Password Field
        _buildTextField(
          labelText: 'Password',
          hintText: 'Create a strong password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          validator: (value) => (value == null || value.length < 6)
              ? 'Password must be at least 6 characters'
              : null,
          onChanged: (v) {
            context.read<AuthBloc>().setSignUpTextEvent(password: v);
          },
        ),

        const SizedBox(height: 16),

        // Confirm Password Field
        _buildTextField(
          labelText: 'Confirm Password',
          hintText: 'Re-enter your password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
          validator: (value) => (value == null)
              ? 'Please confirm your password'
              : value == state.store.signUpPassword
              ? null
              : 'Passwords do not match',
        ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context, AuthState state, ThemeData theme) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        hintText: 'Select your date of birth',
        prefixIcon: const Icon(Icons.cake_outlined),
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please select your date of birth';
        }
        if (_selectedDate != null) {
          final age = DateTime.now().difference(_selectedDate!).inDays / 365;
          if (age < 13) {
            return 'You must be at least 13 years old';
          }
        }
        return null;
      },
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)), // Min age 13
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: theme.colorScheme,
                datePickerTheme: DatePickerThemeData(
                  backgroundColor: theme.colorScheme.surface,
                  headerBackgroundColor: theme.colorScheme.primary,
                  headerForegroundColor: theme.colorScheme.onPrimary,
                  dayStyle: theme.textTheme.bodyMedium,
                  yearStyle: theme.textTheme.bodyMedium,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  headerHeadlineStyle: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  headerHelpStyle: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return theme.colorScheme.onPrimary;
                    }
                    return theme.colorScheme.onSurface;
                  }),
                  dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return theme.colorScheme.primary;
                    }
                    return Colors.transparent;
                  }),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });

          // Update bloc with selected date
          context.read<AuthBloc>().setSignUpTextEvent(dob: pickedDate);
        }
      },
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization= TextCapitalization.none,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: obscureText
            ? Icon(
          Icons.visibility_off_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        )
            : null,
      ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildGenderDropdown(BuildContext context, AuthState state, ThemeData theme) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        hintText: 'Select your gender',
        prefixIcon: Icon(Icons.people_outline_rounded),
      ),
      items: const [
        DropdownMenuItem(
          value: 'Male',
          child: Row(
            children: [
              Icon(Icons.male, size: 18),
              SizedBox(width: 8),
              Text('Male'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Row(
            children: [
              Icon(Icons.female, size: 18),
              SizedBox(width: 8),
              Text('Female'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'Other',
          child: Row(
            children: [
              Icon(Icons.transgender, size: 18),
              SizedBox(width: 8),
              Text('Other'),
            ],
          ),
        ),
      ],
      value: state.store.signUpGender.isNotEmpty ? state.store.signUpGender : null,
      onChanged: (value) {
        context.read<AuthBloc>().setSignUpTextEvent(gender: value);
      },
      validator: (value) => value == null ? 'Please select your gender' : null,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, AuthState state, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: state.store.isLoading
            ? null
            : LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: state.store.isLoading
            ? null
            : [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: state.store.isLoading
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthBloc>().signUpEvent();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: state.store.isLoading
              ? theme.colorScheme.surface
              : Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.store.isLoading
            ? SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add_rounded,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Create Account',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () {
              context.go(AppRouter.login);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign In',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}