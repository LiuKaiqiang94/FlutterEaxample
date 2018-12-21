import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

///可滚动的widget都直接或间接包含一个Scrollable widget
class ScrollWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("可滚动Widget"),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            textColor: Colors.blue,
            child: Text("SingleChildScrollView"),
            onPressed: () {
              Navigator.pushNamed(context, "single_child_scroll_page");
            },
          ),
          FlatButton(
            textColor: Colors.blue,
            child: Text("ListView"),
            onPressed: () {
              Navigator.pushNamed(context, "list_view_page");
            },
          ),
        ],
      ),
    );
  }
}

///类似于ScrollView 只能接受一个子widget
class SingleChildScrollViewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
      appBar: AppBar(
        title: Text("SingleChildScrollView"),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, //滚动方向，默认垂直
          reverse: false, //是否按阅读方向相反
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: str
                  .split("")
                  .map((c) => Text(c, textScaleFactor: 2))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

//important！
//  double itemExtent, 若指定数值，会强制子widget高度为设定值
//  bool shrinkWrap = false, 是否根据子widget的总长度来设置listView的长度
//  bool addAutomaticKeepAlives = true,是否将列表项包裹在AutomaticKeepAlive中
//  在懒加载列表中，如果这位true，列表项滑出视口不会被gc，会使用KeepAliveNotification
//  保存状态
//  bool addRepaintBoundaries = true,是否将列表项包裹在RepaintBoundary中，
//  可以避免列表项重绘，但是重绘开销很小时，不添加反而更高效
//  double cacheExtent,
class ListViewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ListView"),
        ),
        body: InfiniteListView());
  }
}

///写死的item 不常用
class ListView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      children: <Widget>[
        Text("Item 1"),
        Text("Item 2"),
        Text("Item 3"),
        Text("Item 4"),
        Text("Item 5"),
      ],
    );
  }
}

///加载大量数据 用builder
class ListView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //数量较多时
      itemCount: 100,
      itemExtent: 50,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("$index"),
        );
      },
    );
  }
}

///带有分割线的listView
class ListView3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget divider1 = Divider(color: Colors.blue);
    Widget divider2 = Divider(color: Colors.green);
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("$index"));
      },
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
      itemCount: 100,
    );
  }
}

///无限加载列表 练习实例
class InfiniteListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InfiniteListViewState();
}

class InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (_words[index] == loadingTag) {
          //
          if (_words.length - 1 < 100) {
            _retrieveData();
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: Text("没有更多了", style: TextStyle(color: Colors.grey)),
            );
          }
        }
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (context, index) => Divider(height: .0),
      itemCount: _words.length,
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      _words.insertAll(
        _words.length - 1,
        //每次生成20个单词
        generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
      );
      setState(() {
        //刷新
      });
    });
  }
}
