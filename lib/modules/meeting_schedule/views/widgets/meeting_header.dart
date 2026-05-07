import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_text_styles.dart';

class MeetingHeader extends StatelessWidget {
  const MeetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3159B8), Color(0xFF1E3F8F), Color(0xFF102A63)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3F8F).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Positioned(
            right: -40,
            top: -28,
            child: _circle(180, Colors.white.withValues(alpha: 0.12)),
          ),
          Positioned(
            left: -28,
            bottom: -34,
            child: _circle(130, const Color(0xFF60A5FA).withValues(alpha: 0.2)),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Container(color: Colors.transparent),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.28)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                Text(
                  'meeting.header.title'.tr,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'meeting.header.date'.tr,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
