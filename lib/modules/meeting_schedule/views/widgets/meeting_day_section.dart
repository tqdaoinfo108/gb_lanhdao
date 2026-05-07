import 'package:flutter/material.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/meeting_schedule_models.dart';
import 'meeting_card.dart';

class MeetingDaySection extends StatelessWidget {
  final MeetingScheduleSection section;
  final bool addBottomSpacing;
  final void Function(MeetingScheduleItem item, int index) onTapMeeting;
  final void Function(int index) onDeleteMeeting;

  const MeetingDaySection({
    super.key,
    required this.section,
    required this.addBottomSpacing,
    required this.onTapMeeting,
    required this.onDeleteMeeting,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: addBottomSpacing ? 24 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.title,
                  style: AppTextStyles.label.copyWith(
                    color: const Color(0xFF4B5563),
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              if (section.subtitle.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    section.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF1A56DB),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.meetings.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MeetingCard(
                    item: entry.value,
                    onTap: () => onTapMeeting(entry.value, entry.key),
                    onDelete: () => onDeleteMeeting(entry.key),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
