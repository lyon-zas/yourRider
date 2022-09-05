import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/homepage.dart';

class SeedPhrasePage extends StatefulWidget {
  final String? seedPhrase;

  const SeedPhrasePage({Key? key, required this.seedPhrase}) : super(key: key);

  @override
  _SeedPhrasePageState createState() => _SeedPhrasePageState();
}

class _SeedPhrasePageState extends State<SeedPhrasePage> {
  late String _privKey;
  late String _pubAddress;
  getDetails() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _privKey = _prefs.getString("privAddress") ?? "";
    _pubAddress = _prefs.getString("pubAddress") ?? "";
  }

  @override
  void initState() {
    getDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF347AF0),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        actions: [
          Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: PageView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DefaultTextStyle(
                  child: Text("Your Secret Phrase"),
                  style: TextStyle(
                      color: Color.fromRGBO(13, 31, 60, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Titillium_Web',
                      fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                const DefaultTextStyle(
                  child: Text(
                    "Write down or copy these words in the right order and save them somewhere safe",
                    textAlign: TextAlign.center,
                  ),
                  style: TextStyle(
                    color: Color(0xFF3D4C63),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.seedPhrase.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () async {
                      Clipboard.setData(
                              ClipboardData(text: widget.seedPhrase.toString()))
                          .then((value) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Phrase Copied")));
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.copy),
                        Text(
                          "Copy",
                        ),
                      ],
                    )),
                const Spacer(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 100),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(221, 247, 222, 224)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Do not share your secret phrase!",
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "if someone has your secret phrase, they will have full control of your wallet.",
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 1000,
                        minWidth: MediaQuery.of(context).size.width / 1.3),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => HomePage(
                                      privKey: _privKey,
                                      pubAddress: _pubAddress,
                                    )));
                      },
                      style: TextButton.styleFrom(
                        primary: const Color(0xFF347AF0),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.1,
                          MediaQuery.of(context).size.height * 0.1,
                        ),
                        // materialTapTargetSize:
                        //     MaterialTapTargetSize.shrinkWrap, // add this
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none),
                      ),
                      child: const Text(
                        "Contnue",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
