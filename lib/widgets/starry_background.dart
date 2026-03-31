import 'package:flutter/material.dart';
import 'dart:math';

class StarryBackground extends StatefulWidget {
  final Widget child;

  const StarryBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground> {
  late List<Star> stars;

  @override
  void initState() {
    super.initState();
    stars = List.generate(100, (_) => Star());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFF0F172A),
          child: CustomPaint(
            painter: StarPainter(stars),
            size: Size.infinite,
          ),
        ),
        Container(
          color: const Color(0xFF0F172A).withOpacity(0.3),
        ),
        widget.child,
      ],
    );
  }
}

class Star {
  late double x;
  late double y;
  late double size;
  late double opacity;

  Star() {
    x = Random().nextDouble();
    y = Random().nextDouble();
    size = Random().nextDouble() * 2 + 0.5;
    opacity = Random().nextDouble() * 0.7 + 0.3;
  }
}

class StarPainter extends CustomPainter {
  final List<Star> stars;

  StarPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var star in stars) {
      paint.color = Colors.white.withOpacity(star.opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => false;
}
