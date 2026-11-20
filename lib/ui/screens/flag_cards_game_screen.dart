import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';
import '../theme/app_theme.dart';

class FlagCardsGameScreen extends StatefulWidget {
  final LessonData lesson;

  const FlagCardsGameScreen({super.key, required this.lesson});

  @override
  State<FlagCardsGameScreen> createState() => _FlagCardsGameScreenState();
}

class _FlagCardsGameScreenState extends State<FlagCardsGameScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _flagsEarned = 0;
  int _correctCount = 0;

  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  bool _isGameOver = false;

  final List<Color> _blooketColors = [
    AppColors.blooketRed,
    AppColors.blooketBlue,
    AppColors.blooketGreen,
    AppColors.blooketYellow,
  ];

  final List<String> _optionPrefixes = ['A', 'B', 'C', 'D'];

  // Shuffled view for the active question: list of options and current correct index
  List<String> _currentOptions = [];
  int _currentCorrectIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupCurrentQuestion();
  }

  void _setupCurrentQuestion() {
    if (widget.lesson.exercises.isEmpty) return;
    final question = widget.lesson.exercises[_currentQuestionIndex];
    final originalOptions = List<String>.from(question.options);
    final correctValue = (question.correctIndex >= 0 && question.correctIndex < originalOptions.length)
        ? originalOptions[question.correctIndex]
        : originalOptions.first;

    // Shuffle options randomly each time question appears
    originalOptions.shuffle();
    _currentOptions = originalOptions;
    _currentCorrectIndex = _currentOptions.indexOf(correctValue);
  }

  void _handleOptionSelect(int index) {
    if (_hasAnswered) return;

    final question = widget.lesson.exercises[_currentQuestionIndex];
    final isCorrect = index == _currentCorrectIndex;

    setState(() {
      _selectedOptionIndex = index;
      _hasAnswered = true;

      if (isCorrect) {
        _correctCount++;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;

        // Blooket Flag Reward mechanism: every correct answer grants flags + combo multiplier!
        final multiplier = _streak >= 3 ? 2 : 1;
        _score += question.points * multiplier;
        _flagsEarned += (1 * multiplier);
      } else {
        _streak = 0;
      }
    });

    if (isCorrect) {
      TtsService().speak('Correct! Well done!');
    } else {
      TtsService().speak('Incorrect! Keep trying!');
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.lesson.exercises.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
        _setupCurrentQuestion();
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final total = widget.lesson.exercises.length;
    final percent = total > 0 ? (_correctCount / total) * 100 : 0;
    int stars = 1;
    if (percent >= 80) {
      stars = 3;
    } else if (percent >= 50) {
      stars = 2;
    }

    // Save progress to LocalStorage
    final prog = await StorageService().getProgress(widget.lesson.id);
    final newProg = prog.copyWith(
      exercisesCompleted: true,
      highestScore: _score > prog.highestScore ? _score : prog.highestScore,
      flagsEarned: prog.flagsEarned + _flagsEarned,
      stars: stars > prog.stars ? stars : prog.stars,
    );
    await StorageService().saveProgress(newProg);
    await StorageService().addFlags(_flagsEarned);

    setState(() => _isGameOver = true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game Bài Tập')),
        body: const Center(child: Text('Chưa có câu hỏi bài tập cho bài học này!')),
      );
    }

    if (_isGameOver) {
      return _buildGameOverScreen();
    }

    final question = widget.lesson.exercises[_currentQuestionIndex];
    final totalQuestions = widget.lesson.exercises.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text('${widget.lesson.subjectName} - Flag Cards Game'),
        actions: [
          // Current Game Flags
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: Row(
              children: [
                const Text('🚩', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '+$_flagsEarned',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentDark),
                ),
              ],
            ),
          ),
          // Streak Counter
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _streak > 1 ? AppColors.blooketRed : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  'Streak: $_streak',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _streak > 1 ? Colors.white : AppColors.textMain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / totalQuestions,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),

              // Game Status Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Câu ${_currentQuestionIndex + 1} / $totalQuestions',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Điểm: $_score PTS',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Question Box
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          question.lesson,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        question.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Explanation / Feedback box when answered
              if (_hasAnswered)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedOptionIndex == _currentCorrectIndex
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedOptionIndex == _currentCorrectIndex
                          ? AppColors.blooketGreen
                          : AppColors.blooketRed,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedOptionIndex == _currentCorrectIndex
                            ? Icons.check_circle_rounded
                            : Icons.info_rounded,
                        color: _selectedOptionIndex == _currentCorrectIndex
                            ? AppColors.blooketGreen
                            : AppColors.blooketRed,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedOptionIndex == _currentCorrectIndex
                              ? 'Chính xác! +${question.points} điểm 🚩'
                              : 'Giải thích: ${question.explanation}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _selectedOptionIndex == _currentCorrectIndex
                                ? AppColors.blooketGreen
                                : AppColors.blooketRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // 4 Blooket Answer Choices (2x2 Grid)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.3,
                    ),
                    itemCount: _currentOptions.length,
                    itemBuilder: (context, index) {
                      final optionText = _currentOptions[index];
                      final baseColor = _blooketColors[index % _blooketColors.length];

                      Color cardColor = baseColor;
                      Color borderColor = Colors.white.withOpacity(0.3);

                      if (_hasAnswered) {
                        if (index == _currentCorrectIndex) {
                          cardColor = AppColors.blooketGreen;
                          borderColor = Colors.white;
                        } else if (index == _selectedOptionIndex) {
                          cardColor = AppColors.blooketRed;
                          borderColor = Colors.white;
                        } else {
                          cardColor = baseColor.withOpacity(0.35);
                        }
                      }

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _handleOptionSelect(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: cardColor.withOpacity(0.3),
                                offset: const Offset(0, 6),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    _optionPrefixes[index % 4],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bottom Action button when answered
              if (_hasAnswered)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        _currentQuestionIndex < totalQuestions - 1
                            ? 'Câu Kế Tiếp ➡️'
                            : 'Xem Kết Quả Tổng Kết 🏆',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // GameOver Summary Screen
  Widget _buildGameOverScreen() {
    final total = widget.lesson.exercises.length;
    final percent = total > 0 ? ((_correctCount / total) * 100).round() : 0;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Celebration Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 52)),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Chúc Mừng Bạn Đã Hoàn Thành!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.lesson.title} - Tuần ${widget.lesson.week}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),

                // Score card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Điểm Số', '$_score', '⭐', AppColors.primary),
                          _buildStatItem('Cờ Nhận Được', '+$_flagsEarned', '🚩', AppColors.accentDark),
                          _buildStatItem('Chính Xác', '$percent%', '🎯', AppColors.success),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Độ chính xác: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('$_correctCount / $total câu', style: const TextStyle(color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chuỗi đúng liên tiếp dài nhất: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('$_maxStreak câu 🔥', style: const TextStyle(color: AppColors.blooketRed, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Buttons: Chơi lại or Quay về
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex = 0;
                            _score = 0;
                            _streak = 0;
                            _flagsEarned = 0;
                            _correctCount = 0;
                            _selectedOptionIndex = null;
                            _hasAnswered = false;
                            _isGameOver = false;
                            _setupCurrentQuestion();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.textMain,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: AppColors.border, width: 2),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Chơi Lại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text('Hoàn Thành', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
