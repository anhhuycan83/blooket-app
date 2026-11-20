import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/tts_button.dart';

class TheoryScreen extends StatefulWidget {
  final LessonData lesson;

  const TheoryScreen({super.key, required this.lesson});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipAnimController;
  late Animation<double> _flipAnimation;

  // Option B: Self-test state
  final Set<String> _masteredCardIds = {};
  final Set<String> _reviewCardIds = {};
  bool _isSelfTestMode = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _flipAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipAnimController, curve: Curves.easeInOut),
    );

    // Auto speak first card if available
    if (widget.lesson.theoryCards.isNotEmpty) {
      TtsService().speak(widget.lesson.theoryCards[0].term);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flipAnimController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipAnimController.reverse();
    } else {
      _flipAnimController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _onCardChanged(int index) {
    setState(() {
      _currentIndex = index;
      _isFlipped = false;
      _flipAnimController.reset();
    });
    if (index < widget.lesson.theoryCards.length) {
      TtsService().speak(widget.lesson.theoryCards[index].term);
    }
  }

  void _markCard({required bool mastered}) async {
    final currentCard = widget.lesson.theoryCards[_currentIndex];
    setState(() {
      if (mastered) {
        _masteredCardIds.add(currentCard.id);
        _reviewCardIds.remove(currentCard.id);
      } else {
        _reviewCardIds.add(currentCard.id);
        _masteredCardIds.remove(currentCard.id);
      }
    });

    if (_currentIndex < widget.lesson.theoryCards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Completed all theory cards
      await _finishTheory();
    }
  }

  Future<void> _finishTheory() async {
    final prog = await StorageService().getProgress(widget.lesson.id);
    await StorageService().saveProgress(
      prog.copyWith(theoryCompleted: true),
    );

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('Hoàn Thành Lý Thuyết!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn đã ôn qua ${widget.lesson.theoryCards.length} thẻ kiến thức.'),
            const SizedBox(height: 8),
            Text('• Đã thuộc vững: ${_masteredCardIds.length} thẻ'),
            Text('• Cần xem lại: ${_reviewCardIds.length} thẻ'),
            const SizedBox(height: 12),
            const Text(
              'Bây giờ bạn đã sẵn sàng thử thách với Game Bài Tập để nhận cờ Blooket!',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to Hub
            },
            child: const Text('Về Menu Bài Học', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.lesson.theoryCards;
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lý Thuyết')),
        body: const Center(child: Text('Chưa có thẻ lý thuyết cho tuần này!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lý Thuyết Tuần ${widget.lesson.week}'),
        actions: [
          // Mode switch button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilterChip(
              avatar: Icon(
                _isSelfTestMode ? Icons.check_circle_outline : Icons.flip_to_back_rounded,
                size: 16,
                color: _isSelfTestMode ? AppColors.accentDark : AppColors.primary,
              ),
              label: Text(
                _isSelfTestMode ? 'Chế độ Tự Kiểm Tra' : 'Chế độ Lật Thẻ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _isSelfTestMode ? AppColors.accentDark : AppColors.primary,
                ),
              ),
              selected: _isSelfTestMode,
              onSelected: (val) {
                setState(() => _isSelfTestMode = val);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Progress indicator & Counter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thẻ ${_currentIndex + 1} / ${cards.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      'Thuộc: ${_masteredCardIds.length} | Ôn lại: ${_reviewCardIds.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / cards.length,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),

              // Flashcard View Area
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onCardChanged,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];

                    return Center(
                      child: GestureDetector(
                        onTap: _flipCard,
                        child: AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            final angle = _flipAnimation.value * pi;
                            final isUnder = angle > (pi / 2);

                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isUnder
                                  ? Transform(
                                      transform: Matrix4.identity()..rotateY(pi),
                                      alignment: Alignment.center,
                                      child: _buildCardBack(card),
                                    )
                                  : _buildCardFront(card),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              // Hint text
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app_rounded, size: 16, color: AppColors.textMuted),
                  SizedBox(width: 6),
                  Text(
                    'Chạm vào thẻ để lật mặt trước / sau',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: _isSelfTestMode
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _markCard(mastered: false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFEE2E2),
                                foregroundColor: AppColors.blooketRed,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: AppColors.blooketRed, width: 2),
                                ),
                              ),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text(
                                'Cần Ôn Lại',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _markCard(mastered: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDCFCE7),
                                foregroundColor: AppColors.blooketGreen,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: AppColors.blooketGreen, width: 2),
                                ),
                              ),
                              icon: const Icon(Icons.check_circle_rounded),
                              label: const Text(
                                'Đã Thuộc Vững',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            onPressed: _currentIndex > 0
                                ? () => _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    )
                                : null,
                          ),
                          ElevatedButton.icon(
                            onPressed: _flipCard,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.flip_rounded),
                            label: Text(
                              _isFlipped ? 'Xem Mặt Trước' : 'Lật Xem Giải Nghĩa',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: _currentIndex < cards.length - 1
                                ? () => _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    )
                                : () => _finishTheory(),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // Mặt trước của Thẻ Flashcard (Front)
  Widget _buildCardFront(TheoryCard card) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              card.category,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const Spacer(),

          // Image hint emoji or illustration
          Text(
            card.imageHint,
            style: const TextStyle(fontSize: 68),
          ),
          const SizedBox(height: 16),

          // English Term
          Text(
            card.term,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 8),

          // Phonetic & TTS Speaker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card.phonetic,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              TtsButton(text: card.term, size: 28),
            ],
          ),
          const Spacer(),

          // Bottom label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Mặt trước • Chạm để lật xem nghĩa 🔄',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  // Mặt sau của Thẻ Flashcard (Back)
  Widget _buildCardBack(TheoryCard card) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFE),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.secondary.withOpacity(0.5), width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.12),
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of back
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.term,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TtsButton(text: card.term, size: 24),
            ],
          ),
          const Divider(height: 24, thickness: 1.5),

          // Vietnamese Meaning
          const Text(
            'Nghĩa Tiếng Việt:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.vietnamese,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 16),

          // English Definition
          const Text(
            'Định nghĩa (Definition):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.definition,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 16),

          // Example in Context
          const Text(
            'Ví dụ mẫu (Example):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '“${card.example}”',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TtsButton(text: card.example, size: 20),
              ],
            ),
          ),
          const Spacer(),

          // Bottom label
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Mặt sau • Chạm để lật lại 🔄',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
