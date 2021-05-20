import 'package:viper/viper.dart';
import 'package:viper/annotation.dart';

import 'main.dart';

part 'presenter.g.dart';

@presenter
class MyHomePresenterImpl extends MyHomePresenter
    with _$MyHomePresenterImpl
    implements MyHomeViewDelegate, CounterInteractorDelegate {
  MyHomePresenterImpl._();
  factory MyHomePresenterImpl() => _$BoundMyHomePresenterImpl();

  // ignore: close_sinks
  final incrementButtonDidTap = BehaviorSubject<void>();
}
