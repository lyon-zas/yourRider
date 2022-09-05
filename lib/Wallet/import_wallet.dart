import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/homepage.dart';
import 'package:token_integration/Wallet/screen/home.dart';
import 'package:token_integration/services/wallet_services.dart';

import '../provider/app_provider.dart';
import '../provider/auth_provider.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({Key? key}) : super(key: key);

  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  String? pubAddress;
  String? privAddress;
  String? username;
  String? seedPhrase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new_outlined),
        title: const Text("Multi-coin Wallet"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            child: TextField(
              maxLines: 5,
              scrollPadding: const EdgeInsets.all(8),
              onChanged: (text) {
                seedPhrase = text;
                print(text);
              },
              decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 500),
                  fillColor: Color.fromARGB(236, 212, 212, 212),
                  filled: true,
                  hintText: "Secret Phrase",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 158, 157, 157)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
            ),
          ),
          const Text(
            "Typically 12(sometimes 24) words seperated by single spaces",
            style: TextStyle(color: Color.fromARGB(255, 58, 57, 57)),
          ),
          Spacer(),
          ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 50.0,
                minWidth: MediaQuery.of(context).size.width / 1.2,
              ),
              child: Container(
                decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: const Color(0xFF347AF0), width: 2),
                    borderRadius: BorderRadius.circular(100)),
                child: TextButton(
                  // padding: EdgeInsets.zero,
                  // minWidth: 0.0,
                  style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: const Color(0xFF347AF0),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.1,
                              MediaQuery.of(context).size.height * 0.1),
                          // materialTapTargetSize:
                          //     MaterialTapTargetSize.shrinkWrap, // add this
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide.none),
                        ),
                  onPressed: () async {
                    WalletAddress service = WalletAddress();
                    final privateKey =
                        await service.getPrivateKey(seedPhrase.toString());
                    final publicKey = await service.getPublicKey(privateKey);
                    privAddress = privateKey;
                    pubAddress = publicKey.toString();

                    final SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    await _prefs.setString("privAddress", privAddress!);
                    await _prefs.setString("pubAddress", pubAddress!);
                    await _prefs.setBool('data', true);
                    print(seedPhrase);
                    await Provider.of<AppProvider>(context, listen: false)
                        .initialize();
                    await Provider.of<Auth>(context, listen: false)
                        .setBlochainAddresse(privAddress, pubAddress);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) => const Home()));
                  },
                  // color: const Color(0xFF347AF0),

                  // height: MediaQuery.of(context).size.height * 0.1,
                  // materialTapTargetSize:
                  //     MaterialTapTargetSize.shrinkWrap, // add this
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15),
                  //     side: BorderSide.none),
                  child: const DefaultTextStyle(
                    child: Text(
                      "Import",
                    ),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Titillium_Web',
                        fontSize: 19),
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}

// pen resemble large tongue subject cross orchard bar sample eye peanut master