import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';

class SampleRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("bottom_navigation_widget", "底部导航栏"));
    list.add(RouteBean("bottom_appbar_demo", "不规则的底部导航栏"));
    return RoutePage(list, "实例");
  }
}
