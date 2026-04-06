/// A curated group of countries whose flags look visually similar.
/// Used by Quiz — Tricky Flags to present same-group distractors.
class TrickyFlagGroup {
  /// Short descriptive label shown during the quiz (e.g. "Green/Yellow/Red Tricolors").
  final String groupName;

  /// ISO 3166-1 alpha-2 codes of the countries in this group.
  /// Must contain at least 4 entries (to fill 4 answer cards).
  final List<String> isoCodes;

  const TrickyFlagGroup({
    required this.groupName,
    required this.isoCodes,
  });

  /// Number of countries in this group.
  int get length => isoCodes.length;
}
