part of '../home_screen.dart';

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

Map<DateTime, List<BookingModel>> _groupBookingsByDate(
  List<BookingModel> bookings,
) {
  final grouped = <DateTime, List<BookingModel>>{};
  for (final booking in bookings) {
    final start = DateTime.tryParse(booking.dateStart);
    if (start == null) continue;
    final day = DateTime(start.year, start.month, start.day);
    grouped.putIfAbsent(day, () => []).add(booking);
  }
  for (final entry in grouped.entries) {
    entry.value.sort((a, b) {
      final first = DateTime.tryParse(a.dateStart) ?? DateTime(2100);
      final second = DateTime.tryParse(b.dateStart) ?? DateTime(2100);
      return first.compareTo(second);
    });
  }
  return Map.fromEntries(
    grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

String _workCalendarRangeLabel(
  WorkCalendarViewMode mode,
  (DateTime, DateTime) range,
) {
  switch (mode) {
    case WorkCalendarViewMode.day:
      return _calendarDayTitle(range.$1);
    case WorkCalendarViewMode.week:
      return '${_shortDate(range.$1)} - ${_shortDate(range.$2)}';
    case WorkCalendarViewMode.month:
      return 'Tháng ${range.$1.month}/${range.$1.year}';
  }
}

String _calendarDayTitle(DateTime date) {
  const weekdays = [
    'Thứ hai',
    'Thứ ba',
    'Thứ tư',
    'Thứ năm',
    'Thứ sáu',
    'Thứ bảy',
    'Chủ nhật',
  ];
  return '${weekdays[date.weekday - 1]}, ${_shortDate(date)}';
}

String _shortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _formatDateTimeLabel(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return 'Chưa xác định';
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/${date.year} $hour:$minute';
}

String _formatTimeOnly(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return '--:--';
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _bookingStatusLabel(BookingModel booking) {
  if (booking.statusName.trim().isNotEmpty) return booking.statusName.trim();
  return _bookingStatusLabelById(booking.statusID);
}

String _bookingStatusLabelById(int statusId) {
  switch (statusId) {
    case 0:
      return 'Đã kết thúc';
    case 1:
      return 'Mới';
    case 2:
      return 'Đã xác nhận';
    case 3:
      return 'Đang diễn ra';
    case 4:
      return 'Đã kết thúc';
    case 5:
      return 'Đã hủy';
    default:
      return 'Chưa xác định';
  }
}

SmartTone _bookingStatusTone(int statusId) {
  switch (statusId) {
    case 1:
    case 2:
      return SmartTone.success;
    case 3:
      return SmartTone.warning;
    case 5:
      return SmartTone.danger;
    default:
      return SmartTone.neutral;
  }
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
