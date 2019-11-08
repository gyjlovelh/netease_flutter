import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:netease_flutter/models/banner.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';

class NeteaseSwiper extends StatefulWidget {
  final List<BannerModel> banners;
  NeteaseSwiper({@required this.banners});

  @override
  _NeteaseSwiperState createState() => _NeteaseSwiperState();
}

class _NeteaseSwiperState extends State<NeteaseSwiper> {


  @override
  Widget build(BuildContext context) {
    List<BannerModel> banners = widget.banners;
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (banners.length == 0) {
      return Center(child: NeteaseLoading());
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenUtil.setHeight(28.0)
      ),
      height: screenUtil.setHeight(300.0),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          BannerModel item = banners[index];

          Color titleColor = Colors.cyan;
          if (item.titleColor == 'red') {
            titleColor = Colors.red;
          }
          if (item.titleColor == 'blue') {
            titleColor = Colors.blue;
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0)),
              image: DecorationImage(
                image: NetworkImage(item.pic),
                fit: BoxFit.cover
              ),
              color: Colors.white70
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenUtil.setWidth(12.0),
                  vertical: screenUtil.setWidth(5.0)
                ),
                decoration: BoxDecoration(
                  color: titleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenUtil.setWidth(8.0)),
                    bottomRight: Radius.circular(screenUtil.setWidth(8.0)),
                  )
                ),
                child: Text(item.typeTitle, style: TextStyle(
                  color: Colors.white,
                  fontSize: screenUtil.setSp(20.0)
                )),
              )
            ),
          );
        },
        scale: 0.8,
        viewportFraction: 0.905,
        autoplayDelay: 5000,
        autoplay: true,
        duration: 1000,
        outer: false,
        loop: true,
        itemCount: banners.length,
        layout: SwiperLayout.DEFAULT,
        pagination: new SwiperPagination(),
        control: new SwiperControl(
          iconPrevious: null,
          iconNext: null
        ),
        onTap: (int index) {
          
        },
      ),
    );
  }
}