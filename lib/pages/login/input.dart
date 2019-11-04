import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeteaseInput extends StatefulWidget {

  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;

  NeteaseInput({
    @required this.controller,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false
  });

  @override
  _NeteaseInputState createState() => _NeteaseInputState();
}

class _NeteaseInputState extends State<NeteaseInput> {

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);

    return Container(
      child: TextField(
        controller: widget.controller,
        autofocus: false,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: ScreenUtil.getInstance().setSp(32.0)
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.prefixIcon, 
            size: ScreenUtil.getInstance().setSp(38.0),
            color: Theme.of(context).textSelectionColor
          )
        ),
        style: TextStyle(
          color: Colors.white70,
          fontSize: ScreenUtil.getInstance().setSp(32.0)
        ),
        obscureText: widget.obscureText
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).textSelectionColor.withOpacity(0.3),
            width: 1.0
          )
        )
      ),
    );
  }
}