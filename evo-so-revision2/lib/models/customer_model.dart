import 'models.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: 'Kode_Customer')
  final String kode;
  @JsonKey(name: 'Nama')
  final String nama;
  @JsonKey(name: 'Lokasi')
  final String lokasi;
  @JsonKey(name: 'Jenis_Trans')
  final String jenisTrans;

  Customer(
      {required this.kode,
      required this.nama,
      required this.lokasi,
      required this.jenisTrans});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  static List<Customer> fromJsonList(List jsonList) {
    return jsonList.map((json) => Customer.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  String toString() {
    return 'Customer($kode, $nama, $lokasi, $jenisTrans)';
  }
}

     