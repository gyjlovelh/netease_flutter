import 'package:flutter/material.dart';
import './icon_buttons_item.dart';
import './icon_buttons_vo.dart';

Widget iconButtonsMine(List<IconButtonsVO> list) {
  return Container(
    // height: ScreenUtil.instance.setHeight(40.0),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          child: IconButtonsItem(
            itemVO: list[index],
          ),
        );
      },
    ),
  );
}
