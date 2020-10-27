import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/Address.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/IndexPage.dart';
import 'package:flutterapp2/pages/Mine.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../main.dart';

class flowUsers extends StatefulWidget {
  int order_id;
  flowUsers({this.order_id});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<flowUsers> {


  List data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFlowUser();
  }
  getFlowUser() async {
      ResultData res = await HttpManager.getInstance().get("getFlowUser",params: {"order_id":widget.order_id},withLoading: false);
      setState(() {
        data = res.data["data"];
      });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    // TODO: implement build
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(

          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            size: 25.0,
            color: Colors.white, //修改颜色
          ),
          backgroundColor: Color(0xfffa2020),
          title: Text("跟单列表",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Container(

              padding: EdgeInsets.only(top: 10,bottom: 10),
              alignment: Alignment.center,
              color: Color(0xffe5e8e8),
              child: Wrap(

                spacing: ScreenUtil().setWidth(50),
                children: <Widget>[
                     Text("跟单用户"),
                     Text("倍数"),
                     Text("金额(元)"),
                     Text("时间"),
                ],
              ),
            ),
            Column(
              children: getList(),
            )

          ],
        ),
      ),
    );
  }
  List getList(){
    return data.asMap().keys.map((e){
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                Container(

                  child: Text(data[e]["nickname"].toString()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(data[e]["bei"].toString()),
                ),
                Text(data[e]["amount"],style: TextStyle(color: Colors.red),),
                Text(data[e]["date"]),
              ],
            ),
          ),
          Divider()
        ],
      );
    }).toList();
  }
}
