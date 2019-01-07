import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("custom_intro_page", "简介"));
    list.add(RouteBean("custom_combination_page", "组合方式"));
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
