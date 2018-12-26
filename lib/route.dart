import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'widget/base_widget.dart';
import 'widget/layout_widget.dart';
import 'widget/state_widget.dart';
import 'widget/container_widget.dart';
import 'widget/scroll_widget.dart';
import 'widget/feature_widget.dart';

//路由表
class AppRoute {
  final Map<String, WidgetBuilder> _routeMap = {
    "new_page": (context) => NewRoute(),
    "count_page": (context) => CounterWidget(),
    "cupertino_page": (context) => CupertinoTestRoute(),
    //基础widget
    "base_widget_page": (context) => BaseWidgetRoute(),
    "text_page": (context) => TextStyleRoute(),
    "button_page": (context) => ButtonRoute(),
    "icon_page": (context) => IconRoute(),
    "check_page": (context) => CheckBoxRoute(),
    "input_page": (context) => InputRoute(),
    "form_page": (context) => FormTestRoute(),
    //布局widget
    "layout_widget_page": (context) => LayoutWidgetRoute(),
    "linear_layout_page": (context) => LinearWidgetRoute(),
    "expanded_layout_page": (context) => ExpandedWidgetRoute(),
    "wrap_layout_page": (context) => WrapLayoutRoute(),
    "stack_layout_page": (context) => StackLayoutRoute(),
    //容器widget
    "container_widget_page": (context) => ContainerLayoutRoute(),
    "padding_page": (context) => PaddingRoute(),
    "box_page": (context) => BoxRoute(),
    "transform_page": (context) => TransformRoute(),
    "container_page": (context) => ContainerRoute(),
    //可滚动widget
    "scroll_widget_page": (context) => ScrollWidgetRoute(),
    "single_child_scroll_page": (context) => SingleChildScrollViewRoute(),
    "list_view_page": (context) => ListViewRoute(),
    "grid_view_page": (context) => GridViewRoute(),
    "custom_scroll_page": (context) => CustomScrollRoute(),
    "scroll_controller_page": (context) => ScrollControllerRoute(),
    "notification_listener_page": (context) => NotificationListenerRoute(),
    //功能型widget
    "feature_widget_page": (context) => FeatureWidgetRoute(),
    "will_pop_scope_page": (context) => WillPopScopeRoute(),
  };

  Map<String, WidgetBuilder> getRoute() {
    return _routeMap;
  }
}

///封装的目录页面
class RoutePage extends StatelessWidget {
  final List<RouteBean> list;
  final String title;

  RoutePage(this.list, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return FlatButton(
            textColor: Colors.blue,
            child: Text(list[index].btnName),
            onPressed: () {
              Navigator.pushNamed(context, list[index].routeName);
            },
          );
        },
        itemCount: list.length,
      ),
    );
  }
}

class RouteBean {
  String routeName;
  String btnName;

  RouteBean(this.routeName, this.btnName);
}
