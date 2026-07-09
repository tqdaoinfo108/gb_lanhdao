part of '../home_screen.dart';

class _AppsScreen extends StatelessWidget {
  final HomeController controller;

  const _AppsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final groups = _appGroups.map((group) {
        final query = controller.appQuery.value.toLowerCase();
        final items = group.items.where((item) {
          return query.isEmpty ||
              '${item.title} ${item.subtitle} ${item.search}'
                  .toLowerCase()
                  .contains(query);
        }).toList();
        return _AppGroup(title: group.title, items: items, tone: group.tone);
      }).toList();
      final visibleCount = groups.fold<int>(
        0,
        (total, group) => total + group.items.length,
      );
      final totalApps = _appGroups.fold<int>(
        0,
        (total, group) => total + group.items.length,
      );

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            eyebrow: 'Danh mục',
            title: 'Ứng dụng',
            badge: '$totalApps app',
          ),
          SmartSearchPanel(
            controller: controller.appSearchController,
            hint: 'Tìm ứng dụng...',
            onChanged: (value) => controller.appQuery.value = value,
          ),
          if (visibleCount == 0)
            const _EmptyState(
              title: 'Không tìm thấy ứng dụng',
              note: 'Thử đổi từ khóa tìm kiếm.',
            )
          else
            ...groups
                .where((group) => group.items.isNotEmpty)
                .map(
                  (group) =>
                      _AppGroupSection(group: group, controller: controller),
                ),
        ],
      );
    });
  }
}
