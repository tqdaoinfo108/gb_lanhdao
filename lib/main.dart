import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/localization/app_translations.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo GetStorage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GB Lãnh Đạo',
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
