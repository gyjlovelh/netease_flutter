import 'package:flutter/material.dart';
import '../../../../shared/widgets/icon_data/icon_data.dart';
import './music_list_vo.dart';

class MusicListItem extends StatelessWidget {
  final MusicListVO musicListVO;

  MusicListItem({Key key, @required this.musicListVO}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Image.network(musicListVO.header),
          ),
          Expanded(flex: 1,child: Text(musicListVO.title),),
          Expanded(flex: 0,child: NeteaseIconData(0xe62b,color: Colors.grey,),),
        ],
      ),
    );
  }
}
