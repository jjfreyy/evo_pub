part of 'pages.dart';

class Checker {
  final String kodeArea;
  final String kodeMeja;
  final String namaBarang;
  final String qty;
  final String keterangan;
  final String tglOrder;
  final String id;

  Checker({
    this.kodeArea,
    this.kodeMeja,
    this.namaBarang,
    this.qty,
    this.keterangan,
    this.tglOrder,
    this.id,
  });

  factory Checker.fromJson(Map<String, dynamic> json) {
    return Checker(
      kodeArea: json['kode_area'],
      kodeMeja: json['kode_meja'],
      namaBarang: json['nama'],
      qty: json['qty'],
      keterangan: json['keterangan'],
      tglOrder: json['tanggal'],
      id: json['id'],
    );
  }
}

Future<List<Checker>> _getChecker(_lokasi, _status) async {
  final apiUrl = myUrl;
  final response = await http
      .get(apiUrl + 'getchecker.php?lok=' + _lokasi + '&status=' + _status);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    //return jsonResponse.map((job) => new Job.fromJson(job)).toList();

    List<dynamic> isi = (jsonResponse as Map<String, dynamic>)["data"];

    List<Checker> _isi = [];
    for (int i = 0; i < isi.length; i++) _isi.add(Checker.fromJson(isi[i]));

    return _isi;
  } else {
    return null;
    //throw Exception('Tidak ada data!');
  }
}

/*ini untuk update status */

class EditChecker {
  final String xhasil;

  EditChecker({this.xhasil});

  factory EditChecker.createPostResult(Map<String, dynamic> json) {
    return EditChecker(
      xhasil: json['hasil'],
    );
  }

  static Future<EditChecker> editChecker(
    _idCart,
    _statusOrder,
  ) async {
    String apiUrl = myUrl + 'editchecker.php';

    var apiResult = await http.post(apiUrl, body: {
      "id": _idCart,
      "status": _statusOrder,
    });
    var jsonObject = json.decode(apiResult.body);

    return EditChecker.createPostResult(jsonObject);
  }
}

class CheckerPage extends StatefulWidget {
  @override
  _CheckerPageState createState() => _CheckerPageState();
}

class _CheckerPageState extends State<CheckerPage> {
  //List<RaisedButton> _controllers = new List();
  Checker postResult;

  String pilihan = "0";
  bool visibleDiorder = false;
  bool visibleDiantar = true;
  bool visibleSelesai = true;
  Color warnaLabel = diorder;

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AreaPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Checker'),
            backgroundColor: appbarColor,
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => AreaPage()),
                          (Route<dynamic> route) => false);
                    },
                    child: Icon(
                      Icons.home,
                      size: 26.0,
                    ),
                  )),
            ]),
        backgroundColor: Colors.white,
        body: FutureBuilder<List<Checker>>(
            future: _getChecker(lokasi, pilihan),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Checker> data = snapshot.data;
                return Container(
                  color: Color(0xFFF1F1F1),
                  child: ListView(
                      //padding: 10,
                      children: <Widget>[
                        //TampilButtonPage(),
                        Card(
                          child: Container(
                            padding: new EdgeInsets.all(3.0),
                            margin: new EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text("Filter By : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      // color: diorder,
                                    )),
                                Container(
                                  width: 90,
                                  height: 28,
                                  child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          pilihan = "0";

                                          visibleDiorder = false;
                                          visibleDiantar = true;
                                          visibleSelesai = true;
                                          warnaLabel = diorder;
                                        });
                                      },
                                      child: Text(
                                        "Diorder",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(color: diorder)),
                                      color: diorder),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  width: 90,
                                  height: 28,
                                  child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          pilihan = "1";

                                          visibleDiorder = true;
                                          visibleDiantar = false;
                                          visibleSelesai = true;
                                          warnaLabel = diantar;
                                        });
                                      },
                                      child: Text(
                                        "Diantar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(color: diantar)),
                                      color: diantar),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  width: 90,
                                  height: 28,
                                  child: RaisedButton(
                                      onPressed: () {
                                        pilihan = "2";

                                        visibleDiorder = true;
                                        visibleDiantar = true;
                                        visibleSelesai = false;
                                        warnaLabel = selesai;

                                        setState(() {});
                                      },
                                      child: Text(
                                        "Selesai",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(color: selesai)),
                                      color: selesai),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            //_controllers.add(new RaisedButton());

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
                                      Icon(
                                        Icons.label,
                                        color: warnaLabel,
                                      ),
                                      Text(
                                          data[index].qty +
                                              " X " +
                                              data[index].namaBarang,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            // color: diorder,
                                          )),
                                    ],
                                  ),
                                  Text(
                                      data[index].keterangan +
                                          "\nArea : " +
                                          data[index].kodeArea +
                                          " / Meja : " +
                                          data[index].kodeMeja,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        // color: diorder,
                                      )),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Visibility(
                                        visible: visibleDiorder,
                                        child: Container(
                                          width: 90,
                                          height: 28,
                                          child: RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  try {
                                                    EditChecker.editChecker(
                                                        data[index]
                                                            .id
                                                            .toString(),
                                                        "0");
                                                  } catch (_) {
                                                    print("Err");
                                                    throw Exception("Err.");
                                                  }
                                                });
                                              },
                                              child: Text(
                                                "Diorder",
                                                style:
                                                    TextStyle(color: diorder),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: diorder)),
                                              color: Colors.white),
                                        ),
                                      ),
                                      Visibility(
                                        visible: visibleDiorder,
                                        child: SizedBox(
                                          width: 7,
                                        ),
                                      ),
                                      Visibility(
                                        visible: visibleDiantar,
                                        child: Container(
                                          width: 90,
                                          height: 28,
                                          child: RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  try {
                                                    EditChecker.editChecker(
                                                        data[index]
                                                            .id
                                                            .toString(),
                                                        "1");
                                                  } catch (_) {
                                                    print("Err");
                                                    throw Exception("Err.");
                                                  }
                                                });
                                              },
                                              child: Text(
                                                "Diantar",
                                                style:
                                                    TextStyle(color: diantar),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: diantar)),
                                              color: Colors.white),
                                        ),
                                      ),
                                      Visibility(
                                        visible: visibleDiantar,
                                        child: SizedBox(
                                          width: 7,
                                        ),
                                      ),
                                      Visibility(
                                        visible: visibleSelesai,
                                        child: Container(
                                          width: 90,
                                          height: 28,
                                          child: RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  try {
                                                    EditChecker.editChecker(
                                                        data[index]
                                                            .id
                                                            .toString(),
                                                        "2");
                                                  } catch (_) {
                                                    print("Err");
                                                    throw Exception("Err.");
                                                  }
                                                });
                                              },
                                              child: Text("Selesai",
                                                  style: TextStyle(
                                                      color: selesai)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: selesai)),
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ));
                            /*
                          return ListTile(
                            title: Text(data[index].nama,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                )),
                            subtitle: Text(data[index].keterangan),
                            trailing: Text(data[index].qty),
                          );
                          */
                          },
                        ),
                      ]),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.data == null) {
                return Container(
                  color: Color(0xFFF1F1F1),
                  child: ListView(
                    //padding: 10,
                    children: <Widget>[
                      //TampilButtonPage(),
                      Card(
                        child: Container(
                          padding: new EdgeInsets.all(3.0),
                          margin: new EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text("Filter By : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    // color: diorder,
                                  )),
                              Container(
                                width: 90,
                                height: 28,
                                child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        pilihan = "0";

                                        visibleDiorder = false;
                                        visibleDiantar = true;
                                        visibleSelesai = true;

                                        warnaLabel = diorder;
                                      });
                                    },
                                    child: Text(
                                      "Diorder",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: diorder)),
                                    color: diorder),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                width: 90,
                                height: 28,
                                child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        pilihan = "1";

                                        visibleDiorder = true;
                                        visibleDiantar = false;
                                        visibleSelesai = true;

                                        warnaLabel = diantar;
                                      });
                                    },
                                    child: Text(
                                      "Diantar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: diantar)),
                                    color: diantar),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                width: 90,
                                height: 28,
                                child: RaisedButton(
                                    onPressed: () {
                                      pilihan = "2";

                                      visibleDiorder = true;
                                      visibleDiantar = true;
                                      visibleSelesai = false;

                                      warnaLabel = selesai;

                                      setState(() {});
                                    },
                                    child: Text(
                                      "Selesai",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: selesai)),
                                    color: selesai),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        "Data tidak ada!",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      )),
                    ],
                  ),
                );
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
