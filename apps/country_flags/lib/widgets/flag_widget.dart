import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

/// Consistent flag display wrapper used throughout the app.
/// Renders an SVG flag via the country_flags package with rounded corners.
class FlagWidget extends StatelessWidget {
  final String isoCode;
  final double height;
  final double? width;
  final double borderRadius;

  const FlagWidget({
    super.key,
    required this.isoCode,
    required this.height,
    this.width,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CountryFlag.fromCountryCode(
      isoCode,
      theme: ImageTheme(
        height: height,
        width: width ?? height * 1.5,
        shape: RoundedRectangle(borderRadius),
      ),
    );
  }
}
