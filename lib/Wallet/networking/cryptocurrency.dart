import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/networking/global.dart';

class CryptoList {
  String iconLogo;
  String cryptoCurrency;
  String cryptoQuantity;
  String cryptoBalance;
  double percent;
  String? name;
  String? address;

  CryptoList({
    required this.iconLogo,
    required this.cryptoCurrency,
    required this.cryptoQuantity,
    required this.cryptoBalance,
    required this.percent,
    this.name,
    this.address,
  });
}

late String _privKey;
late String _pubAddress;
getDetails() async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  _privKey = _prefs.getString("privAddress") ?? "";
  _pubAddress = _prefs.getString("pubAddress") ?? "";
}

final cryptoList = [
  CryptoList(
      iconLogo: 'assets/icons/polygon.png',
      cryptoCurrency: 'MATIC',
      cryptoQuantity: '0.00',
      cryptoBalance: '\$ 243.282',
      percent: 31.73,
      name: 'Polygon',
      address: "0x50338cAF974F2ec1869020e83eF48E36aCE93caf",)
];
