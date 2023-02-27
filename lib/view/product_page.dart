import 'package:delivery_app/controllers/product_controller.dart';
import 'package:delivery_app/view/configuracoes_page.dart';
import 'package:delivery_app/view/endereco_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import 'cart_page.dart';
import 'product_info_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController controller = ProductController();
  //User user;

  @override
  void initState() {
    super.initState();
    controller.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Delivery App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://source.unsplash.com/random/200x200',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Ederson",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "edersonspt@gmail.com",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            ListTile(
              title: Text('Endereços'),
              onTap: () {
                Get.to(Endereco());
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                Get.to(Configuracoes());
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                // Do something
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: controller.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final produto = controller.products[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(ProductInfoPage(produto: produto));
                  },
                  child: ListTile(
                    leading: Image.network(produto.imageUrl,
                        width: 60.0, height: 60.0),
                    title: Text(produto.title),
                    subtitle: Text('R\$: ${produto.price}'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
