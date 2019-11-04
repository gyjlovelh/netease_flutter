// 订阅着回调签名
typedef void EventCallback(arguments);

class NeteaseEvent {
  // 私有构造函数
  NeteaseEvent._internal();
  // 保存单例
  static NeteaseEvent _instance;
  // 获取单例
  static NeteaseEvent getInstance() {
    if (_instance == null) {
      _instance = new NeteaseEvent._internal();
    }
    return _instance;
  }

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _channels = new Map<String, List<EventCallback>>();

  // 发布事件
  void publish(String topic, [arguments]) {
    var handlers = _channels[topic];
    if (handlers == null) return;
    handlers.forEach((handler) => handler(arguments));
  }

  // 订阅事件
  void subscribe(String topic, EventCallback handler) {
    if (topic == null || handler == null) return;
    _channels[topic] ??= new List<EventCallback>();
    _channels[topic].add(handler);
  }

  // 取消订阅
  void unsubscribe(String topic, EventCallback handler) {
    var list = _channels[topic];
    if (topic == null || list == null) return;
    if (handler == null) {
      _channels[topic] = null;
    } else {
      list.remove(handler);
    }
  }
}
