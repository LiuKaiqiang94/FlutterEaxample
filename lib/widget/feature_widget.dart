import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeatureWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("will_pop_scope_page", "返回键拦截"));
    return RoutePage(list, "功能型Widget");
  }
}

class WillPopScopeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WillPopScopeRouteState();
}

class WillPopScopeRouteState extends State<WillPopScopeRoute> {
  DateTime _lastPressedAt; //上次点击时间
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("返回键拦截"),
      ),
      body: WillPopScope(
        child: Container(
          alignment: Alignment.center,
          child: Text("2秒内连续按两次返回键退出"),
        ),
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 2)) {
            _lastPressedAt = DateTime.now();
            Fluttertoast.showToast(msg: "再次点击退出页面");
            return false;
          }
          return true;
        },
      ),
    );
  }
}
