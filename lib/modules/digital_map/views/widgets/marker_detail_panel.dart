import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/digital_map_models.dart';
import '../../controllers/digital_map_controller.dart';

/// Panel chi tiết cho một marker được chọn (hiển thị phía dưới).
class MarkerDetailPanel extends StatelessWidget {
  final MapMarker marker;
  final VoidCallback onDismiss;

  const MarkerDetailPanel({
    super.key,
    required this.marker,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.mediumShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _typeColor(marker.type).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _typeIcon(marker.type),
                        color: _typeColor(marker.type),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(marker.name, style: AppTextStyles.h4),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              _StatusChip(status: marker.status),
                              const SizedBox(width: 8),
                              Text(
                                DigitalMapController.markerTypeLabel(
                                    marker.type),
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onDismiss,
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  marker.description,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textSecondary),
                ),

                // Address
                if (marker.address != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          marker.address!,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ],

                // Phone
                if (marker.phone != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(marker.phone!, style: AppTextStyles.caption),
                    ],
                  ),
                ],

                // Coordinates
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.my_location_rounded,
                        size: 14, color: AppColors.primaryBlue),
                    const SizedBox(width: 6),
                    Text(
                      '${marker.latitude.toStringAsFixed(4)}, '
                      '${marker.longitude.toStringAsFixed(4)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryBlue,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.directions_rounded,
                        label: 'Chỉ đường',
                        color: AppColors.primaryBlue,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.share_rounded,
                        label: 'Chia sẻ',
                        color: AppColors.successGreen,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.info_outline_rounded,
                        label: 'Chi tiết',
                        color: AppColors.warningYellow,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(MapMarkerType type) {
    switch (type) {
      case MapMarkerType.administrative:
        return AppColors.primaryBlue;
      case MapMarkerType.infrastructure:
        return const Color(0xFFFF6B35);
      case MapMarkerType.residential:
        return const Color(0xFF7C3AED);
      case MapMarkerType.greenSpace:
        return AppColors.successGreen;
      case MapMarkerType.medical:
        return AppColors.alertRed;
      case MapMarkerType.education:
        return const Color(0xFFD97706);
      case MapMarkerType.construction:
        return AppColors.warningYellow;
    }
  }

  IconData _typeIcon(MapMarkerType type) {
    switch (type) {
      case MapMarkerType.administrative:
        return Icons.account_balance_rounded;
      case MapMarkerType.infrastructure:
        return Icons.construction_rounded;
      case MapMarkerType.residential:
        return Icons.apartment_rounded;
      case MapMarkerType.greenSpace:
        return Icons.park_rounded;
      case MapMarkerType.medical:
        return Icons.local_hospital_rounded;
      case MapMarkerType.education:
        return Icons.school_rounded;
      case MapMarkerType.construction:
        return Icons.engineering_rounded;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final MapMarkerStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case MapMarkerStatus.active:
        bg = AppColors.successLight;
        fg = AppColors.successGreen;
        label = 'Hoạt động';
        break;
      case MapMarkerStatus.inactive:
        bg = AppColors.divider;
        fg = AppColors.textSecondary;
        label = 'Ngừng HĐ';
        break;
      case MapMarkerStatus.underConstruction:
        bg = AppColors.warningLight;
        fg = const Color(0xFFD97706);
        label = 'Đang XD';
        break;
      case MapMarkerStatus.planned:
        bg = AppColors.primaryBlueLight;
        fg = AppColors.primaryBlue;
        label = 'Quy hoạch';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
