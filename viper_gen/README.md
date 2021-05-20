# VIPER Gen

A generator for viper package

## How to use
Mark a presenter with `@presenter`
```dart
import 'package:viper/viper.dart';
import 'package:viper/annotation.dart';

part 'presenter.g.dart';

@presenter
class MyPresenterImpl extends MyPresenter
    // Add states & bound functions
    with _$MyPresenterImpl
    implements MyViewDelegate, MyInteractorDelegate {
  
  // Requires to create a new instance  
  MyPresenterImpl._();
  
  // Bind states with bound functions
  factory MyHomePresenterImpl() => _$BoundMyPresenterImpl(); 

  // Manually declare a state, will skip it from generating
  final incrementButtonDidTap = BehaviorSubject<void>();
  
  // incrementButtonDidTap state will be bound to this function
  void $counterDidIncrement() {}
}
```
