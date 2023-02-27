import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_info_controller.dart';
import '../models/product.dart';

class ProductInfoPage extends StatefulWidget {
  final Product produto;

  const ProductInfoPage({required this.produto});

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  final ProductInfoController _controller = Get.put(ProductInfoController());
  int _quantity = 1;

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.produto.title),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Image.network(widget.produto.imageUrl),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  '${widget.produto.description}',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'R\$: ${widget.produto.price}',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _decrementQuantity();
                  });
                },
              ),
              Text('$_quantity'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _incrementQuantity();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Adicionar ao Carrinho'),
            onPressed: () {
              _controller.addItemToCart(widget.produto.id, _quantity);
              Get.snackbar(
                "",
                "",
                titleText: const Text(
                  "Item adicionado ao carrinho",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.deepOrange,
              );
            },
          ),
        ],
      ),
    );
  }
}
