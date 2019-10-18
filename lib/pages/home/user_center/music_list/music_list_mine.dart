import 'package:flutter/material.dart';
import './music_list_vo.dart';
import './music_list_item.dart';

Widget musicListMine(List<MusicListVO> list) {
  return Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context,index){
        return Container(
          child: MusicListItem(
            musicListVO:list[index],
          ),
        );
      },
    ),
  );
}
