/// User-selected options for a custom quiz session.
class CustomQuizConfig {
  /// When true the quiz never ends — it loops randomly after exhausting all countries.
  final bool loopForever;

  /// Which direction to quiz. [QuizDirection.random] re-rolls each question.
  final QuizDirection direction;

  /// Maximum number of countries to include. null means all countries.
  final int? countryCount;

  /// Restrict to one region. null means all regions.
  final String? region;

  const CustomQuizConfig({
    this.loopForever = false,
    this.direction = QuizDirection.random,
    this.countryCount,
    this.region,
  });

  CustomQuizConfig copyWith({
    bool? loopForever,
    QuizDirection? direction,
    int? countryCount,
    String? region,
    bool clearCountryCount = false,
    bool clearRegion = false,
  }) {
    return CustomQuizConfig(
      loopForever: loopForever ?? this.loopForever,
      direction: direction ?? this.direction,
      countryCount: clearCountryCount ? null : (countryCount ?? this.countryCount),
      region: clearRegion ? null : (region ?? this.region),
    );
  }
}

enum QuizDirection {
  /// Show a flag, pick the country name.
  flagToName,

  /// Show a country name, pick the flag.
  nameToFlag,

  /// Re-roll randomly on each question.
  random,
}
