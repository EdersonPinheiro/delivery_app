class Order {
  final String id;
  final String qrCodeImage;
  final num total;
  final String copiaecola;
  final DateTime? createdAt;
  late final String status;

  Order(
      {required this.id,
      required this.qrCodeImage,
      required this.total,
      required this.copiaecola,
      this.createdAt, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        qrCodeImage: json['qrCodeImage'],
        total: json['total'],
        copiaecola: json['copiaecola'],
        createdAt: DateTime.parse(json['createdAt']), status: json['status'] ?? 'pending_payment');
  }

  factory Order.toJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      qrCodeImage: json['qrCodeImage'],
      total: json['total'],
      copiaecola: json['copiaecola'],
      status: json['status'],
    );
  }
}
