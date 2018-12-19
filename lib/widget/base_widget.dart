import 'package:flutter/material.dart';

class BaseWidgetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Examples"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text("文本及样式"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "text_page");
              },
            ),
            FlatButton(
              child: Text("按钮"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "button_page");
              },
            ),
            FlatButton(
              child: Text("图片和ICON"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "icon_page");
              },
            ),
            FlatButton(
              child: Text("单选开关和复选框"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "check_page");
              },
            ),
            FlatButton(
              child: Text("输入框"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "input_page");
              },
            ),
            FlatButton(
              child: Text("表单"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "form_page");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextStyleRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文本及样式"),
      ),
      body: Column(
        children: <Widget>[
          Text(
            "Hello World!" * 6,
            textAlign: TextAlign.center, //文本对其方式
          ),
          Text(
            "Hello world! I'm Jack." * 4,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, //截断方式
          ),
          Text(
            "字体缩放",
            textScaleFactor: 1.5, //当前字体大小的缩放因子
          ),
          Text(
            "Hello TextStyle",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18.0,
              height: 1.2,
              fontFamily: 'Courier',
              //字体
              background: new Paint()..color = Colors.yellow,
              //背景颜色
              decoration: TextDecoration.underline,
              //下划线
              decorationStyle: TextDecorationStyle.dashed, //下划线虚线
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "Hello:"),
                TextSpan(
                  text: "Rich Text",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          DefaultTextStyle(
            //默认样式
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.start,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Hello Default Style"),
                Text("Hello Style 000"),
                Text("Hello Style 111"),
                Text(
                  "Hello Style inherit",
                  style: TextStyle(
                    inherit: false, //不继承默认样式
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("按钮"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("raisedButton button"),
            onPressed: () => {},
          ),
          FlatButton(
            child: Text("flatButton button"),
            onPressed: () => {},
          ),
          OutlineButton(
            child: Text("outline button"),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () => {},
          ),
          RaisedButton(
            color: Colors.blue,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Text("Custom button"),
            onPressed: () => {},
          ),
        ],
      )),
    );
  }
}

class IconRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("图片及ICON"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('加载本地图片：'),
            Image(
              image: AssetImage('images/icon.png'),
              width: 100.0,
            ),
            Text('Image.asset方式加载：'),
            Image.asset(
              'images/icon.png',
              width: 100.0,
            ),
            Text('加载网络图片:'),
            Image(
              image: NetworkImage(
                "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
              ),
              width: 100.0,
            ),
            Text("Image.assert方式加载网络图片:"),
            Image.network(
              "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
              width: 100.0,
            )
          ],
        ),
      ),
    );
  }
}

class CheckBoxRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CheckBoxRouteState();
}

class CheckBoxRouteState extends State<CheckBoxRoute> {
  bool _switchSelected = true;
  bool _checkboxSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("单选开关和复选框"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Switch(
              value: _switchSelected,
              onChanged: (value) {
                setState(() {
                  _switchSelected = value;
                });
              },
            ),
            Checkbox(
              tristate: true, //复选框是否三种状态
              value: _checkboxSelected,
              activeColor: Colors.red,
              onChanged: (value) {
                setState(() {
                  _checkboxSelected = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InputRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new InputRouteState();
}

class InputRouteState extends State<InputRoute> {
  TextEditingController _uNameController = new TextEditingController(); //监听内容变化
  FocusNode node1 = new FocusNode();
  FocusNode node2 = new FocusNode();
  FocusScopeNode focusScopeNode;

  @override
  void initState() {
    super.initState();
    _uNameController.addListener(() {
      print(_uNameController.text);
    });
    node1.addListener(() {
      //监听焦点的变化
      print(node1.hasFocus);
    });
    node2.addListener(() {
      print(node2.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("输入框"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              focusNode: node1,
              controller: _uNameController,
              decoration: InputDecoration(
                //控制TextField外观显示
                labelText: "用户名",
                hintText: "用户名或邮箱",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              focusNode: node2,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "您的登录密码",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true, //隐藏文字，输入密码场景
            ),
            Container(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "电子邮箱地址",
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                ),
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[200], width: 1.0))),
            ),
            RaisedButton(
              child: Text("移动焦点"),
              onPressed: () {
                if (null == focusScopeNode) {
                  focusScopeNode = FocusScope.of(context);
                }
                focusScopeNode.requestFocus(node2);
              },
            ),
            RaisedButton(
              child: Text("隐藏键盘"),
              onPressed: () {
                //所有编辑框都失去焦点时键盘收起
                node1.unfocus();
                node2.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FormTestRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FormTestRouteState();
}

class FormTestRouteState extends State<FormTestRoute> {
  TextEditingController _uNameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("表单"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Form(
              key: _formKey, //设置全局key，用户后面获取formState
              autovalidate: true, //开启自动校验
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _uNameController,
                    decoration: InputDecoration(
                      labelText: "用户名",
                      hintText: "用户名或邮箱",
                      icon: Icon(Icons.person),
                    ),
                    //校验用户名
                    validator: (v) {
                      return v.trim().length > 0 ? null : "用户名不能为空";
                    },
                  ),
                  TextFormField(
                    controller: _pwdController,
                    decoration: InputDecoration(
                      labelText: "密码",
                      hintText: "您的登录密码",
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (v) {
                      return v.trim().length > 5 ? null : "密码不能少于6位";
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text("登录"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if ((_formKey.currentState as FormState).validate()) {
                        print("验证通过，提交表单");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
