///订阅者回调签名
typedef void EventCallback(arg);

///实现dart版的eventBus
class EventBus {
  //构造函数私有
  EventBus._internal();

  //保存单例
  static EventBus _singleton = EventBus._internal();

  //工厂构造函数
  factory EventBus() => _singleton;

  var _eMap = Map<Object, List<EventCallback>>();

  ///添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _eMap[eventName] ??= List<EventCallback>();
    _eMap[eventName].add(f);
  }

  ///移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _eMap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _eMap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  ///触发事件
  void emit(eventName, [arg]) {
    var list = _eMap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

//top-level变量
var bus = EventBus();
