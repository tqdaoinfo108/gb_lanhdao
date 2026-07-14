import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/agency_models.dart';
import '../../../data/models/ai_assistant_models.dart';
import '../../../data/models/booking_models.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/models/digital_map_models.dart';
import '../../../data/models/document_models.dart';
import '../../../data/models/kpi_models.dart';
import '../../../data/models/office_models.dart';
import '../../../data/models/process_models.dart';
import '../../../data/models/residence_models.dart';
import '../../../data/models/urgent_alert_models.dart';
import '../../../data/models/crime_report_models.dart';
import '../../../data/models/work_calendar_models.dart';
import '../../../widgets/admin_smart_ui.dart';
import '../controllers/home_controller.dart';

part 'widgets/shell_widgets.dart';
part 'screens/overview_screen.dart';
part 'screens/periodic_report_screen.dart';
part 'screens/meeting_schedule_screen.dart';
part 'screens/work_calendar_screen.dart';
part 'screens/apps_screen.dart';
part 'screens/placeholder_screens.dart';
part 'screens/ai_assistant_screen.dart';
part 'screens/digital_map_screen.dart';
part 'screens/offices_screen.dart';
part 'screens/residence_screen.dart';
part 'screens/documents_screen.dart';
part 'screens/kpi_programs_screen.dart';
part 'screens/agencies_screen.dart';
part 'screens/tasks_screen.dart';
part 'screens/account_screen.dart';
part 'widgets/layout_widgets.dart';
part 'widgets/app_grid_widgets.dart';
part 'widgets/period_widgets.dart';
part 'widgets/dashboard_widgets.dart';
part 'widgets/feedback_widgets.dart';
part 'widgets/detail_widgets.dart';
part 'widgets/list_widgets.dart';
part 'helpers/app_catalog.dart';
part 'helpers/home_helpers.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.topCenter,
                      children: [
                        for (final child in previousChildren)
                          Positioned.fill(child: child),
                        if (currentChild != null)
                          Positioned.fill(child: currentChild),
                      ],
                    );
                  },
                  child: SizedBox.expand(
                    key: ValueKey(controller.currentView.value),
                    child:
                        controller.currentView.value ==
                            AdminSmartView.aiAssistant
                        ? _buildCurrentScreen()
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
                            child: _buildCurrentScreen(),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => _SmartBottomNav(
          selectedIndex: controller.selectedTab,
          onTap: controller.showBottomTab,
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (controller.currentView.value) {
      case AdminSmartView.overview:
        return _OverviewScreen(controller: controller);
      case AdminSmartView.apps:
        return _AppsScreen(controller: controller);
      case AdminSmartView.crimeReports:
        return _CrimeReportsScreen(controller: controller);
      case AdminSmartView.crimeReportNew:
        return _CrimeReportNewScreen(controller: controller);
      case AdminSmartView.aiAssistant:
        return _AiAssistantScreen(controller: controller);
      case AdminSmartView.digitalMap:
        return _DigitalMapScreen(controller: controller);
      case AdminSmartView.offices:
        return _OfficesScreen(controller: controller);
      case AdminSmartView.residence:
        return _ResidenceScreen(controller: controller);
      case AdminSmartView.documents:
        return _DocumentsScreen(controller: controller);
      case AdminSmartView.kpiPrograms:
        return _KpiProgramsScreen(controller: controller);
      case AdminSmartView.urgentAlerts:
        return _UrgentAlertsScreen(controller: controller);
      case AdminSmartView.tasks:
        return _TasksScreen(controller: controller);
      case AdminSmartView.processCreate:
        return _ProcessCreateScreen(controller: controller);
      case AdminSmartView.periodicReport:
        return _PeriodicReportScreen(controller: controller);
      case AdminSmartView.meetingSchedule:
        return _MeetingScheduleScreen(controller: controller);
      case AdminSmartView.agencies:
        return _AgenciesScreen(controller: controller);
      case AdminSmartView.account:
        return _AccountScreen(controller: controller);
      case AdminSmartView.accountProfileDetail:
        return _ProfileDetailScreen(controller: controller);
      case AdminSmartView.accountNotificationDetail:
        return _AccountDetailScreen.notifications(controller: controller);
      case AdminSmartView.accountSecurityDetail:
        return _AccountDetailScreen.security(controller: controller);
      case AdminSmartView.accountSyncDetail:
        return _AccountDetailScreen.sync(controller: controller);
      case AdminSmartView.workCalendar:
        return _WorkCalendarScreen(controller: controller);
      case AdminSmartView.workCalendarDetail:
        return _WorkCalendarDetailScreen(controller: controller);
    }
  }
}
