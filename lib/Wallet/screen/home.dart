import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/screen/Homeie..dart';
import 'package:token_integration/Wallet/screen/custom_animated_bottom_nav.dart';
import 'package:token_integration/Wallet/screen/wallet_page.dart';
import 'package:web3dart/web3dart.dart';

import '../../provider/app_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/wallet_provider.dart';
import '../../utils/loading_indicator.dart';

class Home extends StatefulWidget {

  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final _inactiveColor = Colors.white;
  late Client httpClient;
  late Web3Client ethClient;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AppProvider>(context, listen: false).initialize();
    Provider.of<Auth>(context, listen: false).getWalletBalance();
    super.initState();
  }

  Widget callPage(
    int current,
    privKey,
    pubAddress,
  ) {
    switch (current) {
      case 0:
        return WalletPage(privKey: privKey, pubAddress: pubAddress);
      case 1:
        return Homie(
          privKey: privKey,
          pubAddress: pubAddress,
        );
      case 2:
        return Container(
          alignment: Alignment.center,
          child: const Text(
            "Profile",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        );
        break;
    }
    return IndexedStack(
      index: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<WalletProvider>(builder: (context, provider, child) {
          // if (provider.state == AppState.loading) {
          //         return const LoadingIndicator();
          //       }
          return callPage(
              _currentIndex, provider.privAddress, provider.pubAddress);
        }),
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.transparent,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(
            Icons.credit_card,
            color: _currentIndex == 0 ? Colors.white : Colors.black,
          ),
          title: const Text(
            'Wallet',
            style: TextStyle(color: Colors.white),
          ),
          activeColor: Colors.transparent,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.home,
            color: _currentIndex == 1 ? Colors.white : Colors.black,
          ),
          title: const Text(
            'Home ',
            style: TextStyle(color: Colors.white),
          ),
          activeColor: Colors.transparent,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.person,
            color: _currentIndex == 2 ? Colors.white : Colors.black,
          ),
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          activeColor: Colors.transparent,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody({
    privKey,
    pubAddress,
  }) {
    List<Widget> pages = [
      WalletPage(privKey: privKey, pubAddress: pubAddress),
      Homie(
        privKey: privKey,
        pubAddress: pubAddress,
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "Profile",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
