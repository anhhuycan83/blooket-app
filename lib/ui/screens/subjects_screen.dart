import 'package:flutter/material.dart';
import '../../models/curriculum.dart';
import '../../services/data_service.dart';
import '../../services/release_notes_data.dart';
import '../../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/grade_tab_bar.dart';
import 'settings_screen.dart';
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

  Widget _buildVersionChip(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => ReleaseNotesData.showReleaseNotesDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'v${ReleaseNotesData.currentVersion}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 3),
            Icon(Icons.info_outline_rounded, size: 12, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentGrade = _grades.isNotEmpty ? _grades[_selectedGradeIndex] : null;
    final isCompact = MediaQuery.sizeOf(context).width < 560;
    final backendVer = DataService().backendVersion;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings_rounded, color: AppColors.primary, size: 26),
          tooltip: 'Cài đặt & About',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                isCompact ? 'Blooket Ôn Luyện' : 'Blooket Học Tập & Ôn Luyện',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isCompact ? 17 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ),
            if (!isCompact) ...[
              const SizedBox(width: 8),
              _buildVersionChip(context),
            ],
          ],
        ),
        actions: [
          // Total Flags badge
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: isCompact ? 4 : 8),
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🚩', style: TextStyle(fontSize: isCompact ? 14 : 16)),
                const SizedBox(width: 4),
                Text(
                  '$_totalFlags Cờ',
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentDark,
                  ),
                ),
              ],
            ),
          ),
          // Streak badge
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: isCompact ? 10 : 16),
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.blooketRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.blooketRed, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔥', style: TextStyle(fontSize: isCompact ? 14 : 16)),
                const SizedBox(width: 4),
                Text(
                  '$_streak',
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 14,
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
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
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
              ),

              // Web/App Footer: Frontend & Backend Versions + Release Notes link
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Text(
                      'App v${ReleaseNotesData.currentVersion} (${ReleaseNotesData.currentBuild})',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const Text('•', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: (DataService().isUsingLiveBackend
                                ? AppColors.success
                                : AppColors.textMuted)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'BE v$backendVer',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: DataService().isUsingLiveBackend
                              ? AppColors.success
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                    const Text('•', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    InkWell(
                      onTap: () => ReleaseNotesData.showReleaseNotesDialog(context),
                      child: const Text(
                        'Xem nhật ký cập nhật (Release Notes)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
