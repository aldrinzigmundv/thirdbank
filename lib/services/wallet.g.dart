// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WalletProvider on _WalletProvider, Store {
  late final _$mnemonicAtom =
      Atom(name: '_WalletProvider.mnemonic', context: context);

  @override
  String get mnemonic {
    _$mnemonicAtom.reportRead();
    return super.mnemonic;
  }

  @override
  set mnemonic(String value) {
    _$mnemonicAtom.reportWrite(value, super.mnemonic, () {
      super.mnemonic = value;
    });
  }

  late final _$balanceHolderAtom =
      Atom(name: '_WalletProvider.balanceHolder', context: context);

  @override
  String get balanceHolder {
    _$balanceHolderAtom.reportRead();
    return super.balanceHolder;
  }

  @override
  set balanceHolder(String value) {
    _$balanceHolderAtom.reportWrite(value, super.balanceHolder, () {
      super.balanceHolder = value;
    });
  }

  late final _$walletAddressAtom =
      Atom(name: '_WalletProvider.walletAddress', context: context);

  @override
  String get walletAddress {
    _$walletAddressAtom.reportRead();
    return super.walletAddress;
  }

  @override
  set walletAddress(String value) {
    _$walletAddressAtom.reportWrite(value, super.walletAddress, () {
      super.walletAddress = value;
    });
  }

  late final _$transactionsAtom =
      Atom(name: '_WalletProvider.transactions', context: context);

  @override
  List<TransactionDetails> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(List<TransactionDetails> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  late final _$blockchainHeightAtom =
      Atom(name: '_WalletProvider.blockchainHeight', context: context);

  @override
  int get blockchainHeight {
    _$blockchainHeightAtom.reportRead();
    return super.blockchainHeight;
  }

  @override
  set blockchainHeight(int value) {
    _$blockchainHeightAtom.reportWrite(value, super.blockchainHeight, () {
      super.blockchainHeight = value;
    });
  }

  late final _$generateMnemonicAsyncAction =
      AsyncAction('_WalletProvider.generateMnemonic', context: context);

  @override
  Future generateMnemonic() {
    return _$generateMnemonicAsyncAction.run(() => super.generateMnemonic());
  }

  late final _$getDescriptorsAsyncAction =
      AsyncAction('_WalletProvider.getDescriptors', context: context);

  @override
  Future<List<Descriptor>> getDescriptors(String mnemonicStr) {
    return _$getDescriptorsAsyncAction
        .run(() => super.getDescriptors(mnemonicStr));
  }

  late final _$createOrRestoreWalletAsyncAction =
      AsyncAction('_WalletProvider.createOrRestoreWallet', context: context);

  @override
  Future createOrRestoreWallet({required String mnemonic}) {
    return _$createOrRestoreWalletAsyncAction
        .run(() => super.createOrRestoreWallet(mnemonic: mnemonic));
  }

  late final _$getNewAddressAsyncAction =
      AsyncAction('_WalletProvider.getNewAddress', context: context);

  @override
  Future getNewAddress() {
    return _$getNewAddressAsyncAction.run(() => super.getNewAddress());
  }

  late final _$blockchainInitAsyncAction =
      AsyncAction('_WalletProvider.blockchainInit', context: context);

  @override
  Future blockchainInit() {
    return _$blockchainInitAsyncAction.run(() => super.blockchainInit());
  }

  late final _$getBlockchainHeightAsyncAction =
      AsyncAction('_WalletProvider.getBlockchainHeight', context: context);

  @override
  Future getBlockchainHeight() {
    return _$getBlockchainHeightAsyncAction
        .run(() => super.getBlockchainHeight());
  }

  late final _$syncWalletAsyncAction =
      AsyncAction('_WalletProvider.syncWallet', context: context);

  @override
  Future syncWallet() {
    return _$syncWalletAsyncAction.run(() => super.syncWallet());
  }

  late final _$getBalanceAsyncAction =
      AsyncAction('_WalletProvider.getBalance', context: context);

  @override
  Future getBalance() {
    return _$getBalanceAsyncAction.run(() => super.getBalance());
  }

  late final _$getTransactionsAsyncAction =
      AsyncAction('_WalletProvider.getTransactions', context: context);

  @override
  Future getTransactions() {
    return _$getTransactionsAsyncAction.run(() => super.getTransactions());
  }

  late final _$sendTxAsyncAction =
      AsyncAction('_WalletProvider.sendTx', context: context);

  @override
  Future sendTx(
      {required dynamic addressStr, required int amount, required double fee}) {
    return _$sendTxAsyncAction.run(
        () => super.sendTx(addressStr: addressStr, amount: amount, fee: fee));
  }

  @override
  String toString() {
    return '''
mnemonic: ${mnemonic},
balanceHolder: ${balanceHolder},
walletAddress: ${walletAddress},
transactions: ${transactions},
blockchainHeight: ${blockchainHeight}
    ''';
  }
}
