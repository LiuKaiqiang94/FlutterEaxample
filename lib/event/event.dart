import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:flutter/gestures.dart';

class EventRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("pointer_event", "Pointer事件处理"));
    list.add(RouteBean("gesture_detector", "GestureDetector"));
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

///手势检测
class GestureDetectorRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GestureDetectorRouteState();
}

class GestureDetectorRouteState extends State<GestureDetectorRoute> {
  var _tapGestureRecognizer = TapGestureRecognizer();
  String _operation = "No Gesture detected!";
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GestureDetector"),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                width: 200,
                height: 100,
                child: Text(
                  _operation,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () => updateText("Tap"),
              onDoubleTap: () => updateText("DoubleTap"),
              onLongPress: () => updateText("LongPress"),
            ),
            _Drag(),
            Positioned(
              top: 100,
              left: 50,
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: "你好"),
                  TextSpan(
                    text: "点我变色",
                    style: TextStyle(
                        fontSize: 30,
                        color: _toggle ? Colors.blue : Colors.red),
                    recognizer: _tapGestureRecognizer
                      ..onTap = () {
                        setState(() {
                          _toggle = !_toggle;
                        });
                      },
                  ),
                  TextSpan(text: "世界"),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateText(String s) {
    setState(() {
      _operation = s;
    });
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }
}

class _Drag extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DragState();
}

class _DragState extends State<_Drag> {
  double _top = 30.0;
  double _left = 250.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(
              child: Text("A"),
            ),
            //手指按下
            onPanDown: (DragDownDetails e) {
              print("用户手指按下：${e.globalPosition}");
            },
            //手指滑动
            onPanUpdate: (DragUpdateDetails e) {
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            //结束滑动
            onPanEnd: (DragEndDetails e) {
              print(e.velocity);
            },
            //只识别垂直方向的手势
//            onVerticalDragUpdate: (details) {},
            //只识别水平方向的手势
//            onHorizontalDragUpdate: (details) {},
          ),
        ),
      ],
    );
  }
}
