import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/auth_helper.dart';

import '../../../data/models/agency_models.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/models/digital_map_models.dart';
import '../../../data/models/kpi_models.dart';
import '../../../data/models/office_models.dart';
import '../../../data/models/process_models.dart';
import '../../../data/models/user_profile_models.dart';
import '../../../data/models/urgent_alert_models.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../data/models/crime_report_models.dart';
import '../../../data/services/file_upload_service.dart';
import '../../../data/models/work_calendar_models.dart';
import '../../../data/repositories/agency_repository.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/digital_map_repository.dart';
import '../../../data/repositories/kpi_repository.dart';
import '../../../data/repositories/office_repository.dart';
import '../../../data/repositories/process_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/urgent_alert_repository.dart';
import '../../../data/repositories/crime_report_repository.dart';
import '../../../data/repositories/work_calendar_repository.dart';
import '../../../data/models/booking_models.dart';

enum AdminSmartView {
  overview,
  apps,
  crimeReports,
  crimeReportNew,
  aiAssistant,
  digitalMap,
  kpiPrograms,
  urgentAlerts,
  tasks,
  periodicReport,
  meetingSchedule,
  workCalendar,
  workCalendarDetail,
  agencies,
  processCreate,
  account,
  accountProfileDetail,
  accountNotificationDetail,
  accountSecurityDetail,
  accountSyncDetail,
}

enum WorkCalendarViewMode { day, week, month }

class HomeController extends GetxController {
  final DashboardRepository _dashboardRepository;
  final ProcessRepository _processRepository;
  final AgencyRepository _agencyRepository;
  final DigitalMapRepository _digitalMapRepository;
  final OfficeRepository _officeRepository;
  final KpiRepository _kpiRepository;
  final ProfileRepository _profileRepository;
  UrgentAlertRepository? _urgentAlertRepository;
  CrimeReportRepository? _crimeReportRepository;
  final WorkCalendarRepository _workCalendarRepository;

  HomeController({
    DashboardRepository? dashboardRepository,
    ProcessRepository? processRepository,
    AgencyRepository? agencyRepository,
    DigitalMapRepository? digitalMapRepository,
    OfficeRepository? officeRepository,
    KpiRepository? kpiRepository,
    ProfileRepository? profileRepository,
    UrgentAlertRepository? urgentAlertRepository,
    CrimeReportRepository? crimeReportRepository,
    WorkCalendarRepository? workCalendarRepository,
  }) : _dashboardRepository = dashboardRepository ?? DashboardRepository(),
       _processRepository = processRepository ?? ProcessRepository(),
       _agencyRepository = agencyRepository ?? AgencyRepository(),
       _digitalMapRepository = digitalMapRepository ?? DigitalMapRepository(),
       _officeRepository = officeRepository ?? OfficeRepository(),
       _kpiRepository = kpiRepository ?? KpiRepository(),
       _profileRepository = profileRepository ?? ProfileRepository(),
       _urgentAlertRepository = urgentAlertRepository,
       _crimeReportRepository = crimeReportRepository,
       _workCalendarRepository =
           workCalendarRepository ?? WorkCalendarRepository();

  UrgentAlertRepository get _urgentAlerts =>
      _urgentAlertRepository ??= UrgentAlertRepository();

  CrimeReportRepository get _crimeReports =>
      _crimeReportRepository ??= CrimeReportRepository();

  final currentView = AdminSmartView.overview.obs;
  final isDashboardLoading = false.obs;
  final dashboardError = RxnString();
  final dashboard = DashboardBundle.empty().obs;
  final periodicReport = PeriodicReportBundle.empty().obs;
  final meetingHub = MeetingHubBundle.empty().obs;
  final agencyBundle = AgencyBundle.empty().obs;
  final digitalMapBundle = DigitalMapBundle.empty().obs;
  final officeBundle = OfficeBundle.empty().obs;
  final kpiBundle = KpiBundle.empty().obs;
  final processDropdowns = ProcessDropdownBundle.empty().obs;
  final profile = UserProfile.empty().obs;
  final urgentAlertBundle = UrgentAlertBundle.empty().obs;
  final crimeReportBundle = CrimeReportBundle.empty().obs;
  final isCrimeReportLoading = false.obs;
  final crimeReportError = RxnString();
  final crimeStatusFilter = (-100).obs;
  final crimeTypeFilter = 0.obs;
  final isCrimeAiAnalyzing = false.obs;
  final isCrimeSubmitting = false.obs;
  final crimeFormError = RxnString();
  final crimeCreateMessage = RxnString();
  final crimeAiAnalysis = Rxn<WarningAiAnalysis>();
  final crimeAttachmentPaths = <String>[].obs;
  final isProfileLoading = false.obs;
  final isProfileSaving = false.obs;
  final profileError = RxnString();
  final isUploading = false.obs;
  final profileMessage = RxnString();
  final selectedProfileGenderId = 1.obs;
  final selectedProfileBirthday = Rxn<DateTime>();

  // Lịch công tác chung
  final workCalendar = WorkCalendarBundle.empty().obs;
  final isWorkCalendarLoading = false.obs;
  final workCalendarError = RxnString();
  final workCalendarViewMode = WorkCalendarViewMode.day.obs;
  final workCalendarAnchor = DateTime.now().obs;
  final workCalendarTypeFilter = 0.obs; // 0 = tất cả
  final workCalendarRoomFilter = 0.obs; // 0 = tất cả
  final workCalendarStatusFilter = (-100).obs; // -100 = tất cả
  final selectedBooking = Rxn<BookingModel>();

  final isPeriodicReportLoading = false.obs;
  final isMeetingLoading = false.obs;
  final isAgencyLoading = false.obs;
  final isDigitalMapLoading = false.obs;
  final isOfficeLoading = false.obs;
  final isKpiLoading = false.obs;
  final isProcessDropdownLoading = false.obs;
  final isProcessCreating = false.obs;
  final isUrgentAlertLoading = false.obs;
  final periodicReportError = RxnString();
  final meetingError = RxnString();
  final agencyError = RxnString();
  final digitalMapError = RxnString();
  final officeError = RxnString();
  final kpiError = RxnString();
  final processFormError = RxnString();
  final urgentAlertError = RxnString();
  final processCreateMessage = RxnString();
  final taskStatus = 'all'.obs;
  final urgentFilter = 'all'.obs;
  final urgentGroupFilter = 0.obs;
  final urgentStatusFilter = (-100).obs;
  final agencyStatusFilter = (-100).obs;
  final digitalMapTypeFilter = 0.obs;
  final digitalMapVillageFilter = 0.obs;
  final digitalMapBoundaryVisible = true.obs;
  final digitalMapOfficesVisible = true.obs;
  final officeStatusFilter = (-100).obs;
  final officeTypeFilter = 0.obs;
  final kpiStatusFilter = (-100).obs;
  final appQuery = ''.obs;
  final taskQuery = ''.obs;
  final crimeQuery = ''.obs;
  final mapQuery = ''.obs;
  final kpiQuery = ''.obs;
  final urgentQuery = ''.obs;
  final agencyQuery = ''.obs;
  final officeQuery = ''.obs;
  final anonymousReport = false.obs;
  final aiPrompt = ''.obs;
  final aiDraft =
      'AI có thể mắc lỗi. Vui lòng kiểm tra thông tin quan trọng.'.obs;

  final overviewDepartmentLimit = 3.obs;
  final overviewKpiLimit = 5.obs;
  final overviewActiveUserLimit = 3.obs;
  final periodicItemLimit = 5.obs;
  final periodicTrendLimit = 4.obs;
  final periodicNotificationLimit = 5.obs;
  final meetingRoomLimit = 4.obs;
  final meetingUserLimit = 5.obs;
  final meetingBookingLimit = 5.obs;
  final crimeReportLimit = 3.obs;
  final urgentAlertLimit = 5.obs;
  final taskLimit = 3.obs;

  final appSearchController = TextEditingController();
  final taskSearchController = TextEditingController();
  final crimeSearchController = TextEditingController();
  final mapSearchController = TextEditingController();
  final kpiSearchController = TextEditingController();
  final urgentSearchController = TextEditingController();
  final agencySearchController = TextEditingController();
  final officeSearchController = TextEditingController();
  final aiPromptController = TextEditingController();
  final crimeNameController = TextEditingController();
  final crimePhoneController = TextEditingController();
  final crimeTitleController = TextEditingController();
  final crimeDescriptionController = TextEditingController();
  final crimeAddressController = TextEditingController();
  final processTitleController = TextEditingController();
  final processDescriptionController = TextEditingController();
  final processAttachmentController = TextEditingController();

  final profileFullNameController = TextEditingController();
  final profileEmailController = TextEditingController();
  final profilePhoneController = TextEditingController();
  final profileAddressController = TextEditingController();

  final selectedProcessUser = Rxn<ProcessUserOption>();
  final selectedProcessLevel = Rxn<ProcessLevelOption>();
  final selectedProcessSourceType = Rxn<ProcessSourceTypeOption>();
  final selectedProcessBooking = Rxn<ProcessBookingOption>();
  final selectedProcessConclusion = Rxn<ProcessConclusionOption>();
  final selectedProcessDocument = Rxn<ProcessDocumentOption>();
  final selectedProcessKpi = Rxn<ProcessKpiOption>();
  final selectedProcessDueDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
    fetchPeriodicReport();
    fetchMeetingHub();
    fetchAgencies();
    fetchDigitalMap();
    fetchOffices();
    fetchKpiPrograms();
    fetchUrgentAlerts();
    fetchProfile();
  }

  Future<void> fetchUrgentAlerts() async {
    isUrgentAlertLoading.value = true;
    urgentAlertError.value = null;
    try {
      urgentAlertBundle.value = await _urgentAlerts.getBundle(
        key: urgentQuery.value.trim(),
        statusId: urgentStatusFilter.value,
      );
    } catch (e) {
      urgentAlertError.value = 'Không tải được thông báo khẩn: $e';
    } finally {
      isUrgentAlertLoading.value = false;
    }
  }

  void searchUrgentAlerts(String value) {
    urgentQuery.value = value;
    fetchUrgentAlerts();
  }

  void setUrgentGroupFilter(int groupId) {
    urgentGroupFilter.value = groupId;
  }

  void setUrgentStatusFilter(int statusId) {
    urgentStatusFilter.value = statusId;
    fetchUrgentAlerts();
  }

  void clearUrgentFilters() {
    urgentFilter.value = 'all';
    urgentGroupFilter.value = 0;
    urgentStatusFilter.value = -100;
    fetchUrgentAlerts();
  }

  List<InformationItem> filteredUrgentInformation() {
    final query = urgentQuery.value.trim().toLowerCase();
    return urgentAlertBundle.value.information.items.where((item) {
      if (urgentFilter.value == 'urgent' && !item.isUrgent) return false;
      if (urgentFilter.value == 'unread' && item.isRead) return false;
      if (urgentGroupFilter.value != 0 &&
          !item.groupIds.contains(urgentGroupFilter.value)) {
        return false;
      }
      if (query.isNotEmpty) {
        final haystack =
            '${item.title} ${item.shortDescription} ${item.description}'
                .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList()..sort((a, b) {
      final first = a.timeSet ?? DateTime(1900);
      final second = b.timeSet ?? DateTime(1900);
      return second.compareTo(first);
    });
  }

  Future<void> fetchProfile() async {
    isProfileLoading.value = true;
    profileError.value = null;
    profileMessage.value = null;
    try {
      final result = await _profileRepository.getProfile();
      profile.value = result;
      _syncProfileForm(result);

      // Save for upload headers
      await AuthHelper.saveUserInfo(
        result.userId,
        result.userName,
        result.userTypeId,
      );
    } catch (e) {
      profileError.value = 'Không tải được thông tin cá nhân: $e';
    } finally {
      isProfileLoading.value = false;
    }
  }

  void openProfileDetail() {
    _syncProfileForm(profile.value);
    profileMessage.value = null;
    profileError.value = null;
    showView(AdminSmartView.accountProfileDetail);
    if (profile.value.userId == 0 && !isProfileLoading.value) {
      fetchProfile();
    }
  }

  void _syncProfileForm(UserProfile source) {
    profileFullNameController.text = source.fullName;
    profileEmailController.text = source.email;
    profilePhoneController.text = source.phone;
    profileAddressController.text = source.address;
    selectedProfileGenderId.value = source.genderId == 0 ? 1 : source.genderId;
    selectedProfileBirthday.value = source.birthday;
  }

  String? _validateProfileForm() {
    if (profileFullNameController.text.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên.';
    }
    final email = profileEmailController.text.trim();
    if (email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  Future<void> updateProfile() async {
    profileMessage.value = null;
    final validation = _validateProfileForm();
    if (validation != null) {
      profileError.value = validation;
      return;
    }

    isProfileSaving.value = true;
    profileError.value = null;
    try {
      final payload = profile.value.copyWith(
        fullName: profileFullNameController.text.trim(),
        genderId: selectedProfileGenderId.value,
        email: profileEmailController.text.trim(),
        phone: profilePhoneController.text.trim(),
        address: profileAddressController.text.trim(),
        birthday: selectedProfileBirthday.value,
      );
      final updated = await _profileRepository.updateUser(payload);
      profile.value = updated;
      _syncProfileForm(updated);
      profileMessage.value = 'Cập nhật thông tin cá nhân thành công.';
    } catch (e) {
      profileError.value = 'Không cập nhật được thông tin cá nhân: $e';
    } finally {
      isProfileSaving.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Lịch công tác chung
  // ---------------------------------------------------------------------------
  void openWorkCalendar() {
    showView(AdminSmartView.workCalendar);
    if (workCalendar.value.bookings.isEmpty && !isWorkCalendarLoading.value) {
      fetchWorkCalendar();
    }
  }

  Future<void> fetchWorkCalendar() async {
    isWorkCalendarLoading.value = true;
    workCalendarError.value = null;
    try {
      workCalendar.value = await _workCalendarRepository.getBundle();
    } catch (e) {
      workCalendarError.value = 'Không tải được lịch công tác: $e';
    } finally {
      isWorkCalendarLoading.value = false;
    }
  }

  void setWorkCalendarViewMode(WorkCalendarViewMode mode) {
    workCalendarViewMode.value = mode;
  }

  void moveWorkCalendar(int direction) {
    final anchor = workCalendarAnchor.value;
    switch (workCalendarViewMode.value) {
      case WorkCalendarViewMode.day:
        workCalendarAnchor.value = anchor.add(Duration(days: direction));
        break;
      case WorkCalendarViewMode.week:
        workCalendarAnchor.value = anchor.add(Duration(days: 7 * direction));
        break;
      case WorkCalendarViewMode.month:
        workCalendarAnchor.value = DateTime(
          anchor.year,
          anchor.month + direction,
          1,
        );
        break;
    }
  }

  void goToToday() {
    workCalendarAnchor.value = DateTime.now();
  }

  void setWorkCalendarTypeFilter(int typeId) {
    workCalendarTypeFilter.value = typeId;
  }

  void setWorkCalendarRoomFilter(int roomId) {
    workCalendarRoomFilter.value = roomId;
  }

  void setWorkCalendarStatusFilter(int statusId) {
    workCalendarStatusFilter.value = statusId;
  }

  void clearWorkCalendarFilters() {
    workCalendarTypeFilter.value = 0;
    workCalendarRoomFilter.value = 0;
    workCalendarStatusFilter.value = -100;
  }

  int get workCalendarActiveFilterCount {
    var count = 0;
    if (workCalendarTypeFilter.value != 0) count++;
    if (workCalendarRoomFilter.value != 0) count++;
    if (workCalendarStatusFilter.value != -100) count++;
    return count;
  }

  void openBookingDetail(BookingModel booking) {
    selectedBooking.value = booking;
    showView(AdminSmartView.workCalendarDetail);
  }

  /// Lọc booking theo bộ lọc hiện tại (không xét khoảng thời gian).
  List<BookingModel> filteredBookings() {
    return workCalendar.value.bookings.where((booking) {
      if (workCalendarTypeFilter.value != 0 &&
          booking.typeBookingID != workCalendarTypeFilter.value) {
        return false;
      }
      if (workCalendarRoomFilter.value != 0 &&
          booking.roomBookingID != workCalendarRoomFilter.value) {
        return false;
      }
      if (workCalendarStatusFilter.value != -100 &&
          booking.statusID != workCalendarStatusFilter.value) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Booking nằm trong khoảng thời gian đang xem, đã áp dụng bộ lọc.
  List<BookingModel> visibleBookings() {
    final range = _currentRange();
    final list = filteredBookings().where((booking) {
      final start = DateTime.tryParse(booking.dateStart);
      if (start == null) return false;
      final day = DateTime(start.year, start.month, start.day);
      return !day.isBefore(range.$1) && !day.isAfter(range.$2);
    }).toList();
    list.sort((a, b) {
      final da = DateTime.tryParse(a.dateStart) ?? DateTime(2100);
      final db = DateTime.tryParse(b.dateStart) ?? DateTime(2100);
      return da.compareTo(db);
    });
    return list;
  }

  /// Trả về (từ ngày, đến ngày) theo chế độ xem hiện tại.
  (DateTime, DateTime) _currentRange() {
    final anchor = workCalendarAnchor.value;
    final day = DateTime(anchor.year, anchor.month, anchor.day);
    switch (workCalendarViewMode.value) {
      case WorkCalendarViewMode.day:
        return (day, day);
      case WorkCalendarViewMode.week:
        final start = day.subtract(Duration(days: day.weekday - 1));
        return (start, start.add(const Duration(days: 6)));
      case WorkCalendarViewMode.month:
        final start = DateTime(anchor.year, anchor.month, 1);
        final end = DateTime(anchor.year, anchor.month + 1, 0);
        return (start, end);
    }
  }

  (DateTime, DateTime) get workCalendarRange => _currentRange();

  Future<void> fetchDashboard() async {
    isDashboardLoading.value = true;
    dashboardError.value = null;
    try {
      dashboard.value = await _dashboardRepository.getDashboard(
        dateSearch: DateTime.now(),
        typeSearch: 0,
      );
    } catch (e) {
      dashboardError.value = 'Không tải được dữ liệu dashboard: $e';
    } finally {
      isDashboardLoading.value = false;
    }
  }

  Future<void> fetchPeriodicReport() async {
    isPeriodicReportLoading.value = true;
    periodicReportError.value = null;
    try {
      periodicReport.value = await _dashboardRepository.getPeriodicReport();
    } catch (e) {
      periodicReportError.value = 'Không tải được báo cáo định kỳ: $e';
    } finally {
      isPeriodicReportLoading.value = false;
    }
  }

  Future<void> fetchMeetingHub() async {
    isMeetingLoading.value = true;
    meetingError.value = null;
    try {
      meetingHub.value = await _dashboardRepository.getMeetingHub();
    } catch (e) {
      meetingError.value = 'Không tải được dữ liệu họp không giấy tờ: $e';
    } finally {
      isMeetingLoading.value = false;
    }
  }

  Future<void> fetchAgencies() async {
    isAgencyLoading.value = true;
    agencyError.value = null;
    try {
      agencyBundle.value = await _agencyRepository.getAgencyBundle(
        statusId: agencyStatusFilter.value,
        page: 1,
        limit: 5,
        key: agencyQuery.value.trim(),
      );
    } catch (e) {
      agencyError.value = 'Không tải được danh sách sở ban ngành: $e';
    } finally {
      isAgencyLoading.value = false;
    }
  }

  void setAgencyStatusFilter(int statusId) {
    agencyStatusFilter.value = statusId;
    fetchAgencies();
  }

  void searchAgencies(String value) {
    agencyQuery.value = value;
    fetchAgencies();
  }

  Future<void> fetchDigitalMap() async {
    isDigitalMapLoading.value = true;
    digitalMapError.value = null;
    try {
      digitalMapBundle.value = await _digitalMapRepository.getBundle(
        key: mapQuery.value.trim(),
        typeOfficeId: digitalMapTypeFilter.value,
      );
    } catch (e) {
      digitalMapError.value = 'Không tải được dữ liệu bản đồ số: $e';
    } finally {
      isDigitalMapLoading.value = false;
    }
  }

  void searchDigitalMap(String value) {
    mapQuery.value = value;
    fetchDigitalMap();
  }

  void setDigitalMapTypeFilter(int typeOfficeId) {
    digitalMapTypeFilter.value = typeOfficeId;
    fetchDigitalMap();
  }

  void setDigitalMapVillageFilter(int villageId) {
    digitalMapVillageFilter.value = villageId;
  }

  void toggleDigitalMapBoundary() {
    digitalMapBoundaryVisible.value = !digitalMapBoundaryVisible.value;
  }

  void toggleDigitalMapOffices() {
    digitalMapOfficesVisible.value = !digitalMapOfficesVisible.value;
  }

  Future<void> fetchOffices() async {
    isOfficeLoading.value = true;
    officeError.value = null;
    try {
      officeBundle.value = await _officeRepository.getOfficeBundle(
        key: officeQuery.value.trim(),
        typeOfficeId: officeTypeFilter.value,
        statusId: officeStatusFilter.value,
        page: 1,
        limit: 10,
      );
    } catch (e) {
      officeError.value = 'Không tải được danh sách địa điểm: $e';
    } finally {
      isOfficeLoading.value = false;
    }
  }

  void setOfficeStatusFilter(int statusId) {
    officeStatusFilter.value = statusId;
    fetchOffices();
  }

  void searchOffices(String value) {
    officeQuery.value = value;
    fetchOffices();
  }

  Future<void> fetchKpiPrograms() async {
    isKpiLoading.value = true;
    kpiError.value = null;
    try {
      kpiBundle.value = await _kpiRepository.getKpiBundle();
    } catch (e) {
      kpiError.value = 'Không tải được dữ liệu Chương trình & KPI: $e';
    } finally {
      isKpiLoading.value = false;
    }
  }

  void setKpiStatusFilter(int statusId) {
    kpiStatusFilter.value = statusId;
  }

  void searchKpis(String value) {
    kpiQuery.value = value;
  }

  void showView(AdminSmartView view) {
    currentView.value = view;
    if (view == AdminSmartView.urgentAlerts &&
        urgentAlertBundle.value.information.items.isEmpty &&
        !isUrgentAlertLoading.value) {
      fetchUrgentAlerts();
    }
    if (view == AdminSmartView.workCalendar &&
        workCalendar.value.bookings.isEmpty &&
        !isWorkCalendarLoading.value) {
      fetchWorkCalendar();
    }
    if (view == AdminSmartView.crimeReports &&
        crimeReportBundle.value.warnings.items.isEmpty &&
        !isCrimeReportLoading.value) {
      fetchCrimeReports();
    }
    if (view == AdminSmartView.crimeReportNew &&
        crimeReportBundle.value.types.items.isEmpty &&
        !isCrimeReportLoading.value) {
      fetchCrimeReports();
    }
  }

  // ---------------------------------------------------------------------------
  // Tố giác tội phạm
  // ---------------------------------------------------------------------------

  Future<void> fetchCrimeReports() async {
    isCrimeReportLoading.value = true;
    crimeReportError.value = null;
    try {
      crimeReportBundle.value = await _crimeReports.getBundle(
        key: crimeQuery.value.trim(),
        statusId: crimeStatusFilter.value,
        typeWarningId: crimeTypeFilter.value,
      );
    } catch (e) {
      crimeReportError.value = 'Không tải được dữ liệu tố giác: $e';
    } finally {
      isCrimeReportLoading.value = false;
    }
  }

  void searchCrimeReports(String value) {
    crimeQuery.value = value;
    fetchCrimeReports();
  }

  void setCrimeStatusFilter(int statusId) {
    crimeStatusFilter.value = statusId;
    fetchCrimeReports();
  }

  void setCrimeTypeFilter(int typeWarningId) {
    crimeTypeFilter.value = typeWarningId;
    fetchCrimeReports();
  }

  void clearCrimeFilters() {
    crimeStatusFilter.value = -100;
    crimeTypeFilter.value = 0;
    crimeQuery.value = '';
    crimeSearchController.clear();
    fetchCrimeReports();
  }

  String crimeDepartmentName(int departmentId) {
    final dept = crimeReportBundle.value.departments.items.where(
      (d) => d.departmentId == departmentId,
    );
    return dept.isNotEmpty ? dept.first.departmentName : 'Chưa phân công';
  }

  void openCrimeReportNew() {
    _prefillCrimeIdentity();
    crimeFormError.value = null;
    crimeCreateMessage.value = null;
    crimeAiAnalysis.value = null;
    showView(AdminSmartView.crimeReportNew);
  }

  void editCrimeReportForm() {
    crimeAiAnalysis.value = null;
    crimeFormError.value = null;
  }

  Future<void> analyzeCrimeReport() async {
    crimeCreateMessage.value = null;
    final validation = _validateCrimeForm();
    if (validation != null) {
      crimeFormError.value = validation;
      return;
    }

    isCrimeAiAnalyzing.value = true;
    crimeFormError.value = null;
    try {
      crimeAiAnalysis.value = await _crimeReports.askAiWarning(
        title: crimeTitleController.text.trim(),
        description: crimeDescriptionController.text.trim(),
        address: crimeAddressController.text.trim(),
      );
    } catch (e) {
      crimeFormError.value = 'Không phân tích được tố giác bằng AI: $e';
    } finally {
      isCrimeAiAnalyzing.value = false;
    }
  }

  Future<void> confirmCreateCrimeReport() async {
    final analysis = crimeAiAnalysis.value;
    if (analysis == null) {
      await analyzeCrimeReport();
      if (crimeAiAnalysis.value == null) return;
    }

    isCrimeSubmitting.value = true;
    crimeFormError.value = null;
    try {
      final request = WarningCreateRequest(
        warningCode: _generateWarningCode(),
        warningTitle: crimeTitleController.text.trim(),
        userSent: anonymousReport.value
            ? 'Ẩn danh'
            : crimeNameController.text.trim(),
        dateSent: DateTime.now(),
        phone: anonymousReport.value ? '' : crimePhoneController.text.trim(),
        typeWarningId: _crimeTypeIdForCreate(crimeAiAnalysis.value),
        departmentId: _crimeDepartmentIdForCreate(crimeAiAnalysis.value),
        userIdProcess: 0,
        levelId: _crimeLevelIdForCreate(crimeAiAnalysis.value),
        statusId: 1,
        address: crimeAddressController.text.trim(),
        lat: 0,
        lng: 0,
        isVisible: !anonymousReport.value,
        aiAnalysis: crimeAiAnalysis.value?.aiAnalysis ?? 0,
        description: crimeDescriptionController.text.trim(),
        attachments: crimeAttachmentPaths.toList(),
      );
      final created = await _crimeReports.createWarning(request);
      crimeCreateMessage.value =
          'Đã nộp đơn ${created.warningCode.isNotEmpty ? created.warningCode : '#${created.warningId}'}.';
      _resetCrimeFormAfterCreate();
      showView(AdminSmartView.crimeReports);
      await fetchCrimeReports();
    } catch (e) {
      crimeFormError.value = 'Không nộp được đơn tố giác: $e';
    } finally {
      isCrimeSubmitting.value = false;
    }
  }

  void removeCrimeAttachment(String path) {
    crimeAttachmentPaths.remove(path);
  }

  Future<void> openProcessCreate() async {
    currentView.value = AdminSmartView.processCreate;
    selectedProcessLevel.value ??= ProcessLevelOption.all[1];
    selectedProcessSourceType.value ??= ProcessSourceTypeOption.conclusion;
    selectedProcessDueDate.value ??= DateTime.now().add(
      const Duration(days: 5),
    );
    if (processDropdowns.value.isEmpty) {
      await fetchProcessDropdowns();
    }
  }

  Future<void> fetchProcessDropdowns() async {
    isProcessDropdownLoading.value = true;
    processFormError.value = null;
    try {
      final bundle = await _processRepository.getCreateDropdowns();
      processDropdowns.value = bundle;
      selectedProcessUser.value ??= bundle.users.isNotEmpty
          ? bundle.users.first
          : null;
      selectedProcessBooking.value ??= bundle.bookings.isNotEmpty
          ? bundle.bookings.first
          : null;
      selectedProcessConclusion.value ??=
          selectedProcessBooking.value?.conclusions.isNotEmpty == true
          ? selectedProcessBooking.value!.conclusions.first
          : null;
      selectedProcessDocument.value ??= bundle.documents.isNotEmpty
          ? bundle.documents.first
          : null;
      selectedProcessKpi.value ??= bundle.kpis.isNotEmpty
          ? bundle.kpis.first
          : null;
    } catch (e) {
      processFormError.value = 'Không tải được dropdown giao việc: $e';
    } finally {
      isProcessDropdownLoading.value = false;
    }
  }

  void selectProcessBooking(ProcessBookingOption? booking) {
    selectedProcessBooking.value = booking;
    selectedProcessConclusion.value = booking?.conclusions.isNotEmpty == true
        ? booking!.conclusions.first
        : null;
  }

  Future<void> createProcess() async {
    processCreateMessage.value = null;
    final validation = _validateProcessForm();
    if (validation != null) {
      processFormError.value = validation;
      return;
    }

    isProcessCreating.value = true;
    processFormError.value = null;
    try {
      final request = ProcessCreateRequest(
        title: processTitleController.text.trim(),
        description: processDescriptionController.text.trim(),
        userIdProcess: selectedProcessUser.value!.userId,
        levelId: selectedProcessLevel.value!.levelId,
        dateExpired: selectedProcessDueDate.value!,
        typeSourceId: selectedProcessSourceType.value!.typeSourceId,
        codeReference: _processCodeReference(),
        conclusionId: selectedProcessConclusion.value?.conclusionId ?? 0,
        kpiId: selectedProcessKpi.value?.kpiId ?? 0,
        attachments: _attachmentPaths(),
      );
      final created = await _processRepository.create(request);
      processCreateMessage.value =
          'Đã tạo giao việc #${created.processId} cho ${created.userNameProcess}.';
      _resetProcessFormAfterCreate();
      showView(AdminSmartView.tasks);
    } catch (e) {
      processFormError.value = 'Không tạo được giao việc: $e';
    } finally {
      isProcessCreating.value = false;
    }
  }

  void toggleLoadMore(String key, int total) {
    final target = _loadMoreByKey(key);
    if (target == null) {
      return;
    }

    final expanded = target.value >= total;
    target.value = expanded ? _defaultLimitByKey(key) : total;
  }

  bool isExpanded(String key, int total) {
    final target = _loadMoreByKey(key);
    if (target == null) {
      return false;
    }
    return target.value >= total;
  }

  int visibleCount(String key, int total) {
    final target = _loadMoreByKey(key);
    if (target == null) {
      return total;
    }
    return target.value > total ? total : target.value;
  }

  void showBottomTab(int index) {
    final tabs = [
      AdminSmartView.overview,
      AdminSmartView.apps,
      AdminSmartView.account,
    ];
    showView(tabs[index]);
  }

  int get selectedTab {
    switch (currentView.value) {
      case AdminSmartView.overview:
        return 0;
      case AdminSmartView.apps:
      case AdminSmartView.crimeReports:
      case AdminSmartView.crimeReportNew:
      case AdminSmartView.aiAssistant:
      case AdminSmartView.digitalMap:
      case AdminSmartView.kpiPrograms:
      case AdminSmartView.urgentAlerts:
      case AdminSmartView.periodicReport:
      case AdminSmartView.meetingSchedule:
      case AdminSmartView.workCalendar:
      case AdminSmartView.workCalendarDetail:
      case AdminSmartView.agencies:
      case AdminSmartView.tasks:
      case AdminSmartView.processCreate:
        return 1;
      case AdminSmartView.account:
      case AdminSmartView.accountProfileDetail:
      case AdminSmartView.accountNotificationDetail:
      case AdminSmartView.accountSecurityDetail:
      case AdminSmartView.accountSyncDetail:
        return 2;
    }
  }

  void sendAiPrompt() {
    final prompt = aiPromptController.text.trim();
    if (prompt.isEmpty) {
      aiDraft.value = 'Nhập nội dung cần AI hỗ trợ trước khi gửi.';
      return;
    }
    aiPrompt.value = prompt;
    aiDraft.value =
        'Đã tạo nháp xử lý cho yêu cầu: "$prompt". Vui lòng rà soát trước khi phát hành.';
  }

  void useAiSuggestion(String suggestion) {
    aiPromptController.text = suggestion;
    aiPrompt.value = suggestion;
  }

  void resetAiChat() {
    aiPromptController.clear();
    aiPrompt.value = '';
    aiDraft.value =
        'AI có thể mắc lỗi. Vui lòng kiểm tra thông tin quan trọng.';
  }

  @override
  void onClose() {
    appSearchController.dispose();
    taskSearchController.dispose();
    crimeSearchController.dispose();
    mapSearchController.dispose();
    kpiSearchController.dispose();
    urgentSearchController.dispose();
    agencySearchController.dispose();
    officeSearchController.dispose();
    aiPromptController.dispose();
    crimeNameController.dispose();
    crimePhoneController.dispose();
    crimeTitleController.dispose();
    crimeDescriptionController.dispose();
    crimeAddressController.dispose();
    processTitleController.dispose();
    processDescriptionController.dispose();
    processAttachmentController.dispose();
    profileFullNameController.dispose();
    profileEmailController.dispose();
    profilePhoneController.dispose();
    profileAddressController.dispose();
    super.onClose();
  }

  void _prefillCrimeIdentity() {
    if (crimeNameController.text.trim().isEmpty &&
        profile.value.fullName.trim().isNotEmpty) {
      crimeNameController.text = profile.value.fullName.trim();
    }
    if (crimePhoneController.text.trim().isEmpty &&
        profile.value.phone.trim().isNotEmpty) {
      crimePhoneController.text = profile.value.phone.trim();
    }
  }

  String? _validateCrimeForm() {
    if (!anonymousReport.value && crimeNameController.text.trim().isEmpty) {
      return 'Vui lòng nhập họ tên hoặc chọn nộp ẩn danh.';
    }
    if (crimeTitleController.text.trim().isEmpty) {
      return 'Vui lòng nhập tiêu đề tố giác.';
    }
    if (crimeDescriptionController.text.trim().isEmpty) {
      return 'Vui lòng nhập nội dung chi tiết.';
    }
    return null;
  }

  String _generateWarningCode() {
    final year = DateTime.now().year;
    final number = 100000 + Random().nextInt(900000);
    return 'TG-$year-$number';
  }

  int _crimeTypeIdForCreate(WarningAiAnalysis? analysis) {
    if ((analysis?.typeWarningId ?? 0) > 0) return analysis!.typeWarningId;
    final types = crimeReportBundle.value.types.items;
    final other = types.where(
      (item) => item.typeWarningName.toLowerCase().contains('khác'),
    );
    if (other.isNotEmpty) return other.first.typeWarningId;
    return types.isNotEmpty ? types.first.typeWarningId : 0;
  }

  String crimeTypeNameForCreate(WarningAiAnalysis? analysis) {
    if ((analysis?.typeWarningName ?? '').trim().isNotEmpty) {
      return analysis!.typeWarningName.trim();
    }
    final typeId = _crimeTypeIdForCreate(analysis);
    final types = crimeReportBundle.value.types.items.where(
      (item) => item.typeWarningId == typeId,
    );
    return types.isNotEmpty ? types.first.typeWarningName : 'Khác';
  }

  int _crimeDepartmentIdForCreate(WarningAiAnalysis? analysis) {
    if ((analysis?.departmentId ?? 0) > 0) return analysis!.departmentId;
    final departments = crimeReportBundle.value.departments.items;
    return departments.isNotEmpty ? departments.first.departmentId : 1;
  }

  String crimeDepartmentNameForCreate(WarningAiAnalysis? analysis) {
    if ((analysis?.departmentName ?? '').trim().isNotEmpty) {
      return analysis!.departmentName.trim();
    }
    return crimeDepartmentName(_crimeDepartmentIdForCreate(analysis));
  }

  int _crimeLevelIdForCreate(WarningAiAnalysis? analysis) {
    final levelId = analysis?.levelId ?? 0;
    return levelId > 0 ? levelId : 1;
  }

  String crimeLevelNameForCreate(WarningAiAnalysis? analysis) {
    if ((analysis?.levelName ?? '').trim().isNotEmpty &&
        analysis!.levelName != 'Không xác định') {
      return analysis.levelName.trim();
    }
    switch (_crimeLevelIdForCreate(analysis)) {
      case 1:
        return 'Thấp';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Cao';
      default:
        return 'Không xác định';
    }
  }

  void _resetCrimeFormAfterCreate() {
    anonymousReport.value = false;
    crimeAiAnalysis.value = null;
    crimeFormError.value = null;
    crimeNameController.clear();
    crimePhoneController.clear();
    crimeTitleController.clear();
    crimeDescriptionController.clear();
    crimeAddressController.clear();
    crimeAttachmentPaths.clear();
  }

  String? _validateProcessForm() {
    if (processTitleController.text.trim().isEmpty) {
      return 'Vui lòng nhập tiêu đề giao việc.';
    }
    if (selectedProcessUser.value == null) {
      return 'Vui lòng chọn người xử lý.';
    }
    if (selectedProcessLevel.value == null) {
      return 'Vui lòng chọn mức độ.';
    }
    if (selectedProcessDueDate.value == null) {
      return 'Vui lòng chọn hạn xử lý.';
    }
    final source = selectedProcessSourceType.value;
    if (source == null) {
      return 'Vui lòng chọn nguồn giao việc.';
    }
    if (source.typeSourceId == ProcessSourceTypeOption.document.typeSourceId &&
        selectedProcessDocument.value == null) {
      return 'Vui lòng chọn văn bản liên quan.';
    }
    if (source.typeSourceId == ProcessSourceTypeOption.kpi.typeSourceId &&
        selectedProcessKpi.value == null) {
      return 'Vui lòng chọn KPI liên quan.';
    }
    return null;
  }

  String _processCodeReference() {
    final source = selectedProcessSourceType.value;
    if (source?.typeSourceId == ProcessSourceTypeOption.document.typeSourceId) {
      return selectedProcessDocument.value?.codeReference ?? 'Document';
    }
    if (source?.typeSourceId == ProcessSourceTypeOption.kpi.typeSourceId) {
      return selectedProcessKpi.value?.codeReference ?? 'KPI';
    }
    return selectedProcessConclusion.value?.codeReference ??
        selectedProcessBooking.value?.codeReference ??
        'Conclusion';
  }

  List<String> _attachmentPaths() {
    return processAttachmentController.text
        .split(RegExp(r'[\n,;]+'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void _resetProcessFormAfterCreate() {
    processTitleController.clear();
    processDescriptionController.clear();
    processAttachmentController.clear();
    selectedProcessDueDate.value = DateTime.now().add(const Duration(days: 5));
  }

  Future<void> pickAndUploadProcessAttachment() async {
    try {
      final result = await FilePicker.pickFiles();
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        isUploading.value = true;
        final service = FileUploadService();
        final path = await service.uploadFile(file);
        if (processAttachmentController.text.isNotEmpty) {
          processAttachmentController.text += '\n$path';
        } else {
          processAttachmentController.text = path;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi tải file',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> pickAndUploadCrimeAttachment() async {
    try {
      final result = await FilePicker.pickFiles(allowMultiple: true);
      if (result != null && result.files.isNotEmpty) {
        isUploading.value = true;
        final service = FileUploadService();
        for (final picked in result.files) {
          if (picked.path == null) continue;
          final path = await service.uploadFile(File(picked.path!));
          if (path.isNotEmpty && !crimeAttachmentPaths.contains(path)) {
            crimeAttachmentPaths.add(path);
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi tải file',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }

  RxInt? _loadMoreByKey(String key) {
    switch (key) {
      case 'overview_departments':
        return overviewDepartmentLimit;
      case 'overview_kpis':
        return overviewKpiLimit;
      case 'overview_users':
        return overviewActiveUserLimit;
      case 'period_items':
        return periodicItemLimit;
      case 'period_trends':
        return periodicTrendLimit;
      case 'period_notifications':
        return periodicNotificationLimit;
      case 'meeting_rooms':
        return meetingRoomLimit;
      case 'meeting_users':
        return meetingUserLimit;
      case 'meeting_bookings':
        return meetingBookingLimit;
      case 'crime_reports':
        return crimeReportLimit;
      case 'urgent_alerts':
        return urgentAlertLimit;
      case 'tasks':
        return taskLimit;
    }
    return null;
  }

  int _defaultLimitByKey(String key) {
    switch (key) {
      case 'overview_departments':
        return 3;
      case 'overview_kpis':
        return 5;
      case 'overview_users':
        return 3;
      case 'period_items':
        return 5;
      case 'period_trends':
        return 4;
      case 'period_notifications':
        return 5;
      case 'meeting_rooms':
        return 4;
      case 'meeting_users':
        return 5;
      case 'meeting_bookings':
        return 5;
      case 'crime_reports':
        return 3;
      case 'urgent_alerts':
        return 5;
      case 'tasks':
        return 3;
    }
    return 0;
  }
}
