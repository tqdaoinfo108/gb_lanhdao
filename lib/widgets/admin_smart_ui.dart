import 'package:flutter/material.dart';

import '../core/values/app_colors.dart';
import '../core/values/app_text_styles.dart';

class SmartColors {
  SmartColors._();

  static const Color background = Color(0xFFF7F8FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFCFCFD);
  static const Color soft = Color(0xFFF0F3F8);
  static const Color border = Color(0xFFE1E6EF);
  static const Color accent = Color(0xFF2F65ED);
  static const Color accentSoft = Color(0xFFEAF0FF);
  static const Color danger = Color(0xFFE74C3C);
  static const Color dangerSoft = Color(0xFFFFEFED);
  static const Color success = Color(0xFF17A568);
  static const Color successSoft = Color(0xFFEAF8F1);
  static const Color warning = Color(0xFFD79D10);
  static const Color warningSoft = Color(0xFFFFF7DF);
}

class SmartCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const SmartCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 18,
    this.color,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? SmartColors.cardSurface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? SmartColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF263248).withValues(alpha: 0.055),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return content;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class SmartScreenHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final String? badge;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? backLabel;
  final VoidCallback? onBack;

  const SmartScreenHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.badge,
    this.actionLabel,
    this.onAction,
    this.backLabel,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (backLabel != null)
                SmartTextButton(
                  label: backLabel!,
                  icon: Icons.chevron_left_rounded,
                  onTap: onBack,
                ),
              if (eyebrow != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    eyebrow!,
                    style: AppTextStyles.label.copyWith(
                      color: SmartColors.accent,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 26,
                  height: 1.06,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (badge != null) SmartPill(label: badge!, tone: SmartTone.neutral),
        if (actionLabel != null)
          SmartTextButton(label: actionLabel!, onTap: onAction),
      ],
    );
  }
}

class SmartSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SmartSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          if (actionLabel != null)
            SmartTextButton(label: actionLabel!, onTap: onAction),
        ],
      ),
    );
  }
}

class SmartTextButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const SmartTextButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: icon == null
          ? const SizedBox.shrink()
          : Icon(icon, size: 18, color: SmartColors.accent),
      label: Text(label),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: SmartColors.accent,
        textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

enum SmartTone { neutral, accent, danger, success, warning }

class SmartPill extends StatelessWidget {
  final String label;
  final SmartTone tone;

  const SmartPill({
    super.key,
    required this.label,
    this.tone = SmartTone.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _toneColors(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.$2.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: colors.$2,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class SmartStatGrid extends StatelessWidget {
  final List<SmartStatData> stats;
  final bool compact;

  const SmartStatGrid({super.key, required this.stats, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats
          .map(
            (stat) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: stat == stats.last ? 0 : 8),
                child: SmartCard(
                  radius: compact ? 16 : 18,
                  padding: EdgeInsets.all(compact ? 9 : 10),
                  color: _toneColors(stat.tone).$1 == Colors.transparent
                      ? SmartColors.cardSurface
                      : _toneColors(stat.tone).$1,
                  borderColor: _toneColors(stat.tone).$2.withValues(
                    alpha: stat.tone == SmartTone.neutral ? 0.12 : 0.18,
                  ),
                  child: SizedBox(
                    height: compact ? 50 : 46,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          stat.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h3.copyWith(
                            color: _toneColors(stat.tone).$2,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          stat.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class SmartStatData {
  final String value;
  final String label;
  final SmartTone tone;

  const SmartStatData({
    required this.value,
    required this.label,
    this.tone = SmartTone.neutral,
  });
}

class SmartSearchPanel extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final List<String> chips;
  final String? activeChip;
  final ValueChanged<String>? onChipSelected;
  final String Function(String value)? chipLabelBuilder;

  const SmartSearchPanel({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.chips = const [],
    this.activeChip,
    this.onChipSelected,
    this.chipLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: const EdgeInsets.all(9),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              isDense: true,
              filled: true,
              fillColor: SmartColors.soft,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: SmartColors.accent),
              ),
            ),
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: chips.length,
                separatorBuilder: (context, index) => const SizedBox(width: 7),
                itemBuilder: (context, index) {
                  final chip = chips[index];
                  final selected = chip == activeChip;
                  return ChoiceChip(
                    label: Text(chipLabelBuilder?.call(chip) ?? chip),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => onChipSelected?.call(chip),
                    visualDensity: VisualDensity.compact,
                    labelStyle: AppTextStyles.caption.copyWith(
                      color: selected
                          ? SmartColors.accent
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                    backgroundColor: SmartColors.soft,
                    selectedColor: SmartColors.accentSoft,
                    shape: const StadiumBorder(
                      side: BorderSide(color: Colors.transparent),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SmartIconBadge extends StatelessWidget {
  final String label;
  final SmartTone tone;
  final double size;

  const SmartIconBadge({
    super.key,
    required this.label,
    this.tone = SmartTone.accent,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _toneColors(tone);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(size * 0.38),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: colors.$2,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class SmartProgressBar extends StatelessWidget {
  final double value;
  final SmartTone tone;

  const SmartProgressBar({
    super.key,
    required this.value,
    this.tone = SmartTone.danger,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: 6,
        backgroundColor: SmartColors.soft,
        color: _toneColors(tone).$2,
      ),
    );
  }
}

class SmartPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool secondary;
  final double? width;

  const SmartPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.secondary = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth =
            width ??
            (constraints.maxWidth.isFinite ? constraints.maxWidth : null);
        return SizedBox(
          width: effectiveWidth,
          height: 42,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: secondary
                  ? SmartColors.soft
                  : SmartColors.accent,
              foregroundColor: secondary
                  ? AppColors.textPrimary
                  : AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      },
    );
  }
}

(Color, Color) _toneColors(SmartTone tone) {
  switch (tone) {
    case SmartTone.accent:
      return (SmartColors.accentSoft, SmartColors.accent);
    case SmartTone.danger:
      return (SmartColors.dangerSoft, SmartColors.danger);
    case SmartTone.success:
      return (SmartColors.successSoft, SmartColors.success);
    case SmartTone.warning:
      return (SmartColors.warningSoft, SmartColors.warning);
    case SmartTone.neutral:
      return (SmartColors.surface, AppColors.textSecondary);
  }
}
