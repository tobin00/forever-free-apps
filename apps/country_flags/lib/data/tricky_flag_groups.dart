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
    // Group 1 — Green / Yellow / Red tricolors (Pan-African colors)
    TrickyFlagGroup(
      groupName: 'Green, Yellow & Red Tricolors',
      isoCodes: ['ET', 'GH', 'GN', 'CM'],
      // Ethiopia, Ghana, Guinea, Cameroon
    ),

    // ── Add more groups below as they are identified ──────────────────────
    // Example:
    // TrickyFlagGroup(
    //   groupName: 'Blue & White Horizontal Stripes',
    //   isoCodes: ['GR', 'AR', 'HN', 'SV'],
    // ),
  ];
}
