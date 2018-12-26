import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';

///布局类Widget都包含一个或多个widget
///<table>
///<tr>
///<td>Widget</td>
///<td>Element</td>
///<td>用途</td>
///</tr>
///<tr>
///<td>LeafRenderObjectWidget  </td>
///<td>LeafRenderObjectElement  </td>
///<td>叶子节点，Text、Image  </td>
///</tr>
///<tr>
///<td>SingleChildRenderObjectWidget  </td>
///<td>SingChildRenderObjectElement  </td>
///<td>包含一个子Widget，ConstrainedBox、DecoratedBox  </td>
///</tr>
///<tr>
///<td>MultiChildRenderObjectWidget  </td>
///<td>MultiChildRenderObjectElement  </td>
///<td>包含多个子Widget，Row、Column等  </td>
///</tr>
///</table>
class LayoutWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("linear_layout_page", "线性布局"));
    list.add(RouteBean("expanded_layout_page", "弹性布局"));
    list.add(RouteBean("wrap_layout_page", "流式布局"));
    list.add(RouteBean("stack_layout_page", "层叠布局"));
    return RoutePage(list, "布局Widget");
  }
}

///线性布局
class LinearWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("线性布局"),
      ),
      body: Column(
        //从左往右
        textDirection: TextDirection.ltr,
        //对齐方式
        mainAxisAlignment: MainAxisAlignment.start,
        //垂直对齐方式，从上到下
        verticalDirection: VerticalDirection.down,
        //水平方向宽度
        mainAxisSize: MainAxisSize.max,
        //纵轴对齐方式
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("hello world"),
              Text("I am Jack"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("hello world"),
              Text("I am Jack"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            //从右向左
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Text("Hello world"),
              Text("I am Jack"),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Text("Hello world", style: TextStyle(fontSize: 30.0)),
              Text("I am Jack"),
            ],
          ),
        ],
      ),
    );
  }
}

///弹性布局
class ExpandedWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("弹性布局"),
      ),
      body: Column(
        children: <Widget>[
          //两个子widget1:2水平分布
          Flex(
            //方向
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1, //相当于权重 weight
                child: Container(height: 30, color: Colors.red),
              ),
              Expanded(
                flex: 2,
                child: Container(height: 30, color: Colors.green),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 100,
              //三个子widget 垂直方向2:1:1分布
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 30,
                      color: Colors.red,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///流式布局
class WrapLayoutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("流式布局"),
      ),
      body: Column(
        children: <Widget>[
          Wrap(
            spacing: 8.0, //主轴方向间距
            runSpacing: 4.0, //纵轴方向间距
            alignment: WrapAlignment.center, //沿主轴方向居中
            children: <Widget>[
              Chip(
                avatar: CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('A')),
                label: Text("Hamilton"),
              ),
              Chip(
                avatar: CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('M')),
                label: Text("Lafayette"),
              ),
              Chip(
                avatar: CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('H')),
                label: Text("Mulligan"),
              ),
              Chip(
                avatar: CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('J')),
                label: Text("Laurens"),
              ),
            ],
          ),
          Flow(
            delegate: TestFlowDelegate(margin: EdgeInsets.all(10)),
            children: <Widget>[
              new Container(width: 80, height: 80, color: Colors.red),
              new Container(width: 80, height: 80, color: Colors.green),
              new Container(width: 80, height: 80, color: Colors.grey),
              new Container(width: 80, height: 80, color: Colors.blue),
              new Container(width: 80, height: 80, color: Colors.cyan),
              new Container(width: 80, height: 80, color: Colors.deepOrange),
            ],
          ),
        ],
      ),
    );
  }
}

///Flow需要自己实现widget的位置转换，用于一些需要自定义布局策略或性能要求较高的场景
///<br><br>
///优点
///<li>性能好
///<li>灵活
///<br><br>缺点
///<li>使用复杂
///<li>不能自适应子widget大小
class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;

  TestFlowDelegate({this.margin});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;

    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(double.infinity, 200);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

///层叠布局
///和Frame相似
class StackLayoutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("层叠布局"),
      ),
      //ConstrainedBox占满屏幕
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
//          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Text(
                "Hello world",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            ),
            Positioned(
              left: 18,
              child: Text("I am Jack"),
            ),
            Positioned(
              top: 18,
              child: Text("Your friend"),
            ),
          ],
        ),
      ),
    );
  }
}
