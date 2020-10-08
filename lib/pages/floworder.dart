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
import 'package:flutterapp2/pages/flowdetail.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../main.dart';

class floworder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<floworder> {
  Future _future;
  String old_pwd;
  String new_pwd;
  String re_pwd;
  bool check = false;
  List list = [];
  List dashen = [];
  FocusNode _commentFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentFocus = FocusNode();
    _future = getList();
  }

  getList() async {
   ResultData res = await HttpManager.getInstance().get("getFlowOrder",withLoading: false);

   setState(() {
     list = res.data["data"];
     dashen = res.data["dashen"];
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
            size: 22.0,
            color: Colors.white, //修改颜色
          ),
          backgroundColor: Color(0xfffa2020),
          title: Text("跟单"),
        ),
        backgroundColor: Color(0xfff5f5f5),
        body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeLeft: true,
            removeRight: true,
            child:

            FutureBuilder(
                future: _future,
                builder: (context, snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return  Center(child: CircularProgressIndicator());

                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Text('网络请求出错'),
                        );
                      }
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: <Widget>[

                                Container(


                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Text("大神排行"),
                                      ),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 20,
                                        children: dashen.asMap().keys.map((e) {
                                          return Wrap(
                                            spacing: 5,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            direction: Axis.vertical,
                                            children: <Widget>[
                                              ClipOval(
                                                  child: Image.network(
                                                    dashen[e]["avatar"],
                                                    fit: BoxFit.fill,
                                                    width: ScreenUtil().setWidth(45),
                                                    height: ScreenUtil().setWidth(45),
                                                  )),
                                              Text(dashen[e]["nickname"])
                                            ],
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                               Divider(),
                               Column(
                                 children: getOrder(),
                               )


                              ],
                            ),
                          )
                        ],
                      );
                  }
                  return null;
                }
            )


        ),
      ),
    );
  }
  List getOrder(){
    return list.asMap().keys.map((e){
      return Container(
        margin: EdgeInsets.only(top: 15,left: 5,right: 5,bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    ClipOval(
                        child: Image.network(
                          list[e]["avatar"],
                          fit: BoxFit.fill,
                          width: ScreenUtil().setWidth(35),
                          height: ScreenUtil().setWidth(35),
                        )),
                    Text(list[e]["nickname"]),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("胜率 : "),
                    Text(list[e]["sl"].toString(),style: TextStyle(color: Colors.red),)
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text("跟我一起中大奖!!!"),
            ),
             Container(
               margin: EdgeInsets.only(top: 5),
               decoration: BoxDecoration(border: Border.all(width: 0.4,color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10))),
               child: Row(
                 children: <Widget>[
                   Container(
                     decoration: BoxDecoration(border: Border(right: BorderSide(width: 0.4,color: Colors.grey))),
                     margin: EdgeInsets.only(top: 5),
                     child: Column(
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.only(bottom: 5,top: 5,right: 5),
                           margin: EdgeInsets.only(bottom: 5),
                           decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 0.4,color: Colors.grey)) ),

                           width: ScreenUtil().setWidth(310),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Container(
                                 padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),),
                                 child: Text("类型"),
                               ),
                               Container(
                                 padding: EdgeInsets.only(left: ScreenUtil().setWidth(70),),
                                 child: Text("自购金额"),
                               ),
                               Container(
                                 padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),),
                                 child: Text("单倍金额"),
                               ),
                             ],
                           ),
                         ),
                         Container(
                           padding: EdgeInsets.only(bottom: 5),
                           width: ScreenUtil().setWidth(280),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Text(list[e]["type"]=="f"?"竞彩足球":"竞彩篮球"),
                               Text(list[e]["amount"]),
                               Text((list[e]["num"]*2).toString()),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                   Container(


                     margin: EdgeInsets.only(left: 5),
                     alignment: Alignment.center,
                     width: ScreenUtil().setWidth(80),
                     child: RaisedButton(
                       color: Colors.deepOrange,
                       onPressed: () {
                         JumpAnimation().jump(flowdetail(list[e]), context);
                       },
                       child: Text('跟单',style: TextStyle(fontSize: 12.0,color: Colors.white),),
                       ///圆角
                       shape: RoundedRectangleBorder(
                           side: BorderSide.none,
                           borderRadius: BorderRadius.all(Radius.circular(15))
                       ),
                     )
                     ,
                   )
                 ],
               ),
             ),
            Container(
              margin:EdgeInsets.only(top: 5),
              alignment: Alignment.bottomRight,
              width: double.infinity,
              child: Text("截止:"+list[e]["dtime"]),
            ),
             Divider(
               height: 25,
             ),

          ],
        ),
      );
    }).toList();
  }
}
