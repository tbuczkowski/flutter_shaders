import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class MathShaderWidget extends StatefulWidget {
  const MathShaderWidget({super.key});

  @override
  State<MathShaderWidget> createState() => _MathShaderWidgetState();
}

class _MathShaderWidgetState extends State<MathShaderWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
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
          painter: MathShaderPainter(shader, _currentTime),
          // painter: MathCustomPainter(_currentTime),
        ),
      );
}

class MathShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final Duration currentTime;

  MathShaderPainter(
    this.shader,
    this.currentTime,
  );

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, currentTime.inMilliseconds.toDouble());
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MathCustomPainter extends CustomPainter {
  static const double scaleFactor = 8;
  static const double timeScale = 0.005;

  final Duration currentTime;

  MathCustomPainter(this.currentTime);

  double normalizeTrigonometricFunction(double value) => (value + 1) / 2;

  Color mix(Color x, Color y, double a) => Color.fromARGB(
        255,
        (y.red * a + x.red * (1 - a)).round(),
        (y.green * a + x.green * (1 - a)).round(),
        (y.blue * a + x.blue * (1 - a)).round(),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final double scaledTime = currentTime.inMilliseconds.toDouble() * timeScale;
    for (double x = 0; x < size.width; x++) {
      final double normalizedX = x / size.width;
      final double verticalStripe = normalizeTrigonometricFunction(sin(normalizedX * pi * scaleFactor + scaledTime));
      for (double y = 0; y < size.height; y++) {
        final double normalizedY = y / size.height;
        final double horizontalStripe =
            normalizeTrigonometricFunction(cos(normalizedY * pi * scaleFactor + scaledTime));
        final double diagonalStripe =
            normalizeTrigonometricFunction(sin((normalizedX + normalizedY) * pi * scaleFactor + scaledTime));
        final Color verticalStripeColor = Color.fromARGB(255, (255 * verticalStripe).round(), 0, 0);
        final Color horizontalStripeColor = Color.fromARGB(255, 0, (255 * horizontalStripe).round(), 0);
        final Color diagonalStripeColor = Color.fromARGB(255, 0, 0, (255 * diagonalStripe).round());
        paint.color = mix(
          mix(verticalStripeColor, horizontalStripeColor, normalizedX),
          diagonalStripeColor,
          normalizedY,
        );
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
