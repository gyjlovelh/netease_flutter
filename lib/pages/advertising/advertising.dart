import 'dart:async';

import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/states/global.dart';

class NeteaseAdvertising extends StatefulWidget {
  @override
  _NeteaseAdvertisingState createState() => _NeteaseAdvertisingState();
}

class _NeteaseAdvertisingState extends State<NeteaseAdvertising> {
  Timer _timer;
  int time = 5;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (time > 0) {
        setState(() {
          time--;
        });
      } else {
        _timer.cancel();
        _timer = null;
        // 跳转
        if (Global.isLogin) {
          Navigator.of(context).pushNamed('home'); 
        } else {
          Navigator.of(context).pushNamed('login');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ad_cover.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 50.0,
              right: 30.0
            ),
            child: Container(
              height: 35.0,
              width: 80.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.redAccent
                ),
                color: Colors.white54,
                borderRadius: BorderRadius.circular(999.0)
              ),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.0)
                ),
                onPressed: () {
                  _timer.cancel();
                  if (Global.isLogin) {
                    Navigator.of(context).pushNamed('home'); 
                  } else {
                    Navigator.of(context).pushNamed('login');
                  }
                },
                child: Text('关闭 $time', style: TextStyle(
                  color: Colors.redAccent
                )),
              ),
            )
          ),
        ),
      ),
    );
  }
}