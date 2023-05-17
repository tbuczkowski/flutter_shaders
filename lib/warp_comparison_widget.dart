import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:vector_math/vector_math.dart';

class WarpComparisonWidget extends StatefulWidget {
  const WarpComparisonWidget({super.key});

  @override
  _WarpComparisonWidgetState createState() => _WarpComparisonWidgetState();
}

class _WarpComparisonWidgetState extends State<WarpComparisonWidget> with SingleTickerProviderStateMixin {
  bool useShader = true;

  late Ticker _ticker;

  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
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
        assetKey: 'shaders/warp.frag',
        (BuildContext context, FragmentShader shader, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Warp'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      useShader = !useShader;
                    });
                  },
                  icon: Icon(useShader ? Icons.check_box : Icons.check_box_outline_blank)),
            ],
          ),
          body: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: useShader ? ShaderCustomPainter(shader, _elapsed) : ClassicCustomPainter(_elapsed),
          ),
        ),
      );
}

class ShaderCustomPainter extends CustomPainter {
  final FragmentShader shader;
  final Duration currentTime;

  ShaderCustomPainter(this.shader, this.currentTime);

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, currentTime.inMilliseconds.toDouble() / 1000.0);
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ClassicCustomPainter extends CustomPainter {
  final Duration currentTime;

  ClassicCustomPainter(this.currentTime);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final time = currentTime.inMilliseconds.toDouble();
    const strength = 0.25;
    final t = time / 8.0;
    for (double x = 0; x < size.width; x++) {
      for (double y = 0; y < size.height; y++) {
        Vector3 col = Vector3(0, 0, 0);
        Vector2 pos = Vector2(x / size.width, y / size.height);
        pos = (Vector2(0.5, 0.5) - pos);
        pos = pos * 4.0;
        for (double k = 1.0; k < 7.0; k += 1.0) {
          pos.x += strength * sin(2.0 * t + k * 1.5 * pos.y) + t * 0.5;
          pos.y += strength * cos(2.0 * t + k * 1.5 * pos.x);
        }
        col += Vector3(
          0.5 + 0.5 * cos(0 + pos.x + time),
          0.5 + 0.5 * cos(2 + pos.y + time),
          0.5 + 0.5 * cos(4 + pos.x + time),
        );
        col = Vector3(
          pow(col.x, 0.4545).toDouble(),
          pow(col.y, 0.4545).toDouble(),
          pow(col.z, 0.4545).toDouble(),
        );
        paint.color = Color.fromRGBO(
          (col.x * 255).round(),
          (col.y * 255).round(),
          (col.z * 255).round(),
          1,
        );
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
