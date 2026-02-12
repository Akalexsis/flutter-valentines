import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ValentineHome(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>
    with SingleTickerProviderStateMixin {
  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';

  bool isAnimated = false;
  late final AnimationController _controller;

  bool _balloonsOn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _toggleBalloons() {
    setState(() => _balloonsOn = !_balloonsOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cupid\'s Canvas')),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // PART 1: Core UI / Base Implementations
          DropdownButton<String>(
            value: selectedEmoji,
            items: emojiOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) =>
                setState(() => selectedEmoji = value ?? selectedEmoji),
          ),

          const SizedBox(height: 8),

          AnimatedScale(
            duration: const Duration(milliseconds: 500),
            scale: isAnimated ? 1.5 : 1.0,
            child: CustomPaint(
              size: const Size(300, 220),
              painter: HeartEmojiPainter(type: selectedEmoji),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                isAnimated = true;
              });

              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  isAnimated = false;
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),
            child: const Text("Pulse Heart"),
          ),

          const SizedBox(height: 8),

          // PART 2: Celebration / Enhanced Visual Effects
          FilledButton.icon(
            onPressed: _toggleBalloons,
            icon: const Icon(Icons.celebration),
            label: Text(_balloonsOn ? 'Stop Finale' : 'Balloon Finale'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF2D8D),
              foregroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(320, 320),
                    painter: ValentineScenePainter(
                      type: selectedEmoji,
                      t: _controller.value,
                      balloonsOn: _balloonsOn,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  HeartEmojiPainter({required this.type});
  final String type;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 55)
      ..cubicTo(center.dx + 95, center.dy - 5,
          center.dx + 55, center.dy - 105, center.dx, center.dy - 35)
      ..cubicTo(center.dx - 55, center.dy - 105,
          center.dx - 95, center.dy - 5, center.dx, center.dy + 55)
      ..close();

    Paint heartPaint;

    if (type == 'Party Heart') {
      heartPaint = Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFFF7AB5),
            Color(0xFFFF2D8D),
            Color(0xFF7C4DFF),
          ],
        ).createShader(
          Rect.fromCenter(center: center, width: 220, height: 220),
        );
    } else {
      heartPaint = Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFFF7AB5),
            Color(0xFFFF2D8D),
            Color(0xFF8A0030),
          ],
        ).createShader(
          Rect.fromCenter(center: center, width: 220, height: 220),
        );
    }

    canvas.drawPath(heartPath, heartPaint);

    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - 22, center.dy - 10), 7, eyePaint);
    canvas.drawCircle(Offset(center.dx + 22, center.dy - 10), 7, eyePaint);

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy + 18), radius: 20),
      0,
      pi,
      false,
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) =>
      oldDelegate.type != type;
}

class ValentineScenePainter extends CustomPainter {
  ValentineScenePainter({
    required this.type,
    required this.t,
    required this.balloonsOn,
  });

  final String type;
  final double t;
  final bool balloonsOn;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Offset.zero & size;

    final backgroundShader = const RadialGradient(
      colors: [
        Color(0xFFFFA6C9),
        Color(0xFFFF2D8D),
        Color(0xFFB0005A),
      ],
      stops: [0.0, 0.6, 1.0],
    ).createShader(rect);

    canvas.drawRect(rect, Paint()..shader = backgroundShader);

    final auraPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.white.withOpacity(0.15);

    final auraPath = Path()
      ..moveTo(center.dx, center.dy + 65)
      ..cubicTo(center.dx + 120, center.dy - 10,
          center.dx + 65, center.dy - 130, center.dx, center.dy - 45)
      ..cubicTo(center.dx - 65, center.dy - 130,
          center.dx - 120, center.dy - 10, center.dx, center.dy + 65)
      ..close();

    canvas.drawPath(auraPath, auraPaint);

    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(center.dx + 110, center.dy - 10,
          center.dx + 60, center.dy - 120, center.dx, center.dy - 40)
      ..cubicTo(center.dx - 60, center.dy - 120,
          center.dx - 110, center.dy - 10, center.dx, center.dy + 60)
      ..close();

    final heartRect = Rect.fromCenter(center: center, width: 260, height: 260);

    final heartShader = const LinearGradient(
      colors: [
        Color(0xFFFF7AB5),
        Color(0xFFFF2D8D),
        Color(0xFF8A0030),
      ],
    ).createShader(heartRect);

    canvas.drawPath(
      heartPath,
      Paint()
        ..shader = heartShader
        ..style = PaintingStyle.fill,
    );

    final eyePaint = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(center.dx - 30, center.dy - 10), 10, eyePaint);
    canvas.drawCircle(Offset(center.dx + 30, center.dy - 10), 10, eyePaint);

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy + 20), radius: 30),
      0,
      pi,
      false,
      mouthPaint,
    );

    final sparklePaint = Paint()..color = Colors.white.withOpacity(0.6);

    for (int i = 0; i < 10; i++) {
      final angle = (i * 2 * pi / 10) + t * 2 * pi;
      final r = 140.0;

      final p = Offset(
        center.dx + cos(angle) * r,
        center.dy + sin(angle) * r,
      );

      canvas.drawCircle(p, 2.5, sparklePaint);
    }

    if (balloonsOn) {
      final balloonPaint = Paint()
        ..color = const Color(0xFFFF2D8D)
        ..style = PaintingStyle.fill;

      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 8; i++) {
        final x = (i + 1) * size.width / 9;
        final phase = (t + i * 0.12) % 1.0;
        final y = phase * (size.height + 120) - 120;

        final balloonRect = Rect.fromCenter(
          center: Offset(x, y),
          width: 40,
          height: 55,
        );

        canvas.drawOval(balloonRect, balloonPaint);

        final shineRect = Rect.fromCenter(
          center: Offset(x - 8, y - 10),
          width: 10,
          height: 18,
        );

        canvas.drawOval(shineRect, shinePaint);

        canvas.drawLine(
          Offset(x, y + 25),
          Offset(x, y + 70),
          Paint()
            ..color = Colors.black.withOpacity(0.3)
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ValentineScenePainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.type != type ||
      oldDelegate.balloonsOn != balloonsOn;
}
