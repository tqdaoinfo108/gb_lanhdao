import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/digital_map_models.dart';

/// Panel quản lý các layer bản đồ.
class MapLayerPanel extends StatelessWidget {
  final List<MapLayer> layers;
  final ValueChanged<String> onToggle;
  final VoidCallback onClose;

  const MapLayerPanel({
    super.key,
    required this.layers,
    required this.onToggle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [AppColors.mediumShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Row(
              children: [
                const Icon(Icons.layers_rounded,
                    color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text('Lớp bản đồ', style: AppTextStyles.h4),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Layer list
          ...layers.map((layer) => _LayerTile(
                layer: layer,
                onToggle: () => onToggle(layer.id),
              )),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LayerTile extends StatelessWidget {
  final MapLayer layer;
  final VoidCallback onToggle;

  const _LayerTile({required this.layer, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final color = _layerColor(layer.type);
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_layerIcon(layer.type), color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(layer.name, style: AppTextStyles.bodyMedium),
                  Text(
                    '${layer.markerCount} địa điểm',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: layer.isVisible,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.primaryBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Color _layerColor(MapLayerType type) {
    switch (type) {
      case MapLayerType.administrative:
        return AppColors.primaryBlue;
      case MapLayerType.infrastructure:
        return const Color(0xFFFF6B35);
      case MapLayerType.residential:
        return const Color(0xFF7C3AED);
      case MapLayerType.environment:
        return AppColors.successGreen;
      case MapLayerType.utility:
        return const Color(0xFFD97706);
    }
  }

  IconData _layerIcon(MapLayerType type) {
    switch (type) {
      case MapLayerType.administrative:
        return Icons.account_balance_rounded;
      case MapLayerType.infrastructure:
        return Icons.settings_input_component_rounded;
      case MapLayerType.residential:
        return Icons.apartment_rounded;
      case MapLayerType.environment:
        return Icons.eco_rounded;
      case MapLayerType.utility:
        return Icons.local_convenience_store_rounded;
    }
  }
}
