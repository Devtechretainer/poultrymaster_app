import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/user_profile_providers.dart';
import '../../domain/entities/user_profile.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/loading_widget.dart';
import '../../application/providers/auth_providers.dart';
import '../../core/theme/input_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    // Create a UserProfile from the authenticated User
    final profile = user != null
        ? UserProfile(
            id: user.id,
            userName: user.username,
            email: user.email,
            phoneNumber: user.phoneNumber,
            farmId: user.farmId,
            farmName: user.farmName,
            firstName: user.firstName,
            lastName: user.lastName,
            selectedFarmId: user.farmId, // Use farmId from User as selectedFarmId
          )
        : null;

    if (kDebugMode) {
      debugPrint('ProfileScreen - Profile Phone Number: ${profile?.phoneNumber}');
    }

    return BasePageScreen(
      currentRoute: '/profile',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Account',
      pageSubtitle: 'Manage your account settings',
      pageIcon: Icons.account_circle,
      iconBackgroundColor: const Color(0xFFF5F3FF),
      searchController: searchController,
      child: profile == null
          ? const LoadingWidget.large()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFF9333EA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 40),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.userName ?? 'User',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email ?? '',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.farmName ?? '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow('Farm ID', profile.selectedFarmId ?? 'N/A'),
                  const SizedBox(height: 16),
                  _buildInfoRow('User ID', profile.id ?? 'N/A'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Phone Number',
                      (profile.phoneNumber == null || profile.phoneNumber!.isEmpty) ? 'N/A' : profile.phoneNumber!),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _showEditProfileDialog(context, ref, profile),
                        child: const Text('Edit Profile'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () =>
                            _showDeleteConfirmationDialog(context, ref, user!.id),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Delete Account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500)),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showEditProfileDialog(
      BuildContext context, WidgetRef ref, UserProfile? profile) {
    if (profile == null) return;

    final firstNameController = TextEditingController(text: profile.firstName);
    final lastNameController = TextEditingController(text: profile.lastName);
    final phoneController = TextEditingController(text: profile.phoneNumber);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: firstNameController,
                  decoration: InputTheme.standardDecoration(
                    label: 'First Name',
                    hint: profile.firstName ?? 'Enter first name',
                  )),
              const SizedBox(height: 16),
              TextField(
                  controller: lastNameController,
                  decoration: InputTheme.standardDecoration(
                    label: 'Last Name',
                    hint: profile.lastName ?? 'Enter last name',
                  )),
              const SizedBox(height: 16),
              TextField(
                  controller: phoneController,
                  decoration: InputTheme.standardDecoration(
                    label: 'Phone Number',
                    hint: profile.phoneNumber ?? 'Enter phone number',
                  )),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final updatedProfile = profile.copyWith(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneController.text,
                );
                Navigator.of(dialogContext).pop();
                try {
                  await ref
                      .read(userProfileControllerProvider.notifier)
                      .updateUserProfile(updatedProfile);

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (kDebugMode) {
                    print('Error updating profile: $e');
                  }
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating profile: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content:
              const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .deleteUserProfile(id);
                Navigator.of(context).pop();
                widget.onLogout();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
