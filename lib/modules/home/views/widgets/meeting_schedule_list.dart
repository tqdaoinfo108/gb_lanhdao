import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../core/values/app_constants.dart';
import '../../../../data/models/dashboard_models.dart';

/// Danh sách lịch họp hôm nay.
class MeetingScheduleList extends StatelessWidget {
  final List<MeetingItem> meetings;
  final int totalCount;
  final VoidCallback? onViewAll;

  const MeetingScheduleList({
    super.key,
    required this.meetings,
    required this.totalCount,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 18, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text(
                'Lịch họp hôm nay',
                style: AppTextStyles.h4.copyWith(fontSize: 15),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.neutralBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Tổng cộng $totalCount cuộc',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // Meeting items
          ...meetings.asMap().entries.map((entry) {
            final index = entry.key;
            final meeting = entry.value;
            return Column(
              children: [
                _MeetingRow(meeting: meeting),
                if (index < meetings.length - 1)
                  Divider(
                    height: 1,
                    indent: 60,
                    color: AppColors.divider.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),

          // View all
          if (onViewAll != null) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Xem tất cả lịch trình',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.primaryBlue),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Một dòng cuộc họp.
class _MeetingRow extends StatelessWidget {
  final MeetingItem meeting;

  const _MeetingRow({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          SizedBox(
            width: 48,
            child: Text(
              meeting.time,
              style: AppTextStyles.h4.copyWith(fontSize: 15),
            ),
          ),
          const SizedBox(width: 12),

          // Vertical line indicator
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: meeting.isUrgent
                  ? AppColors.alertRed
                  : AppColors.primaryBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.title,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        meeting.location,
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tag
          if (meeting.tag != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                meeting.tag!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
