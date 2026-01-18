import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/states/auth_state.dart';
import '../widgets/branding_section.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

/// Presentation Screen - Login UI
/// Pure UI, reads state and calls controller
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .login(
            _usernameController.text.trim(),
            _passwordController.text,
            _rememberMe,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Navigate to home if logged in
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.isLoggedIn && next.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error ?? 'An error occurred'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).clearError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1F2E)
          : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            // Mobile: Stack vertically, scrollable
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Compact branding for mobile (theme-aware)
                    Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1A1F2E)
                          : Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Poultry Core',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF2C3E50),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Farm Management System',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : const Color(0xFF7F8C8D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Login Form
                    Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1A1F2E)
                          : Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      width: double.infinity,
                      child: _buildLoginForm(
                        context,
                        authState,
                        isMobile: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Desktop: Side by side layout
          return Row(
            children: [
              Expanded(flex: 4, child: BrandingSection()),
              Expanded(
                flex: 6,
                child: Container(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1A1F2E)
                      : Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.w,
                    vertical: 40.h,
                  ),
                  child: _buildLoginForm(context, authState, isMobile: false),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    AuthState authState, {
    bool isMobile = false,
  }) {
    final iconSize = isMobile ? 50.w : 60.w;
    final titleSize = isMobile ? 24.sp : 28.sp;
    final spacing = isMobile ? 20.h : 32.h;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: isMobile ? 8.h : 0),
          // Icon
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                'images/farmer-illustration.png',
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16.h : 24.h),
          // Title
          Text(
            'Sign In',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1F2937),
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing),
          // Username/Email field
          TextFormField(
            controller: _usernameController,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              labelText: 'Username or Email',
              labelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF6B7280),
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0x80334155)
                  : const Color(0xFFE8EEF6),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ), // slate-600 / slate-300
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: const Color(0xFFFF7A00),
                  width: 1.5.w,
                ), // orange-500
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your username or email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF6B7280),
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0x80334155)
                  : const Color(0xFFE8EEF6),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ), // slate / light
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: const Color(0xFFFF7A00),
                  width: 1.5.w,
                ), // orange-500
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : const Color(0xFF6B7280),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          // Remember me and Forgot password - Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 350.w;

              if (isNarrow) {
                // Stack vertically on very narrow screens
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          fillColor: WidgetStateProperty.all(Colors.orange),
                        ),
                        Flexible(
                          child: Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              // Side by side on wider screens
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        fillColor: WidgetStateProperty.all(Colors.orange),
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF1F2937),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.orange, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: isMobile ? 20.h : 24.h),
          // Sign In button
          SizedBox(
            height: isMobile ? 48.h : 50.h,
            child: ElevatedButton(
              onPressed: authState.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: authState.isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 20.h : 24.h),
          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not registered?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isMobile ? 13.sp : 14.sp,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: isMobile ? 13.sp : 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16.h : 0),
        ],
      ),
    );
  }
}
