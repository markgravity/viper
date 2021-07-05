part of 'module.dart';

abstract class View {
  BuildContext get context;
  Stream<void> get stateDidInit;
}

abstract class ViewState<V extends StatefulWidget, M extends Widget>
    extends State<V> implements View {
  @visibleForTesting
  static Module? overriddenModule;
  Module? _disposedModule;

  BehaviorSubject<void> stateDidInit = BehaviorSubject();

  @override
  void initState() {
    super.initState();

    final module = _getModule();
    module?.assembly(this);
    stateDidInit.add(null);
  }

  @override
  void didChangeDependencies() {
    final module = _getModule();

    if (module is ArgumentsModule) {
      module.setArguments(ModalRoute.of(context)?.settings.arguments);
    }

    _disposedModule = module;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _disposedModule?.dispose();
    super.dispose();
  }

  Module? _getModule() =>
      (context.findAncestorWidgetOfExactType<M>() ?? overriddenModule)
          as Module?;
}
