import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class NeteaseSearch extends StatefulWidget {
  @override
  _NeteaseSearchState createState() => _NeteaseSearchState();
}

class _NeteaseSearchState extends State<NeteaseSearch> {

  Widget drawIcon(String iconUrl) {
    if (iconUrl == null) {
      return Text('');
    } else {
      return Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil.getInstance().setWidth(12.0)
        ),
        child: Image.network(
          iconUrl,
          height: ScreenUtil.getInstance().setHeight(20.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            decoration: InputDecoration(
              hintText: "关键字"
            ),
          ),
        ),
        actions: <Widget>[
          Icon(Icons.search)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenUtil.setWidth(30.0)
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('历史记录', style: TextStyle(
                        fontSize: screenUtil.setSp(28.0),
                        fontWeight: FontWeight.bold
                      )),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Container(
                    height: screenUtil.setHeight(50.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: ["记录A", "刘德华", "赵雷", "烟火里的尘埃", "偏爱小龟", "失重",
                      "记录A", "刘德华", "赵雷", "烟火里的尘埃", "偏爱小龟", "失重"].map((item) {
                        return Container(
                          margin: EdgeInsets.only(
                            right: screenUtil.setWidth(18.0)
                          ),
                          padding: EdgeInsets.zero,
                          child: FlatButton(
                            child: Text(item, style: TextStyle(
                              fontSize: screenUtil.setSp(24.0)
                            )),
                            padding: EdgeInsets.zero,
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {},
                          ),
                        );
                      }).toList()
                    )
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: screenUtil.setWidth(30.0),
                top: screenUtil.setHeight(70.0),
                bottom: screenUtil.setHeight(10.0)
              ),
              width: double.infinity,
              child: Text(
                '热搜榜',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: screenUtil.setSp(28.0)
                ),
              ),
            ),
            FutureBuilder(
              future: RequestService.getInstance(context: context).getSearchHotDetail(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {

                if (snapshot.hasData) {
                  List list = snapshot.data;
                  return Column(
                    children: list.asMap().keys.map((int index) {
                      var item = list[index];
                      return ListTile(
                        dense: true,
                        onTap: () {
                          Navigator.of(context).pushNamed('search_result', arguments: item["searchWord"]);
                        },
                        leading: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: index < 3 ? Colors.redAccent : Colors.grey,
                            fontSize: screenUtil.setSp(30.0),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        title: Row(
                          children: <Widget>[
                            Text(
                              item['searchWord'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenUtil.setSp(30.0)
                              ),
                            ),
                            drawIcon(item['iconUrl'])
                          ],
                        ),
                        subtitle: Text(
                          item['content'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenUtil.setSp(24.0)
                          )
                        ),
                        trailing: Text(
                          item['score'].toString(),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: screenUtil.setSp(24.0)
                          ),
                        ),
                      );
                    }).toList()
                  );
                } else {
                  return Center(
                    child: Text('loading'),
                  );
                }
              },
            )
          ],
        ),
      )
    );
  }
}