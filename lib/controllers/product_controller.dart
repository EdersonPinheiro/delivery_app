import 'package:dio/dio.dart';
import '../models/product.dart';
import '../token.dart';

class ProductController {
  late List<Product> products = [];
  final Dio dio = Dio();
  bool isLoading = true;

  Future<List<Product>> getProducts() async {
    dio.options.headers = {
      'X-Parse-Application-Id': '',
      'X-Parse-REST-API-Key': '',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio
        .post('https://parseapi.back4app.com/parse/functions/get-all-products');

    if (response.data["result"] != null) {
      products = (response.data["result"] as List)
          .map((data) => Product.fromJson(data))
          .toList();
      //return products;
    }

    return [];
  }
}
