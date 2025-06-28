part of 'pages.dart';

class Checkout2Page extends StatefulWidget {
  @override
  _Checkout2PageState createState() => _Checkout2PageState();
}

class _Checkout2PageState extends State<Checkout2Page> {
  // /TextEditingController jmlController = TextEditingController();
  List<TextEditingController> _jumlahController = new List();
  double subTotal = 0;
  bool hasilEdit = false;
  String ketCheckout = "Terjadi kesalahan!";

  List _jnsTrx = [
    "Tunai",
    "Kredit",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentTrx;
  String _masterTrx;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentTrx = jnsTransaksiCustomer;
    _masterTrx = jnsTransaksiCustomer;

    super.initState();
    Timer(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String trx in _jnsTrx) {
      items.add(new DropdownMenuItem(value: trx, child: new Text(trx)));
    }
    return items;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentTrx = selectedCity;
    });
  }

  Future _deleteCart(String documentID, String _flagPaket, String _kodePaket,
      String _kodePaket2) async {
    var firestore = Firestore.instance;

    if (_flagPaket == "Y") {
      var batch = firestore.batch();

      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .where("kode_paket", isEqualTo: _kodePaket)
          .getDocuments()
          .then(
            (docSnapshot) => {
              for (int i = 0; i < docSnapshot.documents.length; i++)
                {
                  batch.delete(
                    firestore
                        .collection("transaksi_detail")
                        .document(kodeUnik)
                        .collection("brg")
                        .document(docSnapshot.documents[i].documentID),
                  ),
                },
            },
          );

      batch.commit();
    } else {
      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(documentID)
          .delete()
          .then(
            (docSnapshot) => {},
          );
    }

    return _deleteCart;
  }

  Future _editCart(String documentID, int _jml) async {
    hasilEdit = false;
    bool cekAdaGa;

    var firestore = Firestore.instance;
    await firestore
        .collection("transaksi_detail")
        .document(kodeUnik)
        .collection("brg")
        .document(documentID)
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists == true)
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
      hasilEdit = false;
    } else {
      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(documentID)
          .setData({
        'jumlah': _jml,
      }, merge: true).then((docSnapshot) => {hasilEdit = true});
    }

    return _editCart;
  }

  bool hasilCheckout = false;

  Future _checkout() async {
    hasilCheckout = false;
    bool cekVersi = false;

    var firestore = Firestore.instance;

    await firestore.collection("vrs").document("001").get().then(
          (docSnapshot) => {
            if (docSnapshot.exists == true)
              {
                if (docSnapshot.data["versi"] == versi)
                  {
                    cekVersi = true,
                  }
                else
                  {
                    cekVersi = false,
                    ketCheckout = "Ada versi terbaru! Apps harus diupdate!",
                  }
              }
            else
              {
                cekVersi = false,
                ketCheckout = "Ada versi terbaru! Apps harus diupdate!",
              }
          },
        );

    if (cekVersi == true) {
      WriteBatch batch = firestore.batch();

      DocumentReference documentReference =
          firestore.collection("transaksi").document(kodeUnik);

      DocumentReference documentReference2 =
          firestore.collection("transaksi_detail").document(kodeUnik);

      batch.setData(
        documentReference,
        {
          'kode_transaksi': kodeUnik,
          'kode_customer': kodeCust,
          'nama_customer': namaCust,
          'tanggal': Timestamp.now(),
          'flag_checkout': "Y",
          'selesai': null,
          'status_batal': null,
          'sudah_sync': null,
          'jenis_transaksi': _currentTrx,
          'lokasi': lokasi,
          'userid': userID,
          'spc_request': "T",
          'sudah_flag_spc_request': null,
          'sudah_acc_kacab': null,
          'ada_problem': null,
          'ket_problem': null,
          'sudah_proses': null,
          'flag_plafon': null,
          'flag_lama_jt': null,
          'flag_stock_kurang': null,
          'sudah_stock_kurang': null,
          'sudah_sync_stock_kurang': null,
          'sudah_plafon': null,
          'sudah_lama_jt': null,
        },
      );

      batch.setData(
        documentReference2,
        {
          'flag_checkout': "Y",
        },
      );

      await batch.commit();
      hasilCheckout = true;
    } else {
      hasilCheckout = false;
    }

    return _checkout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("transaksi_detail")
            .document(kodeUnik)
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
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomersPage()),
                            );
                            if (result != null) {
                              setState(() {
                                _currentTrx = jnsTransaksiCustomer;
                                _masterTrx = jnsTransaksiCustomer;
                              });
                            }
                          },
                          child: Container(
                            margin: new EdgeInsets.only(
                                left: 10, right: 5, top: 5, bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(300),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                                Container(
                                  margin: new EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Customer",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      Text(
                                        namaCust,
                                        // snapshot.data.documents[0]
                                        //   .data["nama_customer"],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      IgnorePointer(
                                        ignoring: _masterTrx == "Tunai"
                                            ? true
                                            : false,

                                        // ignoring: false,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 6),
                                          margin: EdgeInsets.only(top: 4),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            border: Border.all(),
                                          ),
                                          child: DropdownButton(
                                            value: _currentTrx,
                                            items: _dropDownMenuItems,
                                            onChanged: changedDropDownItem,
                                            underline: SizedBox(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey[200],
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            _jumlahController.add(new TextEditingController());
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
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible: snapshot.data.documents[index]
                                                    .data["flag_paket"] ==
                                                "Y"
                                            ? false
                                            : true,
                                        child: Container(
                                          height: 35,
                                          width: 30,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.mode_edit,
                                                color: Colors.black45,
                                              ),
                                              onPressed: () async {
                                                await _showDialog(
                                                  snapshot.data.documents[index]
                                                      .documentID,
                                                  snapshot.data.documents[index]
                                                      .data["nama_barang"],
                                                  snapshot.data.documents[index]
                                                      .data["jumlah"],
                                                );

                                                setState(() {});
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        height: 35,
                                        width: 40,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              try {
                                                await _deleteCart(
                                                  snapshot.data.documents[index]
                                                      .documentID,
                                                  snapshot.data.documents[index]
                                                      .data["flag_paket"],
                                                  snapshot.data.documents[index]
                                                      .data["kode_paket"],
                                                  snapshot.data.documents[index]
                                                      .data["kode_paket2"],
                                                );

                                                await setState(() {});
                                              } catch (_) {
                                                print("Err");
                                                throw Exception("Err.");
                                              }
                                            }),
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
                              Container(
                                margin: EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                width: double.infinity,
                                height: 40,
                                child: RaisedButton(
                                    elevation: 0,
                                    onPressed: () {
                                      setState(() async {
                                        try {
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
                                          } else {
                                            Scaffold.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(ketCheckout),
                                                  duration:
                                                      Duration(seconds: 4),
                                                ),
                                              );
                                            return false;
                                          }
                                        } catch (_) {
                                          print("Err");
                                          throw Exception("Err.");
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Simpan",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        side: BorderSide(color: btnAddToCart)),
                                    color: btnAddToCart),
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

  _showDialog(
    String documentID,
    String _namaBrg,
    int _jml,
  ) async {
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
                    _namaBrg,
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
                    controller: _jmlEdit..text = _jml.toString(),
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
                      hintText: "Qty",
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
                            await _editCart(
                                documentID, int.parse(_jmlEdit.text));
                            String hasilString;

                            if (hasilEdit == true) {
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

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
