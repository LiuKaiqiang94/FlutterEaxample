import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';

class EventRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("pointer_event", "Pointer事件处理"));
    return RoutePage(list, "事件处理与通知");
  }
}

///命中测试（Hit Test）
///和事件冒泡机制相似
///使用Listener widget监听触摸事件
///behavior属性，觉得子widget如何响应命中测试
///想要忽略PointerEvent，可以用IgnorePointer和AbsorbPointer，其中AbsorbPointer
///本身可以收到指针事件（但其子树不行），IgnorePointer本身也收不到事件
class PointerEventRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PointerEventRouteState();
}

class PointerEventRouteState extends State<PointerEventRoute> {
  PointerEvent _event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pointer事件处理"),
      ),
      body: Stack(
        children: <Widget>[
          Listener(
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: 300,
              height: 200,
              child: Text(
                _event?.toString() ?? "",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPointerDown: (PointerDownEvent event) {
              print("down0");
              setState(() => _event = event);
            },
            onPointerMove: (PointerMoveEvent event) =>
                setState(() => _event = event),
            onPointerUp: (PointerUpEvent event) =>
                setState(() => _event = event),
          ),
          Listener(
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(Size(200, 100)),
              child: Center(child: Text("左上角200*100区域内非本文区域点击")),
            ),
            onPointerDown: (event) => print("down1"),
            behavior: HitTestBehavior.translucent, //放开此行注释后可以“点透”
            //HitTestBehavior.translucent:点击透明区域时，可以对底部widget透明测试
            //deferToChild:
          ),
        ],
      ),
    );
  }
}
