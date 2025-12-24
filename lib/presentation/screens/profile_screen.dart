import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/user_profile_providers.dart';
import '../../domain/entities/user_profile.dart';
import '../widgets/base_page_screen.dart';
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
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    if (user != null) {
      Future.microtask(() => ref
          .read(userProfileControllerProvider.notifier)
          .findUserProfile(user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final userProfileState = ref.watch(userProfileControllerProvider);
    final profile = userProfileState.userProfile;

    return BasePageScreen(
      currentRoute: '/profile',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Account',
      pageSubtitle: 'Manage your account settings',
      pageIcon: Icons.account_circle,
      iconBackgroundColor: const Color(0xFFF5F3FF),
      searchController: searchController,
      child: userProfileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProfileState.error != null
              ? Center(child: Text('Error: ${userProfileState.error}'))
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
                                  profile?.userName ?? 'User',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile?.email ?? '',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile?.farmName ?? '',
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
                      _buildInfoRow('Farm ID', profile?.farmId ?? 'N/A'),
                      const SizedBox(height: 16),
                      _buildInfoRow('User ID', profile?.id ?? 'N/A'),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                          'Phone Number', profile?.phoneNumber ?? 'N/A'),
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: firstNameController,
                  decoration: InputTheme.standardDecoration(
                    label: 'First Name',
                    hint: 'Enter first name',
                  )),
              const SizedBox(height: 16),
              TextField(
                  controller: lastNameController,
                  decoration: InputTheme.standardDecoration(
                    label: 'Last Name',
                    hint: 'Enter last name',
                  )),
              const SizedBox(height: 16),
              TextField(
                  controller: phoneController,
                  decoration: InputTheme.standardDecoration(
                    label: 'Phone Number',
                    hint: 'Enter phone number',
                  )),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final updatedProfile = UserProfile(
                  id: profile.id,
                  userName: profile.userName,
                  email: profile.email,
                  farmId: profile.farmId,
                  farmName: profile.farmName,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneController.text,
                );
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(updatedProfile);
                Navigator.of(context).pop();
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
