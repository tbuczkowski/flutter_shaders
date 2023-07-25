import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class MathWidget extends StatefulWidget {
  const MathWidget({super.key});

  @override
  State<MathWidget> createState() => _MathWidgetState();
}

class _MathWidgetState extends State<MathWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _currentTime = elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShaderBuilder(
        assetKey: 'shaders/math.frag',
        (BuildContext context, FragmentShader shader, _) => CustomPaint(
          size: MediaQuery.of(context).size,
          painter: MathPainter(shader, _currentTime),
        ),
      );
}

class MathPainter extends CustomPainter {
  final FragmentShader shader;
  final Duration currentTime;

  MathPainter(
    this.shader,
    this.currentTime,
  );

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    // shader.setFloat(2, currentTime.inMilliseconds.toDouble());
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
