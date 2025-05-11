class OrderModel {
  String uidPedido;
  String uidCliente;
  List<Map<String, dynamic>> itens;
  String formaPagamento;
  String? rua;
  String? numeroCasa;
  String? cidade;
  String? estado;
  double total;

  OrderModel({
    required this.uidPedido,
    required this.uidCliente,
    required this.itens,
    required this.formaPagamento,
    required this.total,
    this.rua,
    this.numeroCasa,
    this.cidade,
    this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidPedido': uidPedido,
      'uidCliente': uidCliente,
      'itens': itens,
      'formaPagamento': formaPagamento,
      'total': total,
      'rua': rua,
      'numeroCasa': numeroCasa,
      'cidade': cidade,
      'estado': estado,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      uidPedido: map['uidPedido'],
      uidCliente: map['uidCliente'],
      itens: List<Map<String, dynamic>>.from(map['itens']),
      formaPagamento: map['formaPagamento'],
      total: map['total'],
      rua: map['rua'],
      numeroCasa: map['numeroCasa'],
      cidade: map['cidade'],
      estado: map['estado'],
    );
  }
}
