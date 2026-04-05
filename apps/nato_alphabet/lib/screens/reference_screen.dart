import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/nato_alphabet.dart';
import '../widgets/nato_entry_card.dart';

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'NATO Alphabet Reference',
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _WikiBlurb(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NatoEntryCard(entry: NatoData.entries[index]),
                ),
                childCount: NatoData.entries.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

/// Header blurb with a tappable Wikipedia link.
class _WikiBlurb extends StatefulWidget {
  @override
  State<_WikiBlurb> createState() => _WikiBlurbState();
}

class _WikiBlurbState extends State<_WikiBlurb> {
  late final TapGestureRecognizer _wikiTap;

  static final _wikiUri = Uri.parse(
    'https://en.wikipedia.org/wiki/NATO_phonetic_alphabet',
  );

  @override
  void initState() {
    super.initState();
    _wikiTap = TapGestureRecognizer()..onTap = _launchWiki;
  }

  @override
  void dispose() {
    _wikiTap.dispose();
    super.dispose();
  }

  Future<void> _launchWiki() async {
    try {
      await launchUrl(_wikiUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // If no browser is available, silently ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyMedium;
    final linkStyle = baseStyle?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );

    return Semantics(
      label:
          'The NATO phonetic alphabet is an internationally recognized set of names '
          'for the letters of the Latin alphabet, commonly used in radio and phone '
          'communication where letters are likely to be misheard. '
          'Tap "More information" to open the Wikipedia article.',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: baseStyle,
              children: [
                const TextSpan(
                  text:
                      'The NATO phonetic alphabet is an internationally recognized '
                      'set of names for the letters of the Latin alphabet, commonly '
                      'used in radio and phone communication where letters are likely '
                      'to be misheard.  ',
                ),
                TextSpan(
                  text: 'More information here.',
                  style: linkStyle,
                  recognizer: _wikiTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
