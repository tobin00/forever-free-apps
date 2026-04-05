/// A single NATO phonetic alphabet entry (e.g., A = Alfa).
class NatoEntry {
  final String letter;
  final String word;
  final String pronunciation;

  const NatoEntry({
    required this.letter,
    required this.word,
    required this.pronunciation,
  });
}
