import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_k_chart/flutter_k_chart.dart';
import 'package:flutter_k_chart/utils/data_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp2/pages/hangqing/StockRankList.dart';
import 'package:flutterapp2/pages/myorder.dart';
import 'package:flutterapp2/utils/request.dart';

import 'ChildItemView.dart';
class orderlist extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new hangqing_();
  }

}
class hangqing_ extends State<orderlist>{
  List<String> containers = ["全部","中奖","未开奖","跟单"];
  int page = 0;
  List<TextStyle> ts = [TextStyle()];
  @override
  void initState() {
    super.initState();

  }
  TextStyle checked_text_style =
  TextStyle(color: Color(0xfffa2020));
  TextStyle unchecked_text_style = null;
  BoxDecoration checked_border_style = BoxDecoration(
      border: Border(
          top: BorderSide(
            // 设置单侧边框的样式
              color: Color(0xfffa2020),
              width: 1.5,
              style: BorderStyle.solid)));
  BoxDecoration unchecked_border_style = null;
  PageController controller;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("我的彩票",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        backgroundColor: Color(0xfffa2020),

      ),

      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: containers.asMap().keys.map((e) {
                TextStyle cur_ts;
                BoxDecoration cur_bd;
                if(e == page){
                  cur_ts = checked_text_style;
                  cur_bd = checked_border_style;
                }else{
                  cur_ts = unchecked_text_style;
                  cur_bd = unchecked_border_style;
                }
                return Container(

                  padding: EdgeInsets.only(top: 7),
                  child: Column(
                    children: <Widget>[
                      Container(child: Text(containers[e],style: cur_ts,),),
                      Container(
                        margin: EdgeInsets.only(top: 7),
                        decoration: cur_bd,width: 60,
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: onPageChanged,
              children: <Widget>[
                myorder(state: -1,),
                myorder(state: 2,),
                myorder(state: 0,),
                myorder(mode: 3,state: -1,),
              ],
            ),
          )
        ],
      ),
    );
  }
  void onPageChanged(int page) {
    setState(() {
      this.page = page;
    });
  }
}