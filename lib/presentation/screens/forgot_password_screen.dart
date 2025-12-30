import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/states/auth_state.dart';
import '../widgets/branding_section.dart';
import '../widgets/loading_widget.dart';

/// Presentation Screen - Forgot Password UI
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _showOtpField = false;
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _handleRequestOtp() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .requestPasswordReset(_emailController.text.trim());
      setState(() {
        _showOtpField = true;
      });
    }
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .resetPassword(
            _emailController.text.trim(),
            _otpController.text.trim(),
            _newPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.error == null && !next.isLoading && _showOtpField) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'images/farmer-illustration.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Forgot Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _showOtpField
                                  ? 'Enter the OTP code and your new password'
                                  : 'Enter your registered email address. We\'ll send you a code to reset your password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: subtitleColor),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              enabled: !_showOtpField,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                              decoration: _inputDecoration(
                                context,
                                'Enter your email address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (!value.contains('@')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            if (_showOtpField) ...[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _otpController,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1F2937),
                                ),
                                decoration: _inputDecoration(
                                  context,
                                  'Enter OTP',
                                ),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1F2937),
                                ),
                                decoration:
                                    _inputDecoration(
                                      context,
                                      'New Password',
                                    ).copyWith(
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
                                            _obscurePassword =
                                                !_obscurePassword;
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
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : _showOtpField
                                    ? _handleResetPassword
                                    : _handleRequestOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                        child: LoadingWidget.small(),
                                      )
                                    : Text(
                                        _showOtpField
                                            ? 'Reset Password'
                                            : 'Send OTP',
                                        style: const TextStyle(
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
                                  'Remember your password?',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        const Spacer(),
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
                        const SizedBox(height: 40),
                        // Title
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showOtpField
                              ? 'Enter the OTP code and your new password'
                              : 'Enter your registered email address. We\'ll send you a code to reset your password.',
                          style: TextStyle(color: subtitleColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          enabled: !_showOtpField,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                          decoration: _inputDecoration(
                            context,
                            'Enter your email address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!value.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                        if (_showOtpField) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _otpController,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1F2937),
                            ),
                            decoration: _inputDecoration(context, 'Enter OTP'),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1F2937),
                            ),
                            decoration:
                                _inputDecoration(
                                  context,
                                  'New Password',
                                ).copyWith(
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
                        ],
                        const SizedBox(height: 30),
                        // Button
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : _showOtpField
                                ? _handleResetPassword
                                : _handleRequestOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: authState.isLoading
                                ? const LoadingWidget.small()
                                : Text(
                                    _showOtpField
                                        ? 'Reset Password'
                                        : 'Send OTP',
                                    style: const TextStyle(
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
                            Text(
                              'Remember your password?',
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
                        const Spacer(),
                      ],
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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFFF7A00), width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
