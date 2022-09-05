import 'package:flutter/material.dart';
import 'package:token_integration/Wallet/screen/reciept.dart';

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  _ConfirmPasswordState createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  @override
  Widget build(BuildContext context) {
    FocusNode nodeOne = FocusNode();

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
            
            const SizedBox(
              height: 27,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Polygon token",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  SizedBox(height: 12),
                  const Text(
                    "Please enter your password to confirm order",
                    style: TextStyle( fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Material(
                    child: TextField(
                        onChanged: (text) {},
                        focusNode: nodeOne,
                        decoration: const InputDecoration(
                             border: OutlineInputBorder())),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Receipt()));
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
                            'Send Token',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
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
