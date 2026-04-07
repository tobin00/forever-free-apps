import '../models/tricky_flag_group.dart';

/// Curated groups of visually similar flags used by Quiz — Tricky Flags.
///
/// ─── HOW TO ADD A NEW GROUP ──────────────────────────────────────────────
/// 1. Add a new TrickyFlagGroup entry to the [all] list below.
/// 2. Set a descriptive [groupName] (shown to user during the quiz).
/// 3. List the ISO 3166-1 alpha-2 codes in [isoCodes].
///    Must have at least 4 entries (to fill 4 answer cards).
/// 4. That's it — no other code changes needed.
/// ─────────────────────────────────────────────────────────────────────────
class TrickyFlagGroupsData {
  TrickyFlagGroupsData._();

  static const List<TrickyFlagGroup> all = [
    // Group 1 — Pan-African horizontal tricolors (green/yellow/red)
    TrickyFlagGroup(
      groupName: 'Green, Yellow & Red Tricolors',
      isoCodes: ['ET', 'GH', 'GN', 'CM'],
      // Ethiopia, Ghana, Guinea, Cameroon
    ),

    // Group 2 — Nordic cross flags (cross on solid background)
    TrickyFlagGroup(
      groupName: 'Nordic Cross Flags',
      isoCodes: ['DK', 'NO', 'IS', 'FI', 'SE'],
      // Denmark, Norway, Iceland, Finland, Sweden
    ),

    // Group 3 — Arab tricolors (red / white / black horizontal)
    TrickyFlagGroup(
      groupName: 'Arab Tricolors (Red, White & Black)',
      isoCodes: ['EG', 'SY', 'IQ', 'YE'],
      // Egypt, Syria, Iraq, Yemen
    ),

    // Group 4 — Red & white bicolor flags
    TrickyFlagGroup(
      groupName: 'Red & White Bicolor Flags',
      isoCodes: ['ID', 'MC', 'PL', 'SG'],
      // Indonesia, Monaco, Poland, Singapore
    ),

    // Group 5 — Green / white / red-or-orange vertical tricolors
    TrickyFlagGroup(
      groupName: 'Green–White Vertical Tricolors',
      isoCodes: ['IE', 'IT', 'CI', 'MX'],
      // Ireland, Italy, Côte d'Ivoire, Mexico
    ),

    // Group 6 — Red / white / blue horizontal tricolors
    TrickyFlagGroup(
      groupName: 'Red, White & Blue Horizontal Tricolors',
      isoCodes: ['NL', 'LU', 'RU', 'CZ'],
      // Netherlands, Luxembourg, Russia, Czech Republic
    ),
  ];
}
