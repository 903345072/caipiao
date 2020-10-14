import 'dart:convert';
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
import 'package:flutterapp2/pages/pay.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../main.dart';

class recharge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<recharge> {
  String old_pwd;
  String new_pwd;
  String re_pwd;
  bool check = false;
  double give_money =0;
  FocusNode _commentFocus;

  int yj ;
  int pay_type = 2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
          title: Text("充值",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("选择支付方式"),
                      ),
                      Container(
                        color: Colors.white,
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(399),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset("img/alipay.jpg",fit: BoxFit.fill,width: ScreenUtil().setWidth(100),),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("支付宝快捷支付"),
                                          Text("支付宝推荐,安全快捷",style: TextStyle(color: Colors.grey),),
                                        ],
                                      )
                                    ],
                                  ),
                                  Radio(
                                    value:2,
                                    groupValue:this.pay_type,
                                    onChanged:(v){
                                      setState(() {
                                        this.pay_type = v;
                                      });
                                    },
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("请输入充值金额(元)"),
                      ),
                      Expanded(
                        child: TextField(
                          //限制2长度],//只允许输入数字
                          onChanged: (e) {
                            double rate;
                            setState(() {

                             yj = int.parse(e);
                             int w = DateTime.now().weekday;
                             if(w == 6 || w == 7){
                                rate = 0.04;
                             }else{
                               rate = 0.03;
                             }
                             give_money = yj*rate;
                            });

                          },
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text:
                                  '${this.yj == null ? "" : this.yj}',
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity:
                                          TextAffinity.downstream,
                                          offset: '${this.yj}'.length)))),
                          keyboardType: TextInputType.number,
                          //键盘类型，数字键盘

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: "",
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10,top: 10),
                  child: Text("赠送金额:"+give_money.toString(),style: TextStyle(color: Colors.red),),
                ),
                Container(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    minWidth: ScreenUtil().setWidth(390),
                    color: Colors.red,
                    onPressed: () async {

                      if(yj != null){
                        if(yj<1){
                          Toast.toast(context,msg: "请输入正确金额");
                          return;
                        }

                      }else{
                        Toast.toast(context,msg: "请输入正确金额");
                        return;
                      }

                      ResultData res = await HttpManager.getInstance().post("recharge/wechat",params: {"price":yj,"type":pay_type,"from":"weixinh5"});
                    Map data = jsonDecode(res.data["data"]);
                    print(data["code"] == 200);
                    if(data["code"] == 200){
                      JumpAnimation().jump(pay(data["data"]), context);
                    }else{
                      Toast.toast(context,msg: "支付通道异常,请联系客服");
                    }
                    },
                    child: Text("立即充值",style: TextStyle(color: Colors.white),),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("提示:充值无手续分，最低充值1元"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                  alignment: Alignment.center,
                  child: Text("预存款须知",style: TextStyle(color: Colors.orangeAccent),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,bottom: 10),
                  child: Text("1、为了尽可能防范套现和洗钱，充值金额100%须用于消费。",style: TextStyle(fontSize: 12),),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("2、为充值成功后，若金额未到账，请等待1-2分钟，或联系客服。",style: TextStyle(fontSize: 12),),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
