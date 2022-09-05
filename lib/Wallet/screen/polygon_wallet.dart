import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:token_integration/Wallet/screen/home.dart';
import 'package:token_integration/Wallet/screen/send_token.dart';

import '../../provider/app_provider.dart';
import '../../provider/wallet_provider.dart';
import '../../utils/enum.dart';
import '../../utils/loading_indicator.dart';

class PolygonWallet extends StatefulWidget {
  final String privKey;
  final String pubAddress;
  const PolygonWallet(
      {Key? key, required this.privKey, required this.pubAddress})
      : super(key: key);

  @override
  _PolygonWalletState createState() => _PolygonWalletState();
}

class _PolygonWalletState extends State<PolygonWallet> {
  var maticBalance = '0.000';

  // getMaticBal() async {
  //   Uri url = Uri.https(
  //     "api-eu1.tatum.io",
  //     "/v3/polygon/account/balance/${widget.pubAddress}",
  //   );

  //   Map<String, String> headers = {
  //     "content-Type": "application/json",
  //     "x-api-key": "c7d214a0-497a-490d-a272-3199ce208c0d"
  //   };

  //   http.Response response = await http.get(url, headers: headers);
  //   var results = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     maticBalance = await results['balance'];
  //     setState(() {});
  //     print(results);
  //   } else {
  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<WalletProvider>(builder: (context, provider, child) {
          if (provider.state == AppState.loading) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 13.0, left: 12),
                    child: GestureDetector(
                      // onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => Home(
                      //             // privKey: widget.privKey,
                      //             // pubAddress: widget.pubAddress,
                      //             ))),
                      child: Row(
                        children: const [Icon(Icons.arrow_back), Text("Back")],
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 30),
                  child: Text(
                    "Polygon Token",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Titillium_Web"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8247E5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 265,
                    width: 326,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 19.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jack morris",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.pubAddress.substring(0, 6) +
                                      "..." +
                                      widget.pubAddress.substring(38, 42),
                                  style: const TextStyle(
                                    letterSpacing: 2.15,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  width: 4.8,
                                ),
                                IconButton(
                                    icon: const Icon(Icons.copy_all_rounded),
                                    color: Colors.white,
                                    onPressed: () async {
                                      Clipboard.setData(ClipboardData(
                                              text:
                                                  widget.pubAddress.toString()))
                                          .then((value) {
                                        return ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Address Copied")));
                                      });
                                    })
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 49,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxHeight: 10, maxWidth: 10),
                              child: Image.asset(
                                "assets/polygon-matic-logo 1.png",
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            formatBalance(provider.balance),
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontFamily: "Titillium_Web",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 24),
                  child: Text(
                    "Your tokens",
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Titillium_Web"),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SendToken()));
                    },
                    child: Container(
                      height: 100,
                      width: 324,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3.5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("YourRider", textAlign: TextAlign.start),
                            const SizedBox(height: 12),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  "Send tokens",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Titillium_Web",
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 5.0, bottom: 1),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                    backgroundColor: Color(0xFF0015CE),
                                    radius: 15,
                                    child:
                                        Icon(Icons.send, color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: GestureDetector(
                    onTap: (() async {
                      Clipboard.setData(
                              ClipboardData(text: widget.pubAddress.toString()))
                          .then((value) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Address Copied")));
                      });
                    }),
                    child: Container(
                      height: 100,
                      width: 324,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3.5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Polygon", textAlign: TextAlign.start),
                            const SizedBox(height: 12),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: const Color(0xFF548247E5),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        maxHeight: 14, maxWidth: 14),
                                    child: Image.asset(
                                      "assets/polygon-matic-logo 1.png",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 70,
                                ),
                                const Text(
                                  "Recieve Tokens",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Titillium_Web",
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 5.0, bottom: 1),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                    backgroundColor: Color(0xFF0015CE),
                                    radius: 15,
                                    child: Icon(Icons.folder_shared_rounded,
                                        color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }));
  }
}
