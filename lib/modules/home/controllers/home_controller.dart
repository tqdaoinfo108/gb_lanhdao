import 'package:get/get.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/mock/home_mock_data.dart';

/// Controller (ViewModel) cho màn hình Home.
/// Chỉ chứa logic — không import bất kỳ Widget nào.
class HomeController extends GetxController {
  // ---------------------------------------------------------------------------
  // State (Observable)
  // ---------------------------------------------------------------------------
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // User
  final RxString userName = ''.obs;
  final RxString greeting = ''.obs;
  final RxString dateString = ''.obs;

  // KPI
  final RxList<KpiSummary> kpiSummaries = <KpiSummary>[].obs;

  // Alert
  final Rxn<AlertInfo> alert = Rxn<AlertInfo>();

  // Chart
  final RxList<ChartDataPoint> chartData = <ChartDataPoint>[].obs;

  // AI Insight
  final Rxn<AiInsight> aiInsight = Rxn<AiInsight>();

  // Meetings
  final RxList<MeetingItem> meetings = <MeetingItem>[].obs;
  final RxInt totalMeetings = 0.obs;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    _setGreeting();
    fetchData();
  }

  // ---------------------------------------------------------------------------
  // Methods
  // ---------------------------------------------------------------------------
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulated API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // TODO: Thay bằng Repository call thực tế
      // final result = await _homeRepository.getDashboard();

      // Load từ mock data
      userName.value = HomeMockData.userName;
      kpiSummaries.assignAll(HomeMockData.kpiSummaries);
      alert.value = HomeMockData.alert;
      chartData.assignAll(HomeMockData.weeklyChart);
      aiInsight.value = HomeMockData.aiInsight;
      meetings.assignAll(HomeMockData.meetings);
      totalMeetings.value = HomeMockData.totalMeetings;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------
  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Chào buổi sáng';
    } else if (hour < 18) {
      greeting.value = 'Chào buổi chiều';
    } else {
      greeting.value = 'Chào buổi tối';
    }

    // Format date
    final now = DateTime.now();
    final weekdays = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    final months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
    final weekday = weekdays[now.weekday - 1];
    final day = now.day.toString().padLeft(2, '0');
    final month = months[now.month - 1];
    dateString.value = '$weekday, $day tháng $month, ${now.year}';
  }
}
