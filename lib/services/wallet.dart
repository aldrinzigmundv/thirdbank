import 'package:mobx/mobx.dart';

import 'package:bdk_flutter/bdk_flutter.dart';

part 'wallet.g.dart';

class WalletProvider = _WalletProvider with _$WalletProvider;

abstract class _WalletProvider with Store {
  @observable
  late String mnemonic = "";

  @observable
  late String balanceHolder = "Please wait...";

  @observable
  late String walletAddress = "";

  @observable
  late List<TransactionDetails> transactions = [];

  @observable
  int blockchainHeight = 0;

  late Wallet wallet;

  late Blockchain blockchain;

  @action
  getBlockchainHeight() async{
    int height = await blockchain.getHeight();
    blockchainHeight = height;
  }

  @action
  syncWallet() async {
    balanceHolder = 'Please wait...';
    wallet.sync(blockchain);

  }

  @action
  getBalance() async {
    final balanceObj = await wallet.getBalance();
    final result = balanceObj.total;
    balanceHolder = "$result sats";
  }

  @action
  getTransactions() async {
    final resultObj = await wallet.listTransactions(false);
    transactions = resultObj;
    transactions.sort((a, b) {
      if (a.confirmationTime == null && b.confirmationTime == null) {
        return 0;
      } else if (a.confirmationTime == null) {
        return -1;
      } else if (b.confirmationTime == null) {
        return 1;
      } else {
        return b.confirmationTime!.timestamp!
            .compareTo(a.confirmationTime!.timestamp!);
      }
    });
  }

  @action
  sendTx({required addressStr, required int amount, required double fee}) async {
    try {
      final txBuilder = TxBuilder();
      final address = await Address.create(address: addressStr);
      final script = await address.scriptPubKey();
      final txBuilderResult = await txBuilder
          .addRecipient(script, amount)
          .feeRate(fee)
          .finish(wallet);
      final sbt = await wallet.sign(psbt: txBuilderResult.psbt);
      final tx = await sbt.extractTx();
      await blockchain.broadcast(tx);
    } catch (_) {
      rethrow;
    }
  }

  @action
  generateMnemonic() async {
    var res = await Mnemonic.create(WordCount.Words24);
    mnemonic = res.asString();
  }

  @action
  Future<List<Descriptor>> getDescriptors(String mnemonicStr) async {
    final descriptors = <Descriptor>[];
    try {
      for (var e in [KeychainKind.External, KeychainKind.Internal]) {
        final mnemonic = await Mnemonic.fromString(mnemonicStr);
        final descriptorSecretKey = await DescriptorSecretKey.create(
          network: Network.Bitcoin,
          mnemonic: mnemonic,
        );
        final descriptor = await Descriptor.newBip84(
            secretKey: descriptorSecretKey,
            network: Network.Bitcoin,
            keychain: e);
        descriptors.add(descriptor);
      }
      return descriptors;
    } catch (_) {
      rethrow;
    }
  }

  @action
  blockchainInit() async {
    try {
      blockchain = await Blockchain.create(
          config: const BlockchainConfig.electrum(
              config: ElectrumConfig(
                  stopGap: 10,
                  timeout: 5,
                  retry: 5,
                  url: "ssl://electrum.blockstream.info:60002",
                  validateDomain: false)));
    } catch (_) {
      rethrow;
    }
  }

  @action
  getNewAddress() async {
    try {
    final res = await wallet.getAddress(addressIndex: const AddressIndex());
    walletAddress = res.address;
    } catch (_) {
      rethrow;
    }
  }

  @action
  createOrRestoreWallet(
      {required String mnemonic,
      required String path}) async {
    try {
      final descriptors = await getDescriptors(mnemonic);
      await blockchainInit();
      final res = await Wallet.create(
          descriptor: descriptors[0],
          changeDescriptor: descriptors[1],
          network: Network.Bitcoin,
          databaseConfig: const DatabaseConfig.memory());
      wallet = res;
    } catch (_) {
      rethrow;
    }
  }
}
