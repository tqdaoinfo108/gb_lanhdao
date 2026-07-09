part of '../home_screen.dart';

class _CompactRow extends StatelessWidget {
  final String title;
  final String note;
  final Widget? leading;
  final Widget? trailing;

  const _CompactRow({
    required this.title,
    required this.note,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 9)],
          Expanded(
            child: _LabelNote(label: title, note: note, large: true),
          ),
          trailing ?? const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _LabelNote extends StatelessWidget {
  final String label;
  final String note;
  final bool large;

  const _LabelNote({
    required this.label,
    required this.note,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: large ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: large ? 14 : 12,
            fontWeight: FontWeight.w800,
            height: 1.22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          note,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(height: 1.3),
        ),
      ],
    );
  }
}

class _MetaTile extends StatelessWidget {
  final String title;
  final String value;

  const _MetaTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: SmartColors.soft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SmartColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: SmartColors.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String note;
  final String state;
  final SmartTone stateTone;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.label,
    required this.note,
    required this.state,
    this.stateTone = SmartTone.neutral,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: _LabelNote(label: label, note: note),
          ),
          const SizedBox(width: 8),
          SmartPill(label: state, tone: stateTone),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _DetailValueRow extends StatelessWidget {
  final String label;
  final String note;
  final String value;

  const _DetailValueRow({
    required this.label,
    required this.note,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _DetailRowBase(
      label: label,
      note: note,
      trailing: Text(
        value,
        textAlign: TextAlign.right,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DetailSwitchRow extends StatelessWidget {
  final String label;
  final String note;
  final bool enabled;

  const _DetailSwitchRow({
    required this.label,
    required this.note,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return _DetailRowBase(
      label: label,
      note: note,
      trailing: Switch.adaptive(
        value: enabled,
        activeThumbColor: SmartColors.accent,
        onChanged: (_) {},
      ),
    );
  }
}

class _DetailRowBase extends StatelessWidget {
  final String label;
  final String note;
  final Widget trailing;

  const _DetailRowBase({
    required this.label,
    required this.note,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SmartColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: _LabelNote(label: label, note: note),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: trailing,
          ),
        ],
      ),
    );
  }
}
