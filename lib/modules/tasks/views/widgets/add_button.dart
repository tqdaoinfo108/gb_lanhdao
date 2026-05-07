import 'package:flutter/material.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/add_subtask_dialog.dart';

class AddButton extends StatefulWidget {
  final String parentTaskTitle;
  const AddButton({super.key, required this.parentTaskTitle});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AddSubTaskDialog(parentTaskTitle: widget.parentTaskTitle),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18, color: Color(0xFF2F6CE1)),
            SizedBox(width: 4),
            Text(
              'Thêm',
              style: TextStyle(color: Color(0xFF2F6CE1), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}