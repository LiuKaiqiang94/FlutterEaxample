import 'package:flutter/material.dart';

class ContainerLayoutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("容器类Widget"),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            textColor: Colors.blue,
            child: Text("Padding"),
            onPressed: () {
              Navigator.pushNamed(context, "padding_page");
            },
          ),
          FlatButton(
            textColor: Colors.blue,
            child: Text("ConstrainedBox和SizedBox"),
            onPressed: () {
              Navigator.pushNamed(context, "box_page");
            },
          ),
        ],
      ),
    );
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
          SizedBox(
            width: 80,
            height: 80,
            child: redBox,
          ),
          //最终 宽90 高60  取父子最大的宽高值，若maxWidth和
          //maxHeight,取父子较小的宽高值，这样才能保证不发生冲突
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 60, minHeight: 60), //父
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 90, minHeight: 20), //子
              child: redBox,
            ),
          ),
        ],
      ),
    );
  }
}
