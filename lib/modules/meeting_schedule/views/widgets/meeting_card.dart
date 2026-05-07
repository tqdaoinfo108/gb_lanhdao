import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/meeting_schedule_models.dart';

class MeetingCard extends StatelessWidget {
  final MeetingScheduleItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MeetingCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = item.isHighlighted ? const Color(0xFFBFDBFE) : const Color(0xFFE5E7EB);
    return Slidable(
      key: ValueKey('${item.title}-${item.time}-${item.location}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.26,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'meeting.delete.action'.tr,
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: item.isHighlighted ? const Color(0xFFEFF4FF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: item.isHighlighted ? Border.all(color: const Color(0xFF5B8DEF), width: 1) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: item.isHighlighted ? 0.07 : 0.05),
                  blurRadius: item.isHighlighted ? 14 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimeColumn(item: item),
                Container(width: 1, height: 70, margin: const EdgeInsets.symmetric(horizontal: 12), color: dividerColor),
                Expanded(child: _ContentColumn(item: item)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final MeetingScheduleItem item;
  const _TimeColumn({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.time,
            style: AppTextStyles.h3.copyWith(
              fontSize: 16,
              color: item.isHighlighted ? const Color(0xFF1A56DB) : const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          if (item.isHighlighted && item.statusLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFF1A56DB), borderRadius: BorderRadius.circular(6)),
              child: Text(
                item.statusLabel!,
                style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w700),
                maxLines: 1,
                softWrap: false,
              ),
            )
          else if (item.statusLabel != null)
            Text(
              item.statusLabel!,
              style: AppTextStyles.caption.copyWith(color: const Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}

class _ContentColumn extends StatelessWidget {
  final MeetingScheduleItem item;
  const _ContentColumn({required this.item});

  @override
  Widget build(BuildContext context) {
    final metaStyle = AppTextStyles.caption.copyWith(color: const Color(0xFF6B7280), fontSize: 12.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11, color: const Color(0xFF111827), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (item.isHighlighted)
          Row(
            children: [
              const Icon(Icons.schedule_outlined, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(item.duration, style: metaStyle),
              const SizedBox(width: 10),
              const Icon(Icons.place_outlined, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Expanded(child: Text(item.location, style: metaStyle, overflow: TextOverflow.ellipsis)),
            ],
          )
        else if (item.platform != null && item.attendeeSummary != null)
          Row(
            children: [
              const Icon(Icons.videocam_outlined, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(item.platform!, style: metaStyle),
              const SizedBox(width: 12),
              const Icon(Icons.groups_2_outlined, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text('${item.attendeeSummary} ${'meeting.attendees_suffix'.tr}', style: metaStyle),
            ],
          )
        else
          Text('${item.location} • ${item.duration}', style: metaStyle),
        if (item.isHighlighted && item.organizer != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const _AvatarStack(),
              const SizedBox(width: 4),
              Expanded(child: Text(item.organizer!, style: metaStyle.copyWith(fontSize: 11.5), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 22,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(left: 0, child: _AvatarCircle(color: Color(0xFF111827), text: 'A')),
          Positioned(left: 14, child: _AvatarCircle(color: Color(0xFFF59E0B), text: 'B')),
          Positioned(left: 28, child: _AvatarCircle(color: Color(0xFF1A56DB), text: '+12')),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final Color color;
  final String text;
  const _AvatarCircle({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.length > 2 ? 8.5 : 10),
      ),
    );
  }
}
