import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({
    Key key,
    this.initValue: 0,
  });

  final int initValue;

  @override
  State<StatefulWidget> createState() => new _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    print("initState，只执行一次，在widget第一次插入widget树时执行");
  }

  @override
  Widget build(BuildContext context) {
    print("build，在initState、didUpdateWidget、setState、didChangeDependencies");
    return Center(
      child: FlatButton(
        onPressed: () => setState(() => ++_counter),
        child: Text('$_counter'),
      ),
    );
  }

  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget，在widget重新构建时");
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate，对象从树种被移除时回调');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose，从树中永久移除，在此回调中释放资源');
  }

  @override
  void reassemble() {
    super.reassemble();
    print('reassemble,只有在热重载时会调用，release中不会被调用');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies，对象依赖发生变化时调用');
  }
}

//TapBoxA管理自身状态
class TapBoxA extends StatefulWidget {
  TapBoxA({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TapboxAState();
}

class _TapboxAState extends State<TapBoxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _handleTap,
      child: new Container(
        child: new Center(
          child: new Text(
            _active ? 'Active' : 'Inactive',
            style: new TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 150.0,
        height: 70.0,
        decoration: new BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

//TapboxB的状态由父类Parent管理
class ParentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ParentWidgetState();
  }
}

class ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

class TapboxB extends StatelessWidget {
  TapboxB({Key key, this.active: false, @required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _handleTap,
      child: new Container(
        child: new Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: new TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 150.0,
        height: 70.0,
        decoration: new BoxDecoration(
          color: active ? Colors.lightBlue[700] : Colors.yellow[600],
        ),
      ),
    );
  }
}

//TapboxC  父子共同管理 父widget管理active状态，子widget管理高亮状态
class ParentWidgetC extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ParentWidgetCState();
}

class ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new TapboxC(
        onChanged: _handleTapboxChanged,
        active: _active,
      ),
    );
  }
}

class TapboxC extends StatefulWidget {
  TapboxC({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<StatefulWidget> createState() => new TapboxCState();
}

class TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    //效果：按下时添加绿色边框，抬起时，取消高亮
    return new GestureDetector(
      onTapDown: _handleTapDown,
      //按下事件
      onTapUp: _handleTapUp,
      //抬起事件
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: new Container(
        child: new Center(
          child: new Text(
            widget.active ? 'Active' : 'Inactive',
            style: new TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 150.0,
        height: 70.0,
        decoration: new BoxDecoration(
            color: widget.active ? Colors.red : Colors.green,
            border: _highlight
                ? new Border.all(
                    color: Colors.teal,
                    width: 10.0,
                  )
                : null),
      ),
    );
  }
}
