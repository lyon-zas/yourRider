import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../phrase_page.dart';
import '../../services/wallet_services.dart';
import 'home.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  bool _isloading = false;
  String? pubAddress;
  String? privAddress;
  String? username;
  String? seedPhrase;

  create() async {
    // setState(() {
    //   _isloading = true;
    // });
    WalletAddress service = WalletAddress();
    final mnemonic = service.generateMnemonic();
    final privateKey = await service.getPrivateKey(mnemonic);
    final publicKey = await service.getPublicKey(privateKey);
    privAddress = privateKey;
    pubAddress = publicKey.toString();
    seedPhrase = mnemonic;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("privAddress", privAddress!);
    await _prefs.setString("pubAddress", pubAddress!);
    await _prefs.setBool('data', true);
    print(mnemonic);
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //     leading: IconButton(
      //   icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
      //   onPressed: () => Navigator.pop(context),
      // )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You Currently Don't Have A Crypo Wallet For YourRider",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TitilliumWeb-Bold"),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 70.0,
                    minWidth: MediaQuery.of(context).size.width / 1.3),
                child: TextButton(
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      create();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF347AF0),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.1,
                        MediaQuery.of(context).size.height * 0.1,
                      ),
                      // add this
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide.none),
                    ),
                    child: DefaultTextStyle(
                      child: _isloading
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                width: 20,
                                height: 20,
                                child: const CircularProgressIndicator(
                                    backgroundColor: Colors.white),
                              ),
                            )
                          : const Text(
                              "Create a new wallet",
                            ),
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
