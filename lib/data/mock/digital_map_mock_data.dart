import '../models/digital_map_models.dart';

/// Dữ liệu mẫu cho module Bản đồ số.
class DigitalMapMockData {
  DigitalMapMockData._();

  // ---------------------------------------------------------------------------
  // Layers
  // ---------------------------------------------------------------------------
  static List<MapLayer> get layers => [
        MapLayer(
          id: 'layer_admin',
          name: 'Hành chính',
          description: 'Trụ sở, UBND các cấp',
          type: MapLayerType.administrative,
          isVisible: true,
          markerCount: 12,
        ),
        MapLayer(
          id: 'layer_infra',
          name: 'Hạ tầng',
          description: 'Đường, cầu, hệ thống điện nước',
          type: MapLayerType.infrastructure,
          isVisible: true,
          markerCount: 28,
        ),
        MapLayer(
          id: 'layer_residential',
          name: 'Dân cư',
          description: 'Khu dân cư, chung cư',
          type: MapLayerType.residential,
          isVisible: false,
          markerCount: 45,
        ),
        MapLayer(
          id: 'layer_env',
          name: 'Môi trường',
          description: 'Công viên, hồ, cây xanh',
          type: MapLayerType.environment,
          isVisible: false,
          markerCount: 19,
        ),
        MapLayer(
          id: 'layer_utility',
          name: 'Tiện ích',
          description: 'Y tế, giáo dục, chợ',
          type: MapLayerType.utility,
          isVisible: true,
          markerCount: 33,
        ),
      ];

  // ---------------------------------------------------------------------------
  // Markers
  // ---------------------------------------------------------------------------
  static List<MapMarker> get markers => [
        // Hành chính
        MapMarker(
          id: 'm001',
          name: 'UBND Quận Bình Thạnh',
          description: 'Trụ sở Ủy ban Nhân dân Quận Bình Thạnh',
          latitude: 10.8142,
          longitude: 106.7086,
          type: MapMarkerType.administrative,
          status: MapMarkerStatus.active,
          address: '10 Phan Đăng Lưu, P. 1, Q. Bình Thạnh',
          phone: '028 3840 1234',
        ),
        MapMarker(
          id: 'm002',
          name: 'UBND Phường 1',
          description: 'Trụ sở UBND Phường 1',
          latitude: 10.8160,
          longitude: 106.7100,
          type: MapMarkerType.administrative,
          status: MapMarkerStatus.active,
          address: '15 Đinh Bộ Lĩnh, P. 1, Q. Bình Thạnh',
        ),
        MapMarker(
          id: 'm003',
          name: 'UBND Phường 2',
          description: 'Trụ sở UBND Phường 2',
          latitude: 10.8120,
          longitude: 106.7050,
          type: MapMarkerType.administrative,
          status: MapMarkerStatus.active,
          address: '22 Nơ Trang Long, P. 2, Q. Bình Thạnh',
        ),

        // Hạ tầng
        MapMarker(
          id: 'm010',
          name: 'Cầu Văn Thánh',
          description: 'Cầu kết nối Bình Thạnh - TP.HCM',
          latitude: 10.8080,
          longitude: 106.7200,
          type: MapMarkerType.infrastructure,
          status: MapMarkerStatus.active,
        ),
        MapMarker(
          id: 'm011',
          name: 'Dự án nâng cấp đường D2',
          description: 'Mở rộng đường D2 đoạn Đinh Tiên Hoàng',
          latitude: 10.8095,
          longitude: 106.7120,
          type: MapMarkerType.infrastructure,
          status: MapMarkerStatus.underConstruction,
          lastUpdated: DateTime(2026, 4, 15),
        ),
        MapMarker(
          id: 'm012',
          name: 'Hệ thống thoát nước P.13',
          description: 'Nâng cấp hệ thống thoát nước Phường 13',
          latitude: 10.8200,
          longitude: 106.7070,
          type: MapMarkerType.infrastructure,
          status: MapMarkerStatus.planned,
        ),

        // Dân cư
        MapMarker(
          id: 'm020',
          name: 'Khu dân cư Vạn Đô',
          description: 'Khu dân cư hiện hữu, 2.400 hộ',
          latitude: 10.8050,
          longitude: 106.7080,
          type: MapMarkerType.residential,
          status: MapMarkerStatus.active,
        ),
        MapMarker(
          id: 'm021',
          name: 'Chung cư Bình Thạnh Tower',
          description: 'Chung cư 25 tầng, 300 căn hộ',
          latitude: 10.8180,
          longitude: 106.7150,
          type: MapMarkerType.residential,
          status: MapMarkerStatus.active,
        ),

        // Y tế & Giáo dục
        MapMarker(
          id: 'm030',
          name: 'BV Bình Thạnh',
          description: 'Bệnh viện Quận Bình Thạnh, 200 giường',
          latitude: 10.8130,
          longitude: 106.7030,
          type: MapMarkerType.medical,
          status: MapMarkerStatus.active,
          address: '7 Nơ Trang Long, P. 7, Q. Bình Thạnh',
          phone: '028 3841 5678',
        ),
        MapMarker(
          id: 'm031',
          name: 'Trường THPT Gia Định',
          description: 'Trường THPT Gia Định, 45 lớp, 1.800 HS',
          latitude: 10.8170,
          longitude: 106.7060,
          type: MapMarkerType.education,
          status: MapMarkerStatus.active,
          address: '57 Bạch Đằng, P. 2, Q. Bình Thạnh',
        ),

        // Công viên
        MapMarker(
          id: 'm040',
          name: 'Công viên Gia Định',
          description: 'Công viên xanh 50ha, hồ điều tiết',
          latitude: 10.8210,
          longitude: 106.7090,
          type: MapMarkerType.greenSpace,
          status: MapMarkerStatus.active,
        ),
      ];

  // ---------------------------------------------------------------------------
  // Statistics
  // ---------------------------------------------------------------------------
  static List<MapStatistic> get statistics => [
        const MapStatistic(
          label: 'Tổng diện tích',
          value: '20.7',
          unit: 'km²',
          trend: MapStatisticTrend.stable,
          trendText: 'Không đổi',
        ),
        const MapStatistic(
          label: 'Dân số',
          value: '501K',
          unit: 'người',
          trend: MapStatisticTrend.up,
          trendText: '+1.2% năm',
        ),
        const MapStatistic(
          label: 'Công trình đang XD',
          value: '14',
          unit: 'CT',
          trend: MapStatisticTrend.up,
          trendText: '+3 mới',
        ),
        const MapStatistic(
          label: 'Phủ sóng GIS',
          value: '94',
          unit: '%',
          trend: MapStatisticTrend.up,
          trendText: '+4% QIV',
        ),
      ];

  // ---------------------------------------------------------------------------
  // Admin Zones
  // ---------------------------------------------------------------------------
  static List<AdminZone> get adminZones => [
        const AdminZone(
          id: 'az001',
          name: 'Phường 1',
          type: 'Phường',
          population: 24500,
          area: 0.89,
          projectCount: 3,
        ),
        const AdminZone(
          id: 'az002',
          name: 'Phường 2',
          type: 'Phường',
          population: 18200,
          area: 0.72,
          projectCount: 1,
        ),
        const AdminZone(
          id: 'az003',
          name: 'Phường 3',
          type: 'Phường',
          population: 31000,
          area: 1.15,
          projectCount: 5,
        ),
        const AdminZone(
          id: 'az004',
          name: 'Phường 7',
          type: 'Phường',
          population: 27800,
          area: 0.95,
          projectCount: 2,
        ),
        const AdminZone(
          id: 'az005',
          name: 'Phường 13',
          type: 'Phường',
          population: 22100,
          area: 0.81,
          projectCount: 3,
        ),
        const AdminZone(
          id: 'az006',
          name: 'Phường Hiệp Bình Chánh',
          type: 'Phường',
          population: 55000,
          area: 3.20,
          projectCount: 7,
        ),
      ];

  // ---------------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------------
  static List<MapFilter> get filters => [
        MapFilter(id: 'f_all', label: 'Tất cả', isSelected: true),
        MapFilter(
            id: 'f_admin',
            label: 'Hành chính',
            markerType: MapMarkerType.administrative),
        MapFilter(
            id: 'f_infra',
            label: 'Hạ tầng',
            markerType: MapMarkerType.infrastructure),
        MapFilter(
            id: 'f_medical',
            label: 'Y tế',
            markerType: MapMarkerType.medical),
        MapFilter(
            id: 'f_edu',
            label: 'Giáo dục',
            markerType: MapMarkerType.education),
        MapFilter(
            id: 'f_green',
            label: 'Cây xanh',
            markerType: MapMarkerType.greenSpace),
        MapFilter(
            id: 'f_construction',
            label: 'Đang XD',
            markerType: MapMarkerType.construction),
      ];
}
