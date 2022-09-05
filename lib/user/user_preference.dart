

import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences _preferences =
      SharedPreferences.getInstance() as SharedPreferences;
  static const _keyPrivAddress = "privAddress";
  static const _keyPubAddress = "pubAddress";
  static const _keydata = "data";
  
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  static Future setPrivAddress(String _privateAddress) async =>
      await _preferences.setString(_keyPrivAddress, _privateAddress);
  static String? getPrivAddress() => _preferences.getString(_keyPrivAddress);

  static Future setPubAddress(String _pubAddress) async =>
      await _preferences.setString(_keyPubAddress, _pubAddress);
  static String? getPubAddress() => _preferences.getString(_keyPubAddress);

  static Future setData(bool _true) async =>
      await _preferences.setBool(_keydata, true);
  static bool? getData() => _preferences.getBool(_keydata);
}
