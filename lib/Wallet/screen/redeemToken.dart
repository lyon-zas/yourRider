import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:token_integration/Wallet/error.dart';
import 'package:token_integration/Wallet/networking/getbal.dart';
import 'package:token_integration/Wallet/screen/confirm_password.dart';
import 'package:token_integration/Wallet/screen/home.dart';
import 'package:token_integration/Wallet/screen/successSreeen.dart';
import 'package:token_integration/Wallet/screen/wallet_page.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/user_model.dart';
import '../../provider/auth_provider.dart';

class RedeemToken extends StatefulWidget {
  final String privKey;
  final String pubAddress;
  const RedeemToken({Key? key, required this.privKey, required this.pubAddress})
      : super(key: key);

  @override
  _RedeemTokenState createState() => _RedeemTokenState();
}

class _RedeemTokenState extends State<RedeemToken> {
  late Client httpClient;
  final String blockchainUrl =
      "https://polygon-mumbai.g.alchemy.com/v2/xhOSAQIFW6H_-NjxcSrpa1vJbwckXTUC";
  late Web3Client ethClient;
  int amount = 0;
  final GlobalKey<ScaffoldState> _ScaffoldState = GlobalKey<ScaffoldState>();
  late UserModel user;
  TextEditingController amountController = TextEditingController();
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    Provider.of<Auth>(context, listen: false).getWalletBalance();
    user = Provider.of<Auth>(context, listen: false).user;
    getContractRdeem();
    getmaticBal();
  }

  Future<DeployedContract> getContractRdeem() async {
    String abiFile = await rootBundle.loadString("assets/multitransfer.json");
    String contractAddress = "0x5d6243990Ce6159De35D2A163dFD256eABAc3537";
    final contract = DeployedContract(
        ContractAbi.fromJson(abiFile, "FirstToken"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<DeployedContract> getContract() async {
    String abiFile = await rootBundle.loadString("assets/token.json");
    String contractAddress = "0x39da37C7dC03cB9B4ef5034A9b5602eF1660Eb67";
    final contract = DeployedContract(
        ContractAbi.fromJson(abiFile, "FirstToken"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<String> approve() async {
    String appadd = "0x5d6243990Ce6159De35D2A163dFD256eABAc3537";
    EthereumAddress add = EthereumAddress.fromHex(appadd);
    // var amount = BigInt.from(appAmt * 10000000000000000).toInt();
    var am = BigInt.from(amount * BigInt.from(10).pow(18).toInt());
    var response = await submit('approve', [add, am]);
    print('Transfered');
    String transHash = response;
    setState(() {});
    return response;
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
      // getBalance(widget.pubAddress);
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

    //ddj
    var succ = await ethClient.getTransactionReceipt(
        "0x28f9aa725c10709e8f50e0a1dd80083347a8d84051d3f76dc63a985e730c03e5");

    if (succ.toString() != " ") {
      print(succ);
      print("succcessfull");
      await Provider.of<Auth>(context, listen: false).creditWallet(amount);
    }

    print(result);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    snackBar(label: "verifying Exchange");
    //set a 20 seconds delay to allow the transaction to be verified before trying to retrieve the balance
    Future.delayed(const Duration(seconds: 20), () {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      snackBar(label: "retriving balance");
      // getBalance(widget.pubAddress);
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
          backgroundColor: Color(0xFF0015CE)),
    );
  }

  Future<String> exchange() async {
    String add = "0x39da37C7dC03cB9B4ef5034A9b5602eF1660Eb67";
    EthereumAddress tokenAddress = EthereumAddress.fromHex(add);
    var redeemAmt = BigInt.from(amount);
    var response = await submitRedeem("claimTicket", [tokenAddress, redeemAmt]);

    print("Exchange complete");
    setState(() {});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode nodeOne = FocusNode();
    FocusNode nodeTwo = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 13.0, left: 12),
                  child: GestureDetector(
                    // onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) => Home())),
                    child: Row(
                      children: const [Icon(Icons.arrow_back), Text("Back")],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 22.0, bottom: 18, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Rider token",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 17),
                    Text("Please enter the amount of token you want to send",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.start)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          amount = 1000;
                        });
                      },
                      child: Container(
                        height: 34,
                        width: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0015CE),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "1000",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          amount = 5000;
                        });
                      },
                      child: Container(
                        height: 34,
                        width: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0015CE),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "5000",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          amount = 10000;
                        });
                      },
                      child: Container(
                        height: 34,
                        width: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0015CE),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "10000",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 27,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Input other amount",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 7),
                    Material(
                      child: TextFormField(
                          controller: amountController,
                          onChanged: (value) {
                            amount = int.parse(value).round();
                            print('uuu');
                            print(amount);
                          },
                          validator: (value) {
                            if (amount > user.balance) {
                              return "insuffient balance";
                            }
                            return null;
                          },
                          focusNode: nodeOne,
                          decoration: const InputDecoration(
                              hintText: "Amount",
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(height: 10),
                    // const Text(
                    //   "Enter wallet Password",
                    //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    // ),
                    SizedBox(height: 7),
                    // Material(
                    //   child: TextField(
                    //       // onChanged: (text) {},
                    //       focusNode: nodeTwo,
                    //       decoration: const InputDecoration(
                    //           hintText: "Enter Password",
                    //           border: OutlineInputBorder())),
                    // ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (amount > user.balance) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "You have insuffient balance to perform this transaction"),
                                duration: Duration(milliseconds: 600),
                                backgroundColor: Color(0xFF0015CE)),
                          );

                          print("insuffient balance");
                        } else {
                          approve().then((value) => exchange().then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SuccessScreen(
                                            amt: amount,
                                            privKey: widget.privKey,
                                            pubAddress: widget.pubAddress,
                                          )))));
                        }
                      },
                      child: Center(
                        child: Container(
                          width: 345,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFF0015CE),
                          ),
                          child: const Center(
                            child: Text(
                              'Continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
