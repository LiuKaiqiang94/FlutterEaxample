import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';

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
      routes: new AppRoute().getRoute(),
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
  @override
  Widget build(BuildContext context) {
    //每次setState都会调用build
    return Scaffold(
      //默认提供导航栏、标题，主屏幕的widget树的body
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        //位于屏幕中间
        child: Center(
          child: Column(
            //列控件，children竖直方向排列排列
            children: <Widget>[
              FlatButton(
                //按钮
                child: Text("基础Widget"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, "base_widget_page");
                },
              ),
              FlatButton(
                child: Text("布局Widget"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, "layout_widget_page");
                },
              ),
              FlatButton(
                //按钮
                child: Text("open ios style test"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, "cupertino_page");
                },
              ),
            ],
          ),
        ),
      ),
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