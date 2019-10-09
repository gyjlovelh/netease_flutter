import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NeteaseFind extends StatefulWidget {
  @override
  _NeteaseFindState createState() => _NeteaseFindState();
}

class _NeteaseFindState extends State<NeteaseFind> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              vertical: screenUtil.setHeight(28.0)
            ),
            height: screenUtil.setHeight(330.0),
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenUtil.setWidth(15.0)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_bg.jpg'),
                      fit: BoxFit.cover
                    )
                  ),
                );
              },
              scale: 0.8,
              viewportFraction: 0.925,
              autoplayDelay: 5000,
              autoplay: true,
              duration: 1500,
              outer: false,
              loop: true,
              itemCount: 6,
              layout: SwiperLayout.DEFAULT,
              pagination: new SwiperPagination(),
              control: new SwiperControl(
                iconPrevious: null,
                iconNext: null
              )
            ),
          )
        ],
      ),
    );
  }
}