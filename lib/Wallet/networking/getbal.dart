import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:token_integration/Wallet/networking/cryptocurrency.dart';

Future getBal() async {
  getmaticBal();

  return '';
}

getmaticBal() async {
  Uri url = Uri.http(
    "api-eu1.tatum.io", //https://pro-api.coinmarketcap.com
    "/v3/polygon/account/balance/${cryptoList[0].address}",
  );

  http.Response response = await http.get(url);
  var results = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print(results);
    // store.write('maticbal', results['balance']);
  } else {
    print(response.statusCode);
    print(response.body);
  }
}
