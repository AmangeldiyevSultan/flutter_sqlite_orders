import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sqlite/core/assets/themes/theme_data.dart';
import 'package:flutter_sqlite/core/common/provider/di_scope.dart';
import 'package:flutter_sqlite/core/router/router.dart';
import 'package:flutter_sqlite/src/app/di/app_scope.export.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext(
    this.appScope, {
    super.key,
  });

  /// Scope of dependencies which need through all app's life.
  final AppScope appScope;

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late IAppScope _scope;

  @override
  void initState() {
    super.initState();

    _scope = widget.appScope..applicationRebuilder = _rebuildApplication;
  }

  void _rebuildApplication() {
    setState(() {
      _scope = widget.appScope..applicationRebuilder = _rebuildApplication;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 805),
      child: DiScope<IAppScope>(
        key: ObjectKey(_scope),
        factory: () {
          return _scope;
        },
        child: MaterialApp(
          theme: AppThemeData.defaultTheme,
          onGenerateRoute: generateRoute,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: widget!,
            );
          },
        ),
      ),
    );
  }
}
