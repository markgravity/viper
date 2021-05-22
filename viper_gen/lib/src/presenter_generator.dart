import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:viper/annotation.dart';

class PresenterGenerator extends GeneratorForAnnotation<PresenterAnnotation> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final content = StringBuffer();

    final classElement = element as ClassElement;
    final allElementFieldNames = classElement.fields.map((e) => e.name);
    final allInterfaceFields =
        _getAllField(classElement).where((element) => !allElementFieldNames.contains(element.name));

    content.writeln("${classElement.name} _\$Bound${classElement.name}() {");
    content.writeln(" final presenter = ${classElement.name}._();");
    for (final field in allInterfaceFields) {
      final type = field.type as InterfaceType;
      final genericType = type.typeArguments.first;
      genericType.isVoid
          ? content.writeln(
              " presenter.${field.name}.voidListen(presenter.\$${field.name}).addTo(presenter.disposeBag);")
          : content.writeln(
              " presenter.${field.name}.listen(presenter.\$${field.name}).addTo(presenter.disposeBag);");
    }
    content.writeln(" return presenter;");
    content.writeln("}");

    content.writeln("mixin _\$${classElement.name} {");
    for (final field in allInterfaceFields) {
      content.writeln("// ignore: close_sinks");
      content.writeln(" final ${field.name} = ${field.type.toString()}();");

      final type = field.type as InterfaceType;
      final genericType = type.typeArguments.first;
      genericType.isVoid
          ? content.writeln("void \$${field.name}() {}")
          : content.writeln("void \$${field.name}(${genericType.toString()} data) {}");
    }
    content.writeln("}");
    return content.toString();
  }

  bool _isBehaviorSubject(FieldElement fieldElement) {
    if (fieldElement.type.element is! ClassElement) return false;

    ClassElement? classElement = fieldElement.type.element as ClassElement;
    do {
      if (classElement!.name == "BehaviorSubject") return true;
      classElement = classElement.supertype?.element;
    } while (classElement != null);

    return false;
  }

  List<FieldElement> _getAllField(ClassElement classElement) {
    if (classElement.interfaces.length == 0) return [];

    return classElement.interfaces
        .map((e) => e.element.fields + _getAllField(e.element))
        .reduce((value, element) => value + element)
        .where((element) => _isBehaviorSubject(element))
        .toList();
  }
}
