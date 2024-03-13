import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/core/utils/logger.dart';
import 'package:flutter_sqlite/src/app/di/app_scope.export.dart';
import 'package:flutter_sqlite/src/app/logic/initialize_products.dart';
import 'package:flutter_sqlite/src/app/widget/app.dart';

final class AppRunner {
  const AppRunner();

  Future<void> initializeAndRun() async {
    final bindings = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

    FlutterError.onError = logger.logFlutterError;
    PlatformDispatcher.instance.onError = logger.logPlatformDispatcherError;
    bindings.allowFirstFrame();

    final scopeRegister = AppScopeRegister();
    final scope = await scopeRegister.createScope();
    final db = await scope.database;

    await InitializeProducts.initializeProducts(db);
    await scope.initServices();

    App(scope).attach();
  }
}
