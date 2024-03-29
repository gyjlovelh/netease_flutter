import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:provider/provider.dart';

class RecommendSong extends StatefulWidget {
  final List<SongModel> songs;
  RecommendSong({@required this.songs});

  @override
  _RecommendSongState createState() => _RecommendSongState();
}

class _RecommendSongState extends State<RecommendSong> {

  Widget songItem(SongModel model) => Consumer<PlayerSongDemand>(
    builder: (context, notifier, _) {
      ScreenUtil screenUtil = ScreenUtil.getInstance();
      return GestureDetector(
        onTap: () {
          //播放当前音乐
          notifier.loadMusic(model);
          notifier.addMusicItem(model);
          Navigator.of(context).pushNamed('song_detail');
        },
        child: Container(
          width: screenUtil.setWidth(220.0),
          height: screenUtil.setWidth(320.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  bottom: screenUtil.setHeight(8.0)
                ),
                width: screenUtil.setWidth(220.0),
                height: screenUtil.setWidth(220.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("${(model.al ?? model.album)?.picUrl}"),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 4.0,
                      bottom: 4.0
                    ),
                    height: screenUtil.setWidth(65.0),
                    width: screenUtil.setWidth(65.0),
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(99.0)
                    ),
                    
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        //播放当前音乐
                        notifier.loadMusic(model);
                        notifier.addMusicItem(model);
                      },
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99.0)
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Theme.of(context).textSelectionColor,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "${model.name}", 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeSetting.size_12
                ),
              ),
              Text(
                "${(model.ar ?? model.artists).map((item) => item.name).join(',')}",
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeSetting.size_12
                ),
              )
            ],
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    List<SongModel> songs = widget.songs;

    return Container(
      margin: EdgeInsets.only(
        top: screenUtil.setHeight(30.0)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenUtil.setWidth(28.0)
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('最新单曲', style: TextStyle(
                color: Colors.white,
                fontSize: SizeSetting.size_16,
                fontWeight: FontWeight.w500
              )),
              Container(
                height: screenUtil.setHeight(42.0),
                width: screenUtil.setWidth(140.0),
                child: FlatButton(
                  highlightColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: screenUtil.setWidth(1.0),
                      color: Colors.grey[400]
                    ),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  padding: EdgeInsets.zero,
                  child: Text('最新音乐', style: TextStyle(
                    color: Colors.white70,
                    fontSize: SizeSetting.size_10,
                    fontWeight: FontWeight.w400
                  )),
                  onPressed: () {
                    Navigator.of(context).pushNamed('latest_song');
                  },
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: screenUtil.setHeight(20.0))),
          Wrap(
            runSpacing: screenUtil.setHeight(8.0),
            spacing: screenUtil.setWidth(14.0),
            children: songs.map((song) => songItem(song)).toList(),
          )
        ],
      ),
    );
  }
}