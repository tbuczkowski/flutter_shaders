import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GradientWidget extends StatelessWidget {
  const GradientWidget({super.key});

  @override
  Widget build(BuildContext context) => ShaderBuilder(
        assetKey: 'shaders/gradient.frag',
        (BuildContext context, FragmentShader shader, _) => CustomPaint(
          size: MediaQuery.of(context).size,
          painter: GradientPainter(shader),
        ),
      );
}

class GradientPainter extends CustomPainter {
  final FragmentShader shader;

  GradientPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
