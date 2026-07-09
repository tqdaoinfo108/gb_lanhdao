part of '../home_screen.dart';

class _AccountScreen extends StatelessWidget {
  final HomeController controller;

  const _AccountScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        const SmartScreenHeader(
          eyebrow: 'Cá nhân',
          title: 'Tài khoản',
          actionLabel: 'Đăng xuất',
        ),
        Obx(() {
          final profile = controller.profile.value;
          return SmartCard(
            radius: 22,
            borderColor: SmartColors.accent.withValues(alpha: 0.18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SmartIconBadge(
                      label: profile.userId == 0 ? 'AD' : profile.initials,
                      size: 42,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LabelNote(
                        label: profile.fullName.isEmpty
                            ? 'Đang tải...'
                            : profile.fullName,
                        note: [
                          if (profile.positionName.isNotEmpty)
                            profile.positionName,
                          if (profile.departmentName.isNotEmpty)
                            profile.departmentName,
                        ].join(' · '),
                      ),
                    ),
                    SmartPill(
                      label: profile.statusName.isEmpty
                          ? 'Đang trực'
                          : profile.statusName,
                      tone: profile.isActive
                          ? SmartTone.success
                          : SmartTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(
                      child: _MetaTile(
                        title: 'Đơn vị',
                        value: profile.departmentName.isEmpty
                            ? '—'
                            : profile.departmentName,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetaTile(
                        title: 'Chức danh',
                        value: profile.positionName.isEmpty
                            ? '—'
                            : profile.positionName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                const SmartStatGrid(
                  compact: true,
                  stats: [
                    SmartStatData(value: '7', label: 'Việc chờ xử lý'),
                    SmartStatData(value: '4', label: 'Công văn mới'),
                    SmartStatData(value: '2', label: 'Thông báo khẩn'),
                  ],
                ),
              ],
            ),
          );
        }),
        Row(
          children: [
            _QuickAction(
              label: 'Cập nhật hồ sơ',
              icon: Icons.badge_outlined,
              onTap: controller.openProfileDetail,
            ),
            const _QuickAction(
              label: 'Đổi mật khẩu',
              icon: Icons.lock_reset_rounded,
            ),
            const _QuickAction(
              label: 'Ủy quyền xử lý',
              icon: Icons.how_to_reg_outlined,
            ),
          ],
        ),
        const SmartCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SmartSectionHeader(
                title: 'Phiên đăng nhập',
                actionLabel: 'Tin cậy',
              ),
              SizedBox(height: 9),
              _CompactRow(
                title: 'Thiết bị hiện tại',
                note: 'Mobile app · Cập nhật 20:48 hôm nay',
                leading: SmartIconBadge(
                  label: 'IP',
                  tone: SmartTone.success,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        _SettingRow(
          label: 'Thông tin cá nhân',
          note: 'Số điện thoại, email công vụ, chức danh',
          state: 'Đủ',
          stateTone: SmartTone.success,
          onTap: controller.openProfileDetail,
        ),
        _SettingRow(
          label: 'Thông báo',
          note: 'Cảnh báo quá hạn, công văn, lịch họp',
          state: '2 mới',
          stateTone: SmartTone.warning,
          onTap: () =>
              controller.showView(AdminSmartView.accountNotificationDetail),
        ),
        _SettingRow(
          label: 'Bảo mật',
          note: 'Mật khẩu, xác thực, phiên đăng nhập',
          state: '2FA',
          stateTone: SmartTone.success,
          onTap: () =>
              controller.showView(AdminSmartView.accountSecurityDetail),
        ),
        _SettingRow(
          label: 'Đồng bộ dữ liệu',
          note: 'Dữ liệu nội bộ đã đồng bộ đầy đủ',
          state: '20:48',
          stateTone: SmartTone.success,
          onTap: () => controller.showView(AdminSmartView.accountSyncDetail),
        ),
      ],
    );
  }
}

class _ProfileDetailScreen extends StatelessWidget {
  final HomeController controller;

  const _ProfileDetailScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profile.value;
      final loading = controller.isProfileLoading.value;
      final saving = controller.isProfileSaving.value;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Tài khoản',
            onBack: () => controller.showView(AdminSmartView.account),
            title: 'Thông tin cá nhân',
            badge: profile.statusName.isEmpty ? 'Hồ sơ' : profile.statusName,
            actionLabel: 'Làm mới',
            onAction: controller.fetchProfile,
          ),
          if (loading) const LinearProgressIndicator(),
          if (controller.profileError.value != null)
            _InlineError(
              message: controller.profileError.value!,
              onRetry: controller.fetchProfile,
            ),
          if (controller.profileMessage.value != null)
            _InlineSuccess(message: controller.profileMessage.value!),

          // Thông tin chỉ đọc (do hệ thống quản lý)
          SmartCard(
            radius: 22,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SmartIconBadge(
                      label: profile.userId == 0 ? 'U' : profile.initials,
                      size: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabelNote(
                        label: profile.fullName.isEmpty
                            ? 'Chưa có tên'
                            : profile.fullName,
                        note: profile.userName.isEmpty
                            ? 'Tài khoản hệ thống'
                            : '@${profile.userName}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _DetailValueRow(
                  label: 'Chức danh',
                  note: 'Vai trò hành chính hiện tại',
                  value: profile.positionName.isEmpty
                      ? '—'
                      : profile.positionName,
                ),
                _DetailValueRow(
                  label: 'Đơn vị',
                  note: 'Phạm vi công tác',
                  value: profile.departmentName.isEmpty
                      ? '—'
                      : profile.departmentName,
                ),
                _DetailValueRow(
                  label: 'Trạng thái',
                  note: 'Tình trạng tài khoản',
                  value: profile.statusName.isEmpty ? '—' : profile.statusName,
                ),
              ],
            ),
          ),

          // Thông tin có thể cập nhật
          SmartCard(
            radius: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thông tin liên hệ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                _ProfileTextField(
                  label: 'Họ và tên *',
                  hint: 'Nhập họ tên',
                  controller: controller.profileFullNameController,
                ),
                _ProfileTextField(
                  label: 'Email',
                  hint: 'email@donvi.vn',
                  controller: controller.profileEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                _ProfileTextField(
                  label: 'Số điện thoại',
                  hint: 'Số liên hệ',
                  controller: controller.profilePhoneController,
                  keyboardType: TextInputType.phone,
                ),
                _ProfileTextField(
                  label: 'Địa chỉ',
                  hint: 'Địa chỉ liên hệ',
                  controller: controller.profileAddressController,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _ProfileGenderSelector(controller: controller),
                const SizedBox(height: 12),
                _ProfileBirthdayField(controller: controller),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SmartPrimaryButton(
                  label: 'Hủy',
                  secondary: true,
                  onTap: saving
                      ? null
                      : () => controller.showView(AdminSmartView.account),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SmartPrimaryButton(
                  label: saving ? 'Đang lưu...' : 'Cập nhật',
                  onTap: saving ? null : controller.updateProfile,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ProfileTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  const _ProfileTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class _ProfileGenderSelector extends StatelessWidget {
  final HomeController controller;

  const _ProfileGenderSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    const options = [(1, 'Nam'), (2, 'Nữ'), (3, 'Khác')];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giới tính',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => Row(
            children: options.map((option) {
              final selected =
                  controller.selectedProfileGenderId.value == option.$1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: option == options.last ? 0 : 8,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () =>
                        controller.selectedProfileGenderId.value = option.$1,
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? SmartColors.accentSoft
                            : SmartColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? SmartColors.accent
                              : SmartColors.border,
                        ),
                      ),
                      child: Text(
                        option.$2,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? SmartColors.accent
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProfileBirthdayField extends StatelessWidget {
  final HomeController controller;

  const _ProfileBirthdayField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày sinh',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final date = controller.selectedProfileBirthday.value;
          final label = date == null
              ? 'Chọn ngày sinh'
              : '${date.day.toString().padLeft(2, '0')}/'
                    '${date.month.toString().padLeft(2, '0')}/${date.year}';
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime(1990, 1, 1),
                firstDate: DateTime(1920),
                lastDate: now,
              );
              if (picked != null) {
                controller.selectedProfileBirthday.value = picked;
              }
            },
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: SmartColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SmartColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: SmartColors.accent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.body.copyWith(
                        color: date == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _AccountDetailScreen extends StatelessWidget {
  final HomeController controller;
  final String title;
  final String state;
  final SmartTone stateTone;
  final List<Widget> rows;
  final List<Widget> extra;
  final String? secondaryAction;
  final String? primaryAction;

  const _AccountDetailScreen({
    required this.controller,
    required this.title,
    required this.state,
    required this.stateTone,
    required this.rows,
    this.extra = const [],
    this.secondaryAction,
    this.primaryAction,
  });

  factory _AccountDetailScreen.notifications({
    required HomeController controller,
  }) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Thông báo',
      state: '2 mới',
      stateTone: SmartTone.warning,
      rows: const [
        _DetailSwitchRow(
          label: 'Cảnh báo quá hạn',
          note: 'Nhiệm vụ sắp hoặc đã quá hạn',
          enabled: true,
        ),
        _DetailSwitchRow(
          label: 'Công văn mới',
          note: 'Văn bản cần xử lý hoặc theo dõi',
          enabled: true,
        ),
        _DetailSwitchRow(
          label: 'Lịch họp',
          note: 'Nhắc trước giờ họp và tài liệu',
          enabled: true,
        ),
        _DetailSwitchRow(
          label: 'Thông báo yên lặng',
          note: '22:00 đến 06:00 hôm sau',
        ),
      ],
      extra: const [
        _SettingRow(
          label: '24 nhiệm vụ đã leo thang',
          note: 'Đã gửi cảnh báo lên cấp trên',
          state: 'Mới',
          stateTone: SmartTone.warning,
        ),
        _SettingRow(
          label: '4 công văn mới',
          note: 'Chờ phân công xử lý',
          state: 'Hôm nay',
        ),
      ],
    );
  }

  factory _AccountDetailScreen.security({required HomeController controller}) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Bảo mật',
      state: '2FA',
      stateTone: SmartTone.success,
      rows: const [
        _DetailSwitchRow(
          label: 'Xác thực 2 lớp',
          note: 'Yêu cầu mã xác thực khi đăng nhập',
          enabled: true,
        ),
        _DetailValueRow(
          label: 'Đổi mật khẩu',
          note: 'Lần đổi gần nhất 12/06/2026',
          value: '›',
        ),
        _DetailValueRow(
          label: 'Thiết bị tin cậy',
          note: 'Mobile app đang sử dụng',
          value: '1',
        ),
        _DetailSwitchRow(
          label: 'Tự khóa phiên',
          note: 'Sau 15 phút không hoạt động',
          enabled: true,
        ),
      ],
      secondaryAction: 'Đăng xuất thiết bị khác',
      primaryAction: 'Lưu',
    );
  }

  factory _AccountDetailScreen.sync({required HomeController controller}) {
    return _AccountDetailScreen(
      controller: controller,
      title: 'Đồng bộ dữ liệu',
      state: '20:48',
      stateTone: SmartTone.success,
      rows: const [
        _DetailValueRow(
          label: 'Trạng thái',
          note: 'Dữ liệu nội bộ đã đồng bộ đầy đủ',
          value: 'Hoàn tất',
        ),
        _DetailValueRow(
          label: 'Nhiệm vụ',
          note: 'Danh sách giao việc và kết luận',
          value: '29',
        ),
        _DetailValueRow(
          label: 'Văn bản',
          note: 'Công văn và thông báo liên quan',
          value: '4',
        ),
        _DetailSwitchRow(
          label: 'Tự đồng bộ',
          note: 'Khi có kết nối mạng ổn định',
          enabled: true,
        ),
      ],
      secondaryAction: 'Xem lịch sử',
      primaryAction: 'Đồng bộ ngay',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ScreenStack(
      children: [
        SmartScreenHeader(
          backLabel: 'Tài khoản',
          onBack: () => controller.showView(AdminSmartView.account),
          title: title,
          badge: state,
        ),
        SmartCard(radius: 22, child: Column(mainAxisSize: MainAxisSize.min, children: rows)),
        ...extra,
        if (secondaryAction != null || primaryAction != null)
          Row(
            children: [
              if (secondaryAction != null)
                Expanded(
                  child: SmartPrimaryButton(
                    label: secondaryAction!,
                    secondary: true,
                  ),
                ),
              if (secondaryAction != null && primaryAction != null)
                const SizedBox(width: 8),
              if (primaryAction != null)
                Expanded(child: SmartPrimaryButton(label: primaryAction!)),
            ],
          ),
      ],
    );
  }
}
