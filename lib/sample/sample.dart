import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';

class SampleRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    return RoutePage(list, "实例");
  }
}
