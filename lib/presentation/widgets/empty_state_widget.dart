import 'package:flutter/material.dart';

/// Reusable Empty State Widget
/// Matches the frontend FarmArchive design exactly
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48), // py-12
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container (matching frontend: w-16 h-16)
            Container(
              width: 64, // w-16 = 64px
              height: 64, // h-16 = 64px
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // bg-slate-100
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32, // w-8 h-8 = 32px
                color: const Color(0xFF94A3B8), // text-slate-400
              ),
            ),

            const SizedBox(height: 16), // mb-4
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18, // text-lg
                fontWeight: FontWeight.w600, // font-semibold
                color: Color(0xFF0F172A), // text-slate-900
              ),
            ),

            const SizedBox(height: 8), // mb-2
            // Subtitle
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF475569), // text-slate-600
              ),
            ),

            const SizedBox(height: 24), // mb-6
            // Action Button
            ElevatedButton.icon(
              onPressed: onButtonPressed,
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: Text(
                buttonLabel,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), // bg-blue-600
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
