class Address {
  String logradouro;
  String bairro;
  String numero;
  String? complemento;

  Address(
      {
      required this.logradouro,
      required this.bairro,
      required this.numero,
      this.complemento});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        logradouro: json['logradouro'],
        bairro: json['bairro'],
        numero: json['numero'],
        complemento: json['complemento'] ?? '');
  }
}
