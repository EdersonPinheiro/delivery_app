import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/order.dart';

class PaymentPage extends StatefulWidget {
  final Order order;

  PaymentPage({required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _chavePix = "";

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
              base64Decode(widget.order.qrCodeImage.substring(22)),
            ),
          ),
          Text('Total: R\$ ${widget.order.total}'),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('${widget.order.copiaecola}'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _copyToClipboard('${widget.order.copiaecola}');
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
