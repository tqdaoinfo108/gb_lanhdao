import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/meeting_schedule_models.dart';
import '../../controllers/meeting_schedule_controller.dart';

Future<void> showMeetingDetailDialog({
  required BuildContext context,
  required MeetingScheduleItem item,
  required VoidCallback onDeleteTap,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'meeting.detail.title'.tr,
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('meeting.detail.label_title'.tr, item.title),
            _detailRow('meeting.detail.label_time'.tr, item.time),
            _detailRow('meeting.detail.label_duration'.tr, item.duration),
            _detailRow('meeting.detail.label_location'.tr, item.location),
            if (item.platform != null) _detailRow('meeting.detail.label_platform'.tr, item.platform!),
            if (item.attendeeSummary != null)
              _detailRow('meeting.detail.label_attendees'.tr, '${item.attendeeSummary} ${'meeting.attendees_suffix'.tr}'),
            if (item.statusLabel != null) _detailRow('meeting.detail.label_status'.tr, item.statusLabel!),
            if (item.organizer != null) _detailRow('meeting.detail.label_organizer'.tr, item.organizer!.replaceFirst('Tổ chức: ', '')),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'meeting.delete.tooltip'.tr,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onDeleteTap();
            },
            icon: const Icon(Icons.delete_rounded, color: Color(0xFFDC2626)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('common.close'.tr),
          ),
        ],
      );
    },
  );
}

Future<void> showCreateMeetingDialog({
  required BuildContext context,
  required MeetingScheduleController controller,
}) async {
  String title = '';
  String time = '';
  String location = '';
  String duration = '';
  String organizer = '';
  DateTime selectedDate = DateTime.now();
  String? selectedLocation;
  final minDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

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
                    Text('meeting.create.title'.tr, style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _FormField(hint: 'meeting.create.hint_title'.tr, onChanged: (value) => title = value),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _PickerField(
                            value: _formatDate(selectedDate),
                            hint: 'meeting.create.pick_date'.tr,
                            icon: Icons.calendar_month_outlined,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: dialogContext,
                                initialDate: selectedDate,
                                firstDate: minDate,
                                lastDate: DateTime(minDate.year + 5),
                              );
                              if (picked != null) setState(() => selectedDate = picked);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _PickerField(
                            value: time.isEmpty ? null : time,
                            hint: 'meeting.create.pick_time'.tr,
                            icon: Icons.access_time_rounded,
                            onTap: () async {
                              final picked = await showTimePicker(context: dialogContext, initialTime: TimeOfDay.now());
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
                    _FormField(hint: 'meeting.create.hint_duration'.tr, onChanged: (value) => duration = value),
                    const SizedBox(height: 8),
                    _ComboField(
                      hint: 'meeting.create.pick_location'.tr,
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
                    _FormField(hint: 'meeting.create.hint_organizer'.tr, onChanged: (value) => organizer = value),
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
                          if (cleanTitle.isEmpty || cleanTime.isEmpty || cleanLocation.isEmpty || cleanDuration.isEmpty) {
                            Get.snackbar(
                              'meeting.create.missing_title'.tr,
                              'meeting.create.missing_content'.tr,
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
                            organizer: cleanOrganizer.isEmpty ? null : cleanOrganizer,
                            statusLabel: 'meeting.status_new'.tr,
                          );
                          Navigator.of(dialogContext).pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A56DB), foregroundColor: Colors.white),
                        child: Text('meeting.create.save'.tr),
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

Future<bool> showDeleteConfirmDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('meeting.delete.confirm_title'.tr),
      content: Text('meeting.delete.confirm_content'.tr),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text('common.cancel'.tr)),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text('meeting.delete.action'.tr, style: const TextStyle(color: Color(0xFFDC2626))),
        ),
      ],
    ),
  );
  return confirmed == true;
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        style: AppTextStyles.body.copyWith(color: const Color(0xFF111827), height: 1.35),
        children: [
          TextSpan(text: '$label: ', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}

class _PickerField extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;
  const _PickerField({required this.value, required this.hint, required this.icon, required this.onTap});

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
                style: AppTextStyles.body.copyWith(fontSize: 13, color: value == null ? const Color(0xFF94A3B8) : const Color(0xFF111827)),
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
  const _FormField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: _border(const Color(0xFFE5E7EB)),
        enabledBorder: _border(const Color(0xFFE5E7EB)),
        focusedBorder: _border(const Color(0xFF1A56DB)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color));
  }
}

class _ComboField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _ComboField({required this.hint, required this.value, required this.items, required this.onChanged});

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
        border: _border(const Color(0xFFE5E7EB)),
        enabledBorder: _border(const Color(0xFFE5E7EB)),
        focusedBorder: _border(const Color(0xFF1A56DB)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color));
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
