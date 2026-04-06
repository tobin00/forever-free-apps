/// Represents a single sovereign nation.
class Country {
  final String name;     // e.g. "France"
  final String isoCode;  // ISO 3166-1 alpha-2, e.g. "FR"
  final String region;   // "Africa" | "Americas" | "Asia" | "Europe" | "Oceania"

  const Country({
    required this.name,
    required this.isoCode,
    required this.region,
  });

  @override
  String toString() => '$name ($isoCode)';

  @override
  bool operator ==(Object other) =>
      other is Country && other.isoCode == isoCode;

  @override
  int get hashCode => isoCode.hashCode;
}
