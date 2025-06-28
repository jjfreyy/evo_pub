part of 'pages.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  TextEditingController txtSearch = TextEditingController();
  bool hasil = false;

  Future _getCustomer() async {
    var firestore = Firestore.instance;

    if (txtSearch.text == "") {
      QuerySnapshot qn = await firestore
          .collection("customers")
          //.where("kode_kategori", isEqualTo: "k")
          //.startAt(["top"])
          // /.endAt(["\uf8ff"])
          .where("lokasi", isEqualTo: lokasi)
          .orderBy("nama_customer", descending: false)
          .getDocuments();
      return qn.documents;
    } else {
      QuerySnapshot qn = await firestore
          .collection("customers")
          //.where("kode_kategori", isEqualTo: "k")
          //.startAt(["top"])
          // /.endAt(["\uf8ff"])
          .where("lokasi", isEqualTo: lokasi)
          .where("searching",
              arrayContains: txtSearch.text.toString().toUpperCase())
          //.orderBy("nama_barang", descending: false)
          .getDocuments();
      return qn.documents;
    }
  }

  Future _simpanCust(String kodeCust, String namaCust) async {
    hasil = false;

    var firestore = Firestore.instance;
    await firestore.collection("transaksi").document(kodeUnik).setData(
      {
        'kode_customer': kodeCust,
        'nama_customer': namaCust,
        'status_batal': null,
        'tanggal': "",
        'status_berkas': null,
        'sudah_sync': null,
      },
    ).then((docSnapshot) => {hasil = true});

    return _simpanCust;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Pilih Customer"),
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
              future: _getCustomer(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length > 0
                      ? Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: ListTile(
                                  title: Text(
                                      snapshot
                                          .data[index].data["nama_customer"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    color: Colors.red,
                                  ),
                                  onTap: () async {
                                    try {
                                      await _simpanCust(
                                        snapshot
                                            .data[index].data["kode_customer"],
                                        snapshot
                                            .data[index].data["nama_customer"],
                                      );
                                      if (hasil == true) {
                                        kodeCust = snapshot
                                            .data[index].data["kode_customer"];
                                        namaCust = snapshot
                                            .data[index].data["nama_customer"];
                                        jnsTransaksiCustomer = snapshot
                                                    .data[index]
                                                    .data["jenis_trans"] ==
                                                "T"
                                            ? "Tunai"
                                            : "Kredit";
                                        Navigator.pop(context, "ok");
                                      } else {
                                        SnackBar(
                                          content:
                                              Text("Item Gagal Ditambahkan!"),
                                          duration: Duration(seconds: 2),
                                        );
                                      }
                                    } catch (_) {
                                      print("Err");
                                      throw Exception("Err.");
                                    }
                                  },
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
