// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paket_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaketDetail _$PaketDetailFromJson(Map<String, dynamic> json) => PaketDetail(
      hrsBudgeting: json['Hrs_Budgeting'] as String?,
      xHrgMid: (json['X_Hrg_Mid'] as num).toDouble(),
      kodeSO: json['Kode_SO'] as String?,
      kodePaket: json['Kode_Paket'] as String?,
      pakaiRange: json['Pakai_Range'] as String?,
      diskonCash: (json['Diskon_Cash'] as num).toDouble(),
      minOrder: (json['Min_Order'] as num?)?.toDouble(),
      pkt2: json['pkt2'] as String?,
      maxOrder: (json['Max_Order'] as num?)?.toDouble(),
      flagSatuanBesar: json['Flag_Satuan_Besar'] as String?,
      colly1: (json['Colly1'] as num?)?.toDouble(),
      colly2: (json['Colly2'] as num?)?.toDouble(),
      kodeStockOwner: json['Kode_Stock_Owner'] as String?,
      kodeBarang: json['Kode_Barang'] as String?,
      nama: json['Nama'] as String,
      jml: (json['Jml'] as num).toDouble(),
      discPersen: (json['Disc_Persen'] as num).toDouble(),
      kategori: json['Kategori'] as String?,
      bonus: json['Bonus'] as String?,
      dari: (json['Dari'] as num).toDouble(),
      sampai: (json['Sampai'] as num).toDouble(),
      fHrgResellStd: (json['F_Hrg_Resell_Std'] as num?)?.toDouble(),
      satuan: json['Satuan'] as String?,
      disc1: (json['Disc1'] as num).toDouble(),
      kodeSatuanBesar: json['Kode_Satuan_Besar'] as String?,
      isiSatuanBesar: (json['Isi_Satuan_Besar'] as num).toDouble(),
    );

Map<String, dynamic> _$PaketDetailToJson(PaketDetail instance) =>
    <String, dynamic>{
      'Hrs_Budgeting': instance.hrsBudgeting,
      'X_Hrg_Mid': instance.xHrgMid,
      'Kode_SO': instance.kodeSO,
      'Kode_Paket': instance.kodePaket,
      'Pakai_Range': instance.pakaiRange,
      'Diskon_Cash': instance.diskonCash,
      'Min_Order': instance.minOrder,
      'pkt2': instance.pkt2,
      'Max_Order': instance.maxOrder,
      'Flag_Satuan_Besar': instance.flagSatuanBesar,
      'Colly1': instance.colly1,
      'Colly2': instance.colly2,
      'Kode_Stock_Owner': instance.kodeStockOwner,
      'Kode_Barang': instance.kodeBarang,
      'Nama': instance.nama,
      'Jml': instance.jml,
      'Disc_Persen': instance.discPersen,
      'Kategori': instance.kategori,
      'Bonus': instance.bonus,
      'Dari': instance.dari,
      'Sampai': instance.sampai,
      'F_Hrg_Resell_Std': instance.fHrgResellStd,
      'Satuan': instance.satuan,
      'Disc1': instance.disc1,
      'Kode_Satuan_Besar': instance.kodeSatuanBesar,
      'Isi_Satuan_Besar': instance.isiSatuanBesar,
    };
