import 'dart:async';

import 'package:flutter_sqlite/core/utils/logger.dart';
import 'package:flutter_sqlite/src/app/logic/app_runner.dart';

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}
