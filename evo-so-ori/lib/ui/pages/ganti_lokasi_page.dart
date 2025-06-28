part of 'pages.dart';

class GantiLokasiPage extends StatefulWidget {
  @override
  _GantiLokasiPageState createState() => _GantiLokasiPageState();
}

class _GantiLokasiPageState extends State<GantiLokasiPage> {
  bool hasilEdit;

  Future _getPaket() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("user_lokasi")
        //.where("kode_kategori", isEqualTo: "k")
        //.startAt(["top"])
        // /.endAt(["\uf8ff"])
        .where("userid", isEqualTo: userID)
        .getDocuments();

    return qn.documents;
    //  .then((snapshot) {
    //    pointlist = List.from(snapshot.documents);
    /*
      for (int i = 0; i < snapshot.documents.length; i++) {
        subIngredients.add(snapshot.documents.data["lokasi"]);
      }
      */
    // subxxx = List.from(snapshot.data["lokasi"]);
/*
      snapshot.documents.forEach((document) {
        subIngredients.add(document.data["lokasi"].);
      });
      */

    //  });
  }

/*
  Future _getPaket() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("user_lokasi")
        //.where("kode_kategori", isEqualTo: "k")
        //.startAt(["top"])
        // /.endAt(["\uf8ff"])
        .where("userid", isEqualTo: "HENDRY")
        .getDocuments();
    return qn.documents;
  }
*/

  Future _updateLokasi(String _newLokasi) async {
    hasilEdit = false;
    bool cekAdaGa;
    String docID;

    var firestore = Firestore.instance;
    await firestore
        .collection("users")
        .where("userid", isEqualTo: userID)
        .getDocuments()
        .then(
          (docSnapshot) => {
            if (docSnapshot.documents.length > 0)
              {
                cekAdaGa = true,
                docID = docSnapshot.documents[0].documentID,
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
      await firestore.collection("users").document(docID).setData({
        'lokasi': _newLokasi,
      }, merge: true).then((docSnapshot) => {
            hasilEdit = true,
            lokasi = _newLokasi,
          });
    }

    return _updateLokasi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
              //padding: 10,
              children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 12, left: 10),
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Ganti Lokasi",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _getPaket(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length > 0
                      ? Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  List.from(snapshot.data[0].data["lokasi"])
                                      .length,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: ListTile(
                                  title: Text(
                                      snapshot.data[0].data["lokasi"][index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      )),
                                  trailing: Icon(
                                    Icons.arrow_right,
                                    color: Colors.red,
                                  ),
                                  onTap: () async {
                                    await _updateLokasi(
                                        snapshot.data[0].data["lokasi"][index]);
                                    refreshKodeUnik();

                                    Navigator.pop(
                                        context, "Lokasi berhasil diubah!");
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
