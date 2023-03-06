class Cart {
  String imageUrl;
  String product;
  int quantity;
  double price;

  Cart({required this.imageUrl, required this.product, required this.quantity, required this.price});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      imageUrl: json['product']['imageUrl'],
      product: json['product']['title'],
      quantity: json['quantity'],
      price: json['product']['price'].toDouble()
    );
  }
}