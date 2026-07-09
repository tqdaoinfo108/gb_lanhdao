part of '../home_screen.dart';

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      borderColor: SmartColors.warning.withValues(alpha: 0.3),
      color: SmartColors.warningSoft,
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: SmartColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

class _InlineSuccess extends StatelessWidget {
  final String message;

  const _InlineSuccess({required this.message});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      borderColor: SmartColors.success.withValues(alpha: 0.24),
      color: SmartColors.successSoft,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: SmartColors.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
