import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';
import 'package:gb_lanhdao/routes/app_routes.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TaskCardWidget extends StatelessWidget {
  final Task task;

  const TaskCardWidget({super.key, required this.task});

  Color _statusColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('chậm tiến độ')) return const Color(0xFFE74C3C);
    if (l.contains('hoàn thành')) return const Color(0xFF20C46A);
    if (l.contains('có rủi ro')) return const Color(0xFFF2994A);
    if (l.contains('đúng tiến độ')) return const Color(0xFF2F6CE1);
    return const Color(0xFF2F6CE1);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(task.statusLabel);
    final progressColor = task.progressColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: accent, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.statusLabel,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    task.id,
                    style: const TextStyle(
                      color: Color(0xFF8A93A2),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.more_vert, size: 20, color: Color(0xFF8A93A2)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 17,
                height: 1.2,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${task.department} • Phụ trách: ${task.owner}',
              style: const TextStyle(
                color: Color(0xFF7A8494),
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Tiến độ: ${(task.displayProgress * 100).round()}%',
                  style: const TextStyle(
                    color: Color(0xFF7A8494),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  task.displayProgress >= 1.0 ? 'Hoàn thành: ${task.formattedDate}' : 'Hạn chót: ${task.formattedDate}',
                  style: TextStyle(
                    color: task.displayProgress >= 1.0 ? const Color(0xFF6B7280) : accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearPercentIndicator(
                lineHeight: 7,
                percent: task.displayProgress.clamp(0.0, 1.0),
                backgroundColor: const Color(0xFFEAF0F7),
                progressColor: progressColor,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: const Color(0xFFE7ECF3)),
            const SizedBox(height: 10),
            Row(
              children: [
                _Avatars(urls: task.avatarUrls, names: task.assignees),
                if (task.kpiTotal != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.analytics_outlined, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 4),
                        Text(
                          '${task.kpiCurrent}/${task.kpiTotal}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: const Color(0xFF2F6CE1),
                  ),
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatars extends StatelessWidget {
  final List<String> urls;
  final List<String> names;

  const _Avatars({required this.urls, this.names = const []});

  String _getInitial(int index) {
    if (index < names.length && names[index].isNotEmpty) {
      return names[index].split(' ').last[0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final show = urls.take(2).toList();
    final extra = urls.length - show.length;
    final itemCount = show.length + (extra > 0 ? 1 : 0);
    final width = itemCount == 0 ? 0.0 : 28.0 + (itemCount - 1) * 15.0;

    return SizedBox(
      width: width,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < show.length; i++)
            Positioned(
              left: i * 16,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: urls[i].isNotEmpty
                    ? CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(show[i]),
                        backgroundColor: const Color(0xFFEAF0F7),
                      )
                    : CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF2F6CE1),
                        child: Text(
                          _getInitial(i),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: show.length * 15,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$extra',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
