import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../token.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController controller = CartController();
  List<Cart> cartItems = [];

  @override
  void initState() {
    super.initState();
    getItemsCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Carrinho"),
        automaticallyImplyLeading: false,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text("Você ainda não possui itens no carrinho :("))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cart = cartItems[index];
                      return ListTile(
                        leading: SizedBox(
                          child: Image.network(
                            cart.imageUrl,
                            width: 100,
                          ),
                        ),
                        title: Text(cart.product),
                        subtitle: Text("Qtd: ${cart.quantity.toString()}"),
                        trailing: Text("R\$: ${cart.price.toString()}"),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int total = totalItemCart();
                    controller.checkout(total.toInt());
                  },
                  child: const Text("Finalizar Compra"),
                )
              ],
            ),
    );
  }

  int total = 0;
  int totalItemCart() {
    if (cartItems.isNotEmpty) {
      for (Cart cart in cartItems) {
        total += cart.price * cart.quantity;
      }
    }
    print(total);
    return total;
  }

  Future<List<Cart>> getItemsCart() async {
    var dio = Dio();
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio
        .post('https://parseapi.back4app.com/parse/functions/get-cart-items');
    if (mounted) {
      setState(() {
        cartItems = (response.data["result"] as List)
            .map((data) => Cart.fromJson(data))
            .toList();
      });
    }

    return cartItems;
  }
}
