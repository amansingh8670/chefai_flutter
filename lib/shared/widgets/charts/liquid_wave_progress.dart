import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiquidWaveProgress extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color waveColor;
  final Color backgroundColor;

  const LiquidWaveProgress({
    super.key,
    required this.progress,
    required this.waveColor,
    required this.backgroundColor,
  });

  @override
  State<LiquidWaveProgress> createState() => _LiquidWaveProgressState();
}

class _LiquidWaveProgressState extends State<LiquidWaveProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _LiquidWavePainter(
            progress: widget.progress.clamp(0.0, 1.0),
            animationValue: _controller.value,
            waveColor: widget.waveColor,
            backgroundColor: widget.backgroundColor,
          ),
        );
      },
    );
  }
}

class _LiquidWavePainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color waveColor;
  final Color backgroundColor;

  _LiquidWavePainter({
    required this.progress,
    required this.animationValue,
    required this.waveColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw background circle
    final bgPaint = Paint()..color = backgroundColor;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Draw Waves
    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    // Create a circular clipping path so waves stay inside the circle
    final clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clipPath);

    // Calculate Y offset based on progress (0.0 = bottom, 1.0 = top)
    final topY = size.height - (size.height * progress);

    final path = Path();
    path.moveTo(0, size.height); // Start at bottom left
    path.lineTo(0, topY);

    // Draw the sine wave across the width
    final waveWidth = size.width;
    final waveHeight = 10.0; // Amplitude of the wave
    
    // Shift the wave horizontally based on animationValue
    final offset = animationValue * math.pi * 2;

    for (double i = 0.0; i <= size.width; i++) {
      // Map x to a sine wave phase
      final xPhase = (i / waveWidth) * math.pi * 2;
      final y = topY + math.sin(xPhase + offset) * waveHeight;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height); // End at bottom right
    path.close();

    canvas.drawPath(path, wavePaint);

    // Optional: Draw a secondary wave for depth
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, topY);
    
    final offset2 = (animationValue + 0.5) * math.pi * 2; // Offset phase

    for (double i = 0.0; i <= size.width; i++) {
      final xPhase = (i / waveWidth) * math.pi * 1.5;
      final y = topY + math.sin(xPhase - offset2) * (waveHeight * 0.8);
      path2.lineTo(i, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    
    final wavePaint2 = Paint()
      ..color = waveColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
      
    canvas.drawPath(path2, wavePaint2);

    canvas.restore();
    
    // 3. Draw outline border (optional to match image)
    final borderPaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.progress != progress ||
        oldDelegate.waveColor != waveColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
