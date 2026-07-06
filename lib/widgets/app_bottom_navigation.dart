import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onHomeTap;
  final VoidCallback onTasksTap;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onHomeTap,
    required this.onTasksTap,
    required this.onChatTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Tổng quát',
                isSelected: selectedIndex == 0,
                onTap: onHomeTap,
              ),
              _NavItem(
                icon: Icons.work_outline_rounded,
                label: 'Nghiệp vụ',
                isSelected: selectedIndex == 1,
                onTap: onTasksTap,
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Trao đổi',
                isSelected: selectedIndex == 2,
                onTap: onChatTap,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Cá nhân',
                isSelected: selectedIndex == 3,
                onTap: onProfileTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFF2F80ED)
        : const Color(0xFF6B7280);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
