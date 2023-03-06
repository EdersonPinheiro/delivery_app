import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/order.dart';
import '../token.dart';
import '../view/payment_page.dart';

class CartController {

  Future<void> checkout(double total) async {
    try {
      final response = await Dio()
          .post('https://parseapi.back4app.com/parse/functions/checkout',
              options: Options(
                headers: {
                  'X-Parse-Application-Id':
                      'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
                  'X-Parse-REST-API-Key':
                      'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
                  'X-Parse-Session-Token': '${token}',
                  'Content-Type': 'application/json;charset=UTF-8',
                },
              ),
              data: {"total": total});
      final order = Order.toJson(response.data['result']);
      Get.to(PaymentPage(order: order));
      print(order.qrCodeImage);
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
