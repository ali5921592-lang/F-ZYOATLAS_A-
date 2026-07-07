import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_strings.dart';

/// "Fizyoterapiste Ulaş" kartı. AI, referral kriterleri tetiklendiğinde
/// bu kartı sohbet akışının içine gömer.
class PhysioReferralCard extends StatelessWidget {
  const PhysioReferralCard({super.key});

  Future<void> _call() =>
      launchUrl(Uri(scheme: 'tel', path: AppStrings.physioPhone));

  Future<void> _whatsapp() => launchUrl(
        Uri.parse('https://wa.me/${AppStrings.physioPhone.replaceAll('+', '')}'),
      );

  Future<void> _instagram() =>
      launchUrl(Uri.parse('https://instagram.com/${AppStrings.physioInstagram}'));

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fizyoterapist ${AppStrings.physioName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(
                  icon: Icons.phone,
                  label: 'Telefon Et',
                  onTap: _call,
                ),
                _ActionButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  onTap: _whatsapp,
                ),
                _ActionButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  onTap: _instagram,
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
  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
