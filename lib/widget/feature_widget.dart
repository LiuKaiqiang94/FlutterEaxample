import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeatureWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("will_pop_scope_page", "返回键拦截"));
    list.add(RouteBean("inherited_page", "数据共享"));
    list.add(RouteBean("theme_data_page", "自定义主题"));
    return RoutePage(list, "功能型Widget");
  }
}

///返回键拦截
class WillPopScopeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WillPopScopeRouteState();
}

class WillPopScopeRouteState extends State<WillPopScopeRoute> {
  DateTime _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("返回键拦截"),
      ),
      body: WillPopScope(
        child: Container(
          alignment: Alignment.center,
          child: Text("2秒内连续按两次返回键退出"),
        ),
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 2)) {
            _lastPressedAt = DateTime.now();
            Fluttertoast.showToast(msg: "再次点击退出页面");
            return false;
          }
          return true;
        },
      ),
    );
  }
}

///数据共享
class InheritedRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InheritedRouteState();
}

class InheritedRouteState extends State<InheritedRoute> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("数据共享"),
      ),
      body: ShareDataWidget(
        data: count,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: ShareDataTestWidget(),
            ),
            RaisedButton(
              child: Text("Increment"),
              onPressed: () {
                setState(() {
                  ++count;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({
    @required this.data,
    Widget child,
  }) : super(child: child);

  final int data;

  static ShareDataWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ShareDataWidget);
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(ShareDataWidget oldWidget) {
    return oldWidget.data != data;
  }
}

///测试共享数据的widget
class ShareDataTestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShareDataWidgetState();
}

class ShareDataWidgetState extends State<ShareDataTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(ShareDataWidget.of(context).data.toString());
  }

  @override
  void didChangeDependencies() {
    //父或祖先widget中的InheritedWidget改变时会调用。
    //如果build中没有依赖InheritedWidget，此回调不会被调用
    super.didChangeDependencies();
    print("Dependencies change");
  }
}

///主题
class ThemeDataRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ThemeDataRouteState();
}

class ThemeDataRouteState extends State<ThemeDataRoute> {
  Color _themeColor = Colors.teal; //当前路由主题色

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: ThemeData(
        primarySwatch: _themeColor, //用于导航栏，FloatingActionButton的背景色
        iconTheme: IconThemeData(color: _themeColor), //icon颜色
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("主题测试")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //第一行icon使用主题中的iconTheme
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.favorite),
                Icon(Icons.airport_shuttle),
                Text(" 颜色跟随主题")
              ],
            ),
            //第二行icon自定义颜色
            Theme(
              data: themeData.copyWith(
                  iconTheme: themeData.iconTheme.copyWith(
                color: Colors.black,
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite),
                  Icon(Icons.airport_shuttle),
                  Text(" 颜色固定黑色")
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _themeColor =
              _themeColor == Colors.teal ? Colors.blue : Colors.teal),
          child: Icon(Icons.palette),
        ),
      ),
    );
  }
}
