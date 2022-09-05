import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/user/user_preference.dart';
import 'package:web3dart/web3dart.dart';
import "package:bip39/bip39.dart" as bip39;
import "package:hex/hex.dart";
import 'package:ed25519_hd_key/ed25519_hd_key.dart';

abstract class WalletAddressServices {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
}

class WalletAddress implements WalletAddressServices {
  // static SharedPreferences _prefs =
  //     SharedPreferences.getInstance() as SharedPreferences;

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);
    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    print("address: $address");
    return address;
  }

  String getPrefPrivateKey() =>
      UserSimplePreferences.getPrivAddress().toString();
  String getPrefPublic() => UserSimplePreferences.getPubAddress().toString();

  ///set private key
  Future<void> setPrefPrivateKey(String value) async =>
      await UserSimplePreferences.setPrivAddress(value).toString();

  Future<void> setPrefPublicAddress(String value) async =>
      await UserSimplePreferences.setPubAddress(value).toString();

  Credentials initalizeWallet([String? key]) =>
      EthPrivateKey.fromHex(key ?? getPrefPrivateKey());

  generateRandomAccount() {
    final mnemonic = generateMnemonic();
    final privateKey = getPrivateKey(mnemonic);
    final publicKey = getPublicKey(privateKey.toString());
    // privAddress = privateKey;
    // pubAddress = publicKey.toString();
    // seedPhrase = mnemonic;
    setPrefPrivateKey(privateKey.toString());
    setPrefPublicAddress(publicKey.toString());
    return mnemonic;
  }
}
