// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presenter.dart';

// **************************************************************************
// PresenterGenerator
// **************************************************************************

MyHomePresenterImpl _$BoundMyHomePresenterImpl() {
  final presenter = MyHomePresenterImpl._();
  presenter.stateDidInit
      .voidListen(presenter.$stateDidInit)
      .addTo(presenter.disposeBag);
  presenter.counterDidIncrement
      .voidListen(presenter.$counterDidIncrement)
      .addTo(presenter.disposeBag);
  return presenter;
}

mixin _$MyHomePresenterImpl {
// ignore: close_sinks
  final stateDidInit = BehaviorSubject<void>();
  void $stateDidInit() {}
// ignore: close_sinks
  final counterDidIncrement = BehaviorSubject<void>();
  void $counterDidIncrement() {}
}
