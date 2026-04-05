import '../models/nato_entry.dart';

/// The 26 standard NATO phonetic alphabet entries.
class NatoData {
  NatoData._();

  static const List<NatoEntry> entries = [
    NatoEntry(letter: 'A', word: 'Alfa',     pronunciation: 'AL-FAH'),
    NatoEntry(letter: 'B', word: 'Bravo',    pronunciation: 'BRAH-VOH'),
    NatoEntry(letter: 'C', word: 'Charlie',  pronunciation: 'CHAR-LEE'),
    NatoEntry(letter: 'D', word: 'Delta',    pronunciation: 'DELL-TAH'),
    NatoEntry(letter: 'E', word: 'Echo',     pronunciation: 'ECK-OH'),
    NatoEntry(letter: 'F', word: 'Foxtrot',  pronunciation: 'FOKS-TROT'),
    NatoEntry(letter: 'G', word: 'Golf',     pronunciation: 'GOLF'),
    NatoEntry(letter: 'H', word: 'Hotel',    pronunciation: 'hoh-TELL'),
    NatoEntry(letter: 'I', word: 'India',    pronunciation: 'IN-dee-ah'),
    NatoEntry(letter: 'J', word: 'Juliett',  pronunciation: 'JEW-lee-ETT'),
    NatoEntry(letter: 'K', word: 'Kilo',     pronunciation: 'KEY-loh'),
    NatoEntry(letter: 'L', word: 'Lima',     pronunciation: 'LEE-mah'),
    NatoEntry(letter: 'M', word: 'Mike',     pronunciation: 'MIKE'),
    NatoEntry(letter: 'N', word: 'November', pronunciation: 'no-VEM-ber'),
    NatoEntry(letter: 'O', word: 'Oscar',    pronunciation: 'OSS-cah'),
    NatoEntry(letter: 'P', word: 'Papa',     pronunciation: 'pah-PAH'),
    NatoEntry(letter: 'Q', word: 'Quebec',   pronunciation: 'keh-BECK'),
    NatoEntry(letter: 'R', word: 'Romeo',    pronunciation: 'ROW-me-oh'),
    NatoEntry(letter: 'S', word: 'Sierra',   pronunciation: 'see-AIR-rah'),
    NatoEntry(letter: 'T', word: 'Tango',    pronunciation: 'TANG-go'),
    NatoEntry(letter: 'U', word: 'Uniform',  pronunciation: 'YOU-nee-form'),
    NatoEntry(letter: 'V', word: 'Victor',   pronunciation: 'VIK-tah'),
    NatoEntry(letter: 'W', word: 'Whiskey',  pronunciation: 'WISS-key'),
    NatoEntry(letter: 'X', word: 'X-ray',    pronunciation: 'ECKS-ray'),
    NatoEntry(letter: 'Y', word: 'Yankee',   pronunciation: 'YANG-key'),
    NatoEntry(letter: 'Z', word: 'Zulu',     pronunciation: 'ZOO-loo'),
  ];

  /// Map of uppercase letter → NATO word, for quick lookup.
  static final Map<String, String> lookup = {
    for (final e in entries) e.letter: e.word,
  };
}
