import 'dart:convert';
import 'package:http/http.dart' as http;

import '../token.dart';

class ProductInfoController {
  Future<void> addItemToCart(String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('https://parseapi.back4app.com/parse/functions/add-item-cart'),
      headers: <String, String>{
        'X-Parse-Application-Id': '',
        'X-Parse-REST-API-Key': '',
        'X-Parse-Session-Token': '${token}',
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'quantity': quantity,
        'productId': productId,
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
}
