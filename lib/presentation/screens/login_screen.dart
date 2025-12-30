import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/states/auth_state.dart';
import '../widgets/branding_section.dart';
import '../widgets/loading_widget.dart';
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Poultry Core',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Farm Management System',
                            style: TextStyle(
                              fontSize: 12,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 40,
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
    final iconSize = isMobile ? 50.0 : 60.0;
    final titleSize = isMobile ? 24.0 : 28.0;
    final spacing = isMobile ? 20.0 : 32.0;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: isMobile ? 8 : 0),
          // Icon
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'images/farmer-illustration.png',
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
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
            ),
            decoration: InputDecoration(
              labelText: 'Username or Email',
              labelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF6B7280),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0x80334155)
                  : const Color(0xFFE8EEF6),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ), // slate-600 / slate-300
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFF7A00),
                  width: 1.5,
                ), // orange-500
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your username or email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF6B7280),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0x80334155)
                  : const Color(0xFFE8EEF6),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ), // slate / light
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFF7A00),
                  width: 1.5,
                ), // orange-500
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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
          const SizedBox(height: 16),
          // Remember me and Forgot password - Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 350;

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
                        const Flexible(
                          child: Text(
                            'Remember me',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.orange),
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
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: isMobile ? 20 : 24),
          // Sign In button
          SizedBox(
            height: isMobile ? 48 : 50,
            child: ElevatedButton(
              onPressed: authState.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: authState.isLoading
                  ? const SizedBox(child: LoadingWidget.small())
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not registered?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isMobile ? 13 : 14,
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
                    fontSize: isMobile ? 13 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 0),
        ],
      ),
    );
  }
}
