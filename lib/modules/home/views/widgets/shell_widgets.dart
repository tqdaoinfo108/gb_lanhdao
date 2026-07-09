part of '../home_screen.dart';

class _SmartBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _SmartBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.dashboard_rounded, 'Tổng quan'),
      (Icons.apps_rounded, 'Ứng dụng'),
      (Icons.person_rounded, 'Tài khoản'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SmartCard(
          radius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = selectedIndex == index;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected
                          ? SmartColors.accentSoft
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index].$1,
                          size: 20,
                          color: selected
                              ? SmartColors.accent
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[index].$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10.5,
                            color: selected
                                ? SmartColors.accent
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
