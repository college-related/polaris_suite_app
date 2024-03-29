import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:polaris_suite_app/models/token_model.dart';
import 'package:polaris_suite_app/models/user_model.dart';
import 'package:polaris_suite_app/resources/colors/colors.dart';
import 'package:polaris_suite_app/utils/routes/routes_name.dart';
import 'package:polaris_suite_app/utils/utils.dart';
import 'package:polaris_suite_app/view_model/email_view_model.dart';
import 'package:polaris_suite_app/view_model/token_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polaris_suite_app/view_model/userid_view_model.dart';

class AuthProvider with ChangeNotifier {
  //for url
  String? baseUrl = dotenv.env['Local_Host'];
  // String? baseUrl = 'https://polaris-suite-server.onrender.com';

  //for loading
  bool _isloading = false;
  bool get isloading => _isloading;

  void setLoading(bool val) {
    _isloading = val;
    notifyListeners();
  }

  //for storing token
  SharedPreferencesToken sharedPreferencesToken = SharedPreferencesToken();
  SharedPreferencesUserId sharedPreferencesUserId = SharedPreferencesUserId();
  SharedPreferencesUserEmail sharedPreferencesUserEmail = SharedPreferencesUserEmail();
  //Register
  void register(String email, String name, String password, BuildContext context) async {
    setLoading(true);
    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'name': name,
        }),
      );
      if (resp.statusCode == 201) {
        //
        setLoading(false);
        // ignore: use_build_context_synchronously
        Utils.flushbarErrorMessage(
          context,
          'Account Created Successfully',
          AppColors.success,
        );
      } else {
        print(resp.statusCode.toString());
        //
        setLoading(false);
        // ignore: use_build_context_synchronously
        Utils.flushbarErrorMessage(
            context, 'User has already been created!', AppColors.neutralGray);
      }
    } catch (e) {
      setLoading(false);
      //
      print('object');
      //
      Utils.flushbarErrorMessage(context, e.toString(), AppColors.secondaryColor);
    }
  }

  //login
  void login(String email, String password, BuildContext context) async {
    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        setLoading(false);
        // print(response.body);
        final decodedResp = jsonDecode(response.body.toString());
        print(decodedResp.toString());
        UserModel userModel = UserModel.fromJson(decodedResp);
        print('===================>');
        print(jsonEncode(userModel.user!.email.toString()));
        print(jsonEncode(userModel.toString()));
        /////////////////////////////////
        TokenModel tokenModel = TokenModel.fromJson(decodedResp);
        print('========================>');
        print(jsonEncode(tokenModel.token!.access!.token.toString()));
        // Navigator.pushNamed(context, RoutesName.bottomNavBar);

        print('============================>');
        print(tokenModel.toJson());

        print('=========================>>>>>>>>>>');
        print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHH');

        sharedPreferencesUserEmail.saveUser(UserModel.fromJson(decodedResp));
        sharedPreferencesUserId.saveUser(UserModel.fromJson(decodedResp));

        sharedPreferencesToken
            .saveUser(
          TokenModel.fromJson(decodedResp),
        )
            .then((value) {
          print('SUCCESS');
          Navigator.pushNamed(context, RoutesName.bottomNavBar);
        }).onError((error, stackTrace) {
          setLoading(false);
          print('error');
        });

        //
      } else {
        print(response.statusCode);
        setLoading(false);
        // ignore: use_build_context_synchronously
        Utils.flushbarErrorMessage(
            context, 'Email or Password invalid', AppColors.secondaryColor);
      }
    } catch (e) {
      setLoading(false);
      // print('========================================>');
      Utils.flushbarErrorMessage(context, e.toString(), AppColors.secondaryColor);
    }
  }

  //reset password
  void resetPassword(String? email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgotpassword'),
      );
    } catch (e) {}
  }
}
