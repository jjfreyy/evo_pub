// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      kodePerusahaan: json['Kode_Perusahaan'] as String,
      tanggal: Cart._parseTanggal(json['Tanggal']),
      userID: json['UserID'] as String,
      lokasi: json['Lokasi'] as String,
      kodeBarang: json['Kode_Barang'] as String,
      namaBarang: json['Nama_Barang'] as String,
      satuan: json['Satuan'] as String,
      disc: json['Disc'] as int,
      qty: json['Qty'] as int,
      kodePaket: json['Kode_Paket'] as String,
      flagPaket: json['Flag_Paket'] as String,
      harga: (json['Harga'] as num).toDouble(),
      kodeSatuanBesar: json['Kode_Satuan_Besar'] as String,
      isiSatuanBesar: (json['Isi_Satuan_Besar'] as num).toDouble(),
      kodePaket2: json['Kode_Paket2'] as String,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'Kode_Perusahaan': instance.kodePerusahaan,
      'Tanggal': instance.tanggal.toIso8601String(),
      'UserID': instance.userID,
      'Lokasi': instance.lokasi,
      'Kode_Barang': instance.kodeBarang,
      'Nama_Barang': instance.namaBarang,
      'Satuan': instance.satuan,
      'Disc': instance.disc,
      'Qty': instance.qty,
      'Kode_Paket': instance.kodePaket,
      'Flag_Paket': instance.flagPaket,
      'Harga': instance.harga,
      'Kode_Satuan_Besar': instance.kodeSatuanBesar,
      'Isi_Satuan_Besar': instance.isiSatuanBesar,
      'Kode_Paket2': instance.kodePaket2,
    };
