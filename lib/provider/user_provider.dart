import 'package:flutter/foundation.dart';

import '../model/gql_query.dart';
import '../model/user.dart';
import '../services/graphql_service.dart';
import 'wallet_provider.dart';

enum UserState { empty, loading, loaded, success, error }

class UserProvider with ChangeNotifier {
  final GraphqlService _graphql;
  final WalletProvider _walletProvider;

  UserProvider(this._graphql, this._walletProvider);

  UserState state = UserState.empty;
  String errMessage = '';

  ///VARAIBLES
  late User user;

  fetchUserInfo() async {
    try {
      user = User.initEmpty(_walletProvider.address.hex);

      _handleLoading();

      final data = await _graphql
          .get(qCreator, {'uAddress': _walletProvider.address.hex});

      if (data['users'].isEmpty) {
        user = User(
          name: 'Unamed',
          uAddress: _walletProvider.address,
          // metadata: '',
          // image: 'QmWTq1mVjiBp6kPXeT2XZftvsWQ6nZwSBvTbqKLumipMwD',
        );
      } else {
        user = User.fromMap(data['users'][0]);
      }

      _handleLoaded();
    } catch (e) {
      debugPrint('Error at User Provider -> fetchUserInfo: $e');

      _handleError(e);
    }
  }

  void _handleEmpty() {
    state = UserState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = UserState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = UserState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = UserState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = UserState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
