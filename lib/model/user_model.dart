// ignore_for_file: non_constant_identifier_names

class UserModel {
  String id,
      name,
      email,
      username,
      photo_url,
      address,
      phone,
      token,
      code,
      access_token,
      device_token,
      blockchain_private_address,
      blockchain_public_address;
  String role_id;
  int balance;
  UserModel(
      {required this.id,
      required this.photo_url,
      required this.address,
      required this.code,
      required this.email,
      required this.access_token,
      required this.device_token,
      required this.phone,
      required this.token,
      required this.role_id,
      required this.name,
      required this.username,
      required this.balance,
      required this.blockchain_private_address,
      required this.blockchain_public_address});
}
