import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class AnimationRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("scale_animation_page", "动画基本结构"));
    list.add(RouteBean("custom_route_page", "自定义路由切换动画"));
    return RoutePage(list, "动画");
  }
}

class AnimationApi {
  AnimationApi() {
    Animation _animation;
    _animation.addListener(() {
      //帧监听器
    });
    _animation.addStatusListener((animationStatus) {
      //监听动画状态改变
    });
    //曲线，描述动画过程
    final CurvedAnimation curve =
        new CurvedAnimation(parent: null, curve: Curves.easeIn);

    //用于控制动画，包含启动 forward()、停止 stop()、反向播放 reverse()等方法
    //lowerBound和upperBound控制controller生成数字
    final AnimationController controller = new AnimationController(
      vsync: null,
      duration: const Duration(milliseconds: 2000),
      lowerBound: 10,
      upperBound: 20,
    );

    //Tween 配置动画生成不同的范围或数据类型的值
    //唯一职责就是定义输入范围到输出范围的映射
    final Tween doubleTween = new Tween(begin: -200, end: 0);
    //Tween也可以表示颜色过渡
    final Tween colorTween =
        new ColorTween(begin: Colors.transparent, end: Colors.black54);
  }
}

///自定义曲线
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.pi * 2);
  }
}

//图片放大动火
class ScaleAnimationRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScaleAnimationRouteState();
}

class _ScaleAnimationRouteState extends State<ScaleAnimationRoute>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        new AnimationController(duration: Duration(seconds: 3), vsync: this);
    //使用弹性曲线
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    //图片宽高从0到300
    animation = new Tween(begin: 0.0, end: 300.0).animate(animation);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画结束之后反向执行
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //恢复到初始状态时正向执行
        controller.forward();
      }
    });
    //启动动画
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动画基本结构"),
        actions: <Widget>[
          Icon(Icons.add),
          Icon(Icons.subject),
          Icon(Icons.battery_alert),
        ],
      ),
      body: GrowTransition(
        child: Image.asset("images/icon.png"),
        animation: animation,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

///使用AnimatedWidget简化 进而使用AnimatedBuilder重构
class AnimatedImage extends AnimatedWidget {
  AnimatedImage({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return AnimatedBuilder(
      animation: animation,
      child: Image.asset("images/icon.png"),
      builder: (ctx, child) {
        return Center(
          child: Container(
            height: animation.value,
            width: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}

///封装 复用
class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (ctx, child) {
          return Container(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class CustomSwitchRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("自定义路由切换动画"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return _TestSwitchRoute();
                  }));
                },
                textColor: Colors.blue,
                child: Text("Cupertino风格"),
              ),
              FlatButton(
                child: Text("PageRouteBuilder渐隐渐入"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (BuildContext ctx, Animation animation,
                            Animation secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: _TestSwitchRoute(),
                          );
                        },
                      ));
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context, FadeRoute(builder: (context) {
                    return _TestSwitchRoute();
                  }));
                },
                textColor: Colors.blue,
                child: Text("自定义Route实现渐隐渐入"),
              ),
            ],
          ),
        ));
  }
}

class _TestSwitchRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试路由"),
      ),
      body: Center(
        child: Text("测试目的路由"),
      ),
    );
  }
}

///自定义路由切换效果
class FadeRoute extends PageRoute {
  FadeRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}
