import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/Login.dart';
import 'package:flutterapp2/pages/cash.dart';
import 'package:flutterapp2/pages/cashlist.dart';
import 'package:flutterapp2/pages/editCard.dart';
import 'package:flutterapp2/pages/editPassword.dart';
import 'package:flutterapp2/pages/kefu.dart';
import 'package:flutterapp2/pages/orderlist.dart';
import 'package:flutterapp2/pages/stock.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Router.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:image_picker/image_picker.dart';
import 'heyue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Mine extends StatefulWidget {
  String _title;


  @override
  _Mine createState() => _Mine();
}

class _Mine extends State<Mine>  with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final SystemUiOverlayStyle _style =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);

  Map user_info = {"nickname":"","has_bank":"0","now_money":"0","img_url":"http://192.168.31.199/uploads/store/comment/202009251734185199.jpg"};
  Map user_message_cate = {
    "account": "1000",
    "validContract": "12",
    "deposit": "12043.00"
  };

  File _image;

  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[

                ListTile(

                  title: Text('拍照',textAlign: TextAlign.center),
                  onTap: () async{
                    Navigator.pop(context);
                    var image = await ImagePicker.pickImage(source: ImageSource.camera);
                     setState(() {
                       _image = image;
                     });
                    _upLoadImage(_image);
                  },
                ),
                ListTile(
                  title: Text('从相册选择',textAlign: TextAlign.center),
                  onTap: () async {
                    Navigator.pop(context);
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _image = image;
                    });
                    _upLoadImage(_image);
                  },
                ),
                ListTile(
                  title: Text('取消',textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '取消');
                  },
                ),
              ],
            ),
          );
        }
    );


  }
  @override
  void initState() {

    super.initState();
    getUserInfo();
  }
  getUserInfo() async{
   ResultData res = await HttpManager.getInstance().get("userInfo",withLoading: false);
   setState(() {
     if(res.data != null){
       user_info["nickname"] = res.data["nickname"];
       user_info["now_money"] = res.data["now_money"];
       user_info["has_bank"] = res.data["has_bank"];
       user_info["img_url"] = res.data["avatar"];
     }

   });
  }
  _upLoadImage(File image) async {



    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    // FormData formData = new FormData.fromMap({
    //   "file": new MultipartFile.fromFile (new File(path), name)
    // });

    FormData formdata = FormData.fromMap({
      "filename":name,
      "file":  base64Encode(image.readAsBytesSync())
    });
   ResultData res = await HttpManager.getInstance().post("user/edit_avatar",params: formdata,withLoading: false);
   if(res.code == 200){
     Toast.toast(context,msg:"上传成功");
     setState(() {
       user_info["img_url"] = res.data["url"];
     });
   }else{
     Toast.toast(context,msg:"上传失败");
   }

  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);
    SystemChrome.setSystemUIOverlayStyle(_style);
    return FlutterEasyLoading(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70)),
                  child: Image.asset(
                    "img/mineback.jpg",
                    fit: BoxFit.fill,
                    width: ScreenUtil.screenWidth,
                    height: ScreenUtil().setHeight(325),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(92), left: 10, right: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: <Widget>[
                  Container(
                    child: Container(
                      width: ScreenUtil().setWidth(390),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Wrap(
                            spacing: 16,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                  child: Image.network(
                                    user_info["img_url"],
                                    fit: BoxFit.fill,
                                    width: ScreenUtil().setWidth(60),
                                    height: ScreenUtil().setWidth(60),
                                  )),
                              Text(
                                user_info["nickname"],
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () async{
//                            var image = await ImagePicker.pickImage(source: ImageSource.camera);
//                            print(image);
                              _openModalBottomSheet();
                            },
                            icon: Icon(Icons.edit,color: Colors.white,),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(

                        child: Text(
                          "￥ "+user_info["now_money"]+"元",
                          style: TextStyle(
                              color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: () async {
                            ResultData res = await HttpManager.getInstance().get("userInfo",withLoading: true);
                            setState(() {
                              if(res.data != null){
                                user_info["nickname"] = res.data["nickname"];
                                user_info["now_money"] = res.data["now_money"];
                                user_info["has_bank"] = res.data["has_bank"];
                                user_info["img_url"] = res.data["avatar"];
                              }

                            });
                          },
                          icon: Icon(Icons.refresh,color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    spacing: 25,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Text("充值",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(16))
                          ),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          ResultData res = await HttpManager.getInstance().get("userInfo",withLoading: false);

                          if(res.data["has_bank"] == 0){
                            Toast.toast(context,msg: "请先绑定银行卡信息");
                            JumpAnimation().jump(editCard(), context);
                            return;
                          }
                          JumpAnimation().jump(cash(), context);
                        },
                        child: Container(
                          child: Text("提现",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(16))
                          ),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
                    height: ScreenUtil().setHeight(85),

                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40)),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
//                            Router.navigatorKey.currentState.pushNamedAndRemoveUntil("/editCard",
//                                ModalRoute.withName("/"));
                            JumpAnimation().jump(editCard(), context);
                          },
                          child: Container(
                            child: Wrap(
                              spacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Icon(IconData(0xe603,fontFamily: "iconfont"),size: 17,),
                                ),
                                Container(
                                  child: Text("资料",style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  child: Text("账户信息"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Icon(IconData(0xe671,fontFamily: "iconfont"),color: Colors.blue,size: 30,),
                              ),
                              Container(
                                child: Text("中奖",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                child: Text("22679.98元"),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(85),
                    width: ScreenUtil().setWidth(375),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(50)),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                           onTap: (){
                             JumpAnimation().jump(orderlist(), context);
                           },
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Icon(IconData(0xe60a,fontFamily: "iconfont"),color: Colors.red,size: 17,),
                              ),
                              Container(
                                child: Text("订单",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                child: Text("全部订单"),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            JumpAnimation().jump(cashlist(), context);
                          },
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Icon(IconData(0xe607,fontFamily: "iconfont"),color: Colors.deepOrange,size: 15,),
                              ),
                              Container(
                                child: Text("账单",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                child: Text("资金流向"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                    height: ScreenUtil().setHeight(85),
                    width: ScreenUtil().setWidth(375),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(55)),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(IconData(0xe605,fontFamily: "iconfont"),size: 17,),
                            ),

                            GestureDetector(
                              onTap: (){
                                JumpAnimation().jump(editPassword(), context);
                              },
                              child: Container(
                                child: Text("修改密码"),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            JumpAnimation().jump(kefu(), context);
                          },
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Icon(IconData(0xe602,fontFamily: "iconfont"),color: Colors.blue,size: 18,),
                              ),
                              Container(
                                child: Text("客服",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                child: Text("QQ客服"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(85),
                    width: ScreenUtil().setWidth(375),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(75)),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(IconData(0xe6b1,fontFamily: "iconfont"),color: Colors.pinkAccent,size: 18,),
                            ),
                            Container(
                              child: Text("检查更新",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),

                          ],
                        ),
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(IconData(0xe604,fontFamily: "iconfont"),size: 18,),
                            ),
                            GestureDetector(
                              onTap: () async {

                                ResultData result = await HttpManager.getInstance().get(
                                    "logout",withLoading: false);
                                if(result.code == 200){
                                  TokenStore().clearToken("token");
                                  TokenStore().clearToken("is_login");
                                  JumpAnimation().jump(Login(), context);
                                }
                              },
                              child: Container(
                                child: Text("退出登录",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            )

                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                    height: ScreenUtil().setHeight(70),
                    width: ScreenUtil().setWidth(375),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(100)),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),

                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
