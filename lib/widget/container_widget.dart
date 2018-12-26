import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_example/route.dart';

class ContainerLayoutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("padding_page", "Padding"));
    list.add(RouteBean("box_page", "ConstrainedBox和SizedBox"));
    list.add(RouteBean("transform_page", "Transform变换"));
    list.add(RouteBean("container_page", "Container"));
    return RoutePage(list, "容器类Widget");
  }
}

///Padding也属于Widget，和android区别很大
class PaddingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Padding"),
      ),
      body: Padding(
        //上下左右 单位 像素
        padding: EdgeInsets.all(16),
        child: Column(
          //显式指定左对齐，排除对齐干扰
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              //左边
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Hello world"),
            ),
            Padding(
              //上下
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text("I am Jack"),
            ),
            Padding(
              //指定四个方向
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text("Your friend"),
            ),
          ],
        ),
      ),
    );
  }
}

///ConstrainedBox和SizedBox
///用于对齐子widget添加额外的约束
class BoxRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var redBox = DecoratedBox(
      decoration: BoxDecoration(color: Colors.red),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("ConstrainedBox和SizedBox"),
      ),
      body: Column(
        children: <Widget>[
          Text("ConstrainedBox"),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: double.infinity, //宽度尽量大
              minHeight: 50,
            ),
            child: Container(
              height: 5,
              child: redBox,
            ),
          ),
          Text("SizedBox"),
          SizedBox(
            width: 80,
            height: 80,
            child: redBox,
          ),
          //最终 宽90 高60  取父子最大的宽高值，若maxWidth和
          //maxHeight,取父子较小的宽高值，这样才能保证不发生冲突
          Text("父子共同约束"),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 60, minHeight: 60), //父
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 90, minHeight: 20), //子
              child: redBox,
            ),
          ),
          Text("DecoratedBox装饰子widget"),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.red, Colors.orange[700]]),
              borderRadius: BorderRadius.circular(3), //圆角
              boxShadow: [
                BoxShadow(
                    color: Colors.black54, offset: Offset(2, 2), blurRadius: 4),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 18),
              child: Text("Login", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

///Transform变换
class TransformRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transform变换"),
      ),
      body: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("变换示例"),
              Padding(
                padding: EdgeInsets.only(top: 60, left: 30),
                child: Container(
                  color: Colors.black,
                  child: Transform(
                    alignment: Alignment.topRight,
                    transform: Matrix4.skewY(0.3),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.deepOrange,
                      child: const Text("Apartment for rent!"),
                    ),
                  ),
                ),
              ),
              Text("平移"),
              Padding(
                padding: EdgeInsets.all(30),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Transform.translate(
                    offset: Offset(-20, -5),
                    child: Text("Hello world"),
                  ),
                ),
              ),
              Text("旋转"),
              Padding(
                padding: EdgeInsets.all(30),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Transform.rotate(
                    angle: math.pi / 3,
                    child: Text("Hello World"),
                  ),
                ),
              ),
              Text("缩放"),
              Padding(
                padding: EdgeInsets.all(30),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Text("Hello world"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("RotateBox"),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text("Hello world"),
                ),
              ),
              Text(
                "你好",
                style: TextStyle(color: Colors.green, fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }
}

///用Container实现渐变效果的卡片
///Flutter中组合优于继承
///Container有自己的Margin和Padding
class ContainerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Container"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50, left: 120),
            constraints: BoxConstraints.tightFor(width: 200, height: 150),
            //开片大小
            decoration: BoxDecoration(
              //背景装饰
              gradient: RadialGradient(
                  //背景径向渐变
                  colors: [Colors.red, Colors.orange],
                  center: Alignment.topLeft,
                  radius: .98),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            transform: Matrix4.rotationZ(.2),
            //卡片倾斜变换
            alignment: Alignment.center,
            //卡片内文字居中
            child: Text(
              "5.20",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ],
      ),
    );
  }
}
