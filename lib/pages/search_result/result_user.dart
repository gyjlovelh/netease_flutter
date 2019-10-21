import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';

class ResultUser extends StatefulWidget {

  final String searchWord;
  ResultUser({@required this.searchWord});

  @override
  _ResultUserState createState() => _ResultUserState();
}

class _ResultUserState extends State<ResultUser> {
  final int _limit = 20;
  int _offset = 0;
  bool _hasMore = true; // 是否已经到底.

  ScrollController _controller;
  List _users = List();
  int _userCount = 0;

  @override
  void initState() { 
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_offset + _limit > _userCount) {
          // 已经到底了
          _hasMore = false;
        } else {
          _offset += _limit;
          _loadMore();        
        }
      }
    });

    _loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget genderIcon(ProfileModel profile) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (profile.gender == 1) {
      return NeteaseIconData(
        0xe62c,
        color: Colors.blueAccent,
        size: screenUtil.setSp(20.0),
      );
    } else if (profile.gender == 2) {
      return NeteaseIconData(
        0xe671,
        color: Colors.redAccent,
        size: screenUtil.setSp(20.0),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SingleChildScrollView(
      child: Container(
        height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height),
        child: ListView(
          controller: _controller,
          itemExtent: screenUtil.setHeight(120.0),
          children: _users.map((item) {
            ProfileModel profile = ProfileModel.fromJson(item);

            return ListTile(
              leading: Container(
                height: screenUtil.setHeight(90.0),
                width: screenUtil.setHeight(90.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      profile.avatarUrl
                    ),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(999.0)
                ),
              ),
              title: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: 5.0,
                      ),
                      child: Text(profile.nickname, style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenUtil.setSp(28.0)
                      )),
                    ),
                    genderIcon(profile)
                  ],
                ),
              ),
              subtitle: Text(profile.signature ?? "", 
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: screenUtil.setSp(20.0)
                )
              ),
              dense: true,
              trailing: Container(
                width: screenUtil.setWidth(120.0),
                height: screenUtil.setHeight(42.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: screenUtil.setWidth(1.0),
                    color: Colors.redAccent
                  ),
                  borderRadius: BorderRadius.circular(999.0)
                ),
                padding: EdgeInsets.zero,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  textColor: Colors.redAccent,
                  child: Text('+ 关注', style: TextStyle(
                    fontSize: screenUtil.setSp(22.0)
                  )),
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () {},
                ),
              )
            );
          }).toList(),
        ),
      ),
    );
  }

  void _loadMore() async {
    var response = await RequestService.getInstance(context: context).getSearchResult(
      keywords: widget.searchWord,
      type: 1002,
      limit: _limit,
      offset: _offset
    );

    setState(() {
      _users.addAll(response['userprofiles']);
      _userCount = response['userprofileCount'];
    });
  }
}