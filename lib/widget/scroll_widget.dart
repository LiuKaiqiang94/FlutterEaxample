import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_example/route.dart';

///可滚动的widget都直接或间接包含一个Scrollable widget
class ScrollWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = new List();
    list.add(RouteBean("single_child_scroll_page", "SingleChildScrollView"));
    list.add(RouteBean("list_view_page", "ListView"));
    list.add(RouteBean("grid_view_page", "GridView"));
    list.add(RouteBean("custom_scroll_page", "CustomScrollView"));
    return RoutePage(list, "可滚动Widget");
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

///GridView
class GridViewRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView"),
      ),
      body: Padding(
        padding: EdgeInsets.all(6),
        child: GridView6(),
      ),
    );
  }
}

///一般方式
class GridView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      ///SliverGridDelegateWithFixedCrossAxisCount 纵轴为固定数量的layout算法
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //纵轴子元素数量
        childAspectRatio: 1, //子元素宽高比
      ),
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }
}

///GridView.count方式
class GridView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }
}

///纵轴子元素为固定最大长度的layout算法
class GridView3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SliverGridDelegateWithMaxCrossAxisExtent
    //纵轴子元素为固定最大长度的layout算法
    return GridView(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100, childAspectRatio: 2),
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }
}

///GridView.extent方式
class GridView4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 100,
      childAspectRatio: 2,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }
}

/// StaggeredGridView 不均匀分布
class GridView5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) => Container(
            color: Colors.green,
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("$index"),
              ),
            ),
          ),
      staggeredTileBuilder: (index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
      //控制grid分布规则
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    );
  }
}

/// StaggeredGridView 不均匀分布升级版
class GridView6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<GridData> list = new List();
    initData(list);
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) => Container(
            color: list[index]._color,
            child: Center(
              child: IconButton(
                icon: Icon(list[index]._icon),
                onPressed: () => {},
              ),
            ),
          ),
      staggeredTileBuilder: (index) =>
          StaggeredTile.count(list[index].widthCount, list[index].heightCount),
      //控制grid分布规则
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
    );
  }

  void initData(List<GridData> list) {
    list.add(GridData(Colors.green, Icons.settings, 2, 2));
    list.add(GridData(Colors.blue, Icons.wifi, 2, 1));
    list.add(GridData(Colors.yellow, Icons.tv, 1, 2));
    list.add(GridData(Colors.brown, Icons.tv, 1, 1));
    list.add(GridData(Colors.red, Icons.send, 2, 2));
    list.add(GridData(Colors.lightBlue, Icons.gamepad, 1, 2));
    list.add(GridData(Colors.pink, Icons.bluetooth, 1, 1));
    list.add(GridData(Colors.orange, Icons.battery_alert, 3, 1));
    list.add(GridData(Colors.purple, Icons.computer, 1, 1));
    list.add(GridData(Colors.blueAccent, Icons.computer, 4, 1));
  }
}

class GridData {
  Color _color;
  IconData _icon;
  int widthCount;
  int heightCount;

  GridData(this._color, this._icon, this.widthCount, this.heightCount);
}

///自定义滚动模型
///例如 GridView+ListView共同滑动
class CustomScrollRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("CustomScrollView"),
              background: Image.asset(
                "images/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: new SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: Text("grid item $index"),
                  );
                },
                childCount: 20,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 4,
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text("list item $index"),
              );
            }),
          ), //包含一个appBar
        ],
      ),
    );
  }
}
