import 'package:flutter/material.dart';

import '../data/nato_alphabet.dart';
import '../widgets/nato_entry_card.dart';

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'NATO Alphabet Reference',
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: NatoData.entries.length,
        itemBuilder: (context, index) {
          final entry = NatoData.entries[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: NatoEntryCard(entry: entry),
          );
        },
      ),
    );
  }
}
