import 'package:flutter/material.dart';

class NeteaseIconData extends StatelessWidget {

  final int pointer;

  final double size;

  final Color color;

  NeteaseIconData(
    this.pointer, {
      this.size,
      this.color
    }
  );

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(pointer, fontFamily: 'iconfont'),
      size: size,
      color: color,
    );
  }
}