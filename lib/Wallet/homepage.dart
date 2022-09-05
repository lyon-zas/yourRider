import 'dart:convert';

import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/error.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  final String privKey;
  final String pubAddress;
  const HomePage({
    Key? key,
    required this.privKey,
    required this.pubAddress,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Client httpClient;

  late Web3Client ethClient;

  //Polygon address
  // final String myAddress = "0x4818569AA9dE13d3cC1D702Cd10a95932799a674";

  //url from alchemy
  final String blockchainUrl =
      "https://polygon-mumbai.g.alchemy.com/v2/xhOSAQIFW6H_-NjxcSrpa1vJbwckXTUC";

  bool data = false;
  int myAmount = 0;
  int amt = 0;
  int appAmt = 0;
  int riderGas = 0;
  var addressTo = "";
  var riderBalance = 0;
  var maticBalance = '';
  var dec = pow(10, 18);
  var mydata;
  var mybalance;
  late String transHash;
  var balance;
  var name;
  var symbol;
  final GlobalKey<ScaffoldState> _ScaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);

    super.initState();
    getName();
    getSymbol();
    getContractRdeem();
    getBalance(widget.pubAddress);
    getMaticBal();
  }

  Future<DeployedContract> getContract() async {
    String abiFile = await rootBundle.loadString("assets/token.json");
    String contractAddress = "0x50338cAF974F2ec1869020e83eF48E36aCE93caf";
    final contract = DeployedContract(
        ContractAbi.fromJson(abiFile, "FirstToken"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<DeployedContract> getContractRdeem() async {
    String abiFile = await rootBundle.loadString("assets/multitransfer.json");
    String contractAddress = "0x5d6243990Ce6159De35D2A163dFD256eABAc3537";
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
    var div = BigInt.from(dec);
    balance = BigInt.from(mybalance / div);

    print("balance: $balance");
    // print("sis ${balance.toInt() / 18 }");
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

  Future<String> submit(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    final ethFunction = contract.function(functionName);
    snackBar(label: "Recording tranction");
    EthPrivateKey key = EthPrivateKey.fromHex(widget.privKey);
    Transaction transaction = await Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        maxGas: 100000);
    print(transaction.nonce);
    final result = await ethClient
        .sendTransaction(key, transaction,
            fetchChainIdFromNetworkId: true, chainId: null)
        .catchError((Object e, StackTrace stackTrace) async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ErrorPage(
                    e: e.toString(),
                  )));
    });
    print(result);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    snackBar(label: "verifying transaction");
    //set a 20 seconds delay to allow the transaction to be verified before trying to retrieve the balance
    Future.delayed(const Duration(seconds: 20), () {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      snackBar(label: "retriving balance");
      getBalance(widget.pubAddress);
      ScaffoldMessenger.of(context).clearSnackBars();
    });
    return result;
  }

  Future<String> submitRedeem(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContractRdeem();
    final ethFunction = contract.function(functionName);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    snackBar(label: "Recording Exchange");
    EthPrivateKey key = EthPrivateKey.fromHex(widget.privKey);
    Transaction transaction = await Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        maxGas: 100000);
    print(transaction.nonce);
    final result = await ethClient
        .sendTransaction(key, transaction,
            fetchChainIdFromNetworkId: true, chainId: null)
        .catchError((Object e, StackTrace stackTrace) async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ErrorPage(
                    e: e.toString(),
                  )));
    });
    print(result);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    snackBar(label: "verifying Exchange");
    //set a 20 seconds delay to allow the transaction to be verified before trying to retrieve the balance
    Future.delayed(const Duration(seconds: 20), () {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      snackBar(label: "retriving balance");
      getBalance(widget.pubAddress);
      ScaffoldMessenger.of(context).clearSnackBars();
    });
    return result;
  }

  snackBar({String? label}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label!),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
        duration: const Duration(days: 1),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<String> reciveCoin() async {
    EthereumAddress addressTo = EthereumAddress.fromHex(widget.pubAddress);
    var bigAmount = BigInt.from(myAmount);
    var response = await submit('mint', [addressTo, bigAmount]);

    print('Recieved');
    transHash = response;
    setState(() {});
    return response;
  }

  Future<String> transferCoin() async {
    var amount = BigInt.from(amt * 10000000000000000).toInt();
    var am = BigInt.from(amount * 100);
    EthereumAddress to = EthereumAddress.fromHex(addressTo);
    print("amo: $am");
    var response = await submit('transfer', [to, am]);
    print('Transfered');
    transHash = response;
    setState(() {});
    return "response";
  }

  Future<String> approve() async {
    String appadd = "0x5d6243990Ce6159De35D2A163dFD256eABAc3537";
    EthereumAddress add = EthereumAddress.fromHex(appadd);
    var amount = BigInt.from(appAmt * 10000000000000000).toInt();
    var am = BigInt.from(amount * 100);
    var response = await submit('approve', [add, am]);
    print('Transfered');
    transHash = response;
    setState(() {});
    return response;
  }

  Future<String> exchange() async {
    String add = "0x50338cAF974F2ec1869020e83eF48E36aCE93caf";
    EthereumAddress tokenAddress = EthereumAddress.fromHex(add);
    var redeemAmt = BigInt.from(appAmt);
    var response = await submitRedeem("claimTicket", [tokenAddress, redeemAmt]);
    print("Exchange complete");
    transHash = response;
    setState(() {});
    return response;
  }

  setGasRiderBalance() {
    riderBalance = riderGas + appAmt;
    print(balance);
    return balance;
  }

  getMaticBal() async {
    Uri url = Uri.https(
      "api-eu1.tatum.io",
      "/v3/polygon/account/balance/${widget.pubAddress}",
    );

    Map<String, String> headers = {
      "content-Type": "application/json",
      "x-api-key": "c7d214a0-497a-490d-a272-3199ce208c0d"
    };

    http.Response response = await http.get(url, headers: headers);
    var results = jsonDecode(response.body);
    if (response.statusCode == 200) {
      maticBalance = results['balance'];
      print(results);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode nodeOne = FocusNode();
    FocusNode nodeTwo = FocusNode();
    return Scaffold(
      key: _ScaffoldState,
      body: Stack(children: [
        Positioned(
          left: 0.0,
          right: 0.0,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: data
                      ? Text(
                          ' $balance $symbol / $riderBalance Rider Gas',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 25),
                        )
                      : const CircularProgressIndicator(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.pubAddress),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          child: IconButton(
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: const Text("Send"),
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Material(
                                              child: TextField(
                                                  onChanged: (text) {
                                                    addressTo = text;
                                                    print(addressTo);
                                                  },
                                                  focusNode: nodeOne,
                                                  decoration: const InputDecoration(
                                                      hintText: "Address",
                                                      prefixIcon: Icon(Icons
                                                          .account_balance_wallet_outlined),
                                                      border:
                                                          OutlineInputBorder())),
                                            ),
                                            Material(
                                              child: TextField(
                                                  onChanged: (value) {
                                                    amt = int.parse(value)
                                                        .round();

                                                    print('uuu');
                                                    print(amt);
                                                    setState(() {});
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  focusNode: nodeTwo,
                                                  decoration: const InputDecoration(
                                                      hintText: "Amount",
                                                      prefixIcon: Icon(Icons
                                                          .currency_bitcoin_outlined),
                                                      border:
                                                          OutlineInputBorder())),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                              child: TextButton(
                                            child: const Text(
                                              "Send",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.redAccent,
                                              // hoverColor: Colors.white,
                                              elevation: 5,
                                            ),
                                            onPressed: () {
                                              transferCoin().catchError(
                                                  (Object e,
                                                      StackTrace stackTrace) {
                                                print(e.toString());
                                              });
                                              Navigator.pop(context);
                                            },
                                          ))
                                        ],
                                      )),
                              icon: const Icon(Icons.arrow_upward_outlined)),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        const Text("send")
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          child: IconButton(
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: const Text("Recieve"),
                                        content: Material(
                                          child: TextField(
                                              onChanged: (value) {
                                                myAmount =
                                                    int.parse(value).round();
                                                print('uuu');
                                                print(myAmount);
                                              },
                                              focusNode: nodeOne,
                                              decoration: const InputDecoration(
                                                  hintText: "Amount",
                                                  border:
                                                      OutlineInputBorder())),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                              child: TextButton(
                                            child: const Text(
                                              "recieve",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.green,
                                              // hoverColor: Colors.white,
                                              elevation: 5,
                                            ),
                                            onPressed: () {
                                              reciveCoin();
                                              print("ykb ${e.toString()}");
                                              Navigator.pop(context);
                                            },
                                          ))
                                        ],
                                      )),
                              icon: const Icon(Icons.arrow_downward_outlined)),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        const Text("recieve")
                      ],
                    )
                  ],
                )
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 160, 152, 253),
                  blurRadius: 4,
                  offset: Offset(4, 8), // Shadow position
                ),
              ],
            ),
            height: 200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 230.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "$name",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "$balance $symbol",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Polygon",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "$maticBalance MATIC",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 1,
              ),
              Material(
                child: TextField(
                    onChanged: (value) {
                      appAmt = int.parse(value).round();
                      print('value');
                      print(appAmt);
                    },
                    focusNode: nodeOne,
                    decoration: const InputDecoration(
                        hintText: "Amount", border: OutlineInputBorder())),
              ),
              SizedBox(height: 10),
              TextButton.icon(
                  onPressed: () async {
                    getMaticBal();
                    // approve().then((value) => exchange()
                    //     .then((value) => setGasRiderBalance())
                    //     .then((value) => setState(() {})));
                  },
                  icon: const Icon(Icons.currency_exchange_rounded),
                  label: const Text('Redeem Rider Gas Token for Rider Gas'))
            ]),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => getBalance(widget.pubAddress)),
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
