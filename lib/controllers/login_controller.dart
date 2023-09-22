import 'dart:convert';
import 'package:delivery_app/main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../token.dart';

class LoginController {
  User? user;

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://parseapi.back4app.com/parse/functions/login'),
      headers: <String, String>{
        'X-Parse-Application-Id': '',
        'X-Parse-REST-API-Key': '',
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if (responseJson['result'] != null) {
        token = await responseJson['result']['token'];
        if (token != null) {
          print(responseJson);
          User.fromJson(responseJson);
          Get.to(HomePage());
        } else {
          print("Falha na validação dos dados de login");
        }
      } else {
        print("Falha na validação dos dados de login");
      }
    } else {
      throw Exception('Error: ${response.statusCode}. Failed to login');
    }
  }
}
