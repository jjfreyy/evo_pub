part of 'pages.dart';

class SpcRequestPage extends StatefulWidget {
  final String dokumenID;

  SpcRequestPage({Key key, @required this.dokumenID}) : super(key: key);

  @override
  _SpcRequestPageState createState() => _SpcRequestPageState();
}

class _SpcRequestPageState extends State<SpcRequestPage> {
  // /TextEditingController jmlController = TextEditingController();
  List<TextEditingController> _jumlahController = new List();
  double subTotal = 0;
  bool hasilEdit = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  Future _editCart(String documentID, double _jml) async {
    hasilEdit = false;
    bool cekAdaGa;

    var firestore = Firestore.instance;
    await firestore
        .collection("transaksi_detail")
        .document(widget.dokumenID)
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
          .document(widget.dokumenID)
          .collection("brg")
          .document(documentID)
          .setData({
        'disc_persen': _jml,
      }, merge: true).then((docSnapshot) => {hasilEdit = true});
    }

    return _editCart;
  }

  bool hasilExecute = false;

  Future _execute(String documentID) async {
    hasilExecute = false;
    bool cekAdaGa;

    String spc_request;
    String sudah_spc_request;

    var firestore = Firestore.instance;

    await firestore.collection("transaksi").document(documentID).get().then(
          (docSnapshot) => {
            if (docSnapshot.exists == true)
              {
                cekAdaGa = true,
                if (docSnapshot.data["sudah_spc_request"].toString() == "null")
                  {
                    sudah_spc_request = "null",
                  }
                else
                  {
                    sudah_spc_request = "Y",
                  },
                if (docSnapshot.data["spc_request"].toString() == "T")
                  {
                    spc_request = "T",
                  }
                else
                  {
                    spc_request = "Y",
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
      if (sudah_spc_request == "Y") {
        hasilExecute = false;
        return false;
      } else if (spc_request == "T") {
        hasilExecute = false;
        return false;
      }

      await firestore.collection("transaksi").document(documentID).setData({
        'sudah_flag_spc_request': "Y",
      }, merge: true).then((docSnapshot) => {hasilExecute = true});
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
                                      "Special Request",
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
                                                await _showDialog2(
                                                  snapshot.data.documents[index]
                                                      .documentID,
                                                  snapshot.data.documents[index]
                                                      .data["nama_barang"],
                                                  snapshot.data.documents[index]
                                                      .data["disc_persen"],
                                                );

                                                setState(() {});
                                              }),
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
                                          await _execute(widget.dokumenID);

                                          if (hasilExecute == true) {
                                            Navigator.of(context).pop();
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

  _showDialog2(
    String documentID,
    String _namaBrg,
    double _jml,
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
                      hintText: "Disc %",
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
                                documentID, double.parse(_jmlEdit.text));
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
