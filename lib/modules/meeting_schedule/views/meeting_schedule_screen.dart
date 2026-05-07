import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/meeting_schedule_models.dart';
import '../controllers/meeting_schedule_controller.dart';

class MeetingScheduleScreen extends GetView<MeetingScheduleController> {
  const MeetingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    title: controller.headerTitle,
                    subtitle: controller.headerDate,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _DaySection(
                        section: controller.sections[index],
                        addBottomSpacing: index < controller.sections.length - 1,
                      ),
                      childCount: controller.sections.length,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 18,
              bottom: 90,
              child: FloatingActionButton(
                heroTag: 'meeting-create-right',
                onPressed: () => _showCreateMeetingSheet(context),
                backgroundColor: const Color(0xFF1A56DB),
                elevation: 4,
                child: const Icon(Icons.edit_calendar_rounded, color: Colors.white),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const _BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A56DB),
        elevation: 3,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3159B8),
                  Color(0xFF1E3F8F),
                  Color(0xFF102A63),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3F8F).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Positioned(
            right: -40,
            top: -28,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            left: -28,
            bottom: -34,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF60A5FA).withValues(alpha: 0.2),
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Container(color: Colors.transparent),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.28)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                Text(
                  title,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 38 / 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final MeetingScheduleSection section;
  final bool addBottomSpacing;

  const _DaySection({
    required this.section,
    required this.addBottomSpacing,
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
          ...section.meetings.map(
            (meeting) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MeetingCard(
                item: meeting,
                onTap: () => _showMeetingDetail(context, meeting),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final MeetingScheduleItem item;
  final VoidCallback? onTap;

  const _MeetingCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = item.isHighlighted ? const Color(0xFFBFDBFE) : const Color(0xFFE5E7EB);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: item.isHighlighted ? const Color(0xFFEFF4FF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: item.isHighlighted
                ? Border.all(color: const Color(0xFF5B8DEF), width: 1)
                : null,
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
              SizedBox(
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
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A56DB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.statusLabel!,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        ),
                      )
                    else if (item.statusLabel != null)
                      Text(
                        item.statusLabel!,
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF6B7280),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: dividerColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 22 / 2,
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (item.isHighlighted)
                      Row(
                        children: [
                          const Icon(Icons.schedule_outlined, size: 14, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Text(item.duration, style: _metaStyle),
                          const SizedBox(width: 10),
                          const Icon(Icons.place_outlined, size: 14, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              style: _metaStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else if (item.platform != null && item.attendeeSummary != null)
                      Row(
                        children: [
                          const Icon(Icons.videocam_outlined, size: 14, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Text(item.platform!, style: _metaStyle),
                          const SizedBox(width: 12),
                          const Icon(Icons.groups_2_outlined, size: 14, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Text('${item.attendeeSummary} người', style: _metaStyle),
                        ],
                      )
                    else
                      Text(
                        '${item.location} • ${item.duration}',
                        style: _metaStyle,
                      ),
                    if (item.isHighlighted && item.organizer != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const _AvatarStack(),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.organizer!,
                              style: _metaStyle.copyWith(fontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _metaStyle => AppTextStyles.caption.copyWith(
        color: const Color(0xFF6B7280),
        fontSize: 12.5,
      );
}

void _showMeetingDetail(BuildContext context, MeetingScheduleItem item) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        titlePadding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
        actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        title: Text(
          'Chi tiết cuộc họp',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Tiêu đề', item.title),
            _detailRow('Thời gian', item.time),
            _detailRow('Thời lượng', item.duration),
            _detailRow('Địa điểm', item.location),
            if (item.platform != null) _detailRow('Nền tảng', item.platform!),
            if (item.attendeeSummary != null) _detailRow('Người tham dự', '${item.attendeeSummary} người'),
            if (item.statusLabel != null) _detailRow('Trạng thái', item.statusLabel!),
            if (item.organizer != null) _detailRow('Tổ chức', item.organizer!.replaceFirst('Tổ chức: ', '')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        style: AppTextStyles.body.copyWith(color: const Color(0xFF111827), height: 1.35),
        children: [
          TextSpan(
            text: '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}

extension on MeetingScheduleScreen {
  Future<void> _showCreateMeetingSheet(BuildContext context) async {
    String title = '';
    String time = '';
    String location = '';
    String duration = '';
    String organizer = '';
    DateTime selectedDate = DateTime.now();
    String? selectedLocation;
    final minDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tạo cuộc họp mới',
                        style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      _FormField(
                        hint: 'Tiêu đề cuộc họp',
                        onChanged: (value) => title = value,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _PickerField(
                              value: _formatDate(selectedDate),
                              hint: 'Chọn ngày',
                              icon: Icons.calendar_month_outlined,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: dialogContext,
                                  initialDate: selectedDate,
                                  firstDate: minDate,
                                  lastDate: DateTime(minDate.year + 5),
                                );
                                if (picked != null) {
                                  setState(() => selectedDate = picked);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _PickerField(
                              value: time.isEmpty ? null : time,
                              hint: 'Chọn giờ',
                              icon: Icons.access_time_rounded,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: dialogContext,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    time =
                                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _FormField(
                        hint: 'Thời lượng (VD: 90 phút)',
                        onChanged: (value) => duration = value,
                      ),
                      const SizedBox(height: 8),
                      _ComboField(
                        hint: 'Chọn địa điểm',
                        value: selectedLocation,
                        items: controller.locationOptions,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                            location = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _FormField(
                        hint: 'Người tổ chức (tùy chọn)',
                        onChanged: (value) => organizer = value,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final cleanTitle = title.trim();
                            final cleanTime = time.trim();
                            final cleanLocation = location.trim();
                            final cleanDuration = duration.trim();
                            final cleanOrganizer = organizer.trim();

                            if (cleanTitle.isEmpty ||
                                cleanTime.isEmpty ||
                                cleanLocation.isEmpty ||
                                cleanDuration.isEmpty) {
                              Get.snackbar(
                                'Thiếu thông tin',
                                'Vui lòng nhập đủ tiêu đề, ngày, giờ, địa điểm và thời lượng.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            controller.addMeeting(
                              date: selectedDate,
                              title: cleanTitle,
                              time: cleanTime,
                              location: cleanLocation,
                              duration: cleanDuration,
                              organizer: cleanOrganizer.isEmpty
                                  ? null
                                  : 'Tổ chức: $cleanOrganizer',
                            );
                            Navigator.of(dialogContext).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A56DB),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Lưu cuộc họp'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _PickerField extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: const Color(0xFF6B7280)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                value ?? hint,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  color: value == null ? const Color(0xFF94A3B8) : const Color(0xFF111827),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const _FormField({
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A56DB)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      ),
    );
  }
}

class _ComboField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _ComboField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A56DB)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTextStyles.body.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
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

  const _AvatarCircle({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: text.length > 2 ? 8.5 : 10,
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 10,
      child: SizedBox(
        height: 66,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NavItem(icon: Icons.grid_view_rounded, label: 'Tổng quan', active: false),
            _NavItem(icon: Icons.work_outline_rounded, label: 'Nghiệp vụ', active: true),
            SizedBox(width: 30),
            _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Trao đổi', active: false),
            _NavItem(icon: Icons.person_outline_rounded, label: 'Cá nhân', active: false),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF1A56DB) : const Color(0xFF6B7280);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: color,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
