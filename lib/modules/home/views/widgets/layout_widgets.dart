part of '../home_screen.dart';

class _ScreenStack extends StatelessWidget {
  final List<Widget> children;

  const _ScreenStack({required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withGaps(children),
      ),
    );
  }
}

List<Widget> _withGaps(List<Widget> children) {
  final result = <Widget>[];
  for (var index = 0; index < children.length; index++) {
    if (index > 0) {
      result.add(const SizedBox(height: 10));
    }
    result.add(children[index]);
  }
  return result;
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _QuickAction({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SmartCard(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: SmartColors.accentSoft,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 18, color: SmartColors.accent),
                ),
                const SizedBox(height: 7),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
