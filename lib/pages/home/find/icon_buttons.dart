import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';

class NeteaseIconButtons extends StatelessWidget {

  Widget iconButtonItem(int pointer, {String label, VoidCallback onPressed}) => Container(

    child: GestureDetector(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(15.0)),
            padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(24.0)),
            decoration: BoxDecoration(
              color: Color.fromRGBO(130, 158, 172, 1),
              borderRadius: BorderRadius.circular(99.0)
            ),
            child: NeteaseIconData(pointer, color: Colors.white, size: ScreenUtil.getInstance().setSp(42.0),),
          ),
          Text(label, style: TextStyle(
            color: Colors.white,
            fontSize: SizeSetting.size_12
          ))
        ],
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil.getInstance().setWidth(34.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          iconButtonItem(0xe652, label: '每日推荐', onPressed: () {
            Navigator.of(context).pushNamed('commend_songs');
          }),
          iconButtonItem(0xe608, label: '私人FM', onPressed: () {
            // todo 暂时还有bug。
            // 若当前不是正在播放FM，则重新加载数据。
            if (Global.playMode == 1) {
              Provider.of<PlayerSongDemand>(context).loadMusic(Global.getFmList().first, playMode: 2);
            }
            Navigator.of(context).pushNamed('personal_fm');
          }),
          iconButtonItem(0xe60d, label: '歌单', onPressed: () {
            Navigator.of(context).pushNamed('playlist_square');
          }),
          iconButtonItem(0xe61d, label: '音乐', onPressed: () {
            Navigator.of(context).pushNamed('latest_song');
          }),
          iconButtonItem(0xe6ab, label: '排行榜', onPressed: () {
            Navigator.of(context).pushNamed('rank_list');
          })
        ],
      ),
    );
  }
}