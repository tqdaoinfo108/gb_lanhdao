import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gb_lanhdao/modules/tasks/controllers/tasks_controller.dart';

class SearchBarWidget extends GetView<TasksController> {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.setSearch,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm công việc, hồ sơ...',
        hintStyle: const TextStyle(
          color: Color(0xFF596273),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFF2F5FA),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF7D8795), size: 22),
        prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE0E6EF), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE0E6EF), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFCFD8E3), width: 1),
        ),
        isDense: true,
      ),
    );
  }
}
