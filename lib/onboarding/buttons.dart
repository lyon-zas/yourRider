// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/import_wallet.dart';
import 'package:token_integration/phrase_page.dart';
import 'package:token_integration/services/wallet_services.dart';

class BottomButtons extends StatefulWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons(
      {Key? key,
      required this.currentIndex,
      required this.dataLength,
      required this.controller})
      : super(key: key);

  @override
  State<BottomButtons> createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<BottomButtons> {
  int? selected;
  String? pubAddress;
  String? privAddress;
  String? username;
  String? seedPhrase;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.currentIndex == widget.dataLength - 1
          ? [
              Expanded(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 70.0,
                          minWidth: MediaQuery.of(context).size.width / 1.3),
                      child: TextButton(
                          style: TextButton.styleFrom(
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
                            final mnemonic = service.generateMnemonic();
                            final privateKey =
                                await service.getPrivateKey(mnemonic);
                            final publicKey =
                                await service.getPublicKey(privateKey);
                            privAddress = privateKey;
                            pubAddress = publicKey.toString();
                            seedPhrase = mnemonic;
                            final SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            await _prefs.setString("privAddress", privAddress!);
                            await _prefs.setString("pubAddress", pubAddress!);
                            await _prefs.setBool('data', true);
                            print(mnemonic);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SeedPhrasePage(
                                            seedPhrase: seedPhrase)));
                          },
                          child: const DefaultTextStyle(
                            child: Text(
                              "Create a new wallet",
                            ),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DefaultTextStyle(
                        style: const TextStyle(
                            color: Color(0xFF347AF0),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Titillium_Web',
                            fontSize: 19),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ImportWallet()));
                            },
                            child: const Text(
                              "I already have a wallet",
                            )))
                  ],
                ),
              )
            ]
          : [
              Expanded(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 70.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF347AF0), width: 2),
                          borderRadius: BorderRadius.circular(100)),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.1,
                              MediaQuery.of(context).size.height * 0.1),
                          // materialTapTargetSize:
                          //     MaterialTapTargetSize.shrinkWrap, // add this
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide.none),
                        ),

                        onPressed: () {
                          widget.controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        // color: Colors.white,

                        // height: MediaQuery.of(context).size.height * 0.1,
                        // materialTapTargetSize:
                        //     MaterialTapTargetSize.shrinkWrap, // add this
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(100),
                        //     side: BorderSide.none),
                        child: const DefaultTextStyle(
                          child: Text(
                            "Next",
                          ),
                          style: TextStyle(
                              color: Color(0xFF347AF0),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Titillium_Web',
                              fontSize: 19),
                        ),
                      ),
                    )),
              )
            ],
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// FlatButton(
//                     padding: EdgeInsets.zero,
//                     minWidth: 0.0,
//                     onPressed: () {
//                       controller.nextPage(
//                           duration: const Duration(milliseconds: 200),
//                           curve: Curves.easeInOut);
//                     },
//                     color: Colors.white,

//                     height: MediaQuery.of(context).size.height * 0.1,
//                     materialTapTargetSize:
//                         MaterialTapTargetSize.shrinkWrap, // add this
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                         side: BorderSide.none),
//                     child: const DefaultTextStyle(
//                       child: Text(
//                         "Next",
//                       ),
//                       style: TextStyle(
//                           color: Color(0xFF347AF0),
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Titillium_Web',
//                           fontSize: 19),
//                     ),
//                   // ),