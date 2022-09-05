// ignore_for_file: prefer_final_fields

import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_integration/Wallet/import_wallet.dart';
import 'package:get/get.dart';
import '../Wallet/screen/confirm_password.dart';
import '../Wallet/screen/create_wallet.dart';
import '../Wallet/screen/home.dart';
import '../model/user_model.dart';
import '../provider/app_provider.dart';
import '../provider/auth_provider.dart';
import '../utils/navigation.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const routeName = "/loginscreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late String _selectedCountryType = "+234", phone;
  GlobalKey<FormState> _loginFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  late String _phoneNumber, _password;
  bool _isLoading = false;
  late UserModel user;

  _showShackBar(errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage.toString(),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red[400],
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> submit(BuildContext context) async {
    print("submitttttt");
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    _loginFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('I am connected to a mobile network');
      setState(() {
        _isLoading = true;
        // errMsg = "";
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .signin(_phoneNumber, _password);
        print("doneee");
        setState(() {
          user = Provider.of<Auth>(context, listen: false).user;
        });
        if (user.blockchain_private_address == "null") {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const CreateWallet()));
        } else {
          final SharedPreferences _prefs =
              await SharedPreferences.getInstance();
          await _prefs.setString(
              "privAddress", user.blockchain_private_address);
          await _prefs.setString("pubAddress", user.blockchain_public_address);
          await _prefs.setBool('data', true);
          // print(seedPhrase);
          setState(() {
            _isLoading = false;
          });
          await Provider.of<AppProvider>(context, listen: false).initialize();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Home(
                      // privakep: user.blockchain_private_address,
                      // pubKey: user.blockchain_public_address,
                      )));
        }
      } catch (error) {
        Get.snackbar('Error', error.toString(),
            barBlur: 0,
            colorText: Colors.white,
            dismissDirection: DismissDirection.vertical,
            backgroundColor: const Color(0xff3168F4),
            overlayBlur: 0,
            animationDuration: const Duration(seconds: 2),
            duration: const Duration(seconds: 3));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // LoginAuth() {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (BuildContext context) => ImportWallet()));
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _loginFormKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 150,
              ),
              const Text(
                "Welcome back",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TitilliumWeb-Bold"),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 3,
              ),
              const Text("Please login with yourrider details",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color.fromRGBO(112, 112, 112, 1),
                    fontSize: 12,
                  )),
              const SizedBox(
                height: 60,
              ),
              Container(
                height: 54,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    CountryCodePicker(
                      initialSelection: 'NG',
                      favorite: ['+234', 'NG'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: TextFormField(
                          controller: phoneNumberController,
                          // maxLength: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone number required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phoneNumber = _selectedCountryType + value!;
                            print(_selectedCountryType + value);
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                          )),
                    )
                  ],
                ),

                // Divider()
                // child:  TextField(),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 54,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    onSaved: (val) {
                      setState(() {
                        _password = val.toString();
                      });
                      print("Completed");
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Password';
                      } else {
                        return null;
                      }
                    },
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text("Forgot Password?",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Color(0xFF0633D7),
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  submit(context);
                },
                child: Container(
                  height: 54,
                  width: 300,
                  decoration: BoxDecoration(
                      color: const Color(0xFF0633D7),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: _isLoading
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.white),
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
