import 'package:flutter/material.dart';

class Receipt extends StatefulWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
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
              height: 42,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Polygon token",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  SizedBox(height: 22),
                  Text(
                    "YOU’VE \nSUCCESSFULLY \nTRANSFERED 100 \nPOLYGON TOKEN",
                    style: TextStyle(fontSize: 32),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 63,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Receipt()));
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
      ),
    );
  }
}
