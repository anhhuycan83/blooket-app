import 'package:flutter/material.dart';
import '../../models/curriculum.dart';
import '../../models/user_progress.dart';
import '../../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/grade_tab_bar.dart';
import '../widgets/navigation_bottom_bar.dart';
import 'lesson_hub_screen.dart';

class WeeksScreen extends StatefulWidget {
  final List<GradeItem> grades;
  final int currentGradeIndex;
  final SubjectItem subject;

  const WeeksScreen({
    super.key,
    required this.grades,
    required this.currentGradeIndex,
    required this.subject,
  });

  @override
  State<WeeksScreen> createState() => _WeeksScreenState();
}

class _WeeksScreenState extends State<WeeksScreen> {
  late int _selectedGradeIndex;
  final Map<int, WeekProgress> _weekProgressMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedGradeIndex = widget.currentGradeIndex;
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);
    final gradeNum = widget.grades[_selectedGradeIndex].gradeNumber;
    for (final week in widget.subject.weeks) {
      final lessonId = 'g${gradeNum}_${widget.subject.id}_w${week.weekNumber}';
      final prog = await StorageService().getProgress(lessonId);
      _weekProgressMap[week.weekNumber] = prog;
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Color _parseColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectColor = _parseColor(widget.subject.color);
    final currentGrade = widget.grades[_selectedGradeIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject.name} - ${currentGrade.name}'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Wireframe app_3.jpg: Top Tab Bar (Lớp 5 | Lớp 6 | Lớp 7)
              GradeTabBar(
                grades: widget.grades,
                selectedIndex: _selectedGradeIndex,
                onTabSelected: (index) {
                  setState(() => _selectedGradeIndex = index);
                  _loadProgress();
                },
              ),
              const SizedBox(height: 16),

              // Subject Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: subjectColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: subjectColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            widget.subject.name,
                            style: TextStyle(
                              color: subjectColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Chọn Tuần Học (Weeks)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                    // Quick helper text
                    const Text(
                      'Tuần 9: Dữ liệu bài mẫu đầy đủ 🎯',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Wireframe app_3.jpg: Grid of W1, W2, W3, W4, W5... W9
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisExtent: 140,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: widget.subject.weeks.length,
                        itemBuilder: (context, index) {
                          final weekItem = widget.subject.weeks[index];
                          final weekNumber = weekItem.weekNumber;
                          final progress = _weekProgressMap[weekNumber];
                          final hasDone = progress?.exercisesCompleted ?? false;
                          final flags = progress?.flagsEarned ?? 0;

                          final itemColor = AppColors.parseHex(weekItem.color) ?? AppColors.textMain;
                          final itemBg = AppColors.parseHex(weekItem.bgColor) ??
                              (hasDone ? const Color(0xFFF0FDF4) : Colors.white);
                          final itemBorder = AppColors.parseHex(weekItem.borderColor) ??
                              (hasDone ? AppColors.success : AppColors.border);

                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LessonHubScreen(
                                    grade: currentGrade.gradeNumber,
                                    subject: widget.subject,
                                    week: weekNumber,
                                  ),
                                ),
                              );
                              _loadProgress();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: itemBg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: itemBorder,
                                  width: weekItem.isHighlighted ? 2.5 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: itemBorder.withOpacity(0.08),
                                    offset: const Offset(0, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Week Title (W1, W2, etc.) & Emoji
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        weekItem.title,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: itemColor,
                                        ),
                                      ),
                                      if (weekItem.emoji != null && weekItem.emoji!.isNotEmpty) ...[
                                        const SizedBox(width: 4),
                                        Text(weekItem.emoji!, style: const TextStyle(fontSize: 16)),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    weekItem.subTitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: weekItem.isHighlighted ? itemColor : AppColors.textMuted,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),

                                  // Badge: Flags or status
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: hasDone
                                          ? AppColors.success.withOpacity(0.12)
                                          : (weekItem.isHighlighted
                                              ? itemBorder.withOpacity(0.12)
                                              : const Color(0xFFF1F5F9)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          hasDone
                                              ? '🚩 $flags cờ'
                                              : (weekItem.badge ?? 'Chưa học'),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: hasDone
                                                ? AppColors.success
                                                : (weekItem.isHighlighted ? itemColor : AppColors.textMuted),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Wireframe app_3.jpg: Bottom Navigation Bar: <- | Home | ->
              NavigationBottomBar(
                onBack: () => Navigator.pop(context),
                onHome: () => Navigator.popUntil(context, (route) => route.isFirst),
                onNext: () {
                  // Jump straight to Week 9 demo!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonHubScreen(
                        grade: currentGrade.gradeNumber,
                        subject: widget.subject,
                        week: 9,
                      ),
                    ),
                  ).then((_) => _loadProgress());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
