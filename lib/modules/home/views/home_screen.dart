import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../modules/meeting_schedule/bindings/meeting_schedule_binding.dart';
import '../../../modules/meeting_schedule/views/meeting_schedule_screen.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_loading_indicator.dart';
import '../../../widgets/section_header.dart';
import 'widgets/home_header.dart';
import 'widgets/kpi_summary_grid.dart';
import 'widgets/alert_banner.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/ai_insight_card.dart';
import 'widgets/meeting_schedule_list.dart';

/// Màn hình Home — Dashboard tổng quan lãnh đạo.
/// Chỉ chứa UI, logic nằm trong HomeController.
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const AppLoadingIndicator(
            fullScreen: true,
            message: 'Đang tải dữ liệu...',
          );
        }

        // Error
        if (controller.errorMessage.isNotEmpty) {
          return AppEmptyState(
            icon: Icons.error_outline,
            message: 'Đã xảy ra lỗi',
            subMessage: controller.errorMessage.value,
            onRetry: controller.onRefresh,
          );
        }

        // Content
        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: AppColors.primaryBlue,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Safe area padding
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 12),
              ),

              // Header
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                sliver: SliverToBoxAdapter(
                  child: HomeHeader(
                    greeting: controller.greeting.value,
                    userName: controller.userName.value,
                    dateString: controller.dateString.value,
                    onNotificationTap: () {
                      // TODO: navigate to notifications
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // KPI Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                sliver: SliverToBoxAdapter(
                  child: KpiSummaryGrid(
                    items: controller.kpiSummaries,
                    onItemTap: _onTapKpi,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Alert Banner
              if (controller.alert.value != null)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: AlertBanner(
                      alert: controller.alert.value!,
                      onTap: () {
                        // TODO: navigate to overdue tasks
                      },
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Weekly Chart
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        title: 'Hiệu suất tuần này',
                        actionLabel: 'Chi tiết',
                        onAction: () {
                          // TODO: navigate to performance detail
                        },
                      ),
                      const SizedBox(height: 12),
                      WeeklyPerformanceChart(data: controller.chartData),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // AI Insight
              if (controller.aiInsight.value != null)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: AiInsightCard(
                      insight: controller.aiInsight.value!,
                      onAction: () {
                        // TODO: handle AI suggestion action
                      },
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Meeting Schedule
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                sliver: SliverToBoxAdapter(
                  child: MeetingScheduleList(
                    meetings: controller.meetings,
                    totalCount: controller.totalMeetings.value,
                    onViewAll: () {
                      _goToMeetingSchedule();
                    },
                  ),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Tổng quát',
                isSelected: true,
              ),
              _NavItem(
                icon: Icons.work_outline_rounded,
                label: 'Nghiệp vụ',
                isSelected: false,
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Trao đổi',
                isSelected: false,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Cá nhân',
                isSelected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapKpi(KpiSummary kpi) {
    if (kpi.iconType == KpiIconType.meeting) {
      _goToMeetingSchedule();
    }
  }

  void _goToMeetingSchedule() {
    try {
      Get.toNamed(AppRoutes.meetingSchedule);
    } catch (_) {
      // Fallback giúp mở màn hình ngay cả khi named routes chưa được hot restart.
      Get.to(
        () => const MeetingScheduleScreen(),
        binding: MeetingScheduleBinding(),
      );
    }
  }
}

/// Item cho bottom navigation bar.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryBlue : AppColors.textSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
