import 'package:flutter/material.dart';

class NeteaseListTile extends StatelessWidget {
  final ListTile listTile;

  NeteaseListTile({@required this.listTile});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: listTile,
    );
  }
}