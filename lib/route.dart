import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'animation/animation.dart';
import 'event/event.dart';
import 'main.dart';
import 'widget/base_widget.dart';
import 'widget/container_widget.dart';
import 'widget/custom_widget.dart';
import 'widget/feature_widget.dart';
import 'widget/layout_widget.dart';
import 'widget/scroll_widget.dart';
import 'widget/state_widget.dart';
import 'file/file_and_net.dart';

//路由表
var routeMap = {
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
  "inherited_page": (context) => InheritedRoute(),
  "theme_data_page": (context) => ThemeDataRoute(),
  //事件处理
  "event_page": (context) => EventRoute(),
  "pointer_event": (context) => PointerEventRoute(),
  "gesture_detector": (context) => GestureDetectorRoute(),
  "notification_page": (context) => NotificationRoute(),
  //动画
  "animation_page": (context) => AnimationRoute(),
  "scale_animation_page": (context) => ScaleAnimationRoute(),
  "custom_route_page": (context) => CustomSwitchRoute(),
  "hero_page": (context) => HeroRoute(),
  "stagger_page": (context) => StaggerRoute(),
  //自定义widget
  "custom_widget_page": (context) => CustomWidgetRoute(),
  "custom_intro_page": (context) => CustomIntroRoute(),
  "custom_combination_page": (context) => CombinationRoute(),
  "turnbox_page": (context) => TurnBoxRoute(),
  "canvas_page": (context) => CanvasRoute(),
  "gradient_cicular_progress_page": (context) =>
      GradientCircularProgressRoute(),
  //文件操作
  "file_and_net_page": (context) => FileAndNetRoute(),
  "file_page": (context) => FileRoute(),
};

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
