import 'package:flutter/material.dart';
import '../../models/curriculum.dart';
import '../../services/data_service.dart';
import '../../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/grade_tab_bar.dart';
import 'weeks_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<GradeItem> _grades = [];
  int _selectedGradeIndex = 0;
  bool _isLoading = true;
  int _totalFlags = 0;
  int _streak = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final grades = await DataService().getCurriculumTree();
      final flags = await StorageService().getTotalFlags();
      final streak = await StorageService().getStreak();
      setState(() {
        _grades = grades;
        _totalFlags = flags;
        _streak = streak;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'school':
      default:
        return Icons.menu_book_rounded;
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentGrade = _grades.isNotEmpty ? _grades[_selectedGradeIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blooket Học Tập & Ôn Luyện'),
        actions: [
          // Total Flags badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: Row(
              children: [
                const Text('🚩', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '$_totalFlags Cờ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentDark,
                  ),
                ),
              ],
            ),
          ),
          // Streak badge
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.blooketRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.blooketRed, width: 1.5),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '$_streak',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blooketRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Wireframe app_2.jpg Top Tabs: Lớp 5 | Lớp 6 | Lớp 7
              GradeTabBar(
                grades: _grades,
                selectedIndex: _selectedGradeIndex,
                onTabSelected: (index) {
                  setState(() => _selectedGradeIndex = index);
                },
              ),
              const SizedBox(height: 16),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Icon(Icons.category_rounded, color: AppColors.primary, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Danh Sách Môn Học - ${currentGrade?.name ?? ""}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Wireframe app_2.jpg: Grid/Cards of Subjects (Anh Văn, Toán...)
              Expanded(
                child: currentGrade == null || currentGrade.subjects.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.hourglass_empty_rounded, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              'Nội dung ${currentGrade?.name} đang được biên soạn!',
                              style: const TextStyle(fontSize: 16, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: 170,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: currentGrade.subjects.length,
                        itemBuilder: (context, index) {
                          final subject = currentGrade.subjects[index];
                          final color = _parseColor(subject.color);

                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeeksScreen(
                                    grades: _grades,
                                    currentGradeIndex: _selectedGradeIndex,
                                    subject: subject,
                                  ),
                                ),
                              );
                              // Refresh stats when back
                              _loadData();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: color.withOpacity(0.3), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.12),
                                    offset: const Offset(0, 8),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: color.withOpacity(0.3), width: 2),
                                    ),
                                    child: Icon(
                                      _getIconData(subject.icon),
                                      color: color,
                                      size: 38,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          subject.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          subject.englishName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          subject.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.textMuted,
                                    size: 18,
                                  ),
                                ],
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
    );
  }
}
