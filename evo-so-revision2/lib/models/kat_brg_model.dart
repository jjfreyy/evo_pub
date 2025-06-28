import 'models.dart';

part 'kat_brg_model.g.dart';

@JsonSerializable()
class KatBrg {
  @JsonKey(name: 'Nama')
  final String nama;
  @JsonKey(name: 'Image')
  final dynamic image;

  KatBrg(this.nama, this.image);

  factory KatBrg.fromJson(Map<String, dynamic> json) => _$KatBrgFromJson(json);

  static List<KatBrg> fromJsonList(List jsonList) {
    return jsonList.map((json) => KatBrg.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$KatBrgToJson(this);

  @override
  String toString() {
    return 'KatBrg($nama, $image)';
  }
}
