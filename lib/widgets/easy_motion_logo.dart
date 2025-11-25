import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Светло-зеленый цвет фона для логотипа (lightGreenAccent)
const Color _brightGreen = Color(0xFFB2FF59); // Colors.lightGreenAccent
const Color _black = Color(0xFF000000);

/// Виджет логотипа Easy Motion
/// Черный графический элемент на ярко-зеленом фоне
/// С центральным кругом, 12 радиальными линиями и спиралевидной структурой
class EasyMotionLogo extends StatelessWidget {
  final double size;
  final bool showBackground;

  const EasyMotionLogo({super.key, this.size = 80, this.showBackground = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: _brightGreen,
              borderRadius: BorderRadius.circular(size / 8),
            )
          : null,
      child: CustomPaint(painter: _EasyMotionLogoPainter()),
    );
  }
}

class _EasyMotionLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.65);
    final centralRadius = size.width / 6;
    final smallRadius = size.width / 24;

    final blackPaint = Paint()
      ..color = _black
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = _black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 60;

    // 1. Центральный черный круг
    canvas.drawCircle(center, centralRadius, blackPaint);

    // 2. Двенадцать радиальных линий от центра
    final int linesCount = 12;
    final double angleStep = (2 * math.pi) / linesCount;
    final double lineLength = size.width / 3.5;

    for (int i = 0; i < linesCount; i++) {
      final angle = i * angleStep - math.pi / 2; // Начинаем сверху
      final endX = center.dx + lineLength * math.cos(angle);
      final endY = center.dy + lineLength * math.sin(angle);
      canvas.drawLine(center, Offset(endX, endY), linePaint);
    }

    // 3. Спиралевидная структура с кругами, идущая вверх и вправо
    final spiralPoints = <Offset>[];
    final int spiralPointsCount = 25;
    final double spiralStartAngle = -math.pi / 2; // Начинаем сверху
    final double spiralEndAngle = math.pi / 4; // Заканчиваем вверху-справа
    final double spiralAngleRange = spiralEndAngle - spiralStartAngle;

    for (int i = 0; i < spiralPointsCount; i++) {
      final progress = i / (spiralPointsCount - 1);

      // Угол увеличивается по спирали
      final angle = spiralStartAngle + spiralAngleRange * progress;

      // Расстояние увеличивается по спирали (логарифмическая спираль)
      final baseDistance = lineLength * 1.2;
      final distance =
          baseDistance *
          (1.0 + progress * 1.8) *
          (0.9 + 0.1 * math.sin(progress * math.pi * 4));

      // Позиция точки на спирали
      final pointX = center.dx + distance * math.cos(angle);
      final pointY = center.dy + distance * math.sin(angle);

      spiralPoints.add(Offset(pointX, pointY));

      // Размер круга уменьшается по мере удаления от центра
      final circleRadius = smallRadius * (1.0 - progress * 0.6);
      if (circleRadius > 0.5) {
        canvas.drawCircle(Offset(pointX, pointY), circleRadius, blackPaint);
      }
    }

    // 4. "Стебельки" для некоторых кругов в верхней части спирали
    final stemPaint = Paint()
      ..color = _black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 80;

    for (int i = spiralPointsCount ~/ 2; i < spiralPoints.length - 1; i++) {
      if (i % 3 == 0) {
        // Каждый третий круг получает стебелек
        final point = spiralPoints[i];
        final stemLength = smallRadius * 1.5;
        final stemAngle = math.pi / 2 + (i % 2 == 0 ? 0.3 : -0.3);
        final stemEnd = Offset(
          point.dx + stemLength * math.cos(stemAngle),
          point.dy + stemLength * math.sin(stemAngle),
        );
        canvas.drawLine(point, stemEnd, stemPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Виджет названия студии Easy Motion
class EasyMotionTitle extends StatelessWidget {
  final TextStyle? style;
  final bool showSubtitle;

  const EasyMotionTitle({super.key, this.style, this.showSubtitle = true});

  @override
  Widget build(BuildContext context) {
    // На светлом фоне используем темный текст
    final defaultStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(
        0xFF1A1A1A,
      ), // Темно-серый вместо черного для лучшей читаемости
      letterSpacing: 2,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'EASY',
              style:
                  style?.copyWith(
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ) ??
                  defaultStyle.copyWith(color: const Color(0xFF1A1A1A)),
            ),
            const SizedBox(width: 8),
            Text('MOTION', style: style ?? defaultStyle),
          ],
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 8),
          Text(
            'это не просто тренировки,\nа понимание и контроль своего тела!',
            textAlign: TextAlign.center, // Для короткого текста допустимо
            style: TextStyle(
              fontSize: 14,
              color: const Color(
                0xFF1A1A1A,
              ).withValues(alpha: 0.7), // Полупрозрачный темно-серый
              fontStyle: FontStyle.italic,
              height: 1.6, // Принцип 16: высота строки
            ),
          ),
        ],
      ],
    );
  }
}
