import 'package:flutter/material.dart';
import 'package:flutter_sqlite/src/app/di/app_scope.export.dart';
import 'package:flutter_sqlite/src/app/widget/material_context.dart';

class App extends StatelessWidget {
  const App(
    this.appScope, {
    super.key,
  });

  final AppScope appScope;

  void attach([VoidCallback? callback]) {
    callback?.call();

    runApp(this);
  }

  @override
  Widget build(BuildContext context) => MaterialContext(appScope);
}
