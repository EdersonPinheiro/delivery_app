import 'dart:convert';

import 'package:delivery_app/view/endereco_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/address.dart';
import '../token.dart';

class AddressController {
  TextEditingController textCep = TextEditingController();
  TextEditingController ruaAv = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController bairro = TextEditingController();
  TextEditingController complemento = TextEditingController();
  TextEditingController ruaAvB = TextEditingController();

  Future<void> addAddress(
      String logradouro, String bairro, String numero) async {
    final response = await http.post(
      Uri.parse(
          'https://parseapi.back4app.com/parse/functions/create-endereco'),
      headers: <String, String>{
        'X-Parse-Application-Id': '',
        'X-Parse-REST-API-Key': '',
        'X-Parse-Session-Token': '${token}',
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'logradouro': logradouro,
        'bairro': bairro,
        'numero': numero,
        'cidade': 'Maringá',
        'uf': 'PR'
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print(responseJson);
    } else {
      throw Exception(
          'Error: ${response.statusCode}. Failed to add item to cart.');
    }
  }

  late List<Address> address = [];
  final Dio dio = Dio();
  bool isLoading = true;

  Future<List<Address>> getAddress() async {
    dio.options.headers = {
      'X-Parse-Application-Id': '',
      'X-Parse-REST-API-Key': '',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio
        .post('https://parseapi.back4app.com/parse/functions/get-endereco');

    if (response.data["result"] != null) {
      address = (response.data["result"] as List)
          .map((data) => Address.fromJson(data))
          .toList();
      //return products;
    }

    return [];
  }
}
