import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';

class CustomWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("custom_intro_page", "简介"));
    return RoutePage(list, "自定义Widget");
  }
}

class CustomIntroRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("简介"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("组合其他widget"),
          Text("自绘：customPaint和Canvas自绘UI外观"),
          Text("实现RenderObject"),
          Text("应该优先考虑组合实现，"),
        ],
      ),
    );
  }
}
