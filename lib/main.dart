import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:h_k_app/controllers/preference_controller.dart';
import 'package:h_k_app/controllers/theme_controller.dart';
import 'package:h_k_app/repo/database.dart';
import 'package:h_k_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:h_k_app/utils/bindings.dart';
import 'package:h_k_app/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';

import 'utils/enum.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    await SystemTheme.accentColor.load();
  }

  final prefs = await SharedPreferences.getInstance();

  Get.put<SharedPreferences>(prefs);
  Get.put(DatabaseRepository(Get.find<SharedPreferences>()));
  Get.put(PreferencesController(Get.find<DatabaseRepository>()));

  LicenseRegistry.addLicense(() async* {
    for (final font in Fonts.values) {
      final license = await font.license();
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    }
  });

  runApp(const NeumorphicCalculatorApp());
}

class NeumorphicCalculatorApp extends StatelessWidget {
  const NeumorphicCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(Get.find<DatabaseRepository>(), Get.find<PreferencesController>()),
      builder: (ctrl) {
        return GetMaterialApp(
          initialBinding: InitBindings(),
          debugShowCheckedModeBanner: false,
          title: AppConst.appName,
          themeMode: ctrl.themeMode,
          theme: ctrl.lightTheme,
          darkTheme: ctrl.darkTheme,
          home: DashboardScreen(),
        );
      },
    );
  }
}
