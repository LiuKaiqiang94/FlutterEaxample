import 'package:flutter/material.dart';
import 'package:flutter_example/route.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';

///文件操作相关
class FileAndNetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteBean> list = List();
    list.add(RouteBean("file_page", "文件操作"));
    list.add(RouteBean("http_client_page", "HttpClient请求"));
    list.add(RouteBean("dio_page", "dio请求"));
    list.add(RouteBean("sockets_page", "WebSockets"));
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

class DioRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DioRouteState();
}

class _DioRouteState extends State<DioRoute> {
  Dio _dio;
  String _text = "";
  Response response;

  @override
  void initState() {
    super.initState();

    ///创建并实例dio
    _dio = Dio();
  }

  void _getRequest() async {
    setState(() {
      _text = "加载中";
    });

    ///两者等价
    response = await _dio.get("/test?id=123&name=lucio");
    response = await _dio.get("/test", data: {"id": 123, "name": "lucio"});
    setState(() {
      _text = response.data.toString();
      print(response.data.toString());
      print(response.data.toString());
    });
  }

  void _postRequest() async {
    response = await _dio.post("/test", data: {"id": 123, "name": "lucio"});
    print(response.data.toString());
  }

  void _multiRequest() async {
    // ignore: unused_local_variable
    List<Response> response =
        await Future.wait([_dio.post("/info"), _dio.get("/token")]);
  }

  void _downloadRequest() async {
    response = await _dio.download("https://www.google.com", "savePath");
  }

  void _fromDataRequest() async {
    FormData formData = FormData.from({
      "name": "wemdux",
      "age": 25,
    });
    response = await _dio.post("/info", data: formData);
  }

  void _uploadRequest() async {
    FormData formData = FormData.from({
      "name": "wemdux",
      "age": 25,
      "file1": UploadFileInfo(File("./upload.txt"), "upload1.txt"),
      "file2": UploadFileInfo(File("./upload.txt"), "upload2.txt"),
      //支持文件数组上传
      "files": [
        UploadFileInfo(File("./upload.txt"), "upload1.txt"),
        UploadFileInfo(File("./upload.txt"), "upload2.txt"),
      ]
    });
    response = await _dio.post("/info", data: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dio请求"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(child: Text("get请求"), onPressed: _getRequest),
          RaisedButton(child: Text("post请求"), onPressed: _postRequest),
          RaisedButton(child: Text("多个并发请求"), onPressed: _multiRequest),
          RaisedButton(child: Text("下载文件"), onPressed: _downloadRequest),
          RaisedButton(child: Text("发送fromData"), onPressed: _fromDataRequest),
          RaisedButton(child: Text("上传多个文件"), onPressed: _uploadRequest),
          Text("$_text"),
        ],
      ),
    );
  }
}

///WebSocket的使用
///1.连接到WebSocket服务器
///2.监听来自服务器的消息
///3.将数据发送到服务器
///4.关闭WebSocket练级连接
class WebSocketRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> {
  TextEditingController _controller = TextEditingController();
  IOWebSocketChannel channel;
  String _text = "";

  String _response = "";

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  //网络不通
                  _text = "网络不通...";
                } else if (snapshot.hasData) {
                  _text = "echo:" + snapshot.data;
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(_text),
                );
              },
            ),
            RaisedButton(
              child: Text("Socket API发送"),
              onPressed: _request,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text("$_response"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  //使用Socket Api请求
  _request() async {
    var socket = await Socket.connect("baidu.com", 80);
    socket.writeln("GET / HTTP/1.1");
    socket.writeln("Host:baidu.com");
    socket.writeln("Connection:close");
    socket.writeln();
    await socket.flush(); //发送
    _response = await socket.transform(utf8.decoder).join();
    await socket.close();
    setState(() {});
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
