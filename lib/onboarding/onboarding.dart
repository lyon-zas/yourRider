import 'package:flutter/material.dart';
import 'package:token_integration/onboarding/buttons.dart';
import 'package:token_integration/onboarding/explanation.dart';

final List<ExplanationData> data = [
  ExplanationData(
      description: "Manage all your crypto assets! It’s simple and easy!",
      title: "Welcome to Whollet",
      localImageSrc: "assets/desktop.svg",
      backgroundColor: Color(0xFF0EDF1F9)),
  ExplanationData(
      description: "Keep BTC, ETH, XRP, and many other ERC-20 based tokens.",
      title: "Nice and Tidy Crypto Portfolio!",
      localImageSrc: "assets/idea.svg",
      backgroundColor: const Color(0xFF0EDF1F9)),
  ExplanationData(
      description:
          "Send crypto to your friends with a personal message attached. ",
      title: "Receive and Send Money to Friends!",
      localImageSrc: "assets/mobile.svg",
      backgroundColor: const Color(0xFF0EDF1F9)),
  ExplanationData(
      description:
          "Our top-notch security features will keep you completely safe.",
      title: "Your Safety is Our Top Priority",
      localImageSrc: "assets/social.svg",
      backgroundColor: const Color(0xFF0EDF1F9)),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> /*with ChangeNotifier*/ {
  final _controller = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: data[_currentIndex].backgroundColor,
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(16),
          color: data[_currentIndex].backgroundColor,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                  right: 1,
                  child: TextButton(
                      onPressed: () {
                        _currentIndex == -1;
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                            color: Color(0xFF347AF0),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Titillium_Web',
                            fontSize: 19),
                      ))),
              Column(children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _controller,
                                  onPageChanged: (value) {
                                    // _painter.changeIndex(value);
                                    setState(() {
                                      _currentIndex = value;
                                    });
                                    // notifyListeners();
                                  },
                                  children: data
                                      .map((e) => ExplanationPage(data: e))
                                      .toList())),
                          flex: 3),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(data.length,
                                        (index) => createCircle(index: index)),
                                  )),
                              BottomButtons(
                                currentIndex: _currentIndex,
                                dataLength: data.length,
                                controller: _controller,
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ]),
            ],
          ),
        )));
  }

  createCircle({required int index}) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(right: 4),
        height: 5,
        width: _currentIndex == index ? 6 : 5,
        decoration: BoxDecoration(
            color: _currentIndex == index
                ? const Color(0xFF347AF0)
                : Color.fromARGB(238, 145, 173, 231),
            borderRadius: BorderRadius.circular(4)));
  }

  // skip({required int index}) {
  //   return Positioned(
  //       right: 1,
  //       child: FlatButton(
  //           minWidth: 0.0,
  //           onPressed: () {

  //           },
  //           child: Text(
  //             _currentIndex == index ? "Skip" : '',
  //             style: const TextStyle(
  //                 color: Color(0xFF347AF0),
  //                 fontWeight: FontWeight.w700,
  //                 fontFamily: 'Titillium_Web',
  //                 fontSize: 19),
  //           )));
  // }
}
