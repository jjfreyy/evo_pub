part of 'pages.dart';

class BarangPage extends StatefulWidget {
  final DocumentSnapshot hasil;

  BarangPage({Key key, @required this.hasil}) : super(key: key);

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  TextEditingController txtSearch = TextEditingController();
  List<TextEditingController> _jumlahController = new List();

  bool cekAdaGa;
  bool hasil = false;

  Future _simpanCart(
      int _jml,
      String _kdBrg,
      String _namaBrg,
      String _satuan,
      double _harga,
      double _discPersen,
      String _kodeSatuanBesar,
      double _isiSatuanBesar) async {
    hasil = false;
    int jmlLama;

    var firestore = Firestore.instance;
    await firestore
        .collection("transaksi_detail")
        .document(kodeUnik)
        .collection("brg")
        .document(lokasi + pemisah + _kdBrg)
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists == true)
              {
                jmlLama = docSnapshot.data["jumlah"],
                cekAdaGa = true,
              }
            else
              {
                cekAdaGa = false,
              }
          },
        );

    if (cekAdaGa == false) {
      var firestore = Firestore.instance;
      WriteBatch batch = firestore.batch();

      DocumentReference documentReference = firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(lokasi + pemisah + _kdBrg);

      DocumentReference documentReference2 =
          firestore.collection("transaksi_detail").document(kodeUnik);

      batch.setData(
        documentReference,
        {
          'kode_transaksi': kodeUnik,
          'kode_barang': _kdBrg,
          'nama_barang': _namaBrg,
          'jumlah': _jml,
          'kode_customer': "",
          'nama_customer': "",
          'flag_paket': "T",
          'kode_paket': null,
          'kode_paket2': null,
          'satuan': _satuan,
          'harga': _harga,
          'disc_persen': _discPersen,
          'isi_satuan_besar': _isiSatuanBesar,
          'kode_satuan_besar': _kodeSatuanBesar,
        },
      );

      batch.setData(
        documentReference2,
        {
          'flag_checkout': null,
        },
      );

      await batch.commit();
      hasil = true;

      /*
      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(lokasi + pemisah + _kdBrg)
          .setData(
        {
          'kode_transaksi': kodeUnik,
          'kode_barang': _kdBrg,
          'nama_barang': _namaBrg,
          'jumlah': _jml,
          'kode_customer': "",
          'nama_customer': "",
          'flag_paket': "T",
          'kode_paket': null,
          'kode_paket2': null,
          'satuan': _satuan,
          'harga': _harga,
          'disc_persen': _discPersen,
          'isi_satuan_besar': _isiSatuanBesar,
          'kode_satuan_besar': _kodeSatuanBesar,
        },
      ).then((docSnapshot) => {hasil = true});

      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .setData({
        'flag_checkout': null,
      });
      */
    } else {
      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(lokasi + pemisah + _kdBrg)
          .setData({
        'jumlah': jmlLama + _jml,
      }, merge: true).then((docSnapshot) => {hasil = true});
    }

    return _simpanCart;
  }

  Future _getBarang(String kdKat) async {
    var firestore = Firestore.instance;

    if (txtSearch.text == "") {
      QuerySnapshot qn = await firestore
          .collection("barang")
          //.where("kode_kategori", isEqualTo: "k")
          //.startAt(["top"])
          // /.endAt(["\uf8ff"])
          .where("kode_stock_owner", isEqualTo: lokasi)
          .where("kode_kategori", isEqualTo: kdKat)
          .orderBy("nama_barang", descending: false)
          .getDocuments();
      return qn.documents;
    } else {
      QuerySnapshot qn = await firestore
          .collection("barang")
          //.where("kode_kategori", isEqualTo: "k")
          //.startAt(["top"])
          // /.endAt(["\uf8ff"])
          .where("kode_stock_owner", isEqualTo: lokasi)
          .where("kode_kategori", isEqualTo: kdKat)
          .where("searching",
              arrayContains: txtSearch.text.toString().toUpperCase())
          //.orderBy("nama_barang", descending: false)
          .getDocuments();
      return qn.documents;
    }
  }

  void initState() {
    super.initState();

    //_data = _getBarang(widget.hasil.data["kode_kategori"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Barang"),
          backgroundColor: appbarColor,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainPage2()),
                        (Route<dynamic> route) => false);
                  },
                  child: Icon(
                    Icons.home,
                    size: 26.0,
                  ),
                )),
          ]),
      body: Container(
          child: ListView(
              //padding: 10,
              children: <Widget>[
            Container(
              height: 35,
              margin:
                  new EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 8),
              child: TextField(
                controller: txtSearch,
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
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search"),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            FutureBuilder(
              future: _getBarang(widget.hasil.data["kode_kategori"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length > 0
                      ? Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  _jumlahController.clear();
                                }

                                _jumlahController
                                    .add(new TextEditingController());

                                return Card(
                                    child: ListTile(
                                  leading: snapshot.data[index].data["image"] ==
                                          null
                                      ? Icon(Icons.image)
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data[index].data["image"]),
                                        ),

                                  /*
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(noImageUrl),
                                  ),
*/

                                  title: Text(
                                      snapshot.data[index].data["nama_barang"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      )),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stock " +
                                            NumberFormat.currency(
                                              locale: "en",
                                              symbol: "",
                                              decimalDigits: 0,
                                            ).format(snapshot
                                                .data[index].data["stock"]) +
                                            " " +
                                            snapshot.data[index].data["satuan"],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Rp. " +
                                            NumberFormat.currency(
                                              locale: "en",
                                              symbol: "",
                                              decimalDigits: 0,
                                            ).format(snapshot.data[index]
                                                .data["f_hrg_resell_std"]),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
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
                                                fontSize: 17,
                                              ),
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2.0),
                                                  ),
                                                  hintText: "Qty"),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 70,
                                            height: 30,
                                            child: RaisedButton(
                                              elevation: 0,
                                              color: Colors.red,
                                              child: Text(
                                                "Simpan",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              textColor: Colors.white,
                                              onPressed: () async {
                                                try {
                                                  if (_jumlahController[index]
                                                              .text
                                                              .trim() ==
                                                          "" ||
                                                      _jumlahController[index]
                                                              .text
                                                              .trim()
                                                              .length ==
                                                          0) {
                                                    Scaffold.of(context)
                                                      ..removeCurrentSnackBar()
                                                      ..showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Jumlah belum diisi!"),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    return false;
                                                  } else {
                                                    await _simpanCart(
                                                      int.parse(
                                                          _jumlahController[
                                                                  index]
                                                              .text),
                                                      snapshot.data[index]
                                                          .data["kode_barang"],
                                                      snapshot.data[index]
                                                          .data["nama_barang"],
                                                      snapshot.data[index]
                                                          .data["satuan"],
                                                      snapshot.data[index].data[
                                                          "f_hrg_resell_std"],
                                                      snapshot.data[index]
                                                          .data["disc_persen"],
                                                      snapshot.data[index].data[
                                                          "kode_satuan_besar"],
                                                      double.parse(snapshot
                                                          .data[index]
                                                          .data[
                                                              "isi_satuan_besar"]
                                                          .toString()),
                                                    );

                                                    if (hasil == true) {
                                                      Scaffold.of(context)
                                                        ..removeCurrentSnackBar()
                                                        ..showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "Item Berhasil Ditambahkan!"),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                      _jumlahController[index]
                                                          .text = "";
                                                    } else {
                                                      Scaffold.of(context)
                                                        ..removeCurrentSnackBar()
                                                        ..showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "Item Gagal Ditambahkan!"),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                    }
                                                  }

                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode()); //remove focus
                                                } catch (_) {
                                                  print("Err");
                                                  throw Exception("Err.");
                                                }
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                              }),
                        )
                      : tidakAdaData();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                  child: ColorLoader3(
                    radius: 15.0,
                    dotRadius: 6.0,
                  ),
                );
              },
            ),
          ])),
    );
  }
}
