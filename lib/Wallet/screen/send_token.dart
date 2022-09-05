import 'package:flutter/material.dart';
import 'package:token_integration/Wallet/screen/confirm_password.dart';
import 'package:token_integration/Wallet/screen/wallet_page.dart';

class SendToken extends StatefulWidget {
  const SendToken({Key? key}) : super(key: key);

  @override
  _SendTokenState createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  @override
  Widget build(BuildContext context) {
    FocusNode nodeOne = FocusNode();
    FocusNode nodeTwo = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 13.0, left: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                    "Polygon token",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    onTap: () {},
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
                    onTap: () {},
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
                    onTap: () {},
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 7),
                  Material(
                    child: TextField(
                        onChanged: (text) {},
                        focusNode: nodeOne,
                        decoration: const InputDecoration(
                            hintText: "Amount", border: OutlineInputBorder())),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "Enter wallet address",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 7),
                  Material(
                    child: TextField(
                        onChanged: (text) {},
                        focusNode: nodeTwo,
                        decoration: const InputDecoration(
                            hintText: "Address", border: OutlineInputBorder())),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                   WalletPage(privKey: '', pubAddress: '',)));
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
    );
  }
}
