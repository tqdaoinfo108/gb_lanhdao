import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/auth_helper.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/admin_smart_ui.dart';
import '../../../widgets/app_button.dart';
import '../../../data/services/push_notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _apiClient = ApiClient()..onInit();
  static const _authUserName = 'UserAPILeaderDashboard';
  static const _authPassword = 'UserPassAPILeaderDashboard';
  static const _platform = 'Web';
  static const _deviceName = 'Chrome';
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final message = body['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final nestedMessage = data['message'] ?? data['Message'];
        if (nestedMessage is String && nestedMessage.trim().isNotEmpty) {
          return nestedMessage.trim();
        }
      }
    }

    return null;
  }

  String _buildBasicAuthHeader() {
    final credentials = '$_authUserName:$_authPassword';
    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    final email = _emailController.text.trim();

    try {
      final deviceToken =
          await PushNotificationService.instance.getToken() ?? '';
      final response = await _apiClient.post(
        '/user/login',
        {
          'UserName': email,
          'PassWord': _passwordController.text,
          'Token': deviceToken,
          'Platform': _platform,
          'DeviceName': _deviceName,
        },
        headers: {
          'X-Skip-Authorization': 'true',
          'Authorization': _buildBasicAuthHeader(),
        },
      );

      final body = response.body;
      final data = body is Map<String, dynamic> ? body['data'] : null;
      final tokenId = data is Map<String, dynamic> ? data['TokenID'] : null;

      if (!response.isOk || tokenId is! String || tokenId.isEmpty) {
        final message =
            _extractErrorMessage(body) ??
            'Đăng nhập không thành công. Vui lòng kiểm tra lại thông tin.';
        throw Exception(message);
      }

      await AuthHelper.saveToken(tokenId);

      if (!mounted) {
        return;
      }

      Get.offAllNamed(AppRoutes.home);
      return;
    } catch (_) {
      if (!mounted) {
        return;
      }

      Get.snackbar(
        'Không thể đăng nhập',
        'Vui lòng kiểm tra lại thông tin và thử lại.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: AppColors.cardWhite,
        colorText: AppColors.textPrimary,
        borderRadius: 12,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const SmartIconBadge(label: 'G', size: 38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ẤP THÔNG MINH',
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Đăng nhập để tiếp tục',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SmartCard(
                radius: 26,
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: SmartColors.accentSoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.admin_panel_settings_rounded,
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cổng quản trị nội bộ',
                                    style: AppTextStyles.h4.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Dùng email công vụ và mật khẩu để vào hệ thống.',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tên đăng nhập',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên đăng nhập',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) {
                          final userName = value?.trim() ?? '';
                          if (userName.isEmpty) {
                            return 'Vui lòng nhập tên đăng nhập';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Mật khẩu',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          hintText: 'Nhập mật khẩu',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) {
                          final password = value ?? '';
                          if (password.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          if (password.length < 6) {
                            return 'Mật khẩu tối thiểu 6 ký tự';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      AppButton(
                        label: 'Đăng nhập',
                        isLoading: _isSubmitting,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Hãy dùng tên đăng nhập và mật khẩu được cấp để đăng nhập.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SmartCard(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: SmartColors.accentSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: SmartColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Đăng nhập để tiếp tục sử dụng các chức năng quản lý.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
