import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:token_integration/Wallet/screen/home.dart';
import 'package:token_integration/Wallet/screen/reciept.dart';
import 'package:token_integration/Wallet/screen/wallet_page.dart';

import '../../model/user_model.dart';
import '../../provider/auth_provider.dart';

class Homie extends StatefulWidget {
  final String privKey;
  final String pubAddress;
  const Homie({Key? key, required this.pubAddress, required this.privKey})
      : super(key: key);

  @override
  _HomieState createState() => _HomieState();
}

class _HomieState extends State<Homie> {
  late UserModel user;
  void initState() {
    Provider.of<Auth>(context, listen: false).getWalletBalance();
    user = Provider.of<Auth>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode nodeOne = FocusNode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Padding(
            //     padding: const EdgeInsets.only(top: 13.0, left: 12),
            //     child: GestureDetector(
            //       onTap: () => Navigator.pop(context),
            //       child: Row(
            //         children: const [Icon(Icons.arrow_back), Text("Back")],
            //       ),
            //     )),
            const SizedBox(
              height: 17,
            ),
            const Text(
              "Riders gas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
                child: Container(
                  height: 126,
                  width: MediaQuery.of(context).size.width / 2.5,
                  // child: Image.asset("assets/Frame 7 (1)-1.png"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("assets/Frame 7 (1)-1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.balance.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )),
            Button(
              name: "View Balance",
              onTap: () {
                Provider.of<Auth>(context, listen: false).getWalletBalance();
                print(user.balance);
              },
            ),

            //sencond
            //
            SizedBox(
              height: 50,
            ),

            const Text(
              "Riders Token",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
              child: Container(
                height: 126,
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Jack morris",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Center(
                        child: Text(
                      widget.pubAddress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("assets/Frame 7 (1)-1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Button(
            //   name: "View Balance",
            //   onTap: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (BuildContext context) => Home(
            //               // privKey: widget.privKey,
            //               // pubAddress: widget.pubAddress,
            //               ))),
            // ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final name;
  final onTap;
  const Button({Key? key, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 141,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF0015CE),
          ),
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
