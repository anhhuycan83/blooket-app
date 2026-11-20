import 'package:flutter/material.dart';
import '../../services/tts_service.dart';
import '../theme/app_theme.dart';

class TtsButton extends StatefulWidget {
  final String text;
  final double size;
  final Color? color;

  const TtsButton({
    super.key,
    required this.text,
    this.size = 28,
    this.color,
  });

  @override
  State<TtsButton> createState() => _TtsButtonState();
}

class _TtsButtonState extends State<TtsButton> with SingleTickerProviderStateMixin {
  bool _isSpeaking = false;

  void _handleSpeak() async {
    setState(() => _isSpeaking = true);
    await TtsService().speak(widget.text);
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _isSpeaking = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleSpeak,
      borderRadius: BorderRadius.circular(widget.size),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isSpeaking
              ? AppColors.primary.withOpacity(0.15)
              : (widget.color ?? AppColors.primary).withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: _isSpeaking ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          _isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
          size: widget.size,
          color: widget.color ?? AppColors.primary,
        ),
      ),
    );
  }
}
