import 'package:get/get.dart';
import 'package:h_k_app/repo/database.dart';
import 'package:h_k_app/screens/dashboard_screen/dashboard_controller.dart';
import 'package:h_k_app/screens/calculator_screen/calculator_controller.dart';
import 'package:h_k_app/screens/history_screen/history_controller.dart';
import 'package:h_k_app/screens/settings_screen/settings_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(SettingsController(Get.find<DatabaseRepository>()));
    Get.put(HistoryController(Get.find<DatabaseRepository>()));
    Get.put(CalculatorController());
  }
}
