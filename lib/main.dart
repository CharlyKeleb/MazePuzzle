import 'package:flutter/material.dart';
import 'package:maze_puzzle/views/home.dart';

void main() {
  runApp(const MazeApp());
}

class MazeApp extends StatelessWidget {
  const MazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const MazeHomePage(),
    );
  }
}
