import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';

class CustomWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("custom_intro_page", "简介"));
    list.add(RouteBean("custom_combination_page", "组合方式"));
    list.add(RouteBean("turnbox_page", "实现TurnBox"));
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

class CombinationRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("组合方式"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            GradientButton(
              colors: [Colors.orange, Colors.red],
              height: 50,
              child: Text("Submit"),
              onTap: onTap,
            ),
            GradientButton(
              colors: [Colors.lightGreen, Colors.green[700]],
              height: 50,
              child: Text("Submit"),
              onTap: onTap,
            ),
            GradientButton(
              colors: [Colors.lightBlue[300], Colors.blueAccent],
              height: 50,
              child: Text("Submit"),
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }

  onTap() {
    Fluttertoast.showToast(msg: "button click");
  }
}

///通过组合方式自定义widget
class GradientButton extends StatelessWidget {
  GradientButton({
    this.colors,
    this.width,
    this.height,
    @required this.child,
    this.onTap,
  });

  //渐变色数组
  final List<Color> colors;

  //按钮宽高
  final double width;
  final double height;

  final Widget child;

  //点击回调
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Color> _colors = colors ??
        [theme.primaryColor, theme.primaryColorDark ?? theme.primaryColor];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _colors),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: colors.last,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: DefaultTextStyle(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TurnBoxRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TurnBoxRouteState();
}

class _TurnBoxRouteState extends State<TurnBoxRoute> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TurnBox"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TurnBox(
              turns: _turns,
              speed: 500,
              child: Icon(
                Icons.refresh,
                size: 50,
              ),
            ),
            TurnBox(
              turns: _turns,
              speed: 1000,
              child: Icon(
                Icons.refresh,
                size: 150,
              ),
            ),
            RaisedButton(
              child: Text("顺时针旋转4/5圈"),
              onPressed: () {
                setState(() {
                  _turns += .8;
                });
              },
            ),
            RaisedButton(
              child: Text("逆时针旋转1/5圈"),
              onPressed: () {
                setState(() {
                  _turns -= .2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

///可自定义角度、旋转速度的widget
class TurnBox extends StatefulWidget {
  const TurnBox({
    Key key,
    this.turns = .0, //选择的圈数，一圈为360度
    this.speed = 200, //过渡动画总时长
    this.child,
  }) : super(key: key);

  final double turns;
  final int speed;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _TurnBoxState();
}

class _TurnBoxState extends State<TurnBox> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: -double.infinity,
      upperBound: double.infinity,
    );
    _controller.value = widget.turns;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(TurnBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.turns != widget.turns) {
      _controller.animateTo(
        widget.turns,
        duration: Duration(milliseconds: widget.speed ?? 200),
        curve: Curves.easeOut,
      );
    }
  }
}
