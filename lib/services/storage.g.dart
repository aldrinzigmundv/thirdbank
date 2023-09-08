// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StorageProvider on _StorageProvider, Store {
  late final _$writeAsyncAction =
      AsyncAction('_StorageProvider.write', context: context);

  @override
  Future write({required String key, required String value}) {
    return _$writeAsyncAction.run(() => super.write(key: key, value: value));
  }

  late final _$readAsyncAction =
      AsyncAction('_StorageProvider.read', context: context);

  @override
  Future read({required String key}) {
    return _$readAsyncAction.run(() => super.read(key: key));
  }

  late final _$_StorageProviderActionController =
      ActionController(name: '_StorageProvider', context: context);

  @override
  dynamic initialize() {
    final _$actionInfo = _$_StorageProviderActionController.startAction(
        name: '_StorageProvider.initialize');
    try {
      return super.initialize();
    } finally {
      _$_StorageProviderActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
