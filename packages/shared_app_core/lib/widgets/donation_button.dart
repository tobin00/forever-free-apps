import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/brand.dart';
import '../theme/app_colors.dart';

/// Accent-colored outlined button that opens the donation URL in the system browser.
class DonationButton extends StatelessWidget {
  const DonationButton({super.key});

  Future<void> _openDonationUrl() async {
    final uri = Uri.parse(Brand.donationUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _openDonationUrl,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: const BorderSide(color: AppColors.accent, width: 1.5),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(
        Brand.donationButtonLabel,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.accent),
      ),
    );
  }
}
