import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/brand.dart';
import '../theme/app_colors.dart';
import 'donation_button.dart';

/// Shared About page used by every Forever Free app.
/// Pass [appName], [appVersion], and optionally an [iconWidget] to replace
/// the default placeholder with the app's real icon.
class AboutPage extends StatelessWidget {
  final String appName;
  final String appVersion;
  /// Optional icon displayed at the top. If omitted, a generic placeholder
  /// is shown. Pass e.g. `Image.asset('assets/icon/icon.png')` from the app.
  final Widget? iconWidget;

  const AboutPage({
    super.key,
    required this.appName,
    required this.appVersion,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App icon, name, version
            Center(
              child: Column(
                children: [
                  iconWidget ?? Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [AppColors.primaryDark, AppColors.primaryVariantDark]
                            : [AppColors.primary, AppColors.primaryVariant],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.abc, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(appName, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Version $appVersion',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 28),

            // Paragraph 1 — the origin story
            Text(Brand.missionParagraph1, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),

            // Paragraph 2 — the promise
            Text(Brand.missionParagraph2, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),

            // Paragraph 3 — contact, with tappable mailto link
            _ContactParagraph(baseStyle: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),

            // Paragraph 4 — donation encouragement
            Text(Brand.donationParagraph, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 32),

            // Donation button — centered, amber outlined
            const Center(child: DonationButton()),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Renders the contact paragraph with [Brand.contactEmail] as a tappable
/// mailto link. Uses a [StatefulWidget] so the [TapGestureRecognizer] is
/// properly disposed.
class _ContactParagraph extends StatefulWidget {
  final TextStyle? baseStyle;
  const _ContactParagraph({this.baseStyle});

  @override
  State<_ContactParagraph> createState() => _ContactParagraphState();
}

class _ContactParagraphState extends State<_ContactParagraph> {
  late final TapGestureRecognizer _emailTap;

  @override
  void initState() {
    super.initState();
    _emailTap = TapGestureRecognizer()..onTap = _launchEmail;
  }

  @override
  void dispose() {
    _emailTap.dispose();
    super.dispose();
  }

  Future<void> _launchEmail() async {
    final uri = Uri(scheme: 'mailto', path: Brand.contactEmail);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = widget.baseStyle?.copyWith(
      color: AppColors.accent,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.accent,
    );

    return Semantics(
      label: '${Brand.contactPrefix}${Brand.contactEmail}. Tap to send email.',
      child: RichText(
        text: TextSpan(
          style: widget.baseStyle,
          children: [
            const TextSpan(text: Brand.contactPrefix),
            TextSpan(
              text: Brand.contactEmail,
              style: linkStyle,
              recognizer: _emailTap,
            ),
          ],
        ),
      ),
    );
  }
}
