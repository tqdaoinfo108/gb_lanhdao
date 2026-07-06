import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/agency_models.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/models/kpi_models.dart';
import '../../../data/models/office_models.dart';
import '../../../data/models/process_models.dart';
import '../../../data/repositories/agency_repository.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/kpi_repository.dart';
import '../../../data/repositories/office_repository.dart';
import '../../../data/repositories/process_repository.dart';

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
  agencies,
  processCreate,
  account,
  accountProfileDetail,
  accountNotificationDetail,
  accountSecurityDetail,
  accountSyncDetail,
}

class HomeController extends GetxController {
  final DashboardRepository _dashboardRepository;
  final ProcessRepository _processRepository;
  final AgencyRepository _agencyRepository;
  final OfficeRepository _officeRepository;
  final KpiRepository _kpiRepository;

  HomeController({
    DashboardRepository? dashboardRepository,
    ProcessRepository? processRepository,
    AgencyRepository? agencyRepository,
    OfficeRepository? officeRepository,
    KpiRepository? kpiRepository,
  }) : _dashboardRepository = dashboardRepository ?? DashboardRepository(),
       _processRepository = processRepository ?? ProcessRepository(),
       _agencyRepository = agencyRepository ?? AgencyRepository(),
       _officeRepository = officeRepository ?? OfficeRepository(),
       _kpiRepository = kpiRepository ?? KpiRepository();

  final currentView = AdminSmartView.overview.obs;
  final isDashboardLoading = false.obs;
  final dashboardError = RxnString();
  final dashboard = DashboardBundle.empty().obs;
  final periodicReport = PeriodicReportBundle.empty().obs;
  final meetingHub = MeetingHubBundle.empty().obs;
  final agencyBundle = AgencyBundle.empty().obs;
  final officeBundle = OfficeBundle.empty().obs;
  final kpiBundle = KpiBundle.empty().obs;
  final processDropdowns = ProcessDropdownBundle.empty().obs;
  final isPeriodicReportLoading = false.obs;
  final isMeetingLoading = false.obs;
  final isAgencyLoading = false.obs;
  final isOfficeLoading = false.obs;
  final isKpiLoading = false.obs;
  final isProcessDropdownLoading = false.obs;
  final isProcessCreating = false.obs;
  final periodicReportError = RxnString();
  final meetingError = RxnString();
  final agencyError = RxnString();
  final officeError = RxnString();
  final kpiError = RxnString();
  final processFormError = RxnString();
  final processCreateMessage = RxnString();
  final taskStatus = 'all'.obs;
  final urgentFilter = 'all'.obs;
  final agencyStatusFilter = (-100).obs;
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
  final processTitleController = TextEditingController();
  final processDescriptionController = TextEditingController();
  final processAttachmentController = TextEditingController();

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
    fetchOffices();
    fetchKpiPrograms();
  }

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
    processTitleController.dispose();
    processDescriptionController.dispose();
    processAttachmentController.dispose();
    super.onClose();
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
