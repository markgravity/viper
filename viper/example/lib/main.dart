import 'package:flutter/material.dart' hide Router;
import 'package:viper/viper.dart';

abstract class MyHomeViewDelegate {
  BehaviorSubject<void> get stateDidInit;

  BehaviorSubject<void> get incrementButtonDidTap;
}

abstract class MyHomeView extends View<MyHomeViewDelegate> {
  void setCounter(int counter);
}

abstract class CounterInteractorDelegate {
  BehaviorSubject<void> get counterDidIncrement;
}

abstract class CounterInteractor extends Interactor<CounterInteractorDelegate> {
  int get counter;

  void increment();
}

class CounterInteractorImpl extends CounterInteractor {
  var _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    delegate?.counterDidIncrement.add(null);
  }
}

abstract class MyHomeRouter extends Router {}

class MyHomeRouterImpl extends MyHomeRouter {}

abstract class MyHomePresenter extends Presenter<MyHomeView, MyHomeRouter> {}

class MyHomePresenterImpl extends MyHomePresenter
    implements MyHomeViewDelegate, CounterInteractorDelegate {
  MyHomePresenterImpl() {
    stateDidInit.voidListen(_stateDidInit).addTo(disposeBag);
    incrementButtonDidTap.voidListen(_incrementButtonDidTap).addTo(disposeBag);
    counterDidIncrement.voidListen(_counterDidIncrement).addTo(disposeBag);
  }

  late final counterInteractor = CounterInteractorImpl()..delegate = this;

  @override
  final stateDidInit = BehaviorSubject<void>();

  @override
  final incrementButtonDidTap = BehaviorSubject<void>();

  @override
  final counterDidIncrement = BehaviorSubject<void>();

  void _stateDidInit() {
    view.setCounter(counterInteractor.counter);
  }

  void _incrementButtonDidTap() {
    counterInteractor.increment();
  }

  void _counterDidIncrement() {
    view.setCounter(counterInteractor.counter);
  }
}

class MyHomeModule extends Module<MyHomeView, MyHomePresenter, MyHomeRouter> {
  @override
  final presenter = MyHomePresenterImpl();

  @override
  final router = MyHomeRouterImpl();

  @override
  Widget build(BuildContext context) {
    return MyHomeViewImpl();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomeModule(),
    );
  }
}

class MyHomeViewImpl extends StatefulWidget {
  MyHomeViewImpl({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomeViewImplState createState() => _MyHomeViewImplState();
}

class _MyHomeViewImplState extends ViewState<MyHomeViewImpl, MyHomeModule, MyHomeViewDelegate>
    implements MyHomeView {
  // ignore: close_sinks
  final _counter = BehaviorSubject<int>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Example"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamSelector<int>(
              stream: _counter,
              builder: (_, counter, __) => Text(
                '$counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => delegate?.incrementButtonDidTap.add(null),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void setCounter(int counter) {
    _counter.add(counter);
  }
}
