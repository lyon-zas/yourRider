import 'dart:convert';
import 'dart:io';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:token_integration/config.dart' as config;

import '../Wallet/import_wallet.dart';
import '../model/user_model.dart';

class Auth with ChangeNotifier {
  late String _token;
  late String _accessTokenType;

  UserModel user = UserModel(
      token: '',
      username: '',
      access_token: '',
      address: '',
      blockchain_private_address: '',
      blockchain_public_address: '',
      code: '',
      device_token: '',
      email: '',
      id: '',
      name: '',
      phone: '',
      photo_url: '',
      role_id: '',
      balance: 0);

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != "") {
      return _token;
    }
    return null;
  }

  String? get accessTokenType {
    if (_accessTokenType != "") {
      return _accessTokenType;
    }
    return null;
  }

  Future<void> signin(
    _phoneNumber,
    _password,
  ) async {
    var data =
        jsonEncode({"id": _phoneNumber, "password": _password, "role": 4});
    print(data);
    try {
      final response = await http.post(
        Uri.parse("https://api.yourrider.com/api/login"),
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["status"] == true) {
        print("okkkk");
        print(resData["access_token"]);
        // throw HttpException(resData["message"]);
      }
      if (resData["access_token"] != " ") {
        _token = resData["access_token"];
        // print(resData["user"]["name"]);
        print("testing");
        UserModel userdata = UserModel(
            token: '',
            username: '',
            access_token: '',
            address: '',
            blockchain_private_address: '',
            blockchain_public_address: '',
            code: '',
            device_token: '',
            email: '',
            id: '',
            name: '',
            phone: '',
            photo_url: '',
            role_id: '',
            balance: 0);
        userdata.id = resData["user"]["id"].toString();
        print(resData["user"]["name"]);
        userdata.name = resData["user"]["name"].toString();
        userdata.phone = resData["photo_url"].toString();
        userdata.email = resData["user"]["email"].toString();
        userdata.role_id = resData["user"]["role_id"].toString();

        userdata.address = resData["user"]["address"].toString();
        userdata.blockchain_private_address =
            resData["user"]["blockchain_private_address"].toString();
        userdata.blockchain_public_address =
            resData["user"]["blockchain_public_address"].toString();

        user = userdata;
      }
      print("here is $token");

      if (resData["faild"] == false) {
        // print("failed");
        throw const HttpException("failed");
      } else {
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': token,
          'id': user.id,
          'fullName': user.name,
          "blockchain_private_address": user.blockchain_private_address,
          'email': user.email,
          'userId': user.id,

          // 'balance': user.balance,
        });
        print("whatttt");
        if (resData["user"]["blockchain_private_address"].toString() !=
            "null") {
          await prefs.setString("privAddress",
              resData["user"]["blockchain_private_address"].toString());
          await prefs.setString("pubAddress",
              resData["user"]["blockchain_public_address"].toString());
          print("set keys");
        }
        prefs.setString("userData", userData);
      }

      notifyListeners();
    } catch (error) {
      return;
    }
  }

  Future<void> setBlochainAddresse(
    _privAdd,
    _pubAdd,
  ) async {
    var data = jsonEncode({
      "blockchain_private_address": _privAdd,
      "blockchain_public_address": _pubAdd,
    });
    print(data);
    try {
      final response = await http.post(
        Uri.parse("https://api.yourrider.com/api/users/blockchain/address"),
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["status"] == true) {
        print("okkkk");
        print(resData["message"]);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getWalletBalance() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.yourrider.com/api/public/transactions/balance"),
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["message"] == "Balance retrieved") {
        print(resData["message"]);
        user.balance = resData["data"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("riderbalance", resData["data"].toString());
      }

      notifyListeners();
    } catch (error) {
      return;
    }
  }

  Future<void> creditWallet(
    amount,
  ) async {
    var data = jsonEncode({
      "userId": user.id,
      "service": "crypto_pay",
      "amount": amount,
    });
    print(data);
    try {
      final response = await http.post(
        Uri.parse("https://api.yourrider.com/api/wallet/credit"),
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["status"] == true) {
        print("okkkk");
        print(resData["message"]);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}


// https://api.yourrider.com/api/users/blockchain/address' \