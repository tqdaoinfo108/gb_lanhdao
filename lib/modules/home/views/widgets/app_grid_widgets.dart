part of '../home_screen.dart';

class _AppGroupSection extends StatelessWidget {
  final _AppGroup group;
  final HomeController controller;

  const _AppGroupSection({required this.group, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(group.tone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10, top: 2),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 15,
                decoration: BoxDecoration(
                  color: colors.foreground,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                group.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${group.items.length}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 10.0;
            const columns = 3;
            final tileWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: group.items
                  .map(
                    (item) => SizedBox(
                      width: tileWidth,
                      height: 116,
                      child: _AppGridTile(
                        item: item,
                        tone: group.tone,
                        onTap: item.view == null
                            ? null
                            : () => controller.showView(item.view!),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _AppGridTile extends StatelessWidget {
  final _AppItem item;
  final SmartTone tone;
  final VoidCallback? onTap;

  const _AppGridTile({required this.item, required this.tone, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(tone);
    return SmartCard(
      onTap: onTap,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 96,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        item.icon,
                        size: 26,
                        color: colors.foreground,
                      ),
                    ),
                    if (item.count != null)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: SmartColors.danger,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: SmartColors.surface,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.count!,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    if (item.isInDevelopment)
                      Positioned(
                        top: -6,
                        right: -24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: SmartColors.warning,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Đang phát triển',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 34,
                  child: Center(
                    child: Text(
                      item.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
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
