// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_transaksi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailTransaksi _$DetailTransaksiFromJson(Map<String, dynamic> json) =>
    DetailTransaksi(
      discPersen: json['Disc_Prsn'] as int,
      jumlah: DetailTransaksi._parseJumlah(json['Jumlah']),
      harga: json['Harga'] as int,
      namaBarang: json['Nama_Barang'] as String,
      kodePaket: json['Kode_Pkt'] as String,
      satuan: json['Satuan'] as String,
      kodeSatuanBesar: json['Kode_Satuan_Besar'] as String,
      isiSatuanBesar: json['Isi_Satuan_Besar'] as int,
    );

Map<String, dynamic> _$DetailTransaksiToJson(DetailTransaksi instance) =>
    <String, dynamic>{
      'Disc_Prsn': instance.discPersen,
      'Jumlah': instance.jumlah,
      'Harga': instance.harga,
      'Nama_Barang': instance.namaBarang,
      'Kode_Pkt': instance.kodePaket,
      'Satuan': instance.satuan,
      'Kode_Satuan_Besar': instance.kodeSatuanBesar,
      'Isi_Satuan_Besar': instance.isiSatuanBesar,
    };
