import 'package:delivery_app/view/cart_page.dart';
import 'package:delivery_app/view/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'models/order.dart';
import 'view/login_page.dart';
import 'view/product_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const KeyApplicationId = '';
  const KeyClientKey = '';
  const KeyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    KeyApplicationId,
    KeyParseServerUrl,
    clientKey: keyClassUser,
    liveQueryUrl: 'wss://deliveryappevo.b4a.io',
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loggedIn = false;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Order order;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductPage(),
    const OrdersPage(),
    const CartPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startLiveQuery();
  }

  final LiveQuery liveQuery = LiveQuery();
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject("Order"));

  Future<void> startLiveQuery() async {
    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.update, (value) {
      debugPrint("Object Created: ${value["status"]}");
      if (value["status"] == "paid") {
        Get.showSnackbar(
          const GetSnackBar(
            title: "Pagamento Confirmado!",
            message:
                'Seu pedido esta sendo preparado e logo sairá para entrega',
            icon: Icon(Icons.paypal),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.deepOrange,
            snackPosition: SnackPosition.TOP,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicial",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Pedidos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Carrinho"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
