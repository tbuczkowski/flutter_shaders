import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  bool useShader = false;

  final Future<List<CameraDescription>> _camerasFuture = availableCameras();
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    _camerasFuture.then((cameras) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        controller.startImageStream((image) => setState(() {}));
      }).catchError((Object e) => print(e));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              setState(() {
                useShader = !useShader;
              });
            },
            icon: Icon(useShader ? Icons.check_box : Icons.check_box_outline_blank)),
      ]),
      body: FutureBuilder(
        future: _camerasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (useShader) {
              return ShaderBuilder(
                assetKey: 'shaders/sobel.frag',
                (BuildContext context, FragmentShader shader, _) => AnimatedSampler(
                  (ui.Image image, Size size, Canvas canvas) {
                    shader
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setImageSampler(0, image);
                    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
                  },
                  child: Center(
                    child: CameraPreview(controller),
                  ),
                ),
              );
            } else {
              return Center(child: CameraPreview(controller));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
