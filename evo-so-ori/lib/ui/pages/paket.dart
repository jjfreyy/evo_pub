part of 'pages.dart';

class PaketPage extends StatefulWidget {
  @override
  _PaketPageState createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  Future _getPaket() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("paket")
        //.where("kode_kategori", isEqualTo: "k")
        //.startAt(["top"])
        // /.endAt(["\uf8ff"])
        .where("kode_so", isEqualTo: lokasi)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
              //padding: 10,
              children: <Widget>[
            FutureBuilder(
              future: _getPaket(),
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
                                      snapshot.data[index].data["kode_paket"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      )),
                                  trailing: Icon(
                                    Icons.arrow_right,
                                    color: Colors.red,
                                  ),
                                  onTap: () async {
                                    if (snapshot
                                            .data[index].data["pakai_range"] ==
                                        "Y") {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaketDetailRangePage(
                                                  hasil: snapshot.data[index]),
                                        ),
                                      );

                                      if (result != null) {
                                        Scaffold.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text("$result"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                      }
                                    } else {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaketDetailPage(
                                              hasil: snapshot.data[index]),
                                        ),
                                      );

                                      if (result != null) {
                                        Scaffold.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text("$result"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                      }
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
