part of 'pages.dart';

class DetailTransaksiPage extends StatefulWidget {
  final String dokumenID;
  final DocumentSnapshot hasil;

  DetailTransaksiPage({Key key, @required this.dokumenID, @required this.hasil})
      : super(key: key);

  @override
  _DetailTransaksiPageState createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  double subTotal = 0;
  bool hasilExecute = false;
  bool hasilEdit = false;
  bool hasilPlafon = false;
  bool hasilJT = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Future _editJT(double lamaPlafon) async {
    hasilJT = false;

    var firestore = Firestore.instance;
    WriteBatch batch = firestore.batch();

    DocumentReference documentReference =
        firestore.collection("customer_plafon").document();

    batch.setData(
      documentReference,
      {
        'kode_customer': widget.hasil.data["kode_customer"],
        'plafon_rp': 0,
        'plafon_jt': lamaPlafon,
        'tanggal': Timestamp.now(),
        'sudah_sync': null,
        'kode_transaksi': widget.dokumenID,
        'sudah_proses': null,
        // 'ada_problem': null,
      },
    );

    DocumentReference documentReference2 =
        firestore.collection("transaksi").document();

    batch.setData(
      documentReference2,
      {
        'sudah_lama_jt': "Y",
      },
      merge: true,
    );

    await batch.commit();
    hasilJT = true;

    return _editJT;
  }

  Future _editPlafon(double rpPlafon) async {
    hasilPlafon = false;

    var firestore = Firestore.instance;
    WriteBatch batch = firestore.batch();

    DocumentReference documentReference =
        firestore.collection("customer_plafon").document();

    batch.setData(
      documentReference,
      {
        'kode_customer': widget.hasil.data["kode_customer"],
        'plafon_rp': rpPlafon,
        'plafon_jt': 0,
        'tanggal': Timestamp.now(),
        'sudah_sync': null,
        'kode_transaksi': widget.dokumenID,
        'sudah_proses': null
      },
    );

    DocumentReference documentReference2 =
        firestore.collection("transaksi").document(widget.dokumenID);

    batch.setData(
      documentReference2,
      {
        'sudah_plafon': "Y",
      },
      merge: true,
    );

    await batch.commit();
    hasilPlafon = true;

    return _editPlafon;
  }

  Future _execute(String documentID, String _jenis) async {
    hasilExecute = false;
    bool cekAdaGa;
    String sudah_acc_kacab;
    String spc_request;
    String sudah_stock_kurang;

    var firestore = Firestore.instance;

    await firestore.collection("transaksi").document(documentID).get().then(
          (docSnapshot) => {
            if (docSnapshot.exists == true)
              {
                cekAdaGa = true,
                if (docSnapshot.data["sudah_acc_kacab"].toString() == "null")
                  {
                    sudah_acc_kacab = "null",
                  }
                else
                  {
                    sudah_acc_kacab = "Y",
                  },
                if (docSnapshot.data["spc_request"].toString() == "T")
                  {
                    spc_request = "T",
                  }
                else
                  {
                    spc_request = "Y",
                  },
                if (docSnapshot.data["sudah_stock_kurang"].toString() == "null")
                  {
                    sudah_stock_kurang = "null",
                  }
                else
                  {
                    sudah_stock_kurang = "Y",
                  }
              }
            else
              {
                cekAdaGa = false,
              }
          },
        );

    if (cekAdaGa == false) {
      hasilExecute = false;
    } else {
      if (_jenis == "ACC") {
        if (sudah_acc_kacab == "Y") {
          hasilExecute = false;
          return false;
        }

        await firestore.collection("transaksi").document(documentID).setData({
          'sudah_acc_kacab': "Y",
        }, merge: true).then((docSnapshot) => {hasilExecute = true});
      } else if (_jenis == "SPC") {
        if (spc_request == "Y") {
          hasilExecute = false;
          return false;
        }

        await firestore.collection("transaksi").document(documentID).setData({
          'spc_request': "Y",
        }, merge: true).then((docSnapshot) => {hasilExecute = true});
      } else if (_jenis == "ACC_STOCK") {
        if (sudah_stock_kurang == "Y") {
          hasilExecute = false;
          return false;
        }

        await firestore.collection("transaksi").document(documentID).setData({
          'sudah_stock_kurang': "Y",
        }, merge: true).then((docSnapshot) => {hasilExecute = true});
      }
    }

    return _execute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("transaksi_detail")
            .document(widget.dokumenID)
            .collection("brg")
            .orderBy("nama_barang")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.documents.length > 0
                ? Container(
                    padding: new EdgeInsets.all(0.0),
                    margin: new EdgeInsets.only(
                        left: 0, right: 0, top: 10, bottom: 0),
                    child: ListView(
                      //padding: 10,
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, bottom: 22, left: 10),
                              height: 56,
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
                                      "Detail Transaksi",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              subTotal = 0;
                            }

                            subTotal += double.parse(
                              hitungSubtotalPerBarang(
                                double.parse(snapshot
                                    .data.documents[index].data["disc_persen"]
                                    .toString()),
                                0,
                                double.parse(snapshot
                                    .data.documents[index].data["jumlah"]
                                    .toString()),
                                double.parse(snapshot
                                    .data.documents[index].data["harga"]
                                    .toString()),
                              ).round().toString(),
                            );

                            return Card(
                                child: Container(
                              padding: new EdgeInsets.all(3.0),
                              margin: new EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data.documents[index]
                                              .data["nama_barang"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            // color: diorder,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: snapshot.data.documents[index]
                                                .data["flag_paket"] ==
                                            "T"
                                        ? false
                                        : true,
                                    child: Text(
                                      snapshot.data.documents[index]
                                                  .data["flag_paket"] ==
                                              "T"
                                          ? ""
                                          : snapshot.data.documents[index]
                                              .data["kode_paket"],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 20,
                                        child: Text(
                                          "Rp. ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 65,
                                        child: Text(
                                          formatDouble(
                                              double.parse(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data["harga"]
                                                  .toString()),
                                              0,
                                              context),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 3,
                                        child: Text(
                                          "X",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 60,
                                        child: Text(
                                          formatInteger(
                                              snapshot.data.documents[index]
                                                  .data["jumlah"],
                                              context),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 55,
                                        child: Text(
                                          snapshot.data.documents[index]
                                              .data["satuan"],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible: snapshot.data.documents[index]
                                                    .data["disc_persen"] ==
                                                0
                                            ? false
                                            : true,
                                        child: Container(
                                          width: 75,
                                          child: Text(
                                            "Disc " +
                                                formatDouble(
                                                    double.parse(snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["disc_persen"]
                                                        .toString()),
                                                    1,
                                                    context) +
                                                "%",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 163,
                                        child: Text(
                                          convertKeSatuanBesar(
                                              snapshot.data.documents[index]
                                                  .data["kode_satuan_besar"],
                                              snapshot.data.documents[index]
                                                  .data["isi_satuan_besar"],
                                              snapshot.data.documents[index]
                                                  .data["satuan"],
                                              double.parse(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data["jumlah"]
                                                  .toString())),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 9,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        child: Text(
                                          "Total Rp. ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Text(
                                          formatDouble(
                                              double.parse(
                                                hitungSubtotalPerBarang(
                                                  double.parse(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["disc_persen"]
                                                      .toString()),
                                                  0,
                                                  double.parse(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["jumlah"]
                                                      .toString()),
                                                  double.parse(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["harga"]
                                                      .toString()),
                                                ).round().toString(),
                                              ),
                                              0,
                                              context),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                          },
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          color: Colors.grey[200],
                          child: SizedBox(
                            height: 7,
                          ),
                        ),
                        Container(
                          margin: new EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                      "Subtotal ",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 40,
                                    child: Text(
                                      ": Rp.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 110,
                                    child: Text(
                                      formatDouble(subTotal, 0, context),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                      "PPN ",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 40,
                                    child: Text(
                                      ": Rp.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 110,
                                    child: Text(
                                      formatDouble(
                                          double.parse((subTotal * 10 / 100)
                                              .round()
                                              .toString()),
                                          0,
                                          context),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                      "Grand Total ",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 40,
                                    child: Text(
                                      ": Rp.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 110,
                                    child: Text(
                                      formatDouble(
                                          subTotal +
                                              double.parse((subTotal * 10 / 100)
                                                  .round()
                                                  .toString()),
                                          0,
                                          context),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: (bolehACC == "Y" && roleACC == "Y")
                                    ? true
                                    : false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  width: double.infinity,
                                  height: 40,
                                  child: RaisedButton(
                                      elevation: 0,
                                      onPressed: () {
                                        setState(() async {
                                          try {
                                            await _execute(
                                                widget.dokumenID, "ACC");
                                            String hasilString;

                                            if (hasilExecute == true) {
                                              hasilString =
                                                  "Transaksi berhasil di ACC Kacab";

                                              Navigator.pop(
                                                  context, hasilString);
                                            } else {
                                              hasilString = "Gagal";

                                              SnackBar(
                                                content:
                                                    Text("Transaksi Gagal!"),
                                                duration: Duration(seconds: 2),
                                              );
                                            }
                                          } catch (_) {
                                            print("Err");
                                            throw Exception("Err.");
                                          }
                                        });
                                      },
                                      child: Text(
                                        "ACC",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side:
                                              BorderSide(color: btnAddToCart)),
                                      color: btnAddToCart),
                                ),
                              ),
                              Visibility(
                                visible:
                                    (bolehSpcReq == "Y" && roleSpcReq == "Y")
                                        ? true
                                        : false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  width: double.infinity,
                                  height: 40,
                                  child: RaisedButton(
                                      elevation: 0,
                                      onPressed: () async {
                                        try {
                                          await _execute(
                                              widget.dokumenID, "SPC");
                                          String hasilString;

                                          if (hasilExecute == true) {
                                            hasilString =
                                                "Transaksi berhasil di buat special request";

                                            Navigator.pop(context, hasilString);
                                          } else {
                                            hasilString = "Gagal";

                                            SnackBar(
                                              content: Text("Transaksi Gagal!"),
                                              duration: Duration(seconds: 2),
                                            );
                                          }
                                        } catch (_) {
                                          print("Err");
                                          throw Exception("Err.");
                                        }
                                      },
                                      child: Text(
                                        "Special Request",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side: BorderSide(color: Colors.blue)),
                                      color: Colors.blue),
                                ),
                              ),
                              Visibility(
                                visible: (bolehNaikPlafon == "Y" &&
                                        roleNaikPlafon == "Y")
                                    ? true
                                    : false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  width: double.infinity,
                                  height: 40,
                                  child: RaisedButton(
                                      elevation: 0,
                                      onPressed: () {
                                        setState(() async {
                                          try {
                                            await _showDialogPlafon();
                                          } catch (_) {
                                            print("Err");
                                            throw Exception("Err.");
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Naik Plafon",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side: BorderSide(color: Colors.blue)),
                                      color: Colors.blue),
                                ),
                              ),
                              Visibility(
                                visible: (bolehTambahLamaJT == "Y" &&
                                        roleTambahLamaJT == "Y")
                                    ? true
                                    : false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  width: double.infinity,
                                  height: 40,
                                  child: RaisedButton(
                                      elevation: 0,
                                      onPressed: () {
                                        setState(() async {
                                          try {
                                            /*
                                          if (kodeCust == "") {
                                            Scaffold.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Customer belum diisi!"),
                                                  duration:
                                                      Duration(seconds: 4),
                                                ),
                                              );
                                            return false;
                                          }
                                          await _checkout();

                                          if (hasilCheckout == true) {
                                            refreshChekcout();

                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainPage2()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }
                                          */
                                          } catch (_) {
                                            print("Err");
                                            throw Exception("Err.");
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Tambah Lama Jth Tempo",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side: BorderSide(color: Colors.blue)),
                                      color: Colors.blue),
                                ),
                              ),
                              Visibility(
                                visible: (bolehACCStock == "Y" &&
                                        roleACCStock == "Y")
                                    ? true
                                    : false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  width: double.infinity,
                                  height: 40,
                                  child: RaisedButton(
                                      elevation: 0,
                                      onPressed: () {
                                        setState(() async {
                                          try {
                                            await _execute(
                                                widget.dokumenID, "ACC_STOCK");
                                            String hasilString;

                                            if (hasilExecute == true) {
                                              hasilString =
                                                  "Transaksi berhasil di ACC Stock Kurang";

                                              Navigator.pop(
                                                  context, hasilString);
                                            } else {
                                              hasilString = "Gagal";

                                              SnackBar(
                                                content:
                                                    Text("Transaksi Gagal!"),
                                                duration: Duration(seconds: 2),
                                              );
                                            }
                                          } catch (_) {
                                            print("Err");
                                            throw Exception("Err.");
                                          }
                                        });
                                      },
                                      child: Text(
                                        "ACC Stock Kurang",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side:
                                              BorderSide(color: btnAddToCart)),
                                      color: btnAddToCart),
                                ),
                              ),
                            ],
                          ),
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
      ),
    );
  }

  _showDialogPlafon() async {
    TextEditingController _jmlEdit = TextEditingController();

    await showDialog<String>(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) => _SystemPadding(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(
                    widget.hasil["nama_customer"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      // color: diorder,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: _jmlEdit..text = "",
                    enabled: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      contentPadding: EdgeInsets.only(top: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      hintText: "Plafon Rp.",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        // jml = int.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        setState(() async {
                          try {
                            await _editPlafon(double.parse(_jmlEdit.text));
                            String hasilString;

                            if (hasilPlafon == true) {
                              hasilString = "Item Berhasil Ditambahkan";

                              Navigator.pop(context, hasilString);
                            } else {
                              hasilString = "Gagal";

                              SnackBar(
                                content: Text("Item Gagal Ditambahkan!"),
                                duration: Duration(seconds: 2),
                              );
                            }
                          } catch (_) {
                            print("Err");
                            throw Exception("Err.");
                          }
                        });
                      },
                      child: Text(
                        "Ubah",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: btnAddToCart)),
                      color: btnAddToCart),
                ),
              ],
            ),
          ),
          elevation: 25,
        ),
      ),
    );
  }

  _showDialogJT() async {
    TextEditingController _jmlEdit = TextEditingController();

    await showDialog<String>(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) => _SystemPadding(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(
                    widget.hasil["nama_customer"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      // color: diorder,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: _jmlEdit..text = "",
                    enabled: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      contentPadding: EdgeInsets.only(top: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      hintText: "Lama JT",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        // jml = int.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        setState(() async {
                          try {
                            await _editJT(double.parse(_jmlEdit.text));
                            String hasilString;

                            if (hasilPlafon == true) {
                              hasilString = "Item Berhasil Ditambahkan";

                              Navigator.pop(context, hasilString);
                            } else {
                              hasilString = "Gagal";

                              SnackBar(
                                content: Text("Item Gagal Ditambahkan!"),
                                duration: Duration(seconds: 2),
                              );
                            }
                          } catch (_) {
                            print("Err");
                            throw Exception("Err.");
                          }
                        });
                      },
                      child: Text(
                        "Ubah",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: btnAddToCart)),
                      color: btnAddToCart),
                ),
              ],
            ),
          ),
          elevation: 25,
        ),
      ),
    );
  }
}
