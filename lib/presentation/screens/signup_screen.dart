import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/states/auth_state.dart';
import '../widgets/branding_section.dart';
import 'home_screen.dart';

/// Presentation Screen - Sign Up UI
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _farmNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .register(
            farmName: _farmNameController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Navigate to home if registered
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
          ),
        );
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final darkBg = const Color(0xFF1A1F2E);
    final lightBg = Colors.white;
    final formBg = isDark ? darkBg : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF2C3E50);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF7F8C8D);

    return Scaffold(
      backgroundColor: isDark ? darkBg : lightBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            // Mobile layout to match login
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Branding (dark header)
                    Container(
                      color: isDark ? darkBg : lightBg,
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
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Farm Management System',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Form card
                    Container(
                      color: formBg,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      width: double.infinity,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Icon
                            Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.dashboard,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please fill in your details to register',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: subtitleColor),
                            ),
                            const SizedBox(height: 24),
                            // Fields (same as desktop below)
                            TextFormField(
                              controller: _farmNameController,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(
                                context,
                                'Farm Name',
                              ),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _firstNameController,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(
                                context,
                                'First Name',
                              ),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _lastNameController,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(
                                context,
                                'Last Name',
                              ),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(context, 'Username'),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(
                                context,
                                'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (!value.contains('@'))
                                  return 'Invalid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(
                                context,
                                'Phone Number',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(context, 'Password')
                                  .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: isDark
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
                                  return 'Required';
                                }
                                if (value.length < 6) {
                                  return 'Must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(color: subtitleColor),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Desktop: original side-by-side
          return Row(
            children: [
              Expanded(flex: 4, child: BrandingSection()),
              Expanded(
                flex: 6,
                child: Container(
                  color: formBg,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 40,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Back button
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.orange,
                              ),
                              label: const Text(
                                'Back',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Icon
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'images/farmer-illustration.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Title
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please fill in your details to register',
                            style: TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          // Form fields
                          TextFormField(
                            controller: _farmNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(context, 'Farm Name'),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration(
                                    context,
                                    'First Name',
                                  ),
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration(
                                    context,
                                    'Last Name',
                                  ),
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(context, 'Username'),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              context,
                              'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              if (!value.contains('@')) return 'Invalid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              context,
                              'Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(context, 'Password')
                                .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              if (value.length < 6)
                                return 'Must be at least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          // Create Account button
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? const Color(0x80334155) : const Color(0xFFE8EEF6);
    final borderColor = isDark
        ? const Color(0xFF475569)
        : const Color(0xFFCBD5E1);
    final labelColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: labelColor),
      filled: true,
      fillColor: fill,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF7A00), width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
