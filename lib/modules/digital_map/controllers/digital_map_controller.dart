import 'package:get/get.dart';
import '../../../data/models/digital_map_models.dart';
import '../../../data/mock/digital_map_mock_data.dart';

/// Controller cho màn hình Bản đồ số.
/// Quản lý: layer visibility, filter, search, selected marker.
class DigitalMapController extends GetxController {
  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Data
  final RxList<MapLayer> layers = <MapLayer>[].obs;
  final RxList<MapMarker> allMarkers = <MapMarker>[].obs;
  final RxList<MapMarker> filteredMarkers = <MapMarker>[].obs;
  final RxList<MapStatistic> statistics = <MapStatistic>[].obs;
  final RxList<AdminZone> adminZones = <AdminZone>[].obs;
  final RxList<MapFilter> filters = <MapFilter>[].obs;

  // UI State
  final RxString searchQuery = ''.obs;
  final Rxn<MapMarker> selectedMarker = Rxn<MapMarker>();
  final RxInt selectedTab = 0.obs; // 0: Bản đồ, 1: Danh sách, 2: Thống kê
  final RxBool showLayerPanel = false.obs;
  final RxBool showSearchBar = false.obs;
  final RxString selectedFilterId = 'f_all'.obs;

  // Map zoom/position (simulated)
  final RxDouble mapZoom = 14.0.obs;
  final RxString currentDistrict = 'Quận Bình Thạnh'.obs;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    fetchData();
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedFilterId, (_) => _applyFilters());
  }

  // ---------------------------------------------------------------------------
  // Methods
  // ---------------------------------------------------------------------------
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(milliseconds: 600));

      layers.assignAll(DigitalMapMockData.layers);
      allMarkers.assignAll(DigitalMapMockData.markers);
      filteredMarkers.assignAll(DigitalMapMockData.markers);
      statistics.assignAll(DigitalMapMockData.statistics);
      adminZones.assignAll(DigitalMapMockData.adminZones);
      filters.assignAll(DigitalMapMockData.filters);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async => fetchData();

  /// Toggle hiển thị một layer.
  void toggleLayer(String layerId) {
    final idx = layers.indexWhere((l) => l.id == layerId);
    if (idx != -1) {
      layers[idx].isVisible = !layers[idx].isVisible;
      layers.refresh();
    }
  }

  /// Chọn filter (loại địa điểm).
  void selectFilter(String filterId) {
    selectedFilterId.value = filterId;
    for (final f in filters) {
      f.isSelected = f.id == filterId;
    }
    filters.refresh();
  }

  /// Chọn một marker để xem chi tiết.
  void selectMarker(MapMarker? marker) {
    selectedMarker.value = marker;
  }

  /// Đóng panel chi tiết marker.
  void dismissMarker() {
    selectedMarker.value = null;
  }

  /// Chuyển tab.
  void changeTab(int tab) {
    selectedTab.value = tab;
    if (tab != 0) selectedMarker.value = null;
  }

  /// Toggle panel layer.
  void toggleLayerPanel() {
    showLayerPanel.value = !showLayerPanel.value;
  }

  /// Toggle search bar.
  void toggleSearchBar() {
    showSearchBar.value = !showSearchBar.value;
    if (!showSearchBar.value) {
      searchQuery.value = '';
    }
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------
  void _applyFilters() {
    List<MapMarker> result = List.from(allMarkers);

    // Filter by type
    if (selectedFilterId.value != 'f_all') {
      final activeFilter = filters.firstWhereOrNull(
        (f) => f.id == selectedFilterId.value && f.markerType != null,
      );
      if (activeFilter?.markerType != null) {
        result = result
            .where((m) => m.type == activeFilter!.markerType)
            .toList();
      }
    }

    // Filter by search
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      result = result
          .where((m) =>
              m.name.toLowerCase().contains(q) ||
              m.description.toLowerCase().contains(q) ||
              (m.address?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    filteredMarkers.assignAll(result);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Tổng số layer đang hiển thị.
  int get visibleLayerCount => layers.where((l) => l.isVisible).length;

  /// Màu sắc theo loại marker.
  static String markerTypeLabel(MapMarkerType type) {
    switch (type) {
      case MapMarkerType.administrative:
        return 'Hành chính';
      case MapMarkerType.infrastructure:
        return 'Hạ tầng';
      case MapMarkerType.residential:
        return 'Dân cư';
      case MapMarkerType.greenSpace:
        return 'Cây xanh';
      case MapMarkerType.medical:
        return 'Y tế';
      case MapMarkerType.education:
        return 'Giáo dục';
      case MapMarkerType.construction:
        return 'Công trường';
    }
  }

  static String markerStatusLabel(MapMarkerStatus status) {
    switch (status) {
      case MapMarkerStatus.active:
        return 'Đang hoạt động';
      case MapMarkerStatus.inactive:
        return 'Không hoạt động';
      case MapMarkerStatus.underConstruction:
        return 'Đang thi công';
      case MapMarkerStatus.planned:
        return 'Quy hoạch';
    }
  }
}
