import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/homepage.dart';
import 'package:token_integration/Wallet/screen/wallet_page.dart';

class ErrorPage extends StatefulWidget {
  final String? e;
  const ErrorPage({Key? key, required this.e}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  late String _privKey;
  late String _pubAddress;
  getDetails() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _privKey = _prefs.getString("privAddress") ?? "";
    _pubAddress = _prefs.getString("pubAddress") ?? "";
  }

  @override
  void initState() {
    getDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WalletPage(privKey: _privKey, pubAddress: _pubAddress))),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: const Text('Transaction'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
                "Your Previous transaction failed due to low gas fee kindly purchase some polgon matic to execute this transaction", textAlign: TextAlign.center,),
          )),
    );
  }
}
