import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/localization/app_translations.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'data/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo GetStorage
  await GetStorage.init();

  try {
    await Firebase.initializeApp();
    await PushNotificationService.instance.initialize();
  } catch (error) {
    // iOS cần GoogleService-Info.plist trước khi Firebase có thể khởi tạo.
    debugPrint('[Firebase] Không thể khởi tạo: $error');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ẤP THÔNG MINH',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,

      // Routing
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,

      // Locale (nếu cần i18n sau này)
      locale: const Locale('vi', 'VN'),
      fallbackLocale: const Locale('vi', 'VN'),
      translations: AppTranslations(),

      // Default transition
      defaultTransition: Transition.fadeIn,
    );
  }
}
