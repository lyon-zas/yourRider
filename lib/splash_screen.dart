import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:token_integration/Wallet/homepage.dart';
import 'package:token_integration/Wallet/screen/send_token.dart';
import 'package:token_integration/onboarding/Login_screen.dart';
import 'package:token_integration/onboarding/onboarding.dart';
import 'package:token_integration/services/wallet_services.dart';
import 'dart:async';
import 'Wallet/import_wallet.dart';
import 'Wallet/screen/home.dart';
import 'animation/fade_animation.dart';
import 'animation/scale_animation.dart';
import 'provider/app_provider.dart';
import 'utils/navigation.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/Splashscreen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  late final WalletAddress _walletService;
  _navigate(Widget screen) async {
    scheduleMicrotask(() {
      Navigation.pushReplacement(context, screen: screen);
    });
  }

  double width = 100;
  double height = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AppProvider>(builder: (context, provider, child) {
        Future.delayed(const Duration(seconds: 4), () {
          if (provider.state == AppState.unauthenticated) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => LoginScreen()));
            _navigate(const LoginScreen());
            print("unauthenticated,unauthenticated,unauthenticated");
          } else if (provider.state == AppState.loaded) {
            print("loaded,loaded,loaded");
            // _navigate(const ImportWallet());
            scheduleMicrotask(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => Home()));
            });
          }
        });

        return Center(
          // alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 950),
            curve: Curves.fastOutSlowIn,
            padding: const EdgeInsets.all(
              8,
            ),

            // alignment: Alignment.center,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleAnimation(
                    duration: const Duration(milliseconds: 950),
                    child: FadeAnimation(
                      duration: const Duration(milliseconds: 950),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/spalsh.png',

                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                          // SizedBox(
                          //   width: 3,
                          // ),
                          Image.asset(
                            'assets/YourRider.png',
                            fit: BoxFit.fill,
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
