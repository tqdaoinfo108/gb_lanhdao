import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_text_styles.dart';

class MeetingBottomNavBar extends StatelessWidget {
  const MeetingBottomNavBar({super.key});

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
          children: [
            _NavItem(icon: Icons.grid_view_rounded, label: 'nav.overview'.tr, active: false),
            _NavItem(icon: Icons.work_outline_rounded, label: 'nav.business'.tr, active: true),
            const SizedBox(width: 30),
            _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'nav.chat'.tr, active: false),
            _NavItem(icon: Icons.person_outline_rounded, label: 'nav.profile'.tr, active: false),
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
