import 'package:flutter/material.dart';
import '../screens/add_edit_production_record_screen.dart';
import '../screens/add_edit_sale_screen.dart';
import '../screens/add_edit_expense_screen.dart';
import '../screens/flock_add_edit_form_screen.dart';

/// Presentation Widget - Quick Actions Section
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Column(
              children: [
                _ActionButton(
                  label: '0 Log Production',
                  icon: Icons.checklist,
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditProductionRecordScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: '\$ Record Sale',
                  icon: Icons.attach_money,
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditSaleScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: 'Update Expenses',
                  icon: Icons.settings,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditExpenseScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: 'Add Flock',
                  icon: Icons.pets, // Changed to bird icon to match web version
                  color: const Color(0xFFADD8E6), // Light blue color
                  textColor: Colors.black,
                  borderColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FlockAddEditFormScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // View Alerts Link
                InkWell(
                  onTap: () {
                    // Handle view alerts
                  },
                  child: const Text(
                    'View system alerts and notifications',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.textColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isWhite = color == Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isWhite ? Colors.white : color,
          foregroundColor: textColor ?? (isWhite ? Colors.black : Colors.white),
          elevation: isWhite ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: borderColor ?? (isWhite ? Colors.grey[300]! : color),
              width: isWhite ? 1 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
