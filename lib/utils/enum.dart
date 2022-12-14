import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';


String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == enumToString(v),
      orElse: () => throw NullThrownError(),
    );

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String? validator(String? e) => e == null
    ? 'Field can\'t be empty'
    : e.isEmpty
        ? 'FIELD CAN\'T BE EMPTY'
        : null;

String? urlValidator(String? e) {
  if (validator(e) == null) {
    final isUrl = e!.contains('https://') || e.contains('http://');

    if (!isUrl) {
      return 'URL SHOULD START WITH https:// or http://';
    }
    return null;
  } else {
    return validator(e);
  }
}

String formatBalance(EtherAmount? balance, [int precision = 4]) =>
    balance == null
        ? '0'
        : balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(precision);

String formatAddress(String address) =>
    address.substring(0, 4) + '...' + address.substring(38, 42);

enum ListingType {
  fixedPriceSale,
  fixedPriceNotSale,
  bidding,
}

