import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../token.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Meus Pedidos"),
        automaticallyImplyLeading: false,
      ),
      body: ordersItems.isEmpty
          ? Center(child: Text("Você ainda não fez nenhum pedido."))
          : ListView.builder(
              itemCount: ordersItems.length,
              itemBuilder: (context, index) {
                final order = ordersItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${order.id}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Status: ${order.status.obs}',
                          style: TextStyle(
                            fontSize: 18,
                            
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Data: ${DateFormat('dd/MM/yyyy hh:mm').format(order.createdAt!)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total: R\$ ${order.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Order> ordersItems = [];

  void getOrders() async {
    var dio = Dio();
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio
        .post('https://parseapi.back4app.com/parse/functions/get-orders');
    if (response.data["result"] != null) {
      setState(() {
        ordersItems = (response.data["result"] as List)
            .map((data) => Order.fromJson(data))
            .toList();
      });
    }
  }
}
