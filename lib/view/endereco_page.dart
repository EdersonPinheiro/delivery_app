import 'dart:convert';
import 'package:delivery_app/controllers/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'create_address_page.dart';

class Endereco extends StatefulWidget {
  const Endereco({super.key});

  @override
  State<Endereco> createState() => _EnderecoState();
}

class _EnderecoState extends State<Endereco> {
  AddressController controller = AddressController();

  @override
  void initState() {
    super.initState();
    controller.getAddress();
  }

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

  bool endereco = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Endereço")),
      body: endereco
          ? Padding(
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
            )
          : FutureBuilder(
              future: controller.getAddress(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: controller.address.length,
                    itemBuilder: (context, index) {
                      final endereco = controller.address[index];
                      return GestureDetector(
                        onTap: () {
                          //Get.to(EditAddressPage);
                        },
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Endereço: ${endereco.logradouro}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Bairro: ${endereco.bairro}",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Número: ${endereco.numero}",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.to(CreateAddressPage());
          }),
    );
  }
}
