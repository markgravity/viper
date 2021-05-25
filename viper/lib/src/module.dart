import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

part 'presenter.dart';

part 'interactor.dart';

part 'router.dart';

part 'view.dart';

abstract class Module<V extends View, P extends Presenter, R extends Router>
    extends StatelessWidget {
  late final V view;
  P get presenter;

  R get router;

  void assembly(V view) {
    this.view = view;

    view.delegate = presenter;
    presenter.configure(
      view: view,
      router: router,
    );
  }

  void dispose() {
    presenter.dispose();
  }
}

// ignore: must_be_immutable
abstract class ArgumentsModule<V extends View, P extends ArgumentsPresenter, R extends Router,
    A extends ModuleArguments> extends Module<V, P, R> {
  A? overriddenArguments;

  void setArguments(Object? arguments) {
    presenter.arguments = overriddenArguments ?? arguments as A;
  }
}

abstract class ModuleArguments {}
