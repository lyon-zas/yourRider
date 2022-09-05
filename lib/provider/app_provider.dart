import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/import_wallet.dart';
import 'package:token_integration/onboarding/Login_screen.dart';

import '../model/collection.dart';
import '../model/gql_query.dart';
import '../model/user.dart';
import '../services/graphql_service.dart';
import '../services/wallet_services.dart';
import '../utils/navigation.dart';
import 'user_provider.dart';
import 'wallet_provider.dart';

enum AppState { empty, loading, loaded, success, error, unauthenticated }

class AppProvider with ChangeNotifier {
  final WalletAddress _walletService;
  final WalletProvider _walletProvider;

  final UserProvider _userProvider;
  final GraphqlService _graphql;

  AppProvider(
    this._walletService,
    this._walletProvider,
    this._graphql,
    this._userProvider,
  );

  //APP PROVIDER VAR
  AppState state = AppState.empty;
  String errMessage = '';

  //HOME PAGE
  List<Collection> topCollections = [];
  // List<NFT> featuredNFTs = [];

  //CREATOR PAGE
  List<Collection> userCreatedCollections = [];
  // List<NFT> userCollected = [];

  // List<

  //METHODS

  initialize() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final privateKey = _prefs.getString('pubAddress') ?? '';
    print("privkey" + privateKey);
    if (privateKey.isEmpty) {
      _handleUnauthenticated();
    } else {
      //FIRST - INITIALIZE WALLET
      await _walletProvider.initializeWallet();

      //FETCH USER PAGES DATA
      _userProvider.fetchUserInfo();

      _handleLoaded();
    }
  }

  logOut(BuildContext context) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("privAddress", "");
    _handleUnauthenticated();

    scheduleMicrotask(() {
      Navigation.popAllAndPush(
        context,
        screen: const ImportWallet(),
      );
    });
  }

  void _handleEmpty() {
    state = AppState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = AppState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = AppState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleUnauthenticated() {
    state = AppState.unauthenticated;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = AppState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = AppState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
