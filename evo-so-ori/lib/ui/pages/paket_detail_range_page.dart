part of 'pages.dart';

class PaketDetailRangePage extends StatefulWidget {
  final DocumentSnapshot hasil;

  PaketDetailRangePage({Key key, @required this.hasil}) : super(key: key);

  @override
  _PaketDetailRangePageState createState() => _PaketDetailRangePageState();
}

class _PaketDetailRangePageState extends State<PaketDetailRangePage> {
  // TextEditingController jmlPaketController = TextEditingController();
  List<TextEditingController> _jumlahController = new List();

  int hasilhitung = 0;
  String hasilcoba = "X";
  String hasilcoba2 = "Y";
  String hasilcoba3 = "Z";
  int memenuhi = 0;
  int keBerapa = 0;

  Map maksimalDari = Map<String, dynamic>();
  Map maksimalSampai = Map<String, dynamic>();
  //Map maksimalJml = Map<String, dynamic>(); //= {'A': 8640, 'B': 576};
  Map jmlSekarang = Map<String, dynamic>(); // = {'A': 8641, 'B': 576};
  Map masterMaksimalJml = Map<String, dynamic>();

  Future _getPaketDetail() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("paket_detail")
        .where("kode_so", isEqualTo: lokasi)
        .where("kode_paket", isEqualTo: widget.hasil.data["kode_paket"])
        .orderBy("bonus")
        .orderBy("kategori")
        .orderBy("nama_barang")
        .getDocuments();
    return qn.documents;
  }

/*
  bool hasil = false;
  bool cekAdaGa;

  Future _simpanPaket(
    String _kdBrg,
    String _kdKategori,
    String _kdPaket,
    String _kdPaket2,
  ) async {
    hasil = false;

    await firestore
        .collection("transaksi_detail")
        .document(kodeUnik)
        .collection("brg")
        .document(lokasi +
            pemisah +
            _kdBrg +
            pemisah +
            _kdKategori +
            pemisah +
            _kdPaket +
            pemisah +
            _kdPaket2)
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists)
              {
                cekAdaGa = true,
              }
            else
              {
                cekAdaGa = false,
              }
          },
        );

    if (cekAdaGa == false) {
      DocumentReference documentReference = firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(lokasi +
              pemisah +
              _kdBrg +
              pemisah +
              _kdKategori +
              pemisah +
              _kdPaket +
              pemisah +
              _kdPaket2);

      await batch.setData(documentReference, {
        'kode_transaksi': kodeUnik,
        'kode_barang': _kdBrg,
        'nama_barang': snapshot.data[i].data["nama_barang"],
        'jumlah': int.parse(_jumlahController[i].text),
        'kode_customer': "",
        'nama_customer': "",
        'flag_paket': "Y",
        'kode_paket': snapshot.data[i].data["kode_paket"],
        'kode_paket2': null
      });

      await batch.commit();
      hasil = true;

      //.then((docSnapshot) => {});
    } else {
      hasil = false;
    }

    return _simpanPaket;
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder(
        future: _getPaketDetail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length > 0
                ? Container(
                    color: Colors.white,
                    padding: new EdgeInsets.all(0.0),
                    margin: new EdgeInsets.only(
                        left: 0, right: 0, top: 10, bottom: 0),
                    child: ListView(
                      //padding: 10,
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 0, bottom: 12, left: 10),
                              height: 50,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Paket",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*
                            RaisedButton(
                              child: Text("hitung"),
                              onPressed: () {
                                setState(() {
                                  //hasilhitung =
                                  // int.parse(_jumlahController[3].text);

                                  hasilcoba = "X";
                                  hasilcoba2 = "Y";
                                  hasilcoba3 = "Z";
                                  memenuhi = 0;

                                  maksimalJml.forEach((k, v) {
                                    maksimalJml[k] = masterMaksimalJml[k] *
                                        int.parse(jmlMaxController.text);
                                  });
                                });
                              },
                            ),
                            */
                            //Text(hasilcoba.toString()),
                            //Text(hasilcoba2.toString()),
                            // Text(masterMaksimalJml["B"].toString()),
                            //Text(maksimalJml.toString()),
                            // Text(memenuhi.toString() +
                            // " dari " +
                            // maksimalJml.length.toString()),
                            //  Text(maksimalJml["B"].toString()),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                //adddddd jmlsekarang & jmlmaksimal disini
                                if (keBerapa == 0) {
                                  if (index == snapshot.data.length - 1) {
                                    keBerapa = 1;
                                  }

                                  if (index == 0) {
                                    _jumlahController.clear();
/*
                                    maksimalJml[snapshot
                                            .data[index].data["kategori"]] =
                                        snapshot.data[index].data["jml"];
                                      */

                                    maksimalDari[snapshot
                                            .data[index].data["kategori"]] =
                                        snapshot.data[index].data["dari"];

                                    maksimalSampai[snapshot
                                            .data[index].data["kategori"]] =
                                        snapshot.data[index].data["sampai"];

                                    jmlSekarang[snapshot
                                        .data[index].data["kategori"]
                                        .toString()] = 0;

                                    masterMaksimalJml[snapshot
                                            .data[index].data["kategori"]
                                            .toString()] =
                                        snapshot.data[index].data["jml"];
                                  } else {
                                    if (masterMaksimalJml.containsKey(snapshot
                                            .data[index].data["kategori"]) ==
                                        true) {
                                      /*
                                      maksimalJml.update(
                                        snapshot.data[index].data["kategori"]
                                            .toString(),
                                        (v) {
                                          return v +
                                              snapshot.data[index].data["jml"];
                                        },
                                      );
*/
                                      jmlSekarang.update(
                                        snapshot.data[index].data["kategori"]
                                            .toString(),
                                        (v) {
                                          return v + 0;
                                        },
                                      );

/*
                                      masterMaksimalJml.update(
                                        snapshot.data[index].data["kategori"]
                                            .toString(),
                                        (v) {
                                          return v +
                                              snapshot.data[index].data["jml"];
                                        },
                                      );*/
                                    } else {
                                      /*
                                      maksimalJml[snapshot
                                              .data[index].data["kategori"]
                                              .toString()] =
                                          snapshot.data[index].data["jml"];
*/
                                      maksimalDari[snapshot
                                              .data[index].data["kategori"]] =
                                          snapshot.data[index].data["dari"];

                                      maksimalSampai[snapshot
                                              .data[index].data["kategori"]] =
                                          snapshot.data[index].data["sampai"];

                                      jmlSekarang[snapshot
                                          .data[index].data["kategori"]
                                          .toString()] = 0;

                                      masterMaksimalJml[snapshot
                                              .data[index].data["kategori"]
                                              .toString()] =
                                          snapshot.data[index].data["jml"];
                                    }
                                  }
                                }

                                _jumlahController
                                    .add(new TextEditingController());

                                return Card(
                                    color: snapshot.data[index].data["bonus"]
                                                .toString() ==
                                            "Y"
                                        ? Colors.blue[50]
                                        : Colors.white,
                                    child: Container(
                                      padding: new EdgeInsets.all(3.0),
                                      margin: new EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  snapshot.data[index]
                                                              .data["bonus"]
                                                              .toString() ==
                                                          "Y"
                                                      ? "*Free "
                                                              " \n" +
                                                          snapshot
                                                              .data[index]
                                                              .data[
                                                                  "nama_barang"]
                                                              .toString()
                                                      : snapshot.data[index]
                                                          .data["nama_barang"]
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    // color: diorder,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Group : " +
                                                snapshot.data[index]
                                                    .data["kategori"] +
                                                " \n" +
                                                "range : " +
                                                snapshot.data[index]
                                                    .data["pakai_range"] +
                                                " \n" +
                                                "Max Qty : " +
                                                NumberFormat.currency(
                                                  locale: "en",
                                                  symbol: "",
                                                  decimalDigits: 0,
                                                ).format(maksimalDari[snapshot
                                                    .data[index]
                                                    .data["kategori"]]) +
                                                " sd " +
                                                NumberFormat.currency(
                                                  locale: "en",
                                                  symbol: "",
                                                  decimalDigits: 0,
                                                ).format(maksimalSampai[snapshot
                                                    .data[index]
                                                    .data["kategori"]]),
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 30,
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  controller:
                                                      _jumlahController[index],
                                                  enabled: true,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 10.0),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 2.0),
                                                      ),
                                                      hintText: "Qty"),
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      // jml = int.parse(value);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            ),

                            Container(
                              margin: EdgeInsets.all(defaultMargin),
                              width: double.infinity,
                              height: 40,
                              child: RaisedButton(
                                  elevation: 0,
                                  onPressed: () async {
                                    try {
//reset jml sekarang jd nol
                                      jmlSekarang.clear();

                                      double ttl_rp = 0;

                                      //isi jml sekarang sesuai di textbox
                                      for (int r = 0;
                                          r < snapshot.data.length;
                                          r++) {
                                        int jmlPerBrg;

                                        if (_jumlahController[r].text.trim() ==
                                            "") {
                                          jmlPerBrg = 0;
                                        } else {
                                          jmlPerBrg = int.parse(
                                              _jumlahController[r].text);

                                          if (snapshot.data[r].data["pkt_2"] ==
                                              null) {
                                            ttl_rp += double.parse(
                                                hitungSubtotalPerBarang(
                                              double.parse(snapshot
                                                  .data[r].data["disc_persen"]
                                                  .toString()),
                                              0,
                                              double.parse(_jumlahController[r]
                                                  .text
                                                  .toString()),
                                              double.parse(snapshot.data[r]
                                                  .data["f_hrg_resell_std"]
                                                  .toString()),
                                            ).round().toString());
                                          } else {
                                            ttl_rp += double.parse(
                                                hitungSubtotalPerBarang(
                                              double.parse(snapshot
                                                  .data[r].data["disc_persen"]
                                                  .toString()),
                                              0,
                                              double.parse(_jumlahController[r]
                                                  .text
                                                  .toString()),
                                              double.parse(snapshot
                                                  .data[r].data["x_hrg_mid"]
                                                  .toString()),
                                            ).round().toString());
                                          }
                                        }

                                        if (jmlSekarang.containsKey(snapshot
                                                .data[r].data["kategori"]) ==
                                            true) {
                                          jmlSekarang.update(
                                            snapshot.data[r].data["kategori"]
                                                .toString(),
                                            (v) {
                                              return v + jmlPerBrg;
                                            },
                                          );
                                        } else {
                                          jmlSekarang[snapshot
                                              .data[r].data["kategori"]
                                              .toString()] = jmlPerBrg;
                                        }
                                      }

                                      memenuhi = 0;

/*
                                      jmlSekarang.forEach((k1, v1) {
                                        if (v1 == maksimalJml[k1]) {
                                          memenuhi = memenuhi + 1;
                                        }
                                      });

                                      if (memenuhi != maksimalJml.length) {
                                        Scaffold.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Jml group maksimal tidak memenuhi!"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        return false;
                                      }
*/
                                      jmlSekarang.forEach((k1, v1) {
                                        if (v1 >= maksimalDari[k1] &&
                                            v1 <= maksimalSampai[k1]) {
                                          memenuhi = memenuhi + 1;
                                        }
                                      });

                                      if (memenuhi != maksimalDari.length) {
                                        Scaffold.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Jml group maksimal tidak memenuhi!"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        return false;
                                      }

                                      if (snapshot.data[0].data["min_order"] ==
                                          null) {
                                      } else {
                                        if (ttl_rp + (ttl_rp * 10 / 100) <
                                            snapshot
                                                .data[0].data["min_order"]) {
                                          Scaffold.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Min order tidak memenuhi!"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          return false;
                                        }
                                      }

                                      if (snapshot.data[0].data["max_order"] ==
                                          null) {
                                      } else {
                                        if (ttl_rp + (ttl_rp * 10 / 100) >
                                            snapshot
                                                .data[0].data["max_order"]) {
                                          Scaffold.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text("Melebihi max order!"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          return false;
                                        }
                                      }

                                      String kolomPaket;
                                      String isiPaket;
                                      if (snapshot.data[0].data["kode_paket"] ==
                                          "") {
                                        kolomPaket = "kode_paket2";
                                        isiPaket = snapshot
                                            .data[0].data["kode_paket2"];
                                      } else {
                                        kolomPaket = "kode_paket";
                                        isiPaket =
                                            snapshot.data[0].data["kode_paket"];
                                      }

                                      bool adaGa = false;
                                      var firestore = Firestore.instance;
                                      await firestore
                                          .collection("transaksi_detail")
                                          .document(kodeUnik)
                                          .collection("brg")
                                          .where(kolomPaket,
                                              isEqualTo: isiPaket)
                                          .getDocuments()
                                          .then(
                                            (docSnapshot) => {
                                              if (docSnapshot.documents.length >
                                                  0)
                                                {
                                                  adaGa = true,
                                                }
                                              else
                                                {
                                                  adaGa = false,
                                                }
                                            },
                                          );

                                      if (adaGa == true) {
                                        Scaffold.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Paket ini sudah pernah ditambahkan sebelumnya!"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        return false;
                                      }

                                      WriteBatch batch = firestore.batch();

                                      for (int i = 0;
                                          i < snapshot.data.length;
                                          i++) {
                                        if (_jumlahController[i].text.length >
                                            0) {
                                          if (int.parse(
                                                  _jumlahController[i].text) >
                                              0) {
                                            DocumentReference
                                                documentReference = firestore
                                                    .collection(
                                                        "transaksi_detail")
                                                    .document(kodeUnik)
                                                    .collection("brg")
                                                    .document(lokasi +
                                                        pemisah +
                                                        snapshot.data[i].data[
                                                            "kode_barang"] +
                                                        pemisah +
                                                        snapshot.data[i]
                                                            .data["kategori"] +
                                                        pemisah +
                                                        snapshot.data[i].data[
                                                            "kode_paket"]);

                                            batch.setData(documentReference, {
                                              'kode_transaksi': kodeUnik,
                                              'kode_barang': snapshot
                                                  .data[i].data["kode_barang"],
                                              'nama_barang': snapshot
                                                  .data[i].data["nama_barang"],
                                              'jumlah': int.parse(
                                                  _jumlahController[i].text),
                                              'kode_customer': "",
                                              'nama_customer': "",
                                              'flag_paket': "Y",
                                              'kode_paket': snapshot
                                                  .data[i].data["kode_paket"],
                                              'kode_paket2': snapshot.data[i]
                                                          .data["pkt_2"] ==
                                                      null
                                                  ? null
                                                  : snapshot.data[i]
                                                      .data["kode_paket"],
                                              'satuan': snapshot
                                                  .data[i].data["satuan"],
                                              'harga': snapshot.data[i]
                                                          .data["pkt_2"] ==
                                                      null
                                                  ? snapshot.data[i]
                                                      .data["f_hrg_resell_std"]
                                                  : snapshot.data[i]
                                                      .data["x_hrg_mid"],
                                              'disc_persen': snapshot
                                                  .data[i].data["disc_persen"],
                                              'isi_satuan_besar': snapshot
                                                  .data[i]
                                                  .data["isi_satuan_besar"],
                                              'kode_satuan_besar': snapshot
                                                  .data[i]
                                                  .data["kode_satuan_besar"],
                                            });
                                          }
                                        }
                                      }

                                      DocumentReference documentReference2 =
                                          firestore
                                              .collection("transaksi_detail")
                                              .document(kodeUnik);

                                      batch.setData(
                                        documentReference2,
                                        {
                                          'flag_checkout': null,
                                        },
                                      );

                                      await batch.commit();

                                      Navigator.pop(context,
                                          "Paket Berhasil Ditambahkan!");
                                    } catch (_) {
                                      print("Err");
                                      throw Exception("Err.");
                                    }
                                  },
                                  child: Text(
                                    "Tambah",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(color: btnAddToCart)),
                                  color: btnAddToCart),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : tidakAdaData();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            Text("tidak ada");
          }
          return Center(
            child: ColorLoader3(
              radius: 15.0,
              dotRadius: 6.0,
            ),
          );
          //CircularProgressIndicator();
        },
      )),
    );
  }
}
