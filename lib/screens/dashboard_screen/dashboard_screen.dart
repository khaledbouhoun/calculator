import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:h_k_app/screens/calculator_screen/calculator_controller.dart';
import 'package:h_k_app/screens/dashboard_screen/dashboard_controller.dart';
import 'package:h_k_app/screens/calculator_screen/calculator_screen.dart';
import 'package:h_k_app/screens/history_screen/history_screen.dart';
import 'package:h_k_app/screens/settings_screen/settings_screen.dart';
import 'package:h_k_app/tutorial_screen.dart';
import 'package:h_k_app/utils/extensions/extensions.dart';
import 'package:h_k_app/widgets/calculator_app_bar.dart';
import 'package:h_k_app/widgets/circular_wipe_overlay_widget.dart';
import 'package:h_k_app/widgets/custom_scroll_physics.dart';
import 'package:h_k_app/widgets/input_widget.dart';
import 'package:h_k_app/widgets/keep_alive_wrapper.dart';
import 'package:h_k_app/widgets/result_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<DashboardController>(
      builder: (dashCtrl) {
        return PopScope(
          canPop: dashCtrl.index == 1,
          onPopInvokedWithResult: (val, _) {
            if (val) return;
            dashCtrl.animateToPage(1);
          },
          child: TutorialScreen(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value:
                  theme.appBarTheme.systemOverlayStyle?.copyWith(systemNavigationBarColor: theme.scaffoldBackgroundColor) ??
                  SystemUiOverlayStyle.light,
              child: Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      Flexible(
                        child: GetBuilder<CalculatorController>(
                          builder: (controller) {
                            return CircularWipeOverlayWidget(
                              triggerWipe: controller.isClearing,
                              onWipeComplete: controller.onWipeComplete,
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CalculatorAppBar(),
                                    Expanded(flex: 2, child: InputWidget(controller.textCtrl)),
                                    Expanded(child: ResultWidget(controller.output.formatExpression())),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: PageView(
                          physics: CustomScrollPhysics(),
                          onPageChanged: (index) {
                            dashCtrl.index = index;
                            dashCtrl.update();
                          },
                          controller: dashCtrl.pageController,
                          children: const [
                            KeepAliveWrapper(child: SettingsScreen()),
                            KeepAliveWrapper(child: CalculatorScreen()),
                            KeepAliveWrapper(child: HistoryScreen()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
