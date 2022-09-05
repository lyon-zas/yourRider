import 'dart:convert';

import 'package:web3dart/web3dart.dart';

class User {
  final String name;
  final EthereumAddress uAddress;

  const User({
    required this.name,
    required this.uAddress,
  });

  factory User.initEmpty(String address) => User(
        name: 'Unamed',
        uAddress: EthereumAddress.fromHex(address),
      );

  User copyWith({
    String? name,
    EthereumAddress? uAddress,
    String? metadata,
    String? image,
  }) {
    return User(
      name: name ?? this.name,
      uAddress: uAddress ?? this.uAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uAddress': uAddress.hex,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? 'Unamed',
      uAddress: EthereumAddress.fromHex(map['uAddress']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, uAddress: $uAddress, metadata: )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.name == name && other.uAddress == uAddress;
  }

  @override
  int get hashCode {
    return name.hashCode ^ uAddress.hashCode;
  }
}
