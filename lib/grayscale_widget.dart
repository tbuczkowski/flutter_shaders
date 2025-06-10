import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GrayscaleWidget extends StatefulWidget {
  const GrayscaleWidget({super.key});

  @override
  _GrayscaleWidgetState createState() => _GrayscaleWidgetState();
}

class _GrayscaleWidgetState extends State<GrayscaleWidget> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Grayscale')),
        body: Column(
          children: [
            Expanded(
              child: ShaderBuilder(
                assetKey: 'shaders/liquidglass.frag',
                (BuildContext context, FragmentShader liquidglass, _) => AnimatedSampler(
                  (ui.Image image, Size size, Canvas canvas) {
                    liquidglass
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setFloat(2, _elapsed.inMilliseconds.toDouble() / 1000)
                      ..setImageSampler(0, image);
                    canvas.drawRect(Offset.zero & size, Paint()..shader = liquidglass);
                  },
                  child: _Image(),
                ),
              ),
            ),
            Expanded(
              child: ShaderBuilder(
                assetKey: 'shaders/grayscale.frag',
                (BuildContext context, FragmentShader shader, _) => AnimatedSampler(
                  (ui.Image image, Size size, Canvas canvas) {
                    shader
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setImageSampler(0, image);
                    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
                  },
                  child: _Image(),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Image extends StatelessWidget {
  const _Image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://storage.googleapis.com/cms-storage-bucket/780e0e64d323aad2cdd5.png',
      fit: BoxFit.fitHeight,
    );
  }
}
