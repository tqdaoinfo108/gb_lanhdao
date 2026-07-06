import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/agency_models.dart';
import '../../../data/models/booking_models.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/models/kpi_models.dart';
import '../../../data/models/office_models.dart';
import '../../../data/models/process_models.dart';
import '../../../widgets/admin_smart_ui.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _SmartAppBar(),
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: SingleChildScrollView(
                    key: ValueKey(controller.currentView.value),
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
                    child: _buildCurrentScreen(),
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
        return _AccountDetailScreen.profile(controller: controller);
      case AdminSmartView.accountNotificationDetail:
        return _AccountDetailScreen.notifications(controller: controller);
      case AdminSmartView.accountSecurityDetail:
        return _AccountDetailScreen.security(controller: controller);
      case AdminSmartView.accountSyncDetail:
        return _AccountDetailScreen.sync(controller: controller);
    }
  }
}

class _SmartAppBar extends StatelessWidget {
  const _SmartAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: Row(
        children: [
          const SmartIconBadge(label: 'A', size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AdminSmart',
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w900),
                ),
                Text(
                  'UBND Phường 5, Quận 8',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          SmartCard(
            radius: 15,
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 21),
                  Positioned(
                    top: 9,
                    right: 10,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: SmartColors.danger,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: SmartColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmartBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _SmartBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.dashboard_rounded, 'Tổng quan'),
      (Icons.apps_rounded, 'Ứng dụng'),
      (Icons.person_rounded, 'Tài khoản'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SmartCard(
          radius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = selectedIndex == index;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected
                          ? SmartColors.accentSoft
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index].$1,
                          size: 20,
                          color: selected
                              ? SmartColors.accent
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[index].$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10.5,
                            color: selected
                                ? SmartColors.accent
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _OverviewScreen extends StatelessWidget {
  final HomeController controller;

  const _OverviewScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.dashboard.value;
      final summary = bundle.summary;
      return _ScreenStack(
        children: [
          const SmartScreenHeader(
            eyebrow: 'Điều hành hôm nay',
            title: 'Tổng quan',
            badge: 'Online',
          ),
          if (controller.isDashboardLoading.value)
            const LinearProgressIndicator(),
          if (controller.dashboardError.value != null)
            _InlineError(
              message: controller.dashboardError.value!,
              onRetry: controller.fetchDashboard,
            ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: _MetricCard(
                  value: _formatPercent(summary.percentCompleteKpi),
                  suffix: '%',
                  label: 'Hoàn thành KPI',
                  note:
                      '${summary.totalKpiDone}/${summary.totalKpi} chương trình hoàn thành',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: _MetricCard(
                  value: summary.totalProcessUndone.toString(),
                  suffix: 'việc',
                  label: 'Chưa xử lý',
                  note:
                      '${_formatSigned(summary.totalProcessUndoneLastWeek)} so với tuần trước',
                  tone: SmartTone.danger,
                ),
              ),
            ],
          ),
          SmartStatGrid(
            stats: [
              SmartStatData(
                value: summary.totalProcessPriority.toString(),
                label: 'Việc ưu tiên',
                tone: SmartTone.warning,
              ),
              SmartStatData(
                value: summary.totalBooking.toString(),
                label: 'Lịch họp',
              ),
              SmartStatData(
                value: summary.totalHouseHold.toString(),
                label: 'Hộ dân cư',
              ),
            ],
          ),
          SmartSectionHeader(
            title: 'Ứng dụng nhanh',
            actionLabel: 'Tất cả',
            onAction: () => controller.showView(AdminSmartView.apps),
          ),
          Row(
            children: [
              _QuickAction(
                label: 'Bản đồ',
                icon: Icons.map_outlined,
                onTap: () => controller.showView(AdminSmartView.digitalMap),
              ),
              _QuickAction(
                label: 'KPI',
                icon: Icons.query_stats_rounded,
                onTap: () => controller.showView(AdminSmartView.kpiPrograms),
              ),
              _QuickAction(
                label: 'Khẩn',
                icon: Icons.warning_amber_rounded,
                onTap: () => controller.showView(AdminSmartView.urgentAlerts),
              ),
              _QuickAction(
                label: 'Giao việc',
                icon: Icons.task_alt_rounded,
                onTap: () => controller.showView(AdminSmartView.tasks),
              ),
            ],
          ),
          if (bundle.trends.isNotEmpty)
            _DashboardTrendCard(points: bundle.trends),
          if (bundle.departments.isNotEmpty) ...[
            const SmartSectionHeader(title: 'Theo đơn vị'),
            ...bundle.departments
                .take(
                  controller.visibleCount(
                    'overview_departments',
                    bundle.departments.length,
                  ),
                )
                .map((department) => _DepartmentRow(department: department)),
            if (bundle.departments.length > 3)
              _LoadMoreRow(
                isExpanded: controller.isExpanded(
                  'overview_departments',
                  bundle.departments.length,
                ),
                onTap: () => controller.toggleLoadMore(
                  'overview_departments',
                  bundle.departments.length,
                ),
              ),
          ],
          SmartCard(
            borderColor: SmartColors.danger.withValues(alpha: 0.22),
            child: Row(
              children: [
                const SmartIconBadge(label: '!', tone: SmartTone.danger),
                const SizedBox(width: 9),
                Expanded(
                  child: _LabelNote(
                    label:
                        '${summary.totalProcessPriority} nhiệm vụ ưu tiên cần theo dõi',
                    note: summary.nextBooking,
                  ),
                ),
                SmartPill(
                  label: summary.totalProcessPriority.toString(),
                  tone: SmartTone.danger,
                ),
              ],
            ),
          ),
          SmartSectionHeader(
            title: 'Nhiệm vụ ưu tiên',
            actionLabel: 'Xem',
            onAction: () => controller.showView(AdminSmartView.tasks),
          ),
          if (bundle.kpis.isEmpty)
            const _EmptyState(
              title: 'Chưa có KPI ưu tiên',
              note: 'Dữ liệu sẽ hiển thị khi API trả về danh sách KPI.',
            )
          else
            ...bundle.kpis
                .take(
                  controller.visibleCount('overview_kpis', bundle.kpis.length),
                )
                .map(
                  (kpi) => _TaskCard(
                    title: kpi.kpiName,
                    subtitle: '${kpi.userProcessName} · ${kpi.departmentName}',
                    status: kpi.statusName,
                    progress: kpi.progress / 100,
                    statusTone: _kpiStatusTone(kpi.statusId),
                    tags: [
                      '${_formatPercent(kpi.progress)}%',
                      _formatDateLabel(kpi.dateExpired),
                    ],
                    owner: kpi.userProcessName,
                    due: _formatDateLabel(kpi.dateExpired),
                    avatar: _initials(kpi.userProcessName),
                  ),
                ),
          if (bundle.kpis.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'overview_kpis',
                bundle.kpis.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'overview_kpis',
                bundle.kpis.length,
              ),
            ),
          if (bundle.activeUsers.users.isNotEmpty) ...[
            SmartSectionHeader(
              title: 'Cán bộ hoạt động',
              actionLabel: '${bundle.activeUsers.totals}',
            ),
            ...bundle.activeUsers.users
                .take(
                  controller.visibleCount(
                    'overview_users',
                    bundle.activeUsers.users.length,
                  ),
                )
                .map((user) => _ActiveUserRow(user: user)),
            if (bundle.activeUsers.users.length > 3)
              _LoadMoreRow(
                isExpanded: controller.isExpanded(
                  'overview_users',
                  bundle.activeUsers.users.length,
                ),
                onTap: () => controller.toggleLoadMore(
                  'overview_users',
                  bundle.activeUsers.users.length,
                ),
              ),
          ],
        ],
      );
    });
  }
}

class _PeriodicReportScreen extends StatelessWidget {
  final HomeController controller;

  const _PeriodicReportScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.periodicReport.value;
      final summary = bundle.summary;
      final notifications = bundle.notifications.items;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            eyebrow: 'Báo cáo',
            title: 'Báo cáo định kỳ',
            badge: 'Kỳ 2',
            actionLabel: 'Làm mới',
            onAction: controller.fetchPeriodicReport,
          ),
          if (controller.isPeriodicReportLoading.value)
            const LinearProgressIndicator(),
          if (controller.periodicReportError.value != null)
            _InlineError(
              message: controller.periodicReportError.value!,
              onRetry: controller.fetchPeriodicReport,
            ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: summary.totalCurProcess.toString(),
                label: 'Công việc kỳ này',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: summary.totalCurDocument.toString(),
                label: 'Văn bản kỳ này',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: summary.totalCurBooking.toString(),
                label: 'Lịch họp kỳ này',
                tone: SmartTone.warning,
              ),
              SmartStatData(
                value: _formatPercent(summary.totalPercKpi),
                label: 'KPI hiện tại',
                tone: SmartTone.danger,
              ),
            ],
          ),
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SmartSectionHeader(title: 'So sánh với kỳ trước'),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'Công việc',
                  current: summary.totalCurProcess.toString(),
                  previous: summary.totalPrevProcess.toString(),
                  percent: summary.percentProcess,
                  tone: SmartTone.accent,
                ),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'Văn bản',
                  current: summary.totalCurDocument.toString(),
                  previous: summary.totalPrevDocument.toString(),
                  percent: summary.percentDocument,
                  tone: SmartTone.success,
                ),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'Lịch họp',
                  current: summary.totalCurBooking.toString(),
                  previous: summary.totalPrevBooking.toString(),
                  percent: summary.percentBooking,
                  tone: SmartTone.warning,
                ),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'KPI',
                  current: _formatPercent(summary.totalPercKpi),
                  previous: _formatPercent(summary.prevPercKpi),
                  percent: summary.totalPercKpi - summary.prevPercKpi,
                  tone: SmartTone.danger,
                  currentSuffix: '%',
                  previousSuffix: '%',
                ),
              ],
            ),
          ),
          SmartSectionHeader(
            title: 'Diễn biến trong kỳ',
            actionLabel: '${summary.items.length}',
          ),
          if (summary.items.isEmpty)
            const _EmptyState(
              title: 'Chưa có dữ liệu kỳ này',
              note: 'Dữ liệu báo cáo sẽ hiển thị khi API trả về danh sách.',
            )
          else
            ...summary.items
                .take(
                  controller.visibleCount('period_items', summary.items.length),
                )
                .map((item) => _PeriodItemCard(item: item)),
          if (summary.items.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'period_items',
                summary.items.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'period_items',
                summary.items.length,
              ),
            ),
          SmartSectionHeader(
            title: 'Xu hướng KPI',
            actionLabel: '${bundle.trends.length}',
          ),
          if (bundle.trends.isEmpty)
            const _EmptyState(
              title: 'Chưa có xu hướng',
              note: 'Biểu đồ xu hướng sẽ xuất hiện khi có dữ liệu trả về.',
            )
          else
            ...bundle.trends
                .take(
                  controller.visibleCount(
                    'period_trends',
                    bundle.trends.length,
                  ),
                )
                .map((point) => _PeriodTrendRow(point: point)),
          if (bundle.trends.length > 4)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'period_trends',
                bundle.trends.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'period_trends',
                bundle.trends.length,
              ),
            ),
          SmartSectionHeader(
            title: 'Thông báo gần đây',
            actionLabel: '${bundle.notifications.totals}',
          ),
          if (notifications.isEmpty)
            const _EmptyState(
              title: 'Chưa có thông báo',
              note: 'Hệ thống sẽ hiển thị thông báo khi có phát sinh mới.',
            )
          else
            ...notifications
                .take(
                  controller.visibleCount(
                    'period_notifications',
                    notifications.length,
                  ),
                )
                .map((item) => _NotificationCard(item: item)),
          if (notifications.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'period_notifications',
                notifications.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'period_notifications',
                notifications.length,
              ),
            ),
        ],
      );
    });
  }
}

class _MeetingScheduleScreen extends StatelessWidget {
  final HomeController controller;

  const _MeetingScheduleScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.meetingHub.value;
      final rooms = bundle.rooms.rooms;
      final users = bundle.activeUsers.users;
      final bookings = bundle.todayBookings.bookings;
      final roomNames = <int, String>{
        for (final room in rooms) room.roomBookingId: room.roomBookingName,
      };

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            eyebrow: 'Không giấy tờ',
            title: 'Họp không giấy tờ',
            badge: '${bundle.rooms.totals} phòng',
            actionLabel: 'Làm mới',
            onAction: controller.fetchMeetingHub,
          ),
          if (controller.isMeetingLoading.value)
            const LinearProgressIndicator(),
          if (controller.meetingError.value != null)
            _InlineError(
              message: controller.meetingError.value!,
              onRetry: controller.fetchMeetingHub,
            ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: bundle.rooms.totals.toString(),
                label: 'Phòng họp',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: bundle.activeUsers.totals.toString(),
                label: 'Người dùng hoạt động',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: bundle.todayBookings.totalBookingMonth.toString(),
                label: 'Cuộc họp trong tháng',
                tone: SmartTone.warning,
              ),
            ],
          ),
          SmartSectionHeader(
            title: 'Cuộc họp hôm nay',
            actionLabel: '${bookings.length}',
          ),
          if (bookings.isEmpty)
            const _EmptyState(
              title: 'Chưa có cuộc họp hôm nay',
              note: 'Danh sách sẽ hiển thị khi có lịch họp trong ngày.',
            )
          else
            ...bookings
                .take(
                  controller.visibleCount('meeting_bookings', bookings.length),
                )
                .map(
                  (booking) => _MeetingBookingCard(
                    booking: booking,
                    roomName:
                        roomNames[booking.roomBookingID] ??
                        'Phòng họp ${booking.roomBookingID}',
                  ),
                ),
          if (bookings.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'meeting_bookings',
                bookings.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'meeting_bookings',
                bookings.length,
              ),
            ),
          SmartSectionHeader(
            title: 'Phòng họp đang hoạt động',
            actionLabel: '${rooms.length}',
          ),
          if (rooms.isEmpty)
            const _EmptyState(
              title: 'Chưa có phòng họp',
              note: 'Dữ liệu phòng họp sẽ hiển thị khi API trả về danh sách.',
            )
          else
            ...rooms
                .take(controller.visibleCount('meeting_rooms', rooms.length))
                .map((room) => _MeetingRoomCard(item: room)),
          if (rooms.length > 4)
            _LoadMoreRow(
              isExpanded: controller.isExpanded('meeting_rooms', rooms.length),
              onTap: () =>
                  controller.toggleLoadMore('meeting_rooms', rooms.length),
            ),
          SmartSectionHeader(
            title: 'Người dùng hoạt động',
            actionLabel: '${users.length}',
          ),
          if (users.isEmpty)
            const _EmptyState(
              title: 'Chưa có người dùng hoạt động',
              note: 'Danh sách người dùng sẽ hiển thị khi API có dữ liệu.',
            )
          else
            ...users
                .take(controller.visibleCount('meeting_users', users.length))
                .map((user) => _ActiveUserRow(user: user)),
          if (users.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded('meeting_users', users.length),
              onTap: () =>
                  controller.toggleLoadMore('meeting_users', users.length),
            ),
        ],
      );
    });
  }
}

class _AppsScreen extends StatelessWidget {
  final HomeController controller;

  const _AppsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final groups = _appGroups.map((group) {
        final query = controller.appQuery.value.toLowerCase();
        final items = group.items.where((item) {
          return query.isEmpty ||
              '${item.title} ${item.subtitle} ${item.search}'
                  .toLowerCase()
                  .contains(query);
        }).toList();
        return _AppGroup(title: group.title, items: items);
      }).toList();
      final visibleCount = groups.fold<int>(
        0,
        (total, group) => total + group.items.length,
      );

      return _ScreenStack(
        children: [
          const SmartScreenHeader(
            eyebrow: 'Danh mục',
            title: 'Ứng dụng',
            badge: '15 app',
          ),
          SmartSearchPanel(
            controller: controller.appSearchController,
            hint: 'Tìm ứng dụng...',
            onChanged: (value) => controller.appQuery.value = value,
          ),
          if (visibleCount == 0)
            const _EmptyState(
              title: 'Không tìm thấy ứng dụng',
              note: 'Thử đổi từ khóa tìm kiếm.',
            )
          else
            ...groups
                .where((group) => group.items.isNotEmpty)
                .map(
                  (group) =>
                      _AppGroupSection(group: group, controller: controller),
                ),
        ],
      );
    });
  }
}

class _CrimeReportsScreen extends StatelessWidget {
  final HomeController controller;

  const _CrimeReportsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reports = _crimeReports
          .where(
            (item) => '${item.id} ${item.title} ${item.note}'
                .toLowerCase()
                .contains(controller.crimeQuery.value.toLowerCase()),
          )
          .toList();

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Tiếp nhận',
            title: 'Tố giác tội phạm',
            actionLabel: 'Thêm',
            onAction: () => controller.showView(AdminSmartView.crimeReportNew),
          ),
          const SmartStatGrid(
            stats: [
              SmartStatData(value: '10', label: 'Tổng đơn'),
              SmartStatData(
                value: '09',
                label: 'Tiếp nhận',
                tone: SmartTone.success,
              ),
              SmartStatData(value: '00', label: 'Đang điều tra'),
            ],
          ),
          SmartSearchPanel(
            controller: controller.crimeSearchController,
            hint: 'Tìm mã hồ sơ, tiêu đề, người nộp...',
            onChanged: (value) => controller.crimeQuery.value = value,
            chips: const ['Tất cả', 'Tiếp nhận', 'Cao'],
            activeChip: 'Tất cả',
          ),
          ...reports
              .take(controller.visibleCount('crime_reports', reports.length))
              .map((item) => _ReportCard(item: item)),
          if (reports.length > 3)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'crime_reports',
                reports.length,
              ),
              onTap: () =>
                  controller.toggleLoadMore('crime_reports', reports.length),
            ),
        ],
      );
    });
  }
}

class _CrimeReportNewScreen extends StatelessWidget {
  final HomeController controller;

  const _CrimeReportNewScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Tố giác',
          onBack: () => controller.showView(AdminSmartView.crimeReports),
          eyebrow: 'Hồ sơ mới',
          title: 'Thêm tố giác',
          badge: 'Bảo mật',
        ),
        SmartCard(
          radius: 22,
          child: Column(
            children: [
              Obx(
                () => SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Nộp đơn ẩn danh',
                    style: AppTextStyles.bodyMedium,
                  ),
                  subtitle: Text(
                    'Thông tin cá nhân sẽ được mã hóa',
                    style: AppTextStyles.caption,
                  ),
                  value: controller.anonymousReport.value,
                  activeThumbColor: SmartColors.accent,
                  onChanged: (value) =>
                      controller.anonymousReport.value = value,
                ),
              ),
              const _SmartTextField(
                label: 'Họ và tên *',
                initialValue: 'Nguyễn Văn A',
              ),
              const _SmartTextField(
                label: 'Số điện thoại',
                initialValue: '0901234567',
              ),
              const _SmartTextField(
                label: 'Tiêu đề tố giác *',
                hint: 'Mô tả ngắn gọn về hành vi vi phạm...',
              ),
              const _SmartTextField(
                label: 'Nội dung chi tiết *',
                hint:
                    'Mô tả chi tiết sự việc, thời gian, đối tượng liên quan...',
                maxLines: 4,
              ),
              const _SmartTextField(
                label: 'Địa điểm xảy ra',
                hint: 'Địa chỉ cụ thể...',
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SmartColors.soft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: SmartColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  'Bấm hoặc kéo thả tệp hình ảnh, bằng chứng tại đây',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SmartPrimaryButton(
                label: 'Hủy',
                secondary: true,
                onTap: () => controller.showView(AdminSmartView.crimeReports),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: SmartPrimaryButton(label: 'Phân tích & Nộp đơn'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AiAssistantScreen extends StatelessWidget {
  final HomeController controller;

  const _AiAssistantScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Ứng dụng',
          onBack: () => controller.showView(AdminSmartView.apps),
          eyebrow: 'Trợ lý thông minh',
          title: 'AI Hỗ trợ',
          badge: 'Đang hoạt động',
        ),
        SmartCard(
          radius: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: _LabelNote(
                      label: 'Hội thoại đang mở',
                      note: 'AI hỗ trợ điều hành',
                    ),
                  ),
                  SmartTextButton(
                    label: 'Cuộc mới',
                    onTap: controller.resetAiChat,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _AiMessage(
                icon: 'AI',
                text:
                    'Tôi đã sẵn sàng hỗ trợ phân tích dữ liệu điều hành, soạn báo cáo và đề xuất hướng xử lý.',
              ),
              const _AiMessage(
                icon: 'B',
                text: 'Tóm tắt các vấn đề cần ưu tiên hôm nay.',
                user: true,
              ),
              const _AiMessage(
                icon: 'AI',
                text:
                    'Có 3 nhóm cần xử lý: 08 KPI đang trễ, 12 nhiệm vụ cần nhắc và 03 biên bản họp chưa chốt đầu việc.',
              ),
              const _AiMessage(
                icon: 'B',
                text: 'Gợi ý bước tiếp theo ngắn gọn.',
                user: true,
              ),
              const _AiMessage(
                icon: 'AI',
                text:
                    'Nên gửi nhắc việc theo đơn vị phụ trách, ưu tiên nhóm quá hạn trên 3 ngày và yêu cầu phản hồi trước 16:00 hôm nay.',
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: _aiSuggestions
                    .map(
                      (suggestion) => ActionChip(
                        label: Text(suggestion.label),
                        onPressed: () =>
                            controller.useAiSuggestion(suggestion.prompt),
                        backgroundColor: suggestion == _aiSuggestions.first
                            ? SmartColors.accentSoft
                            : SmartColors.soft,
                        labelStyle: AppTextStyles.caption.copyWith(
                          color: suggestion == _aiSuggestions.first
                              ? SmartColors.accent
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w800,
                        ),
                        shape: const StadiumBorder(
                          side: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.aiPromptController,
                      minLines: 2,
                      maxLines: 4,
                      onChanged: (value) => controller.aiPrompt.value = value,
                      decoration: const InputDecoration(
                        hintText: 'Nhập câu hỏi hoặc yêu cầu...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: controller.sendAiPrompt,
                    icon: const Icon(Icons.north_east_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: SmartColors.accent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Text(
                  controller.aiDraft.value,
                  style: AppTextStyles.caption.copyWith(
                    color: SmartColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DigitalMapScreen extends StatelessWidget {
  final HomeController controller;

  const _DigitalMapScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.officeBundle.value;
      final page = bundle.officePage;
      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Địa bàn',
            title: 'Quản lý địa điểm',
            actionLabel: 'Làm mới',
            onAction: controller.fetchOffices,
          ),
          if (controller.isOfficeLoading.value) const LinearProgressIndicator(),
          if (controller.officeError.value != null)
            _InlineError(
              message: controller.officeError.value!,
              onRetry: controller.fetchOffices,
            ),
          SmartStatGrid(
            stats: [
              SmartStatData(
                value: page.totalAll.toString(),
                label: 'Tổng địa điểm',
              ),
              SmartStatData(
                value: page.totalActive.toString(),
                label: 'Hoạt động',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: page.inactiveCount.toString(),
                label: 'Ngưng hoạt động',
                tone: SmartTone.danger,
              ),
              const SmartStatData(value: '1/2', label: 'Trang'),
            ],
          ),
          SmartCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextField(
                  controller: controller.officeSearchController,
                  onSubmitted: controller.searchOffices,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm địa điểm...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _AgencyFilterChip(
                      label: 'Tất cả',
                      selected: controller.officeStatusFilter.value == -100,
                      onTap: () => controller.setOfficeStatusFilter(-100),
                    ),
                    const SizedBox(width: 8),
                    _AgencyFilterChip(
                      label: 'Hoạt động',
                      selected: controller.officeStatusFilter.value == 1,
                      onTap: () => controller.setOfficeStatusFilter(1),
                    ),
                    const SizedBox(width: 8),
                    _AgencyFilterChip(
                      label: 'Ngưng',
                      selected: controller.officeStatusFilter.value == 0,
                      onTap: () => controller.setOfficeStatusFilter(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SmartCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Danh sách địa điểm',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${page.totals} địa điểm',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (page.offices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: _EmptyState(
                      title: 'Chưa có địa điểm',
                      note: 'Thử đổi bộ lọc hoặc từ khóa tìm kiếm.',
                    ),
                  )
                else
                  ...List.generate(page.offices.length, (index) {
                    return _OfficeRow(
                      office: page.offices[index],
                      showDivider: index < page.offices.length - 1,
                    );
                  }),
              ],
            ),
          ),
          if (bundle.notifications.items.isNotEmpty) ...[
            SmartSectionHeader(
              title: 'Thông báo gần đây',
              actionLabel: '${bundle.notifications.totals}',
            ),
            ...bundle.notifications.items
                .take(3)
                .map((item) => _NotificationCard(item: item)),
          ],
        ],
      );
    });
  }
}

class _OfficeRow extends StatelessWidget {
  final OfficeItem office;
  final bool showDivider;

  const _OfficeRow({required this.office, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: SmartColors.border))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SmartColors.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.location_city_rounded,
              size: 18,
              color: SmartColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  office.officeName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  office.officeAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(height: 1.25),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    SmartPill(
                      label: office.typeOfficeName,
                      tone: SmartTone.neutral,
                    ),
                    SmartPill(
                      label: office.villageName,
                      tone: SmartTone.neutral,
                    ),
                    SmartPill(label: office.cityName, tone: SmartTone.neutral),
                  ],
                ),
                if (office.officeDescription.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    office.officeDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SmartPill(
                label: office.displayStatus,
                tone: office.isActive ? SmartTone.success : SmartTone.danger,
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiProgramsScreen extends StatelessWidget {
  final HomeController controller;

  const _KpiProgramsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.kpiBundle.value;
      final items = _filteredKpiItems(
        bundle.viewItems,
        controller.kpiQuery.value,
        controller.kpiStatusFilter.value,
      );

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Nghiệp vụ',
            title: 'Chương trình & KPI',
            actionLabel: 'Làm mới',
            onAction: controller.fetchKpiPrograms,
          ),
          if (controller.isKpiLoading.value) const LinearProgressIndicator(),
          if (controller.kpiError.value != null)
            _InlineError(
              message: controller.kpiError.value!,
              onRetry: controller.fetchKpiPrograms,
            ),
          SmartStatGrid(
            stats: [
              SmartStatData(
                value: bundle.totalPrograms.toString(),
                label: 'Tổng chương trình',
              ),
              SmartStatData(
                value: bundle.totalOnTrack.toString(),
                label: 'Đúng tiến độ',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: bundle.totalCompleted.toString(),
                label: 'Hoàn thành',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: bundle.totalDelayed.toString(),
                label: 'Chậm tiến độ',
                tone: SmartTone.danger,
              ),
            ],
          ),
          _KpiChartCard(points: bundle.chart),
          SmartCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextField(
                  controller: controller.kpiSearchController,
                  onChanged: controller.searchKpis,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm chương trình...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 9),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _KpiFilterChip(
                        label: 'Tất cả',
                        selected: controller.kpiStatusFilter.value == -100,
                        onTap: () => controller.setKpiStatusFilter(-100),
                      ),
                      _KpiFilterChip(
                        label: 'Đúng tiến độ',
                        selected: controller.kpiStatusFilter.value == 1,
                        onTap: () => controller.setKpiStatusFilter(1),
                      ),
                      _KpiFilterChip(
                        label: 'Có rủi ro',
                        selected: controller.kpiStatusFilter.value == 2,
                        onTap: () => controller.setKpiStatusFilter(2),
                      ),
                      _KpiFilterChip(
                        label: 'Hoàn thành',
                        selected: controller.kpiStatusFilter.value == 3,
                        onTap: () => controller.setKpiStatusFilter(3),
                      ),
                      _KpiFilterChip(
                        label: 'Chậm tiến độ',
                        selected: controller.kpiStatusFilter.value == 4,
                        onTap: () => controller.setKpiStatusFilter(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SmartCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Danh sách chương trình',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SmartPill(
                        label: '${items.length} chương trình',
                        tone: SmartTone.neutral,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: _EmptyState(
                      title: 'Chưa có chương trình',
                      note: 'Dữ liệu sẽ hiển thị khi API trả về danh sách KPI.',
                    ),
                  )
                else
                  ...List.generate(items.length, (index) {
                    return _KpiProgramRow(
                      item: items[index],
                      showDivider: index < items.length - 1,
                    );
                  }),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class KpiProgramsMockScreen extends StatelessWidget {
  final HomeController controller;

  const KpiProgramsMockScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Ứng dụng',
          onBack: () => controller.showView(AdminSmartView.apps),
          eyebrow: 'Điều hành',
          title: 'Chương trình & KPI',
          actionLabel: 'Thêm',
        ),
        const SmartStatGrid(
          stats: [
            SmartStatData(value: '06', label: 'Tổng chương trình'),
            SmartStatData(
              value: '03',
              label: 'Đúng tiến độ',
              tone: SmartTone.success,
            ),
            SmartStatData(value: '01', label: 'Chậm', tone: SmartTone.danger),
          ],
        ),
        SmartCard(
          radius: 22,
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(
                    child: _LabelNote(
                      label: 'KPI theo tháng',
                      note: 'Tiến độ hoàn thành chương trình trọng tâm',
                    ),
                  ),
                  SmartPill(label: '68%', tone: SmartTone.success),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 118,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    _Bar(label: 'T4', value: 0.48),
                    _Bar(label: 'T5', value: 0.64),
                    _Bar(label: 'T6', value: 0.82),
                    _Bar(label: 'T7', value: 0.70),
                  ],
                ),
              ),
            ],
          ),
        ),
        SmartSearchPanel(
          controller: controller.kpiSearchController,
          hint: 'Tìm chương trình, chủ trì...',
          onChanged: (value) => controller.kpiQuery.value = value,
        ),
        const _ProgramRow(
          title: 'Chuyển đổi số cấp xã',
          note: 'UBND xã · Hạn 30/07/2026',
          progress: '80%',
          status: 'Đúng tiến độ',
        ),
        const _ProgramRow(
          title: 'Cải cách thủ tục hành chính',
          note: 'Văn phòng HĐND · Hạn 15/08/2026',
          progress: '55%',
          status: 'Cần nhắc',
        ),
        const _ProgramRow(
          title: 'Rà soát an ninh trật tự',
          note: 'Công an xã · Quá hạn 2 ngày',
          progress: '42%',
          status: 'Chậm',
          danger: true,
        ),
      ],
    );
  }
}

class _KpiChartCard extends StatelessWidget {
  final List<KpiMonthlyPoint> points;

  const _KpiChartCard({required this.points});

  @override
  Widget build(BuildContext context) {
    final maxValue = points
        .map((point) => point.maxValue)
        .fold<int>(1, (max, value) => value > max ? value : max);

    return SmartCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LabelNote(
            label: 'Tiến độ theo tháng',
            note: 'Phân bổ trạng thái chương trình 6 tháng gần nhất',
          ),
          const SizedBox(height: 14),
          if (points.isEmpty)
            const _EmptyState(
              title: 'Chưa có dữ liệu biểu đồ',
              note: 'API biểu đồ chưa trả về dữ liệu.',
            )
          else
            SizedBox(
              height: 164,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: points
                    .map((point) => _KpiMonthBars(point: point, max: maxValue))
                    .toList(),
              ),
            ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _KpiLegend(color: SmartColors.accent, label: 'Hoàn thành'),
              _KpiLegend(color: SmartColors.success, label: 'Đúng tiến độ'),
              _KpiLegend(color: SmartColors.warning, label: 'Có rủi ro'),
              _KpiLegend(color: SmartColors.danger, label: 'Chậm tiến độ'),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiMonthBars extends StatelessWidget {
  final KpiMonthlyPoint point;
  final int max;

  const _KpiMonthBars({required this.point, required this.max});

  @override
  Widget build(BuildContext context) {
    final values = [
      (point.completed, SmartColors.accent),
      (point.onTrack, SmartColors.success),
      (point.atRisk, SmartColors.warning),
      (point.delayed, SmartColors.danger),
    ];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: values.map((entry) {
                  final height = entry.$1 == 0 ? 0.04 : entry.$1 / max;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: FractionallySizedBox(
                      heightFactor: height.clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 8,
                        decoration: BoxDecoration(
                          color: entry.$2,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              point.month,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _KpiLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
      ],
    );
  }
}

class _KpiProgramRow extends StatelessWidget {
  final KpiProgramViewItem item;
  final bool showDivider;

  const _KpiProgramRow({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final program = item.program;
    final tone = _kpiStatusTone(program.statusId);
    final ownerName = item.owner?.fullName.trim().isNotEmpty == true
        ? item.owner!.fullName
        : program.ownerName;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmartIconBadge(label: _initials(ownerName), size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.kpiName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.scopeLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SmartPill(label: ownerName, tone: SmartTone.neutral),
                        SmartPill(
                          label: program.executionLabel,
                          tone: SmartTone.neutral,
                        ),
                        SmartPill(
                          label: _formatDateLabel(program.dateExpired),
                          tone: SmartTone.neutral,
                        ),
                        SmartPill(label: item.processSummary),
                        if (item.processLate > 0)
                          SmartPill(
                            label: '${item.processLate} trễ',
                            tone: SmartTone.danger,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SmartProgressBar(
                            value: program.progressPercent / 100,
                            tone: tone,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_formatPercent(program.progressPercent)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SmartPill(label: program.statusName, tone: tone),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _KpiFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _KpiFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        visualDensity: VisualDensity.compact,
        labelStyle: AppTextStyles.caption.copyWith(
          color: selected ? SmartColors.accent : AppColors.textSecondary,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: SmartColors.soft,
        selectedColor: SmartColors.accentSoft,
        shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
      ),
    );
  }
}

class _AgenciesScreen extends StatelessWidget {
  final HomeController controller;

  const _AgenciesScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.agencyBundle.value;
      final page = bundle.agencyPage;
      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Địa bàn',
            title: 'Cơ quan / Sở ban ngành',
            actionLabel: 'Làm mới',
            onAction: controller.fetchAgencies,
          ),
          if (controller.isAgencyLoading.value) const LinearProgressIndicator(),
          if (controller.agencyError.value != null)
            _InlineError(
              message: controller.agencyError.value!,
              onRetry: controller.fetchAgencies,
            ),
          SmartStatGrid(
            stats: [
              SmartStatData(value: page.totalAll.toString(), label: 'Tổng số'),
              SmartStatData(
                value: page.totalActive.toString(),
                label: 'Hoạt động',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: page.inactiveCount.toString(),
                label: 'Ngưng hoạt động',
                tone: SmartTone.danger,
              ),
              SmartStatData(value: '1/1', label: 'Trang'),
            ],
          ),
          SmartCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextField(
                  controller: controller.agencySearchController,
                  onSubmitted: controller.searchAgencies,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm sở ban ngành...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _AgencyFilterChip(
                      label: 'Tất cả',
                      selected: controller.agencyStatusFilter.value == -100,
                      onTap: () => controller.setAgencyStatusFilter(-100),
                    ),
                    const SizedBox(width: 8),
                    _AgencyFilterChip(
                      label: 'Hoạt động',
                      selected: controller.agencyStatusFilter.value == 1,
                      onTap: () => controller.setAgencyStatusFilter(1),
                    ),
                    const SizedBox(width: 8),
                    _AgencyFilterChip(
                      label: 'Ngưng',
                      selected: controller.agencyStatusFilter.value == 0,
                      onTap: () => controller.setAgencyStatusFilter(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SmartCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Danh sách sở ban ngành',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${page.totals} sở ban ngành',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (page.agencies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: _EmptyState(
                      title: 'Chưa có sở ban ngành',
                      note: 'Thử đổi bộ lọc hoặc từ khóa tìm kiếm.',
                    ),
                  )
                else
                  ...List.generate(page.agencies.length, (index) {
                    return _AgencyRow(
                      agency: page.agencies[index],
                      showDivider: index < page.agencies.length - 1,
                    );
                  }),
              ],
            ),
          ),
          if (bundle.notifications.items.isNotEmpty) ...[
            SmartSectionHeader(
              title: 'Thông báo gần đây',
              actionLabel: '${bundle.notifications.totals}',
            ),
            ...bundle.notifications.items
                .take(3)
                .map((item) => _NotificationCard(item: item)),
          ],
        ],
      );
    });
  }
}

class _AgencyFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AgencyFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? SmartColors.accent : SmartColors.soft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _AgencyRow extends StatelessWidget {
  final AgencyItem agency;
  final bool showDivider;

  const _AgencyRow({required this.agency, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: SmartColors.border))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SmartColors.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              size: 18,
              color: SmartColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LabelNote(
              label: agency.agencyName,
              note: agency.description.isNotEmpty
                  ? agency.description
                  : 'Chưa có mô tả',
              large: true,
            ),
          ),
          const SizedBox(width: 10),
          SmartPill(
            label: agency.displayStatus,
            tone: agency.isActive ? SmartTone.success : SmartTone.danger,
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.edit_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _UrgentAlertsScreen extends StatelessWidget {
  final HomeController controller;

  const _UrgentAlertsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final notices = _notices.where((item) {
        final query = controller.urgentQuery.value.toLowerCase();
        final filter = controller.urgentFilter.value;
        final queryMatch = '${item.title} ${item.note}'.toLowerCase().contains(
          query,
        );
        final filterMatch =
            filter == 'all' ||
            (filter == 'urgent' && item.urgent) ||
            (filter == 'unread' && item.unread);
        return queryMatch && filterMatch;
      }).toList();

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Khẩn cấp',
            title: 'Thông báo khẩn',
            actionLabel: 'Tạo khẩn',
          ),
          const SmartStatGrid(
            stats: [
              SmartStatData(value: '16', label: 'Đã gửi'),
              SmartStatData(
                value: '17',
                label: 'Đã đọc',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: '45',
                label: 'Chưa đọc',
                tone: SmartTone.danger,
              ),
            ],
          ),
          SmartSearchPanel(
            controller: controller.urgentSearchController,
            hint: 'Tìm nội dung, người gửi...',
            onChanged: (value) => controller.urgentQuery.value = value,
            chips: const ['all', 'urgent', 'unread'],
            activeChip: controller.urgentFilter.value,
            chipLabelBuilder: _urgentFilterLabel,
            onChipSelected: (value) => controller.urgentFilter.value = value,
          ),
          ...notices
              .take(controller.visibleCount('urgent_alerts', notices.length))
              .map((item) => _NoticeCard(item: item)),
          if (notices.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'urgent_alerts',
                notices.length,
              ),
              onTap: () =>
                  controller.toggleLoadMore('urgent_alerts', notices.length),
            ),
        ],
      );
    });
  }
}

class _TasksScreen extends StatelessWidget {
  final HomeController controller;

  const _TasksScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tasks = _tasks.where((item) {
        final query = controller.taskQuery.value.toLowerCase();
        final status = controller.taskStatus.value;
        final queryMatch = '${item.title} ${item.subtitle} ${item.owner}'
            .toLowerCase()
            .contains(query);
        final statusMatch = status == 'all' || item.statusKey == status;
        return queryMatch && statusMatch;
      }).toList();

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            eyebrow: 'Nghiệp vụ',
            title: 'Giao việc',
            actionLabel: 'Tạo mới',
            onAction: controller.openProcessCreate,
          ),
          if (controller.processCreateMessage.value != null)
            _InlineSuccess(message: controller.processCreateMessage.value!),
          const SmartStatGrid(
            stats: [
              SmartStatData(value: '29', label: 'Tổng nhiệm vụ'),
              SmartStatData(
                value: '24',
                label: 'Quá hạn',
                tone: SmartTone.danger,
              ),
              SmartStatData(
                value: '3',
                label: 'Đã ký',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartSearchPanel(
            controller: controller.taskSearchController,
            hint: 'Tìm nhiệm vụ...',
            onChanged: (value) => controller.taskQuery.value = value,
            chips: const ['all', 'overdue', 'doing', 'complete'],
            activeChip: controller.taskStatus.value,
            chipLabelBuilder: _taskStatusLabel,
            onChipSelected: (value) => controller.taskStatus.value = value,
          ),
          if (tasks.isEmpty)
            const _EmptyState(
              title: 'Không tìm thấy nhiệm vụ',
              note: 'Thử đổi trạng thái hoặc từ khóa.',
            )
          else
            ...tasks
                .take(controller.visibleCount('tasks', tasks.length))
                .map(
                  (task) => _TaskCard(
                    title: task.title,
                    subtitle: task.subtitle,
                    status: task.status,
                    progress: task.progress,
                    complete: task.statusKey == 'complete',
                    tags: task.tags,
                    owner: task.owner,
                    due: task.due,
                    avatar: task.avatar,
                  ),
                ),
          if (tasks.length > 3)
            _LoadMoreRow(
              isExpanded: controller.isExpanded('tasks', tasks.length),
              onTap: () => controller.toggleLoadMore('tasks', tasks.length),
            ),
        ],
      );
    });
  }
}

class _ProcessCreateScreen extends StatelessWidget {
  final HomeController controller;

  const _ProcessCreateScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dropdowns = controller.processDropdowns.value;
      final source = controller.selectedProcessSourceType.value;
      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Giao việc',
            onBack: () => controller.showView(AdminSmartView.tasks),
            eyebrow: 'Nghiệp vụ',
            title: 'Tạo giao việc',
          ),
          if (controller.isProcessDropdownLoading.value)
            const LinearProgressIndicator(),
          if (controller.processFormError.value != null)
            _InlineError(
              message: controller.processFormError.value!,
              onRetry: controller.fetchProcessDropdowns,
            ),
          SmartCard(
            radius: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FormTextField(
                  label: 'Tiêu đề *',
                  controller: controller.processTitleController,
                  hint: 'Nhập tiêu đề giao việc',
                ),
                const SizedBox(height: 12),
                _FormTextField(
                  label: 'Mô tả',
                  controller: controller.processDescriptionController,
                  hint: 'Nội dung chi tiết cần xử lý',
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                _FormDropdown<ProcessUserOption>(
                  label: 'Người xử lý *',
                  value: controller.selectedProcessUser.value,
                  items: dropdowns.users,
                  emptyText: 'Không có cán bộ hoạt động',
                  itemLabel: (item) =>
                      '${item.displayName} · ${item.departmentName}',
                  onChanged: (value) =>
                      controller.selectedProcessUser.value = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FormDropdown<ProcessLevelOption>(
                        label: 'Mức độ *',
                        value: controller.selectedProcessLevel.value,
                        items: ProcessLevelOption.all,
                        itemLabel: (item) => item.name,
                        onChanged: (value) =>
                            controller.selectedProcessLevel.value = value,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _DueDateField(controller: controller)),
                  ],
                ),
                const SizedBox(height: 12),
                _FormDropdown<ProcessSourceTypeOption>(
                  label: 'Nguồn giao việc *',
                  value: source,
                  items: ProcessSourceTypeOption.all,
                  itemLabel: (item) => item.name,
                  onChanged: (value) {
                    controller.selectedProcessSourceType.value = value;
                    if (value == ProcessSourceTypeOption.kpi &&
                        controller.selectedProcessKpi.value == null &&
                        dropdowns.kpis.isNotEmpty) {
                      controller.selectedProcessKpi.value =
                          dropdowns.kpis.first;
                    }
                    if (value == ProcessSourceTypeOption.document &&
                        controller.selectedProcessDocument.value == null &&
                        dropdowns.documents.isNotEmpty) {
                      controller.selectedProcessDocument.value =
                          dropdowns.documents.first;
                    }
                  },
                ),
                const SizedBox(height: 12),
                _ProcessSourceFields(controller: controller),
                const SizedBox(height: 12),
                _FormTextField(
                  label: 'File đính kèm',
                  controller: controller.processAttachmentController,
                  hint:
                      'Nhập đường dẫn file, mỗi dòng một file. Ví dụ: images\\FileUpload\\file.png',
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SmartPrimaryButton(
                  label: 'Hủy',
                  secondary: true,
                  onTap: () => controller.showView(AdminSmartView.tasks),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SmartPrimaryButton(
                  label: controller.isProcessCreating.value
                      ? 'Đang tạo...'
                      : 'Tạo giao việc',
                  onTap: controller.isProcessCreating.value
                      ? null
                      : controller.createProcess,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ProcessSourceFields extends StatelessWidget {
  final HomeController controller;

  const _ProcessSourceFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    final dropdowns = controller.processDropdowns.value;
    final source = controller.selectedProcessSourceType.value;

    if (source == ProcessSourceTypeOption.document) {
      return _FormDropdown<ProcessDocumentOption>(
        label: 'Văn bản liên quan *',
        value: controller.selectedProcessDocument.value,
        items: dropdowns.documents,
        emptyText: 'Chưa có văn bản từ API document/get-list',
        itemLabel: (item) => '${item.title} · ${item.codeReference}',
        onChanged: (value) => controller.selectedProcessDocument.value = value,
      );
    }

    if (source == ProcessSourceTypeOption.kpi) {
      return _FormDropdown<ProcessKpiOption>(
        label: 'KPI liên quan *',
        value: controller.selectedProcessKpi.value,
        items: dropdowns.kpis,
        emptyText: 'Không có KPI',
        itemLabel: (item) => '${item.kpiName} · ${item.departmentName}',
        onChanged: (value) => controller.selectedProcessKpi.value = value,
      );
    }

    final booking = controller.selectedProcessBooking.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormDropdown<ProcessBookingOption>(
          label: 'Cuộc họp *',
          value: booking,
          items: dropdowns.bookings,
          emptyText: 'Không có cuộc họp',
          itemLabel: (item) =>
              '${item.title} · ${_formatDateLabel(item.dateStart)}',
          onChanged: controller.selectProcessBooking,
        ),
        const SizedBox(height: 12),
        _FormDropdown<ProcessConclusionOption>(
          label: 'Kết luận',
          value: controller.selectedProcessConclusion.value,
          items: booking?.conclusions ?? const [],
          emptyText: 'Cuộc họp này chưa có kết luận, sẽ gửi ConclusionID = 0',
          itemLabel: (item) => '${item.codeReference} · ${item.title}',
          onChanged: (value) =>
              controller.selectedProcessConclusion.value = value,
        ),
      ],
    );
  }
}

class _DueDateField extends StatelessWidget {
  final HomeController controller;

  const _DueDateField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final date = controller.selectedProcessDueDate.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hạn xử lý *',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime(2035),
            );
            if (picked != null) {
              controller.selectedProcessDueDate.value = picked;
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
            ),
            child: Text(
              _formatDateLabel(date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final String emptyText;

  const _FormDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.emptyText = 'Không có dữ liệu',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = items.contains(value) ? value : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        if (items.isEmpty)
          InputDecorator(
            decoration: const InputDecoration(),
            child: Text(
              emptyText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          DropdownButtonFormField<T>(
            initialValue: effectiveValue,
            isExpanded: true,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
      ],
    );
  }
}

class _FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _FormTextField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _AccountScreen extends StatelessWidget {
  final HomeController controller;

  const _AccountScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        const SmartScreenHeader(
          eyebrow: 'Cá nhân',
          title: 'Tài khoản',
          actionLabel: 'Đăng xuất',
        ),
        SmartCard(
          radius: 22,
          borderColor: SmartColors.accent.withValues(alpha: 0.18),
          child: Column(
            children: [
              Row(
                children: [
                  const SmartIconBadge(label: 'AD', size: 42),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _LabelNote(
                      label: 'Administrator',
                      note: 'Chủ tịch UBND · Phường 5, Quận 8',
                    ),
                  ),
                  const SmartPill(label: 'Đang trực'),
                ],
              ),
              const SizedBox(height: 11),
              const Row(
                children: [
                  Expanded(
                    child: _MetaTile(
                      title: 'Đơn vị',
                      value: 'Công an phường/xã',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _MetaTile(
                      title: 'Vai trò',
                      value: 'Quản trị hệ thống',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              const SmartStatGrid(
                compact: true,
                stats: [
                  SmartStatData(value: '7', label: 'Việc chờ xử lý'),
                  SmartStatData(value: '4', label: 'Công văn mới'),
                  SmartStatData(value: '2', label: 'Thông báo khẩn'),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: const [
            _QuickAction(label: 'Cập nhật hồ sơ', icon: Icons.badge_outlined),
            _QuickAction(label: 'Đổi mật khẩu', icon: Icons.lock_reset_rounded),
            _QuickAction(
              label: 'Ủy quyền xử lý',
              icon: Icons.how_to_reg_outlined,
            ),
          ],
        ),
        SmartCard(
          child: Column(
            children: const [
              SmartSectionHeader(
                title: 'Quyền truy cập',
                actionLabel: 'Chi tiết',
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: _MetaTile(title: '18', value: 'Phân hệ được cấp'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _MetaTile(title: '5', value: 'Nhóm nghiệp vụ'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _MetaTile(title: 'UBND', value: 'Phạm vi dữ liệu'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SmartCard(
          child: Column(
            children: [
              SmartSectionHeader(
                title: 'Phiên đăng nhập',
                actionLabel: 'Tin cậy',
              ),
              SizedBox(height: 9),
              _CompactRow(
                title: 'Thiết bị hiện tại',
                note: 'Mobile app · Cập nhật 20:48 hôm nay',
                leading: SmartIconBadge(
                  label: 'IP',
                  tone: SmartTone.success,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        _SettingRow(
          label: 'Thông tin cá nhân',
          note: 'Số điện thoại, email công vụ, chức danh',
          state: 'Đủ',
          stateTone: SmartTone.success,
          onTap: () => controller.showView(AdminSmartView.accountProfileDetail),
        ),
        _SettingRow(
          label: 'Thông báo',
          note: 'Cảnh báo quá hạn, công văn, lịch họp',
          state: '2 mới',
          stateTone: SmartTone.warning,
          onTap: () =>
              controller.showView(AdminSmartView.accountNotificationDetail),
        ),
        _SettingRow(
          label: 'Bảo mật',
          note: 'Mật khẩu, xác thực, phiên đăng nhập',
          state: '2FA',
          stateTone: SmartTone.success,
          onTap: () =>
              controller.showView(AdminSmartView.accountSecurityDetail),
        ),
        _SettingRow(
          label: 'Đồng bộ dữ liệu',
          note: 'Dữ liệu nội bộ đã đồng bộ đầy đủ',
          state: '20:48',
          stateTone: SmartTone.success,
          onTap: () => controller.showView(AdminSmartView.accountSyncDetail),
        ),
      ],
    );
  }
}

class _AccountDetailScreen extends StatelessWidget {
  final HomeController controller;
  final String title;
  final String state;
  final SmartTone stateTone;
  final List<Widget> rows;
  final List<Widget> extra;
  final String? secondaryAction;
  final String? primaryAction;

  const _AccountDetailScreen({
    required this.controller,
    required this.title,
    required this.state,
    required this.stateTone,
    required this.rows,
    this.extra = const [],
    this.secondaryAction,
    this.primaryAction,
  });

  factory _AccountDetailScreen.profile({required HomeController controller}) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Thông tin cá nhân',
      state: 'Đủ',
      stateTone: SmartTone.success,
      rows: const [
        _DetailValueRow(
          label: 'Họ tên',
          note: 'Tên hiển thị trong hệ thống',
          value: 'Administrator',
        ),
        _DetailValueRow(
          label: 'Chức danh',
          note: 'Vai trò hành chính hiện tại',
          value: 'Chủ tịch UBND',
        ),
        _DetailValueRow(
          label: 'Đơn vị',
          note: 'Phạm vi công tác',
          value: 'Phường 5, Quận 8',
        ),
        _DetailValueRow(
          label: 'Email công vụ',
          note: 'Dùng nhận thông báo hệ thống',
          value: 'admin@ubnd.vn',
        ),
        _DetailValueRow(
          label: 'Số điện thoại',
          note: 'Xác thực và liên hệ khẩn',
          value: '0900 000 000',
        ),
      ],
      secondaryAction: 'Hủy',
      primaryAction: 'Cập nhật',
    );
  }

  factory _AccountDetailScreen.notifications({
    required HomeController controller,
  }) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Thông báo',
      state: '2 mới',
      stateTone: SmartTone.warning,
      rows: const [
        _DetailSwitchRow(
          label: 'Cảnh báo quá hạn',
          note: 'Nhiệm vụ sắp hoặc đã quá hạn',
          enabled: true,
        ),
        _DetailSwitchRow(
          label: 'Công văn mới',
          note: 'Văn bản cần xử lý hoặc theo dõi',
          enabled: true,
        ),
        _DetailSwitchRow(
          label: 'Lịch họp',
          note: 'Nhắc trước giờ họp và tài liệu',
          enabled: true,
        ),
        _DetailSwitchRow(
          label: 'Thông báo yên lặng',
          note: '22:00 đến 06:00 hôm sau',
        ),
      ],
      extra: const [
        _SettingRow(
          label: '24 nhiệm vụ đã leo thang',
          note: 'Đã gửi cảnh báo lên cấp trên',
          state: 'Mới',
          stateTone: SmartTone.warning,
        ),
        _SettingRow(
          label: '4 công văn mới',
          note: 'Chờ phân công xử lý',
          state: 'Hôm nay',
        ),
      ],
    );
  }

  factory _AccountDetailScreen.security({required HomeController controller}) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Bảo mật',
      state: '2FA',
      stateTone: SmartTone.success,
      rows: const [
        _DetailSwitchRow(
          label: 'Xác thực 2 lớp',
          note: 'Yêu cầu mã xác thực khi đăng nhập',
          enabled: true,
        ),
        _DetailValueRow(
          label: 'Đổi mật khẩu',
          note: 'Lần đổi gần nhất 12/06/2026',
          value: '›',
        ),
        _DetailValueRow(
          label: 'Thiết bị tin cậy',
          note: 'Mobile app đang sử dụng',
          value: '1',
        ),
        _DetailSwitchRow(
          label: 'Tự khóa phiên',
          note: 'Sau 15 phút không hoạt động',
          enabled: true,
        ),
      ],
      secondaryAction: 'Đăng xuất thiết bị khác',
      primaryAction: 'Lưu',
    );
  }

  factory _AccountDetailScreen.sync({required HomeController controller}) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Đồng bộ dữ liệu',
      state: '20:48',
      stateTone: SmartTone.success,
      rows: const [
        _DetailValueRow(
          label: 'Trạng thái',
          note: 'Dữ liệu nội bộ đã đồng bộ đầy đủ',
          value: 'Hoàn tất',
        ),
        _DetailValueRow(
          label: 'Nhiệm vụ',
          note: 'Danh sách giao việc và kết luận',
          value: '29',
        ),
        _DetailValueRow(
          label: 'Văn bản',
          note: 'Công văn và thông báo liên quan',
          value: '4',
        ),
        _DetailSwitchRow(
          label: 'Tự đồng bộ',
          note: 'Khi có kết nối mạng ổn định',
          enabled: true,
        ),
      ],
      secondaryAction: 'Xem lịch sử',
      primaryAction: 'Đồng bộ ngay',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Tài khoản',
          onBack: () => controller.showView(AdminSmartView.account),
          title: title,
          badge: state,
        ),
        SmartCard(radius: 22, child: Column(children: rows)),
        ...extra,
        if (secondaryAction != null || primaryAction != null)
          Row(
            children: [
              if (secondaryAction != null)
                Expanded(
                  child: SmartPrimaryButton(
                    label: secondaryAction!,
                    secondary: true,
                  ),
                ),
              if (secondaryAction != null && primaryAction != null)
                const SizedBox(width: 8),
              if (primaryAction != null)
                Expanded(child: SmartPrimaryButton(label: primaryAction!)),
            ],
          ),
      ],
    );
  }
}

class _ScreenStack extends StatelessWidget {
  final List<Widget> children;

  const _ScreenStack({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _withGaps(children),
    );
  }
}

List<Widget> _withGaps(List<Widget> children) {
  final result = <Widget>[];
  for (var index = 0; index < children.length; index++) {
    if (index > 0) {
      result.add(const SizedBox(height: 10));
    }
    result.add(children[index]);
  }
  return result;
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String suffix;
  final String label;
  final String note;
  final SmartTone tone;

  const _MetricCard({
    required this.value,
    required this.suffix,
    required this.label,
    required this.note,
    this.tone = SmartTone.accent,
  });

  @override
  Widget build(BuildContext context) {
    final danger = tone == SmartTone.danger;
    return SmartCard(
      radius: 22,
      color: danger ? SmartColors.dangerSoft : SmartColors.cardSurface,
      borderColor: danger
          ? SmartColors.danger.withValues(alpha: 0.22)
          : SmartColors.border,
      child: SizedBox(
        height: 72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyles.h1.copyWith(
                    color: danger ? SmartColors.danger : SmartColors.accent,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    suffix,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            _LabelNote(label: label, note: note),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _QuickAction({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SmartCard(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: SmartColors.accentSoft,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 18, color: SmartColors.accent),
                ),
                const SizedBox(height: 7),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final double progress;
  final bool complete;
  final SmartTone? statusTone;
  final List<String> tags;
  final String? owner;
  final String? due;
  final String? avatar;

  const _TaskCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.progress,
    this.complete = false,
    this.statusTone,
    this.tags = const [],
    this.owner,
    this.due,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LabelNote(label: title, note: subtitle, large: true),
              ),
              const SizedBox(width: 8),
              SmartPill(
                label: status,
                tone:
                    statusTone ??
                    (complete ? SmartTone.success : SmartTone.danger),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 9),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map(
                    (tag) => SmartPill(
                      label: tag,
                      tone: tag.contains('%')
                          ? SmartTone.accent
                          : SmartTone.neutral,
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 9),
          SmartProgressBar(
            value: progress,
            tone:
                statusTone ?? (complete ? SmartTone.success : SmartTone.danger),
          ),
          if (owner != null && due != null && avatar != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                SmartIconBadge(label: avatar!, size: 30),
                const SizedBox(width: 8),
                Expanded(
                  child: _LabelNote(label: owner!, note: 'Hạn $due'),
                ),
                Text(
                  due!.split('/').take(2).join('/'),
                  style: AppTextStyles.caption.copyWith(
                    color: complete ? SmartColors.success : SmartColors.danger,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AppGroupSection extends StatelessWidget {
  final _AppGroup group;
  final HomeController controller;

  const _AppGroupSection({required this.group, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            group.title.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        SmartCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(group.items.length, (index) {
              final item = group.items[index];
              return _AppListRow(
                item: item,
                showDivider: index < group.items.length - 1,
                onTap: item.view == null
                    ? null
                    : () => controller.showView(item.view!),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AppListRow extends StatelessWidget {
  final _AppItem item;
  final bool showDivider;
  final VoidCallback? onTap;

  const _AppListRow({
    required this.item,
    required this.showDivider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: SmartColors.border))
              : null,
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 22, color: SmartColors.accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (item.count != null) ...[
              const SizedBox(width: 8),
              SmartPill(label: item.count!, tone: SmartTone.danger),
            ],
            if (onTap != null) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final _ReportItem item;

  const _ReportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.id,
                style: AppTextStyles.caption.copyWith(
                  color: SmartColors.accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              SmartPill(
                label: item.severity,
                tone: item.severity == 'Cao'
                    ? SmartTone.danger
                    : SmartTone.neutral,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _LabelNote(label: item.title, note: item.note, large: true),
          const SizedBox(height: 10),
          Row(
            children: [
              SmartPill(
                label: item.status,
                tone: item.status == 'Tiếp nhận'
                    ? SmartTone.success
                    : SmartTone.neutral,
              ),
              const Spacer(),
              Text(item.date, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodCompareRow extends StatelessWidget {
  final String title;
  final String current;
  final String previous;
  final double percent;
  final SmartTone tone;
  final String currentSuffix;
  final String previousSuffix;

  const _PeriodCompareRow({
    required this.title,
    required this.current,
    required this.previous,
    required this.percent,
    required this.tone,
    this.currentSuffix = '',
    this.previousSuffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      radius: 18,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SmartPill(
                label: '${_formatSignedDouble(percent)}%',
                tone: percent >= 0 ? SmartTone.success : SmartTone.danger,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Kỳ này',
                  value: '$current$currentSuffix',
                  tone: tone,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Kỳ trước',
                  value: '$previous$previousSuffix',
                  tone: SmartTone.neutral,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodMiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final SmartTone tone;

  const _PeriodMiniMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.foreground.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodItemCard extends StatelessWidget {
  final PeriodReportItem item;

  const _PeriodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Công việc',
                  value: item.sumProcessDetail.toString(),
                  tone: SmartTone.accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Văn bản',
                  value: item.sumDocumentDetail.toString(),
                  tone: SmartTone.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Lịch họp',
                  value: _formatPercent(item.sumBookingDetail),
                  tone: SmartTone.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodTrendRow extends StatelessWidget {
  final PeriodTrendPoint point;

  const _PeriodTrendRow({required this.point});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SmartColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              point.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: SmartColors.accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'KPI ${_formatPercent(point.percKpi)}%',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SmartPill(
                      label: 'Quá hạn ${point.totalProcessExpired}',
                      tone: SmartTone.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Văn bản: ${point.totalDocument}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                SmartProgressBar(
                  value: point.percKpi / 100,
                  tone: SmartTone.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final DashboardNotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isUnread = item.statusId == 1;
    return SmartCard(
      borderColor: isUnread
          ? SmartColors.warning.withValues(alpha: 0.22)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isUnread ? SmartColors.warningSoft : SmartColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isUnread
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              color: isUnread ? SmartColors.warning : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.plainTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SmartPill(
                      label: item.timeAgo.isNotEmpty
                          ? item.timeAgo
                          : (isUnread ? 'Mới' : 'Đã đọc'),
                      tone: isUnread ? SmartTone.warning : SmartTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item.message.isNotEmpty
                      ? item.message
                      : 'Không có nội dung chi tiết.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final _NoticeItem item;

  const _NoticeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      color: item.urgent ? SmartColors.dangerSoft : SmartColors.cardSurface,
      borderColor: item.urgent
          ? SmartColors.danger.withValues(alpha: 0.22)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _LabelNote(label: item.title, note: item.note, large: true),
          ),
          const SizedBox(width: 10),
          Text(
            item.count,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTrendCard extends StatelessWidget {
  final List<DashboardTrendPoint> points;

  const _DashboardTrendCard({required this.points});

  @override
  Widget build(BuildContext context) {
    final visible = points.length > 6
        ? points.sublist(points.length - 6)
        : points;
    final maxValue = visible
        .map(
          (point) => point.kpiPercent > point.processPercent
              ? point.kpiPercent
              : point.processPercent,
        )
        .fold<double>(0, (max, value) => value > max ? value : max)
        .clamp(100, double.infinity);

    return SmartCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: _LabelNote(
                  label: 'Hiệu suất theo tuần',
                  note: 'KPI và tiến độ xử lý từ dashboard part 2',
                ),
              ),
              SmartPill(label: 'API', tone: SmartTone.accent),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 126,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: visible
                  .map(
                    (point) => _TrendBar(
                      label: point.label,
                      kpiValue: point.kpiPercent / maxValue,
                      processValue: point.processPercent / maxValue,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendBar extends StatelessWidget {
  final String label;
  final double kpiValue;
  final double processValue;

  const _TrendBar({
    required this.label,
    required this.kpiValue,
    required this.processValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: kpiValue.clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: SmartColors.accent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: processValue.clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: SmartColors.success,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartmentRow extends StatelessWidget {
  final DepartmentWorkload department;

  const _DepartmentRow({required this.department});

  @override
  Widget build(BuildContext context) {
    final total = department.total == 0 ? 1 : department.total;
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  department.departmentName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SmartPill(
                label: department.total.toString(),
                tone: department.totalOverdue > 0
                    ? SmartTone.danger
                    : SmartTone.neutral,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Row(
              children: [
                _WorkloadSegment(
                  flex: department.totalCompleted,
                  total: total,
                  color: SmartColors.success,
                ),
                _WorkloadSegment(
                  flex: department.totalProcessing,
                  total: total,
                  color: SmartColors.accent,
                ),
                _WorkloadSegment(
                  flex: department.totalPending,
                  total: total,
                  color: SmartColors.warning,
                ),
                _WorkloadSegment(
                  flex: department.totalOverdue,
                  total: total,
                  color: SmartColors.danger,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hoàn thành ${department.totalCompleted} · Đang xử lý ${department.totalProcessing} · Chờ ${department.totalPending} · Quá hạn ${department.totalOverdue}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _WorkloadSegment extends StatelessWidget {
  final int flex;
  final int total;
  final Color color;

  const _WorkloadSegment({
    required this.flex,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final widthFactor = flex == 0 ? 0.04 : flex / total;
    return Expanded(
      flex: (widthFactor * 100).round().clamp(4, 100),
      child: Container(height: 7, color: color),
    );
  }
}

class _ActiveUserRow extends StatelessWidget {
  final DashboardUser user;

  const _ActiveUserRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return _CompactRow(
      title: user.fullName.isNotEmpty ? user.fullName : user.userName,
      note: '${user.departmentName} · ${user.phone}',
      leading: SmartIconBadge(label: user.initials, size: 32),
      trailing: SmartPill(
        label: user.statusName.isNotEmpty ? user.statusName : 'Hoạt động',
        tone: SmartTone.success,
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      borderColor: SmartColors.warning.withValues(alpha: 0.3),
      color: SmartColors.warningSoft,
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: SmartColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

class _InlineSuccess extends StatelessWidget {
  final String message;

  const _InlineSuccess({required this.message});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      borderColor: SmartColors.success.withValues(alpha: 0.24),
      color: SmartColors.successSoft,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: SmartColors.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactRow extends StatelessWidget {
  final String title;
  final String note;
  final Widget? leading;
  final Widget? trailing;

  const _CompactRow({
    required this.title,
    required this.note,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 9)],
          Expanded(
            child: _LabelNote(label: title, note: note, large: true),
          ),
          trailing ?? const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _ProgramRow extends StatelessWidget {
  final String title;
  final String note;
  final String progress;
  final String status;
  final bool danger;

  const _ProgramRow({
    required this.title,
    required this.note,
    required this.progress,
    required this.status,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return _CompactRow(
      title: title,
      note: note,
      trailing: const Icon(Icons.chevron_right_rounded),
      leading: SizedBox(
        width: 76,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            SmartPill(label: progress),
            SmartPill(
              label: status,
              tone: danger ? SmartTone.danger : SmartTone.neutral,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;

  const _Bar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: value,
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: SmartColors.accent,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(999),
                        bottom: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _LabelNote extends StatelessWidget {
  final String label;
  final String note;
  final bool large;

  const _LabelNote({
    required this.label,
    required this.note,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: large ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: large ? 14 : 12,
            fontWeight: FontWeight.w800,
            height: 1.22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          note,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(height: 1.3),
        ),
      ],
    );
  }
}

class _MetaTile extends StatelessWidget {
  final String title;
  final String value;

  const _MetaTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: SmartColors.soft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SmartColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: SmartColors.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String note;
  final String state;
  final SmartTone stateTone;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.label,
    required this.note,
    required this.state,
    this.stateTone = SmartTone.neutral,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: _LabelNote(label: label, note: note),
          ),
          const SizedBox(width: 8),
          SmartPill(label: state, tone: stateTone),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _DetailValueRow extends StatelessWidget {
  final String label;
  final String note;
  final String value;

  const _DetailValueRow({
    required this.label,
    required this.note,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _DetailRowBase(
      label: label,
      note: note,
      trailing: Text(
        value,
        textAlign: TextAlign.right,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DetailSwitchRow extends StatelessWidget {
  final String label;
  final String note;
  final bool enabled;

  const _DetailSwitchRow({
    required this.label,
    required this.note,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return _DetailRowBase(
      label: label,
      note: note,
      trailing: Switch.adaptive(
        value: enabled,
        activeThumbColor: SmartColors.accent,
        onChanged: (_) {},
      ),
    );
  }
}

class _DetailRowBase extends StatelessWidget {
  final String label;
  final String note;
  final Widget trailing;

  const _DetailRowBase({
    required this.label,
    required this.note,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SmartColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: _LabelNote(label: label, note: note),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: trailing,
          ),
        ],
      ),
    );
  }
}

class _SmartTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? hint;
  final int maxLines;

  const _SmartTextField({
    required this.label,
    this.initialValue,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class _AiMessage extends StatelessWidget {
  final String icon;
  final String text;
  final bool user;

  const _AiMessage({required this.icon, required this.text, this.user = false});

  @override
  Widget build(BuildContext context) {
    final bubble = Flexible(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: user ? SmartColors.accent : SmartColors.soft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: user ? Colors.white : AppColors.textPrimary,
            height: 1.35,
          ),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: user ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: user
          ? [
              bubble,
              const SizedBox(width: 8),
              SmartIconBadge(label: icon, size: 30),
            ]
          : [
              SmartIconBadge(label: icon, size: 30),
              const SizedBox(width: 8),
              bubble,
            ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String note;

  const _EmptyState({required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SmartColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: SmartColors.border, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 6),
          Text(note, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LoadMoreRow extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _LoadMoreRow({required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SmartTextButton(
        label: isExpanded ? 'Thu gọn' : 'Xem thêm',
        icon: isExpanded
            ? Icons.expand_less_rounded
            : Icons.expand_more_rounded,
        onTap: onTap,
      ),
    );
  }
}

class _MeetingBookingCard extends StatelessWidget {
  final BookingModel booking;
  final String roomName;

  const _MeetingBookingCard({required this.booking, required this.roomName});

  @override
  Widget build(BuildContext context) {
    final statusTone = switch (booking.statusID) {
      1 => SmartTone.warning,
      2 => SmartTone.success,
      3 => SmartTone.accent,
      4 => SmartTone.neutral,
      5 => SmartTone.danger,
      _ => SmartTone.neutral,
    };

    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SmartPill(
                label: booking.formattedStartTime.isNotEmpty
                    ? booking.formattedStartTime
                    : '--:--',
                tone: SmartTone.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.bookingTitle.isNotEmpty
                      ? booking.bookingTitle
                      : 'Cuộc họp',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SmartPill(
                label: booking.statusID == 1
                    ? 'Mới'
                    : booking.statusID == 2
                    ? 'Xác nhận'
                    : booking.statusID == 3
                    ? 'Đang diễn ra'
                    : booking.statusID == 4
                    ? 'Kết thúc'
                    : 'Hủy',
                tone: statusTone,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$roomName · ${booking.formattedDate}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            booking.description.isNotEmpty
                ? booking.description
                : 'Không có mô tả',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _MeetingRoomCard extends StatelessWidget {
  final MeetingRoomItem item;

  const _MeetingRoomCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isActive = item.statusId == 1;
    return SmartCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive ? SmartColors.successSoft : SmartColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.meeting_room_rounded,
              color: isActive ? SmartColors.success : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LabelNote(
              label: item.roomBookingName,
              note: item.description,
              large: true,
            ),
          ),
          const SizedBox(width: 8),
          SmartPill(
            label: isActive ? 'Hoạt động' : 'Tạm dừng',
            tone: isActive ? SmartTone.success : SmartTone.neutral,
          ),
        ],
      ),
    );
  }
}

class _AppItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String search;
  final String? count;
  final AdminSmartView? view;

  const _AppItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.search,
    this.count,
    this.view,
  });
}

class _AppGroup {
  final String title;
  final List<_AppItem> items;

  const _AppGroup({required this.title, required this.items});
}

class _TaskItem {
  final String title;
  final String subtitle;
  final String status;
  final String statusKey;
  final double progress;
  final List<String> tags;
  final String owner;
  final String due;
  final String avatar;

  const _TaskItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusKey,
    required this.progress,
    required this.tags,
    required this.owner,
    required this.due,
    required this.avatar,
  });
}

class _ReportItem {
  final String id;
  final String title;
  final String note;
  final String severity;
  final String status;
  final String date;

  const _ReportItem({
    required this.id,
    required this.title,
    required this.note,
    required this.severity,
    required this.status,
    required this.date,
  });
}

class _NoticeItem {
  final String title;
  final String note;
  final String count;
  final bool urgent;
  final bool unread;

  const _NoticeItem({
    required this.title,
    required this.note,
    required this.count,
    this.urgent = false,
    this.unread = false,
  });
}

class _AiSuggestion {
  final String label;
  final String prompt;

  const _AiSuggestion(this.label, this.prompt);
}

const _appGroups = [
  _AppGroup(
    title: 'Tổng quan',
    items: [
      _AppItem(
        title: 'Dashboard Lãnh đạo',
        subtitle: 'KPI và cảnh báo điều hành',
        icon: Icons.dashboard_rounded,
        search: 'dashboard lanh dao tong quan',
        view: AdminSmartView.overview,
      ),
      _AppItem(
        title: 'Bản đồ số',
        subtitle: 'Điểm nóng theo địa bàn',
        icon: Icons.map_outlined,
        search: 'ban do so dia ban',
        view: AdminSmartView.digitalMap,
      ),
      _AppItem(
        title: 'Tố giác tội phạm',
        subtitle: 'Tiếp nhận và xử lý đơn',
        icon: Icons.gavel_rounded,
        search: 'to giac toi pham khieu nai',
        view: AdminSmartView.crimeReports,
      ),
      _AppItem(
        title: 'AI Hỗ trợ',
        subtitle: 'Tìm kiếm và gợi ý xử lý',
        icon: Icons.auto_awesome_rounded,
        search: 'ai ho tro tro ly',
        view: AdminSmartView.aiAssistant,
      ),
      _AppItem(
        title: 'Dân cư & Hộ gia đình',
        subtitle: 'Biến động cư trú',
        icon: Icons.groups_rounded,
        search: 'dan cu ho gia dinh',
      ),
      _AppItem(
        title: 'Báo cáo định kỳ',
        subtitle: 'Tổng hợp theo kỳ',
        icon: Icons.bar_chart_rounded,
        search: 'bao cao dinh ky',
        view: AdminSmartView.periodicReport,
      ),
    ],
  ),
  _AppGroup(
    title: 'Nghiệp vụ',
    items: [
      _AppItem(
        title: 'Họp không giấy tờ',
        subtitle: 'Lịch, tài liệu, biên bản',
        icon: Icons.event_note_rounded,
        search: 'hop khong giay to lich hop',
        count: '3',
        view: AdminSmartView.meetingSchedule,
      ),
      _AppItem(
        title: 'Chương trình & KPI',
        subtitle: 'Mục tiêu và chỉ tiêu',
        icon: Icons.query_stats_rounded,
        search: 'chuong trinh kpi',
        view: AdminSmartView.kpiPrograms,
      ),
      _AppItem(
        title: 'Giao việc & Kết luận',
        subtitle: 'Phân công, tiến độ, ký nhận',
        icon: Icons.task_alt_rounded,
        search: 'giao viec ket luan nhiem vu',
        count: '7',
        view: AdminSmartView.tasks,
      ),
      _AppItem(
        title: 'Văn bản / Công văn',
        subtitle: 'Luân chuyển xử lý',
        icon: Icons.description_outlined,
        search: 'van ban cong van',
        count: '4',
      ),
      _AppItem(
        title: 'Lịch công tác chung',
        subtitle: 'Điều phối lịch đơn vị',
        icon: Icons.calendar_month_rounded,
        search: 'lich cong tac chung',
      ),
      _AppItem(
        title: 'Thông báo khẩn',
        subtitle: 'Cảnh báo cần xử lý',
        icon: Icons.warning_amber_rounded,
        search: 'thong bao khan',
        count: '2',
        view: AdminSmartView.urgentAlerts,
      ),
      _AppItem(
        title: 'Danh sách thông báo',
        subtitle: 'Theo dõi phát hành',
        icon: Icons.notifications_rounded,
        search: 'danh sach thong bao',
      ),
    ],
  ),
  _AppGroup(
    title: 'Địa bàn',
    items: [
      _AppItem(
        title: 'Địa điểm số',
        subtitle: 'Vị trí và điểm dữ liệu',
        icon: Icons.place_outlined,
        search: 'dia diem so',
      ),
      _AppItem(
        title: 'Cơ quan / Sở ban ngành',
        subtitle: 'Danh bạ đơn vị phối hợp',
        icon: Icons.account_tree_outlined,
        search: 'co quan so ban nganh',
        view: AdminSmartView.agencies,
      ),
    ],
  ),
];

const _tasks = [
  _TaskItem(
    title: 'Giảm chỉ tiêu bước 1',
    subtitle: 'Administrator · Công an phường/xã',
    status: 'Quá hạn',
    statusKey: 'overdue',
    progress: 0.15,
    tags: ['GCTB1', '15%'],
    owner: 'Administrator',
    due: '22/06/2026',
    avatar: 'A',
  ),
  _TaskItem(
    title: 'Kiểm tra tiến độ thực hiện hộ tịch',
    subtitle: 'Phạm Vũ Minh Mẫn · Đội Cảnh sát QLHC',
    status: 'Quá hạn',
    statusKey: 'overdue',
    progress: 1,
    tags: ['Chỉ đạo trực tiếp', '100%'],
    owner: 'Phạm Vũ Minh Mẫn',
    due: '18/05/2026',
    avatar: 'MM',
  ),
  _TaskItem(
    title: 'Chỉnh ý tài liệu và số hóa tài liệu cũ',
    subtitle: 'Trương Tấn Trạng · Đội An ninh mạng',
    status: 'Đã ký',
    statusKey: 'complete',
    progress: 1,
    tags: ['KPI Task', 'Hoàn thành'],
    owner: 'Trương Tấn Trạng',
    due: '03/12/2026',
    avatar: 'TT',
  ),
];

const _crimeReports = [
  _ReportItem(
    id: 'TG-2026-001',
    title: 'FLC in thêm cổ phiếu',
    note: 'Đội Cảnh sát giao thông · Trịnh Văn Quyết',
    severity: 'Thấp',
    status: 'Đóng hồ sơ',
    date: '22/06',
  ),
  _ReportItem(
    id: 'TG-2026-002',
    title: 'Có người tổ chức sử dụng chất ma túy',
    note: 'Đội Cảnh sát điều tra ma túy · Nguyễn Việt Dũng',
    severity: 'Cao',
    status: 'Tiếp nhận',
    date: '16/06',
  ),
  _ReportItem(
    id: 'TG-2026-003',
    title: 'Hàng xóm hát karaoke quá ồn ào',
    note: 'Công an phường/xã · Phạm Vũ Minh Huy',
    severity: 'Thấp',
    status: 'Tiếp nhận',
    date: '16/06',
  ),
  _ReportItem(
    id: 'TG-2026-008',
    title: 'Dung dao dọa chém người',
    note: 'Công an phường/xã · Đạt',
    severity: 'Thấp',
    status: 'Tiếp nhận',
    date: '19/06',
  ),
];

const _notices = [
  _NoticeItem(
    title: 'Họp khẩn cấp về phòng chống thiên tai',
    note: 'Ưu tiên cao · Gửi toàn đơn vị · 08:30 hôm nay',
    count: '5',
    urgent: true,
    unread: true,
  ),
  _NoticeItem(
    title: 'Công văn triển khai nhiệm vụ cuối tuần',
    note: 'Đã gửi 16 · Đã đọc 12 · Còn 4 chưa đọc',
    count: '75%',
    unread: true,
  ),
  _NoticeItem(
    title: 'Nhắc xử lý hồ sơ quá hạn',
    note: 'Nhắc lại mỗi 2 giờ · Người nhận: bộ phận một cửa',
    count: '45',
    urgent: true,
    unread: true,
  ),
  _NoticeItem(
    title: 'Họp định kỳ giao ban tuần',
    note: 'Mức thường · 32 người nhận · 29 đã xác nhận',
    count: '91%',
  ),
];

const _aiSuggestions = [
  _AiSuggestion('KPI', 'Tóm tắt KPI tháng này và nêu 3 rủi ro cần xử lý'),
  _AiSuggestion(
    'Quá hạn',
    'Phân tích nhiệm vụ quá hạn, nhóm theo đơn vị phụ trách',
  ),
  _AiSuggestion(
    'Dân cư',
    'Tổng hợp thông tin dân số, hộ gia đình và biến động cư trú',
  ),
  _AiSuggestion('Họp', 'Tóm tắt cuộc họp gần nhất thành đầu việc và hạn xử lý'),
  _AiSuggestion(
    'Soạn nhắc',
    'Soạn thông báo nhắc việc gửi các đơn vị chưa hoàn thành',
  ),
];

String _taskStatusLabel(String value) {
  switch (value) {
    case 'overdue':
      return 'Quá hạn';
    case 'doing':
      return 'Đang làm';
    case 'complete':
      return 'Hoàn thành';
    default:
      return 'Tất cả';
  }
}

String _urgentFilterLabel(String value) {
  switch (value) {
    case 'urgent':
      return 'Khẩn';
    case 'unread':
      return 'Chưa đọc';
    default:
      return 'Tất cả';
  }
}

List<KpiProgramViewItem> _filteredKpiItems(
  List<KpiProgramViewItem> items,
  String query,
  int statusFilter,
) {
  final normalizedQuery = query.trim().toLowerCase();
  return items.where((item) {
    final program = item.program;
    final matchStatus =
        statusFilter == -100 || program.statusId == statusFilter;
    final ownerName = item.owner?.fullName ?? program.fullName;
    final searchable = [
      program.kpiName,
      program.departmentName,
      program.categoryKpiName,
      ownerName,
      program.statusName,
    ].join(' ').toLowerCase();
    return matchStatus &&
        (normalizedQuery.isEmpty || searchable.contains(normalizedQuery));
  }).toList();
}

String _formatPercent(double value) {
  if (value % 1 == 0) return value.round().toString();
  return value.toStringAsFixed(1);
}

String _formatSignedDouble(double value) {
  if (value % 1 == 0) {
    final formatted = value.round().toString();
    return value > 0 ? '+$formatted' : formatted;
  }
  final formatted = value.toStringAsFixed(1);
  return value > 0 ? '+$formatted' : formatted;
}

({Color background, Color foreground}) _periodToneColors(SmartTone tone) {
  switch (tone) {
    case SmartTone.accent:
      return (
        background: SmartColors.accentSoft,
        foreground: SmartColors.accent,
      );
    case SmartTone.danger:
      return (
        background: SmartColors.dangerSoft,
        foreground: SmartColors.danger,
      );
    case SmartTone.success:
      return (
        background: SmartColors.successSoft,
        foreground: SmartColors.success,
      );
    case SmartTone.warning:
      return (
        background: SmartColors.warningSoft,
        foreground: SmartColors.warning,
      );
    case SmartTone.neutral:
      return (
        background: SmartColors.surface,
        foreground: AppColors.textSecondary,
      );
  }
}

String _formatSigned(int value) {
  if (value > 0) return '+$value';
  return value.toString();
}

String _formatDateLabel(DateTime? date) {
  if (date == null) return 'Chưa có hạn';
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _initials(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized == 'Chưa xác định') return 'KPI';
  final parts = normalized.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return String.fromCharCodes(parts.first.runes.take(2)).toUpperCase();
  }
  return String.fromCharCodes([
    parts.first.runes.first,
    parts.last.runes.first,
  ]).toUpperCase();
}

SmartTone _kpiStatusTone(int statusId) {
  switch (statusId) {
    case 1:
      return SmartTone.success;
    case 2:
      return SmartTone.warning;
    case 4:
      return SmartTone.danger;
    default:
      return SmartTone.neutral;
  }
}
