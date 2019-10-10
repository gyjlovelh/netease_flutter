import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:netease_flutter/models/banner.dart';
import '../../../shared/service/request_service.dart';

class NeteaseSwiper extends StatefulWidget {
  @override
  _NeteaseSwiperState createState() => _NeteaseSwiperState();
}

class _NeteaseSwiperState extends State<NeteaseSwiper> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    
    return FutureBuilder(
      future: RequestService.getInstance().getBanner(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List banners = (json.decode(snapshot.data.toString())['banners'] as List).cast();

          return Container(
            padding: EdgeInsets.symmetric(
              vertical: screenUtil.setHeight(28.0)
            ),
            height: screenUtil.setHeight(300.0),
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                BannerModel item = new BannerModel.fromJson(banners[index]);
                Color titleColor = Colors.cyan;
                if (item.titleColor == 'red') {
                  titleColor = Colors.red;
                }
                if (item.titleColor == 'blue') {
                  titleColor = Colors.blue;
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenUtil.setWidth(15.0)),
                    image: DecorationImage(
                      image: NetworkImage(item.pic),
                      fit: BoxFit.cover
                    )
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0
                      ),
                      decoration: BoxDecoration(
                        color: titleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        )
                      ),
                      child: Text(item.typeTitle, style: TextStyle(
                        color: Colors.white
                      )),
                    )
                  ),
                );
              },
              scale: 0.8,
              viewportFraction: 0.90,
              autoplayDelay: 5000,
              autoplay: true,
              duration: 1000,
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
          );
        } else {
          return Text('loading');
        }
      },
    );  
  }
}