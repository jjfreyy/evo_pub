// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      kode: json['Kode_Customer'] as String,
      nama: json['Nama'] as String,
      lokasi: json['Lokasi'] as String,
      jenisTrans: json['Jenis_Trans'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'Kode_Customer': instance.kode,
      'Nama': instance.nama,
      'Lokasi': instance.lokasi,
      'Jenis_Trans': instance.jenisTrans,
    };
