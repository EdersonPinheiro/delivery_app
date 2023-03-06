class Product {
  final String id;
  final String imageUrl;
  final String title;
  final double price;
  final String description;

  Product(
      {required this.id,
      required this.imageUrl,
      required this.title,
      required this.price,
      required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        imageUrl: json['imageUrl'],
        title: json['title'],
        price: json['price'].toDouble(),
        description: json['description']
        //price: json['price'],
        );
  }
}
