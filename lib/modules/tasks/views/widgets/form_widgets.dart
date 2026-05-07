import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  final String text;
  final bool required;

  const FormLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
          children: required
              ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
              : null,
        ),
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const FormTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F6CE1), width: 1.5),
        ),
        errorStyle: const TextStyle(height: 0.8),
      ),
    );
  }
}

class FormDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const FormDatePicker({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: TextFormField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          hintText: 'mm/dd/yyyy',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF6B7280)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
    );
  }
}