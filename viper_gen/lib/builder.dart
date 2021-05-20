import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:viper_gen/src/presenter_generator.dart';

Builder presenterBuilder(BuilderOptions options) =>
    SharedPartBuilder([PresenterGenerator()], 'presenter');
