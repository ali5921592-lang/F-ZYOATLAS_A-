import 'package:flutter/material.dart';

/// Kırmızı bayrak uyarısı için kritik görünümlü banner.
/// Normal sohbet balonlarından bilinçli olarak farklı ve dikkat
/// çekici tasarlanmıştır.
class SafetyBanner extends StatelessWidget {
  final String message;

  const SafetyBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.error, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_rounded, color: colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              semanticsLabel: 'Acil sağlık uyarısı: $message',
            ),
          ),
        ],
      ),
    );
  }
}
