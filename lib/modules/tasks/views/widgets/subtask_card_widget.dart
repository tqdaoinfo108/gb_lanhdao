
import 'package:flutter/material.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';

class SubTaskCard extends StatelessWidget {
  final SubTask subTask;
  final Function(SubTaskStatus) onStatusChanged;

  const SubTaskCard({super.key, required this.subTask, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: subTask.isLate ? const Color(0xFFFFF5F5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: subTask.isLate ? const Color(0xFFFECACA) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainContent(),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 10),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: subTask.isDone,
              onChanged: (val) {
                if (val == true) {
                  onStatusChanged(SubTaskStatus.hoanThanh);
                } else {
                  onStatusChanged(SubTaskStatus.dangLam);
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              activeColor: const Color(0xFF10B981),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 10),
              _buildMeta(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          subTask.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: subTask.isDone ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937),
            decoration: subTask.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        PriorityTag(priority: subTask.priority),
        if (subTask.status == SubTaskStatus.treLhan) const LateTag(),
      ],
    );
  }

  Widget _buildMeta() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 14, color: Color(0xFF6B7280)),
            const SizedBox(width: 4),
            Text(
              subTask.assignee,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 14, color: Color(0xFFEF4444)),
            const SizedBox(width: 4),
            Text(
              subTask.formattedDate,
              style: const TextStyle(fontSize: 13, color: Color(0xFFEF4444)),
            ),
          ],
        ),
        StatusChip(status: subTask.status),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (!subTask.isDone)
          StatusDropdown(
            currentStatus: subTask.status,
            onChanged: onStatusChanged,
          ),
        const Spacer(),
        if (subTask.isDone) ...[
          IconCount(icon: Icons.chat_bubble_outline, count: subTask.commentCount),
          const SizedBox(width: 12),
          IconCount(icon: Icons.attach_file, count: subTask.attachmentCount),
        ] else ...[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, size: 20, color: Color(0xFF9CA3AF)),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFF9CA3AF)),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ],
    );
  }
}

class IconCount extends StatelessWidget {
  final IconData icon;
  final int count;
  const IconCount({super.key, required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text('$count', style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}

class PriorityTag extends StatelessWidget {
  final SubTaskPriority priority;
  const PriorityTag({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case SubTaskPriority.cao:
        color = const Color(0xFFEF4444);
      case SubTaskPriority.trungBinh:
        color = const Color(0xFFF59E0B);
      case SubTaskPriority.thap:
        color = const Color(0xFF3B82F6);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(priority.label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class LateTag extends StatelessWidget {
  const LateTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 10, color: Color(0xFFEF4444)),
          SizedBox(width: 2),
          Text('Trễ hạn', style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final SubTaskStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == SubTaskStatus.hoanThanh) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(4)),
        child: const Text('Hoàn thành', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.w700)),
      );
    }
    if (status == SubTaskStatus.dangLam) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)),
        child: const Text('Đang làm', style: TextStyle(color: Color(0xFFD97706), fontSize: 11, fontWeight: FontWeight.w700)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4)),
      child: const Text('Chưa làm', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class StatusDropdown extends StatelessWidget {
  final SubTaskStatus currentStatus;
  final Function(SubTaskStatus) onChanged;

  const StatusDropdown({super.key, required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SubTaskStatus>(
          value: currentStatus == SubTaskStatus.treLhan ? SubTaskStatus.dangLam : currentStatus,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF6B7280)),
          style: const TextStyle(fontSize: 13, color: Color(0xFF374151), fontWeight: FontWeight.w600),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: [
            SubTaskStatus.chuaLam,
            SubTaskStatus.dangLam,
            SubTaskStatus.hoanThanh,
          ].map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.label),
            );
          }).toList(),
        ),
      ),
    );
  }
}