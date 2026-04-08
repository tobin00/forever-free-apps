// Runs on the HOST machine (not the simulator).
// Receives screenshot bytes from the device-side test and saves them as
// PNG files in the screenshots/ directory relative to where flutter drive
// is invoked (apps/nato_alphabet/screenshots/).

import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (
      String screenshotName,
      List<int> screenshotBytes, [
      Map<String, Object?>? args,
    ]) async {
      final dir = Directory('screenshots');
      if (!dir.existsSync()) dir.createSync(recursive: true);

      final file = File('screenshots/$screenshotName.png');
      file.writeAsBytesSync(screenshotBytes);
      // ignore: avoid_print
      print('  ✓ Saved $screenshotName.png (${screenshotBytes.length} bytes)');
      return true;
    },
  );
}
