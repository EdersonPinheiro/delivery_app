import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/order.dart';

class PaymentPage extends StatelessWidget {
  String _chavePix = "";
  final Order order;

  PaymentPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pagamento'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Image.memory(
              base64Decode(order.qrCodeImage.substring(22)),
            ),
          ),
          Text('Total: R\$ ${order.total}'),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('${order.copiaecola}'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _copyToClipboard('${order.copiaecola}');
              Get.snackbar('Chave Pix copiada!', "",
                  backgroundColor: Colors.white);
            },
            child: Text("Copiar Chave Pix"),
          ),
        ],
      ),
    );
  }
}

void _copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
