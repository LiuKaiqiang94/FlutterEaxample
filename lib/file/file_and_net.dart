import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

///文件操作相关
class FileAndNetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("file_page", "文件操作"));
    list.add(RouteBean("http_client_page", "HttpClient请求"));
    return RoutePage(list, "文件和网络请求");
  }
}

class FileRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FileRouteState();
}

class FileRouteState extends State<FileRoute> {
  int _counter;

  @override
  void initState() {
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File("$dir/counter.txt");
  }

  Future<int> _readCounter() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  Future<Null> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await (await _getLocalFile()).writeAsString('$_counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文件操作"),
      ),
      body: Center(
        child: Text("点击了$_counter次"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HttpClientRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpClientRouteState();
}

class _HttpClientRouteState extends State<HttpClientRoute> {
  bool _loading = false;
  String _text = "";

  ///HttpClient属性
  ///idleTimeout => 对应请求头中的keep-alive字段，为避免频繁建立连接，httpClient
  ///在请求结束后会保持连接一段时间，超过这个阈值后才会关闭连接
  ///connectionTimeout => 和服务器建立连接的超时，超过此值会抛SocketException
  ///maxConnectionsPerHost => 同一个host，同时允许建立连接的最大数量
  ///autoUncompress => 对应请求头中的Content-Encoding，若为true，Content-Encoding值为
  ///HttpClient支持的压缩算法列表，目前只有'gzip'
  ///userAgent => 对应请求头的User-Agent
  _load() async {
    setState(() {
      _loading = true;
      _text = "正在请求";
    });
    try {
      //创建一个HttpClient
      HttpClient httpClient = HttpClient();
      //打开Http连接
      HttpClientRequest request =
          await httpClient.getUrl(Uri.parse("https://www.baidu.com"));
      //使用iPhone的UA
      request.headers.add("user-agent",
          "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1");
      //等待连接服务器（会将请求信息发送给服务器）
      HttpClientResponse response = await request.close();
      //读取相应内容
      _text = await response.transform(utf8.decoder).join();
      //输出响应头
      print(response.headers);
      //关闭client
      httpClient.close();
    } catch (e) {
      _text = "请求失败$e";
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HttpClient请求"),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("获取百度首页"),
                onPressed: _loading ? null : _load,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(_text.replaceAll(new RegExp(r"\s"), "")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
