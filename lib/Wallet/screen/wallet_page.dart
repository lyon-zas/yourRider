import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:token_integration/Wallet/screen/polygon_wallet.dart';
import 'package:token_integration/Wallet/screen/redeemToken.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:characters/characters.dart';

import '../../model/user_model.dart';
import '../../provider/app_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/wallet_provider.dart';
import '../../utils/enum.dart';
import '../../utils/loading_indicator.dart';

class WalletPage extends StatefulWidget {
  final String privKey;
  final String pubAddress;
  const WalletPage({
    Key? key,
    required this.privKey,
    required this.pubAddress,
  }) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Client httpClient;

  late Web3Client ethClient;

  //url from alchemy
  final String blockchainUrl =
      "https://polygon-mumbai.g.alchemy.com/v2/xhOSAQIFW6H_-NjxcSrpa1vJbwckXTUC";

  bool data = false;

  var maticBalance = '0.000';

  var mybalance;
  late String transHash;
  var balance;
  var name;
  var symbol;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    user = Provider.of<Auth>(context, listen: false).user;
    super.initState();
    getName();
    getSymbol();
    getBalance(widget.pubAddress);
    // getMaticBal();
  }

  late UserModel user;

  Future<DeployedContract> getContract() async {
    String abiFile = await rootBundle.loadString("assets/token.json");
    String contractAddress = "0x39da37C7dC03cB9B4ef5034A9b5602eF1660Eb67";
    final contract = DeployedContract(
        ContractAbi.fromJson(abiFile, "FirstToken"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    //
    final contract = await getContract();
    final ethFunction = contract.function(functionName);

    // This line below doesn't work.
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    // print(result.toString());
    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    // print('In getGreeting');
    List<dynamic> result = await query('balanceOf', [address]);

    print(result[0]);

    mybalance = result[0];

    balance = mybalance;

    print("balance: $balance");
    data = true;
    setState(() {});
  }

  Future<void> getName() async {
    // print('In getGreeting');
    List<dynamic> result = await query('name', []);

    print(result[0]);

    name = result[0];
    data = true;
    print(name);
    setState(() {});
  }

  Future<void> getSymbol() async {
    List<dynamic> result = await query('symbol', []);

    print(result[0]);

    symbol = result[0];
    data = true;
    setState(() {});
  }

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
  //     maticBalance = results['balance'];
  //     setState(() {});
  //     print(results);
  //   } else {
  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<WalletProvider>(builder: (context, provider, child) {
      // if (provider.state == AppState.loading) {
      //   return const LoadingIndicator();
      // }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0015CE),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 280,
              width: 326,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 19.0, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name.capitalize!,

                          // "Jack morris",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        //0x909816ee84a0f347adbe71df069b52f9256381de
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
                                          text: widget.pubAddress.toString()))
                                      .then((value) {
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text("Address Copied")));
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/indexnhjuy-removebg-preview 2.png"),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "$balance",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: "Titillium_Web",
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 54,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PolygonWallet(
                                      privKey: widget.privKey,
                                      pubAddress: widget.pubAddress,
                                    ))),
                        child: Container(
                          height: 34,
                          width: 106,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2DFED8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.5),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.currency_exchange_rounded,
                                  size: 14,
                                  color: Color(0xFF0015CE),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Convert token",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => RedeemToken(
                                      privKey: widget.privKey,
                                      pubAddress: widget.pubAddress,
                                    ))),
                        child: Container(
                          height: 34,
                          width: 108,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.5),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.card_giftcard_rounded,
                                  size: 13,
                                  color: Color(0xFF0015CE),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Redeem token",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
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
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PolygonWallet(
                            privKey: widget.privKey,
                            pubAddress: widget.pubAddress,
                          ))),
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
                      offset:
                          const Offset(0, 3.5), // changes position of shadow
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
                            width: 100,
                          ),
                          Text(
                            "${formatBalance(provider.balance)} matic",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
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
                              child: Icon(Icons.arrow_right_alt_rounded)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }));
  }
}
