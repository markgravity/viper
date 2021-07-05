part of 'module.dart';

abstract class Presenter<V extends View, R extends Router> {
  final disposeBag = CompositeSubscription();

  late final V view;
  late final R router;

  void configure({
    required V view,
    required R router,
  }) {
    this.view = view;
    this.router = router;
    onReady();
  }

  void onReady() {}

  void dispose() {
    disposeBag.dispose();
  }
}

abstract class ArgumentsPresenter<V extends View, R extends Router, A extends ModuleArguments>
    extends Presenter<V, R> {
  late A arguments;
}
