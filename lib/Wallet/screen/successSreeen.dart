import 'package:flutter/material.dart';
import 'package:token_integration/Wallet/screen/home.dart';
import 'package:token_integration/Wallet/screen/wallet_page.dart';

class SuccessScreen extends StatefulWidget {
  final int amt;
  final String privKey;
  final String pubAddress;
  const SuccessScreen(
      {Key? key,
      required this.amt,
      required this.privKey,
      required this.pubAddress})
      : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 40),
            child: Text("YourRider Token",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "YOU’VE \nSUCCESSFULLY \nREDEEMED ${widget.amt} \nWORTH OF TOKEN",
              style: const TextStyle(fontSize: 32, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => Home(
              //             // privKey: widget.privKey,
              //             // pubAddress: widget.pubAddress,
              //             )));
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
                    'Back to wallet',
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
    );
  }
}
