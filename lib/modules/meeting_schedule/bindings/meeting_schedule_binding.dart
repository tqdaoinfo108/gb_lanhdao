import 'package:get/get.dart';
import '../controllers/meeting_schedule_controller.dart';

class MeetingScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingScheduleController>(() => MeetingScheduleController());
  }
}
