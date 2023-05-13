import 'package:flutter/material.dart';
import 'package:flutter_shaders_poc/blurhash_widget.dart';
import 'package:flutter_shaders_poc/camera_widget.dart';
import 'package:flutter_shaders_poc/gradient_widget.dart';
import 'package:flutter_shaders_poc/warp_comparison_widget.dart';
import 'package:flutter_shaders_poc/warp_counter_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;

  final List _pages = [
    () => GradientWidget(),
    () => WarpComparisonWidget(),
    () => WarpCounterWidget(),
    () => CameraWidget(),
    () => BlurHashWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index](),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.looks_one), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.looks_two), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.looks_3), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.looks_4), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.looks_5), label: ''),
        ],
      ),
    );
  }
}
