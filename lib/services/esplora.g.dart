// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'esplora.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EsploraProvider on _EsploraProvider, Store {
  late final _$emergencyAtom =
      Atom(name: '_EsploraProvider.emergency', context: context);

  @override
  double get emergency {
    _$emergencyAtom.reportRead();
    return super.emergency;
  }

  @override
  set emergency(double value) {
    _$emergencyAtom.reportWrite(value, super.emergency, () {
      super.emergency = value;
    });
  }

  late final _$fastAtom = Atom(name: '_EsploraProvider.fast', context: context);

  @override
  double get fast {
    _$fastAtom.reportRead();
    return super.fast;
  }

  @override
  set fast(double value) {
    _$fastAtom.reportWrite(value, super.fast, () {
      super.fast = value;
    });
  }

  late final _$mediumAtom =
      Atom(name: '_EsploraProvider.medium', context: context);

  @override
  double get medium {
    _$mediumAtom.reportRead();
    return super.medium;
  }

  @override
  set medium(double value) {
    _$mediumAtom.reportWrite(value, super.medium, () {
      super.medium = value;
    });
  }

  late final _$slowAtom = Atom(name: '_EsploraProvider.slow', context: context);

  @override
  double get slow {
    _$slowAtom.reportRead();
    return super.slow;
  }

  @override
  set slow(double value) {
    _$slowAtom.reportWrite(value, super.slow, () {
      super.slow = value;
    });
  }

  late final _$superslowAtom =
      Atom(name: '_EsploraProvider.superslow', context: context);

  @override
  double get superslow {
    _$superslowAtom.reportRead();
    return super.superslow;
  }

  @override
  set superslow(double value) {
    _$superslowAtom.reportWrite(value, super.superslow, () {
      super.superslow = value;
    });
  }

  late final _$getFeesAsyncAction =
      AsyncAction('_EsploraProvider.getFees', context: context);

  @override
  Future getFees() {
    return _$getFeesAsyncAction.run(() => super.getFees());
  }

  late final _$_EsploraProviderActionController =
      ActionController(name: '_EsploraProvider', context: context);

  @override
  double getFee(String speed) {
    final _$actionInfo = _$_EsploraProviderActionController.startAction(
        name: '_EsploraProvider.getFee');
    try {
      return super.getFee(speed);
    } finally {
      _$_EsploraProviderActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
emergency: ${emergency},
fast: ${fast},
medium: ${medium},
slow: ${slow},
superslow: ${superslow}
    ''';
  }
}
