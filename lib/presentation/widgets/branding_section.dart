import 'package:flutter/material.dart';

/// Presentation Widget - Branding section with farmer illustration
/// Pure UI component
class BrandingSection extends StatelessWidget {
  const BrandingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'Poultry Core',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Farm Management System',
                style: TextStyle(fontSize: 18, color: Color(0xFF7F8C8D)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Farmer illustration - Use Flexible to prevent overflow
              Flexible(
                child: Image.asset(
                  'images/farmer-illustration.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              // Bottom text
              const Text(
                'Designed by James Quayson',
                style: TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
