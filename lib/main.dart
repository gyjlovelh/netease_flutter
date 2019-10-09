import 'package:flutter/material.dart';
import 'pages/home/home.dart';
import 'pages/login/login.dart';

void main() => runApp(NeteaseApp());


class NeteaseApp extends StatefulWidget {
  @override
  _NetState createState() => _NetState();
}

class _NetState extends State<NeteaseApp> {

  @override
  Widget build(BuildContext context) {

    // var screenInstance = ScreenUtil.getInstance();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColorLight: Colors.redAccent,
        primaryColor: Colors.redAccent,
        accentColor: Colors.teal,
        fontFamily: 'iconfont',
        iconTheme: IconThemeData(
          color: Colors.red
        ),
        // tabbar样式
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 0.1,
              color: Colors.white10
            )
          ),
          unselectedLabelColor: Colors.black.withOpacity(0.6),
          unselectedLabelStyle: TextStyle(
          ),
          labelPadding: EdgeInsets.all(1.0),
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold
          )
        )
      ),
      initialRoute: "login",
      routes: {
        'login': (BuildContext context) => new NeteaseLogin(),
        'home': (BuildContext context) => new NeteaseHome()
      }
    );
  }
}
