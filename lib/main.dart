import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', //app name
      theme: ThemeData(
        buttonColor: Colors.green.shade600,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'), //应用首页路由
      routes: routeMap,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _lastPressedAt; //上次点击时间
  @override
  Widget build(BuildContext context) {
    //每次setState都会调用build
    List<RouteBean> list = new List();
    list.add(RouteBean("base_widget_page", "基础Widget"));
    list.add(RouteBean("layout_widget_page", "布局Widget"));
    list.add(RouteBean("container_widget_page", "容器类Widget"));
    list.add(RouteBean("scroll_widget_page", "可滚动Widget"));
    list.add(RouteBean("feature_widget_page", "功能型Widget"));
    list.add(RouteBean("event_page", "事件处理与通知"));
    list.add(RouteBean("animation_page", "动画"));
    list.add(RouteBean("custom_widget_page", "自定义Widget"));
    list.add(RouteBean("file_and_net_page", "文件操作与网络请求"));
    list.add(RouteBean("cupertino_page", "open ios style test"));
    return WillPopScope(
      child: RoutePage(list, widget.title),
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          Fluttertoast.showToast(msg: "再次点击退出app");
          return false;
        }
        return true;
      },
    );
  }
}

//新的页面
class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Route")),
      body: Center(
          child: FlatButton(
              textColor: Colors.red,
              child: Text("This is new route"),
              onPressed: () {
                Navigator.pop(context);
              })),
    );
  }
}

//随机词汇测试
class RandomWordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(wordPair.toString()),
    );
  }
}

//无状态的widget
class Echo extends StatelessWidget {
  const Echo({
    Key key,
    @required this.text,
    this.backgroundColor: Colors.grey,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

//测试iOS风格控件
class CupertinoTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("CupertinoDemo"),
      ),
      child: Center(
        child: CupertinoButton(
          color: CupertinoColors.activeBlue,
          child: Text("Press"),
          onPressed: () {},
        ),
      ),
    );
  }
}
