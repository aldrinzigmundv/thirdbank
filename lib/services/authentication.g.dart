// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthenticationProvider on _AuthenticationProvider, Store {
  late final _$checkAuthenticationAvailabilityAsyncAction = AsyncAction(
      '_AuthenticationProvider.checkAuthenticationAvailability',
      context: context);

  @override
  Future checkAuthenticationAvailability() {
    return _$checkAuthenticationAvailabilityAsyncAction
        .run(() => super.checkAuthenticationAvailability());
  }

  late final _$authenticateAsyncAction =
      AsyncAction('_AuthenticationProvider.authenticate', context: context);

  @override
  Future authenticate() {
    return _$authenticateAsyncAction.run(() => super.authenticate());
  }

  late final _$_AuthenticationProviderActionController =
      ActionController(name: '_AuthenticationProvider', context: context);

  @override
  dynamic initialize() {
    final _$actionInfo = _$_AuthenticationProviderActionController.startAction(
        name: '_AuthenticationProvider.initialize');
    try {
      return super.initialize();
    } finally {
      _$_AuthenticationProviderActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
