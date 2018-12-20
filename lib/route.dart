import 'package:flutter/cupertino.dart';
import 'package:flutter_example/main.dart';
import 'package:flutter_example/widget/base_widget.dart';
import 'package:flutter_example/widget/layout_widget.dart';
import 'package:flutter_example/widget/state_widget.dart';

//路由表
class AppRoute {
  final Map<String, WidgetBuilder> _routeMap = {
    "new_page": (context) => NewRoute(),
    "count_page": (context) => CounterWidget(),
    "cupertino_page": (context) => CupertinoTestRoute(),
    "base_widget_page": (context) => BaseWidgetRoute(),
    "text_page": (context) => TextStyleRoute(),
    "button_page": (context) => ButtonRoute(),
    "icon_page": (context) => IconRoute(),
    "check_page": (context) => CheckBoxRoute(),
    "input_page": (context) => InputRoute(),
    "form_page": (context) => FormTestRoute(),
    "layout_widget_page": (context) => LayoutWidgetRoute(),
    "linear_layout_page": (context) => LinearWidgetRoute(),
    "expanded_layout_page": (context) => ExpandedWidgetRoute(),
    "wrap_layout_page": (context) => WrapLayoutRoute(),
    "stack_layout_page": (context) => StackLayoutRoute(),
  };

  Map<String, WidgetBuilder> getRoute() {
    return _routeMap;
  }
}