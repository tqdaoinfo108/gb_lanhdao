part of '../home_screen.dart';

class _ResidenceChangeScreen extends StatelessWidget {
  final HomeController controller;
  const _ResidenceChangeScreen({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isResidenceChangeFormOpen.value) {
      return _ResidenceChangeForm(controller: controller);
    }
    final page = controller.registerHouseHoldPage.value;
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Ứng dụng',
          onBack: () => controller.showView(AdminSmartView.apps),
          eyebrow: 'Dịch vụ hộ dân cư',
          title: 'Biến động dân cư',
          badge: '${page.totals} hồ sơ',
          actionLabel: 'Làm mới',
          onAction: controller.fetchResidenceChanges,
        ),
        if (controller.isResidenceChangeLoading.value)
          const LinearProgressIndicator(),
        if (controller.residenceChangeMessage.value != null)
          _ResidenceChangeNotice(
            message: controller.residenceChangeMessage.value!,
            success: true,
          ),
        if (controller.residenceChangeError.value != null)
          _InlineError(
            message: controller.residenceChangeError.value!,
            onRetry: controller.fetchResidenceChanges,
          ),
        _ResidenceChangeIntro(
          householdName: controller.profile.value.householdName,
          onCreate: controller.openResidenceChangeForm,
        ),
        _ResidenceChangeFilters(controller: controller),
        if (!controller.isResidenceChangeLoading.value && page.items.isEmpty)
          _ResidenceChangeEmpty(onCreate: controller.openResidenceChangeForm)
        else
          ...page.items.map(
            (item) => _ResidenceChangeItemCard(
              item: item,
              onEdit: () => controller.openResidenceChangeForm(item),
              onDelete: () => _confirmResidenceChangeDelete(
                context,
                controller: controller,
                item: item,
              ),
            ),
          ),
      ],
    );
  });
}

class _ResidenceChangeIntro extends StatelessWidget {
  final String householdName;
  final VoidCallback onCreate;
  const _ResidenceChangeIntro({
    required this.householdName,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) => SmartCard(
    radius: 20,
    color: SmartColors.accentSoft,
    borderColor: SmartColors.accent.withValues(alpha: 0.2),
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SmartColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                color: SmartColors.accent,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                householdName.trim().isEmpty
                    ? 'Hồ sơ biến động của hộ gia đình'
                    : householdName.trim(),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Khai báo thay đổi nhân khẩu để địa phương tiếp nhận và xác minh.',
          style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SmartPrimaryButton(label: 'Tạo khai báo mới', onTap: onCreate),
      ],
    ),
  );
}

class _ResidenceChangeFilters extends StatelessWidget {
  final HomeController controller;
  const _ResidenceChangeFilters({required this.controller});

  @override
  Widget build(BuildContext context) => SmartCard(
    padding: const EdgeInsets.all(9),
    child: Row(
      children: [
        const Icon(Icons.filter_list_rounded, color: SmartColors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: controller.residenceChangeTypeFilter.value,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Tất cả biến động')),
                DropdownMenuItem(value: 1, child: Text('Khai sinh')),
                DropdownMenuItem(value: 2, child: Text('Báo tử')),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.setResidenceChangeTypeFilter(value);
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}

class _ResidenceChangeEmpty extends StatelessWidget {
  final VoidCallback onCreate;
  const _ResidenceChangeEmpty({required this.onCreate});

  @override
  Widget build(BuildContext context) => SmartCard(
    padding: const EdgeInsets.all(22),
    child: Column(
      children: [
        const Icon(Icons.note_add_rounded, size: 36, color: SmartColors.accent),
        const SizedBox(height: 10),
        Text(
          'Chưa có khai báo',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Tạo khai báo khi hộ gia đình có biến động nhân khẩu.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 12),
        SmartTextButton(label: 'Tạo khai báo', onTap: onCreate),
      ],
    ),
  );
}

class _ResidenceChangeItemCard extends StatelessWidget {
  final RegisterHouseHoldItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ResidenceChangeItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final type = ResidenceChangeType.values
        .where((value) => value.typeRegisterId == item.typeRegisterId)
        .firstOrNull;
    final title = item.fullName.trim().isEmpty
        ? 'Chưa có họ tên'
        : item.fullName;
    final typeName = item.typeRegisterName.trim().isNotEmpty
        ? item.typeRegisterName
        : type?.label ?? 'Loại #${item.typeRegisterId}';
    final isDeath =
        item.typeRegisterId == ResidenceChangeType.death.typeRegisterId;
    return SmartCard(
      radius: 18,
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDeath
                  ? SmartColors.warningSoft
                  : SmartColors.successSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isDeath
                  ? Icons.volunteer_activism_outlined
                  : Icons.child_care_rounded,
              color: isDeath ? SmartColors.warning : SmartColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    SmartPill(
                      label: typeName,
                      tone: isDeath ? SmartTone.warning : SmartTone.success,
                    ),
                    if (item.statusName.trim().isNotEmpty)
                      SmartPill(
                        label: item.statusName,
                        tone: SmartTone.neutral,
                      ),
                  ],
                ),
                if (item.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(item.description.trim(), style: AppTextStyles.caption),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    SmartTextButton(
                      label: 'Chỉnh sửa',
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 18),
                    SmartTextButton(
                      label: 'Xóa',
                      icon: Icons.delete_outline_rounded,
                      onTap: onDelete,
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
}

class _ResidenceChangeForm extends StatelessWidget {
  final HomeController controller;
  const _ResidenceChangeForm({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
    final editing = controller.editingRegisterHouseHold.value;
    final selectedType = controller.selectedResidenceChangeType.value;
    final error = controller.residenceChangeError.value;
    final isSaving = controller.isResidenceChangeSaving.value;
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Danh sách',
          onBack: controller.closeResidenceChangeForm,
          eyebrow: editing == null ? 'Khai báo mới' : 'Cập nhật khai báo',
          title: editing == null ? 'Biến động dân cư' : 'Chỉnh sửa biến động',
        ),
        SmartCard(
          radius: 20,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ResidenceChangeFieldLabel(
                label: 'Họ và tên người được khai báo',
              ),
              const SizedBox(height: 7),
              TextField(
                controller: controller.residenceChangeFullNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: (_) => controller.residenceChangeError.value = null,
                decoration: _residenceChangeInput(
                  'Nhập đầy đủ họ và tên',
                  Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: 18),
              const _ResidenceChangeFieldLabel(label: 'Loại biến động'),
              const SizedBox(height: 8),
              ...ResidenceChangeType.values.map(
                (type) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ResidenceChangeTypeTile(
                    type: type,
                    selected: selectedType == type,
                    onTap: () => controller.selectResidenceChangeType(type),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const _ResidenceChangeFieldLabel(label: 'Nội dung / ghi chú'),
              const SizedBox(height: 7),
              TextField(
                controller: controller.residenceChangeDescriptionController,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => controller.residenceChangeError.value = null,
                decoration: _residenceChangeInput(
                  'Nhập thông tin bổ sung (nếu có)',
                  Icons.notes_outlined,
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                _ResidenceChangeNotice(message: error, success: false),
              ],
              const SizedBox(height: 14),
              SmartPrimaryButton(
                label: isSaving
                    ? 'Đang lưu...'
                    : editing == null
                    ? 'Gửi khai báo'
                    : 'Lưu thay đổi',
                onTap: isSaving ? null : controller.submitResidenceChange,
              ),
            ],
          ),
        ),
        Text(
          'Thông tin được gửi tới cơ quan có thẩm quyền để tiếp nhận và xác minh.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ],
    );
  });
}

class _ResidenceChangeFieldLabel extends StatelessWidget {
  final String label;
  const _ResidenceChangeFieldLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(
    label,
    style: AppTextStyles.caption.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w800,
    ),
  );
}

InputDecoration _residenceChangeInput(String hint, IconData icon) =>
    InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: SmartColors.soft,
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
        borderSide: const BorderSide(color: SmartColors.accent, width: 1.4),
      ),
    );

class _ResidenceChangeTypeTile extends StatelessWidget {
  final ResidenceChangeType type;
  final bool selected;
  final VoidCallback onTap;
  const _ResidenceChangeTypeTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBirth = type == ResidenceChangeType.birth;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? SmartColors.accentSoft : SmartColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? SmartColors.accent : SmartColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isBirth
                    ? Icons.child_care_rounded
                    : Icons.volunteer_activism_outlined,
                color: selected ? SmartColors.accent : AppColors.textSecondary,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(type.description, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? SmartColors.accent : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResidenceChangeNotice extends StatelessWidget {
  final String message;
  final bool success;
  const _ResidenceChangeNotice({required this.message, required this.success});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: success ? SmartColors.successSoft : SmartColors.warningSoft,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: (success ? SmartColors.success : SmartColors.warning).withValues(
          alpha: 0.26,
        ),
      ),
    ),
    child: Row(
      children: [
        Icon(
          success
              ? Icons.check_circle_outline_rounded
              : Icons.info_outline_rounded,
          color: success ? SmartColors.success : SmartColors.warning,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _confirmResidenceChangeDelete(
  BuildContext context, {
  required HomeController controller,
  required RegisterHouseHoldItem item,
}) async {
  final accepted = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xóa khai báo?'),
      content: Text(
        'Khai báo của ${item.fullName.isEmpty ? 'người này' : item.fullName} sẽ bị xóa.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Xóa'),
        ),
      ],
    ),
  );
  if (accepted == true) await controller.deleteResidenceChange(item);
}
