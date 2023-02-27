import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../controllers/address_controller.dart';

class CreateAddressPage extends StatefulWidget {
  const CreateAddressPage({super.key});

  @override
  State<CreateAddressPage> createState() => _CreateAddressPageState();
}

class _CreateAddressPageState extends State<CreateAddressPage> {
  AddressController controller = AddressController();

  buscaEndereco(String cep) async {
    String url = 'https://viacep.com.br/ws/${cep}/json/';

    http.Response response;
    response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = json.decode(response.body);
    setState(() {
      controller.ruaAv.text = retorno['logradouro'];
      controller.bairro.text = retorno['bairro'];
    });
    print(response.body);
  }

  buscaCep() async {
    String ruaAv = controller.ruaAvB.text;
    ruaAv.replaceAll(" ", "+");
    String url = 'https://viacep.com.br/ws/PR/Maringa/${ruaAv}/json/';

    http.Response response;
    response = await http.get(Uri.parse(url));

    List<dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse.isEmpty) {
      // tratamento para lista vazia
    } else {
      Map<String, dynamic> myMap = {
        'cep': jsonResponse[0]['cep'],
        'logradouro': jsonResponse[0]['logradouro'],
        'bairro': jsonResponse[0]['bairro']
      };

      List<dynamic> myList = myMap.values.toList();
      String cep = myMap['cep'];
      setState(() {
        controller.textCep.text = cep.replaceAll("-", "");
        buscaEndereco(controller.textCep.text);
      });
    }
  }

  void modalBuscaCep() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Buscar CEP'),
          content: TextFormField(
            controller: controller.ruaAvB,
            decoration: const InputDecoration(
              labelText: 'Rua/Avenida',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await buscaCep();
                Navigator.pop(context);
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Endereço"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.textCep,
              decoration: const InputDecoration(
                labelText: "CEP *",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira um Cep";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                if (value.length == 8) {
                  buscaEndereco(value);
                }
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  modalBuscaCep();
                },
                child: Text(
                  "Não sei meu cep...",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ),
            TextFormField(
              controller: controller.ruaAv,
              decoration: const InputDecoration(
                labelText: "Rua/Avenida *",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira uma Rua/Avenida";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: controller.numero,
              decoration: const InputDecoration(
                labelText: "Número *",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira um número";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: controller.bairro,
              decoration: const InputDecoration(
                labelText: "Bairro *",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira um bairro";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: controller.complemento,
              decoration: const InputDecoration(
                labelText: "Complemento",
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  controller.addAddress(controller.ruaAv.text,
                      controller.bairro.text, controller.numero.text);
                },
                child: Text("Salvar"))
          ],
        )),
      ),
    );
  }
}
