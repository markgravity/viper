import 'dart:async';
import 'package:rxdart/rxdart.dart';

extension StreamVoidExtensions on Stream<void> {
  StreamSubscription<void> voidListen(void Function() onData) {
    return listen((_) {
      onData();
    });
  }
}

extension StreamExtensions<T> on Stream<T> {
  StreamSubscription<T> bind(Sink<T> sink) {
    return listen((event) {
      sink.add(event);
    });
  }

  StreamSubscription<T> justListen() {
    return listen((event) {});
  }

  Stream<T> handleException(Function(Exception exception) onException) {
    return this.handleError((object) {
      onException(object as Exception);
    }, test: (object) {
      return object is Exception;
    });
  }
}
