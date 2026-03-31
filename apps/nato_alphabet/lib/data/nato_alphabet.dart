import '../models/nato_entry.dart';

/// The 26 standard NATO phonetic alphabet entries.
class NatoData {
  NatoData._();

  static const List<NatoEntry> entries = [
    NatoEntry(letter: 'A', word: 'Alpha'),
    NatoEntry(letter: 'B', word: 'Bravo'),
    NatoEntry(letter: 'C', word: 'Charlie'),
    NatoEntry(letter: 'D', word: 'Delta'),
    NatoEntry(letter: 'E', word: 'Echo'),
    NatoEntry(letter: 'F', word: 'Foxtrot'),
    NatoEntry(letter: 'G', word: 'Golf'),
    NatoEntry(letter: 'H', word: 'Hotel'),
    NatoEntry(letter: 'I', word: 'India'),
    NatoEntry(letter: 'J', word: 'Juliet'),
    NatoEntry(letter: 'K', word: 'Kilo'),
    NatoEntry(letter: 'L', word: 'Lima'),
    NatoEntry(letter: 'M', word: 'Mike'),
    NatoEntry(letter: 'N', word: 'November'),
    NatoEntry(letter: 'O', word: 'Oscar'),
    NatoEntry(letter: 'P', word: 'Papa'),
    NatoEntry(letter: 'Q', word: 'Quebec'),
    NatoEntry(letter: 'R', word: 'Romeo'),
    NatoEntry(letter: 'S', word: 'Sierra'),
    NatoEntry(letter: 'T', word: 'Tango'),
    NatoEntry(letter: 'U', word: 'Uniform'),
    NatoEntry(letter: 'V', word: 'Victor'),
    NatoEntry(letter: 'W', word: 'Whiskey'),
    NatoEntry(letter: 'X', word: 'X-ray'),
    NatoEntry(letter: 'Y', word: 'Yankee'),
    NatoEntry(letter: 'Z', word: 'Zulu'),
  ];

  /// Map of uppercase letter → NATO word, for quick lookup.
  static final Map<String, String> lookup = {
    for (final e in entries) e.letter: e.word,
  };
}
