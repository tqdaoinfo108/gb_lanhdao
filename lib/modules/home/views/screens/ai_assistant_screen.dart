part of '../home_screen.dart';

class _AiAssistantScreen extends StatelessWidget {
  final HomeController controller;

  const _AiAssistantScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Obx(
        () => Column(
          children: [
            _AiChatHeader(
              onBack: () => controller.showView(AdminSmartView.apps),
              onHistory: () => _showAiHistory(context),
              onNewChat: controller.resetAiChat,
            ),
            const SizedBox(height: 10),
            _AiQuickPrompts(controller: controller),
            const SizedBox(height: 8),
            Expanded(
              child: controller.aiMessages.isEmpty
                  ? _AiWelcome(controller: controller)
                  : _AiMessageList(
                      messages: controller.aiMessages,
                      isSending: controller.isAiSending.value,
                    ),
            ),
            if (controller.aiError.value != null) ...[
              const SizedBox(height: 6),
              _AiInlineError(message: controller.aiError.value!),
            ],
            const SizedBox(height: 8),
            _AiComposer(controller: controller),
          ],
        ),
      ),
    );
  }

  void _showAiHistory(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: .62,
        minChildSize: .35,
        maxChildSize: .9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: SmartColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Obx(
            () => Column(
              children: [
                Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: SmartColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lịch sử trò chuyện',
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Làm mới',
                        onPressed: controller.fetchAiHistory,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                  child: Text(
                    'Các phiên đã lưu trên hệ thống.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: controller.isAiHistoryLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.aiHistory.value.items.isEmpty
                      ? Center(
                          child: Text(
                            'Chưa có cuộc trò chuyện nào.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                          itemCount: controller.aiHistory.value.items.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (_, index) {
                            final item =
                                controller.aiHistory.value.items[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: SmartColors.accentSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.forum_outlined,
                                  color: SmartColors.accent,
                                  size: 19,
                                ),
                              ),
                              title: Text(
                                item.title.isEmpty
                                    ? 'Cuộc trò chuyện #${item.historyChatId}'
                                    : item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiChatHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHistory;
  final VoidCallback onNewChat;

  const _AiChatHeader({
    required this.onBack,
    required this.onHistory,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Quay lại ứng dụng',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: SmartColors.accent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Hỗ trợ',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: SmartColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Đang hoạt động',
                    style: AppTextStyles.caption.copyWith(
                      color: SmartColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Cuộc trò chuyện mới',
          onPressed: onNewChat,
          icon: const Icon(Icons.edit_note_rounded),
        ),
        IconButton(
          tooltip: 'Lịch sử trò chuyện',
          onPressed: onHistory,
          icon: const Icon(Icons.history_rounded),
        ),
      ],
    );
  }
}

class _AiQuickPrompts extends StatelessWidget {
  final HomeController controller;

  const _AiQuickPrompts({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _AiPromptChip(
            icon: Icons.query_stats_rounded,
            label: 'Phân tích KPI tháng này',
            onTap: controller.analyzeCurrentMonthKpi,
          ),
          const SizedBox(width: 8),
          _AiPromptChip(
            icon: Icons.assignment_late_outlined,
            label: 'Phân tích việc quá hạn',
            onTap: controller.analyzeCurrentMonthProcesses,
          ),
          const SizedBox(width: 8),
          _AiPromptChip(
            icon: Icons.groups_outlined,
            label: 'Phân tích dân cư',
            onTap: controller.analyzeCurrentMonthResidence,
          ),
          const SizedBox(width: 8),
          _AiPromptChip(
            icon: Icons.event_note_outlined,
            label: 'Tổng hợp lịch họp',
            onTap: controller.analyzeCurrentMonthBookings,
          ),
          const SizedBox(width: 8),
          _AiPromptChip(
            icon: Icons.description_outlined,
            label: 'Soạn thảo văn bản',
            onTap: () => controller.useAiSuggestion(
              'Hãy hỗ trợ tôi soạn thảo văn bản hành chính.',
            ),
          ),
        ],
      ),
    );
  }
}

class _AiPromptChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AiPromptChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: SmartColors.accent,
        side: const BorderSide(color: SmartColors.border),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        textStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _AiWelcome extends StatelessWidget {
  final HomeController controller;

  const _AiWelcome({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: SmartCard(
          radius: 18,
          padding: const EdgeInsets.all(18),
          color: SmartColors.cardSurface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: SmartColors.accentSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: SmartColors.accent,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Chào bạn, tôi có thể hỗ trợ điều hành.',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Phân tích KPI, đánh giá nhiệm vụ, tóm tắt dữ liệu và hỗ trợ soạn thảo văn bản.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _AiWelcomeAction(
                icon: Icons.query_stats_outlined,
                title: 'Tóm tắt KPI tháng này',
                onTap: controller.analyzeCurrentMonthKpi,
              ),
              _AiWelcomeAction(
                icon: Icons.assignment_late_outlined,
                title: 'Đánh giá công việc quá hạn',
                onTap: () => controller.useAiSuggestion(
                  'Hãy phân tích các nhiệm vụ đang quá hạn và đề xuất thứ tự ưu tiên xử lý.',
                ),
              ),
              _AiWelcomeAction(
                icon: Icons.edit_note_rounded,
                title: 'Soạn thảo văn bản hành chính',
                onTap: () => controller.useAiSuggestion(
                  'Hãy hỗ trợ tôi soạn thảo văn bản hành chính.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiWelcomeAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AiWelcomeAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: SmartColors.accent, size: 20),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _AiMessageList extends StatelessWidget {
  final List<AiChatMessage> messages;
  final bool isSending;

  const _AiMessageList({required this.messages, required this.isSending});

  @override
  Widget build(BuildContext context) {
    final newestFirst = messages.reversed.toList(growable: false);
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length + (isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (isSending && index == 0) return const _AiTypingBubble();
        final messageIndex = isSending ? index - 1 : index;
        return _AiMessageBubble(message: newestFirst[messageIndex]);
      },
    );
  }
}

class _AiMessageBubble extends StatelessWidget {
  final AiChatMessage message;

  const _AiMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? SmartColors.accent : SmartColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: SmartColors.border),
        ),
        child: _AiMarkdownText(
          text: message.content,
          color: isUser ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _AiMarkdownText extends StatelessWidget {
  final String text;
  final Color color;

  const _AiMarkdownText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.body.copyWith(color: color, height: 1.42);
    final parts = text.split(RegExp(r'(\*\*.*?\*\*)'));
    return Text.rich(
      TextSpan(
        children: parts.map((part) {
          final isBold = part.startsWith('**') && part.endsWith('**');
          return TextSpan(
            text: isBold ? part.substring(2, part.length - 2) : part,
            style: isBold
                ? baseStyle.copyWith(fontWeight: FontWeight.w800)
                : baseStyle,
          );
        }).toList(),
      ),
    );
  }
}

class _AiTypingBubble extends StatelessWidget {
  const _AiTypingBubble();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SmartPill(label: 'AI đang trả lời...', tone: SmartTone.neutral),
      ),
    );
  }
}

class _AiInlineError extends StatelessWidget {
  final String message;

  const _AiInlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: SmartColors.danger,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: SmartColors.danger),
          ),
        ),
      ],
    );
  }
}

class _AiComposer extends StatelessWidget {
  final HomeController controller;

  const _AiComposer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: SmartColors.surface,
        border: Border.all(color: SmartColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller.aiPromptController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              onChanged: (value) => controller.aiPrompt.value = value,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Nhập câu hỏi hoặc yêu cầu...',
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          Obx(
            () => IconButton.filled(
              tooltip: 'Gửi yêu cầu',
              onPressed: controller.isAiSending.value
                  ? null
                  : controller.sendAiPrompt,
              icon: controller.isAiSending.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.arrow_upward_rounded),
              style: IconButton.styleFrom(
                backgroundColor: SmartColors.accent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
