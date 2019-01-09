import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class CustomWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("custom_intro_page", "简介"));
    list.add(RouteBean("custom_combination_page", "组合方式"));
    list.add(RouteBean("turnbox_page", "实现TurnBox"));
    list.add(RouteBean("canvas_page", "自绘方式"));
    list.add(RouteBean("gradient_cicular_progress_page", "自绘实例(圆形渐变进度条)"));
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

///自绘
class CanvasRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CustomPaint与Canvas"),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(300, 300),
          painter: MyPainter(),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / 15;
    double eHeight = size.height / 15;

    //画棋盘背景
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..color = Color(0x77cdb175);
    canvas.drawRect(Offset.zero & size, paint);

    //画棋盘网格
    paint
      ..style = PaintingStyle.stroke //线
      ..color = Colors.black54
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 15; ++i) {
      double dy = eHeight * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }

    for (int i = 0; i <= 15; ++i) {
      double dx = eWidth * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    //画一个黑子
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawCircle(
      Offset(size.width / 2 - eWidth / 2, size.height / 2 - eHeight / 2),
      min(eWidth / 2, eHeight / 2) - 2,
      paint,
    );

    //画一个白子
    paint..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2 + eWidth / 2, size.height / 2 - eHeight / 2),
      min(eWidth / 2, eHeight / 2) - 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class GradientCircularProgressRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GradientCircularProgressRouteState();
}

class GradientCircularProgressRouteState
    extends State<GradientCircularProgressRoute> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    bool isForward = true;
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        isForward = true;
      } else if (status == AnimationStatus.completed) {
        if (isForward) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else if (status == AnimationStatus.reverse) {
        isForward = false;
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("圆形渐变进度条"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Wrap(
                          spacing: 10,
                          runSpacing: 16,
                          children: <Widget>[
                            GradientCircularProgressIndicator(
                              colors: [Colors.blue, Colors.blue],
                              radius: 50,
                              stokeWidth: 3,
                              value: _animationController.value,
                            ),
                            GradientCircularProgressIndicator(
                              colors: [Colors.red, Colors.orange],
                              radius: 50,
                              stokeWidth: 3,
                              value: _animationController.value,
                            ),
                            GradientCircularProgressIndicator(
                              colors: [Colors.red, Colors.orange, Colors.red],
                              radius: 50,
                              stokeWidth: 5,
                              value: _animationController.value,
                            ),
                            GradientCircularProgressIndicator(
                              colors: [Colors.teal, Colors.cyan],
                              radius: 50,
                              stokeWidth: 5,
                              strokeCapRound: true,
                              value: CurvedAnimation(
                                      parent: _animationController,
                                      curve: Curves.decelerate)
                                  .value,
                            ),
                            TurnBox(
                              turns: 1 / 8,
                              child: GradientCircularProgressIndicator(
                                radius: 50,
                                colors: [Colors.red, Colors.orange, Colors.red],
                                strokeCapRound: true,
                                backgroundColor: Colors.red[50],
                                totalAngle: 1.5 * pi,
                                value: CurvedAnimation(
                                        parent: _animationController,
                                        curve: Curves.ease)
                                    .value,
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 1,
                              child: GradientCircularProgressIndicator(
                                radius: 50,
                                colors: [Colors.blue[700], Colors.blue[200]],
                                stokeWidth: 3,
                                strokeCapRound: true,
                                backgroundColor: Colors.transparent,
                                value: _animationController.value,
                              ),
                            ),
                            GradientCircularProgressIndicator(
                              colors: [
                                Colors.red,
                                Colors.amber,
                                Colors.cyan,
                                Colors.green[200],
                                Colors.blue,
                                Colors.red
                              ],
                              radius: 50,
                              stokeWidth: 5,
                              strokeCapRound: true,
                              value: _animationController.value,
                            ),
                            GradientCircularProgressIndicator(
                              colors: [Colors.blue[700], Colors.blue[200]],
                              radius: 100,
                              stokeWidth: 20,
                              value: _animationController.value,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: GradientCircularProgressIndicator(
                                radius: 100,
                                colors: [Colors.blue[700], Colors.blue[300]],
                                stokeWidth: 20,
                                value: _animationController.value,
                                strokeCapRound: true,
                              ),
                            ),
                            ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor: .5,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: SizedBox(
                                    child: TurnBox(
                                      turns: .75,
                                      child: GradientCircularProgressIndicator(
                                        radius: 100,
                                        colors: [Colors.teal, Colors.cyan[500]],
                                        stokeWidth: 8,
                                        value: _animationController.value,
                                        totalAngle: pi,
                                        strokeCapRound: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 104,
                              width: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Positioned(
                                    height: 200,
                                    top: .0,
                                    child: TurnBox(
                                      turns: .75,
                                      child: GradientCircularProgressIndicator(
                                        radius: 100,
                                        colors: [Colors.teal, Colors.cyan[500]],
                                        stokeWidth: 8,
                                        value: _animationController.value,
                                        totalAngle: pi,
                                        strokeCapRound: true,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "${(_animationController.value * 100).toInt()}",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///圆形渐变进度条
///1、支持渐变色
///2、任意弧度
///3、自定义粗细、两端是否是圆角

class GradientCircularProgressIndicator extends StatelessWidget {
  GradientCircularProgressIndicator(
      {this.stokeWidth = 2.0,
      @required this.radius,
      @required this.colors,
      this.strokeCapRound = false,
      this.value,
      this.backgroundColor = const Color(0xFFEEEEEE),
      this.totalAngle = 2 * pi,
      this.stops});

  ///粗细
  final double stokeWidth;

  ///圆的半径
  final double radius;

  ///两端是否为圆角
  final bool strokeCapRound;

  ///当前进度，取值范围[0-1.0]
  final double value;

  ///进度条背景色
  final Color backgroundColor;

  ///进度条总弧度，2*PI为整圆
  final double totalAngle;

  ///渐变色数组
  final List<Color> colors;

  ///渐变色终止点
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    double _offset = .0;
    if (strokeCapRound) {
      _offset = asin(stokeWidth / (radius * 2 - stokeWidth));
    }
    var _colors = colors;
    if (_colors == null) {
      Color color = Theme.of(context).accentColor;
      _colors = [color, color];
    }
    return Transform.rotate(
      angle: -pi / 2 - _offset,
      child: CustomPaint(
        size: Size.fromRadius(radius),
        painter: _GradientCircularProgressPainter(
          stokeWidth: stokeWidth,
          strokeCapRound: strokeCapRound,
          backgroundColor: backgroundColor,
          value: value,
          total: totalAngle,
          radius: radius,
          colors: _colors,
        ),
      ),
    );
  }
}

///实现画笔
class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter(
      {this.stokeWidth: 10,
      this.strokeCapRound: false,
      this.value,
      this.backgroundColor = const Color(0xFFEEEEEE),
      @required this.colors,
      this.total = 2 * pi,
      this.radius,
      this.stops});

  final double stokeWidth;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;
  final List<Color> colors;
  final double total;
  final double radius;
  final List<double> stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius);
    }

    double _offset = stokeWidth / 2;
    double _value = value ?? .0;
    _value = _value.clamp(.0, 1.0) * total;
    double _start = .0;
    if (strokeCapRound) {
      _start = asin(stokeWidth / (size.width - stokeWidth));
    }

    Rect rect = Offset(_offset, _offset) &
        Size(size.width - stokeWidth, size.height - stokeWidth);

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = stokeWidth;

    //画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, _start, total, false, paint);
    }

    //画前景
    if (_value > 0) {
      paint.shader = SweepGradient(
        colors: colors,
        startAngle: .0,
        endAngle: _value,
        stops: stops,
      ).createShader(rect);

      canvas.drawArc(rect, _start, _value, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
