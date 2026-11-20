import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavigationBottomBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback onHome;
  final VoidCallback? onNext;
  final String? centerLabel;

  const NavigationBottomBar({
    super.key,
    this.onBack,
    required this.onHome,
    this.onNext,
    this.centerLabel = 'Home',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            ElevatedButton.icon(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: onBack != null ? Colors.white : const Color(0xFFF1F5F9),
                foregroundColor: onBack != null ? AppColors.textMain : AppColors.textMuted,
                elevation: 0,
                side: BorderSide(
                  color: onBack != null ? AppColors.border : Colors.transparent,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Quay lại', style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            // Home Button
            InkWell(
              onTap: onHome,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      centerLabel ?? 'Home',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next / Forward Button
            ElevatedButton.icon(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: onNext != null ? Colors.white : const Color(0xFFF1F5F9),
                foregroundColor: onNext != null ? AppColors.textMain : AppColors.textMuted,
                elevation: 0,
                side: BorderSide(
                  color: onNext != null ? AppColors.border : Colors.transparent,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Text('Tiếp', style: TextStyle(fontWeight: FontWeight.bold)),
              label: const Icon(Icons.arrow_forward_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
