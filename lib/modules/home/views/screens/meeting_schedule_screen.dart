part of '../home_screen.dart';

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
            eyebrow: 'Quản lý cuộc họp',
            title: 'Lịch họp',
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
