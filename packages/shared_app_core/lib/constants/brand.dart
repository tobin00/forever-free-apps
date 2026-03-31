/// Brand-wide constants shared across all Forever Free apps.
class Brand {
  Brand._();

  static const String tagline = 'Free apps, no ads, no tracking. Just useful tools made with care.';

  // ── About page paragraphs (in display order) ──────────────────────────────

  static const String missionParagraph1 =
      'When the internet was young, people made a lot of cool and useful things for free, '
      'just because it was fun. Over time, we\'ve gotten used to everything useful either '
      'being filled with ads, or not being free. Now that development is easier than ever, '
      'I\'d like to start replacing junk with free, high quality apps.';

  static const String missionParagraph2 =
      'Forever Free apps will never have a single ad, and never cost a single dollar, forever. '
      'They won\'t require internet access, or share your personal information. '
      'They\'re just things I think are useful or neat.';

  // Contact paragraph — split so the email address can be rendered as a link.
  static const String contactPrefix =
      'If you find any bugs, or have ideas for an app I should make, send them to ';
  static const String contactEmail = 'foreverfree@coziahr.com';

  static const String donationParagraph =
      'All my apps are free, forever. If you want to help support the cause '
      '(and the app store fees), it\'s always appreciated!';

  // ── Shared UI strings ──────────────────────────────────────────────────────

  static const String donationUrl = 'https://foreverfreeapps.com/donate';
  static const String donationButtonLabel = 'Support These Apps';

  static const String madeWithCare = 'Made with care \u2665';
}
