// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barang_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Barang _$BarangFromJson(Map<String, dynamic> json) => Barang(
      kode: json['Kode_Barang'] as String,
      nama: json['Nama'] as String,
      image: json['Image'] as String?,
      satuan: json['Satuan'] as String,
      stock: Barang._parseStock(json['Good_Stock']),
      fHrgResellStd: json['F_Hrg_Resell_Std'] as int,
    );

Map<String, dynamic> _$BarangToJson(Barang instance) => <String, dynamic>{
      'Kode_Barang': instance.kode,
      'Nama': instance.nama,
      'Image': instance.image,
      'Satuan': instance.satuan,
      'Good_Stock': instance.stock,
      'F_Hrg_Resell_Std': instance.fHrgResellStd,
    };
