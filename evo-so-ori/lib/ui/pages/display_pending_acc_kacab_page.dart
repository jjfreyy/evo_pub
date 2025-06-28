part of 'pages.dart';

class DisplayPendingAccKacabPage extends StatefulWidget {
  final String hsl2;

  DisplayPendingAccKacabPage({Key key, @required this.hsl2}) : super(key: key);

  @override
  _DisplayPendingAccKacabPageState createState() =>
      _DisplayPendingAccKacabPageState();
}

class _DisplayPendingAccKacabPageState
    extends State<DisplayPendingAccKacabPage> {
  final dateformatter = new DateFormat("dd MMM yyyy HH:mm:ss");
  bool hasilExecute = false;
  bool dariDiProses = false;

  Future _execute(String documentID, String _jenis) async {
    hasilExecute = false;
    bool cekAdaGa;
    String sudah_acc_kacab;
    String spc_request;

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
      }
    }

    return _execute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: (widget.hsl2 == "1")
            ? Firestore.instance
                .collection("transaksi")
                .where("lokasi", isEqualTo: lokasi)
                .where("sudah_acc_kacab", isNull: true)
                .where("selesai", isNull: true)
                .where("flag_checkout", isEqualTo: "Y")
                .where("status_batal", isNull: true)
                .where("spc_request", whereIn: ["Y", "T"])
                //.where("spc_request", isEqualTo: "T")
                //.where("sudah_flag_spc_request", isNull: false)
                .snapshots()
            : (widget.hsl2 == "2")
                ? Firestore.instance
                    .collection("transaksi")
                    .where("lokasi", isEqualTo: lokasi)
                    .where("sudah_acc_kacab", isNull: true)
                    .where("selesai", isNull: true)
                    .where("flag_checkout", isEqualTo: "Y")
                    .where("status_batal", isNull: true)
                    .where("spc_request", isEqualTo: "Y")
                    .where("sudah_flag_spc_request", isNull: true)
                    .snapshots()
                : (widget.hsl2 == "3")
                    ? Firestore.instance
                        .collection("transaksi")
                        .where("lokasi", isEqualTo: lokasi)
                        .where("sudah_acc_kacab", isEqualTo: "Y")
                        .where("selesai", isNull: true)
                        .where("flag_checkout", isEqualTo: "Y")
                        .where("status_batal", isNull: true)
                        .snapshots()
                    : Firestore.instance
                        .collection("transaksi")
                        .where("lokasi", isEqualTo: lokasi)
                        .where("selesai", isEqualTo: "Y")
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    color: Colors.blue[50],
                                    child: Container(
                                      padding: new EdgeInsets.all(3.0),
                                      margin: new EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /*
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  snapshot.data[index]
                                                      .data["nama_customer"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    // color: diorder,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          */
                                          Text(
                                            snapshot.data.documents[index]
                                                .data["nama_customer"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              // color: diorder,
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            snapshot.data.documents[index]
                                                .documentID,
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data.documents[index]
                                                .data["lokasi"],
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            dateformatter.format(snapshot
                                                .data
                                                .documents[index]
                                                .data["tanggal"]
                                                .toDate()),
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data.documents[index]
                                                .data["userid"],
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data.documents[index]
                                                .data["jenis_transaksi"],
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Visibility(
                                            visible: (snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["ket_problem"] ==
                                                    null)
                                                ? false
                                                : true,
                                            child: (snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["ket_problem"] ==
                                                    null)
                                                ? Text("")
                                                : Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["ket_problem"],
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          Divider(),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            width: double.infinity,
                                            height: 40,
                                            child: RaisedButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  setState(() async {
                                                    try {
                                                      if (snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "selesai"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "status_batal"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_acc_kacab"] ==
                                                              null) {
                                                        bolehACC = "Y";
                                                      } else {
                                                        bolehACC = "T";
                                                      }

                                                      if (snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "selesai"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "status_batal"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_acc_kacab"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_flag_spc_request"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_sync"] ==
                                                              null) {
                                                        bolehSpcReq = "Y";
                                                      } else {
                                                        bolehSpcReq = "T";
                                                      }

                                                      if (snapshot.data.documents[index].data["selesai"] == null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "status_batal"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_acc_kacab"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_sync"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_proses"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "flag_plafon"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_plafon"] ==
                                                              null) {
                                                        bolehNaikPlafon = "Y";
                                                      } else {
                                                        bolehNaikPlafon = "T";
                                                      }

                                                      if (snapshot.data.documents[index].data["selesai"] == null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "status_batal"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_acc_kacab"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_sync"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_proses"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "flag_lama_jt"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_lama_jt"] ==
                                                              null) {
                                                        bolehTambahLamaJT = "Y";
                                                      } else {
                                                        bolehTambahLamaJT = "T";
                                                      }

                                                      if (snapshot.data.documents[index].data["selesai"] == null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "status_batal"] ==
                                                              null &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_acc_kacab"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_sync"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_proses"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "flag_stock_kurang"] ==
                                                              "Y" &&
                                                          snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  "sudah_stock_kurang"] ==
                                                              null) {
                                                        bolehACCStock = "Y";
                                                      } else {
                                                        bolehACCStock = "T";
                                                      }
                                                      final result =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => widget
                                                                        .hsl2 ==
                                                                    "2"
                                                                ? SpcRequestPage(
                                                                    dokumenID: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .documentID,
                                                                  )
                                                                : DetailTransaksiPage(
                                                                    dokumenID: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .documentID,
                                                                    hasil: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index],
                                                                  )),
                                                      );
                                                    } catch (_) {
                                                      print("Err");
                                                      throw Exception("Err.");
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  "Detail",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    side: BorderSide(
                                                        color:
                                                            Colors.green[300])),
                                                color: Colors.green[300]),
                                          ),
                                          //BATAL
                                          Visibility(
                                            visible: widget.hsl2 == "1" &&
                                                    roleBatal == "Y" &&
                                                    snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            "flag_checkout"] ==
                                                        "Y" &&
                                                    snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            "sudah_acc_kacab"] ==
                                                        null &&
                                                    snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["selesai"] ==
                                                        null &&
                                                    snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            "status_batal"] ==
                                                        null
                                                ? true
                                                : false,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: double.infinity,
                                              height: 40,
                                              child: RaisedButton(
                                                  elevation: 0,
                                                  onPressed: () {
                                                    setState(() async {
                                                      try {
                                                        if (snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "flag_checkout"] ==
                                                                "Y" &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "selesai"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "sudah_acc_kacab"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "status_batal"] ==
                                                                null) {
                                                          var firestore =
                                                              Firestore
                                                                  .instance;

                                                          await firestore
                                                              .collection(
                                                                  "transaksi")
                                                              .document(snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID)
                                                              .setData({
                                                            'status_batal': "Y",
                                                          }, merge: true);
                                                        } else {}
                                                      } catch (_) {
                                                        print("Err");
                                                        throw Exception("Err.");
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Batal",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .redAccent)),
                                                  color: Colors.redAccent),
                                            ),
                                          ),

                                          //REFRESH
                                          Visibility(
                                            visible: widget.hsl2 == "3" &&
                                                    roleRefresh == "Y" &&
                                                    snapshot.data.documents[index].data[
                                                            "flag_checkout"] ==
                                                        "Y" &&
                                                    snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["selesai"] ==
                                                        null &&
                                                    snapshot.data.documents[index].data[
                                                            "status_batal"] ==
                                                        null &&
                                                    snapshot.data.documents[index].data["ada_problem"] ==
                                                        "Y" &&
                                                    snapshot.data.documents[index].data[
                                                            "flag_lama_jt"] ==
                                                        null &&
                                                    snapshot.data.documents[index].data["flag_plafon"] ==
                                                        null &&
                                                    snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["flag_stock_kurang"] ==
                                                        null
                                                ? true
                                                : false,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: double.infinity,
                                              height: 40,
                                              child: RaisedButton(
                                                  elevation: 0,
                                                  onPressed: () {
                                                    setState(() async {
                                                      try {
                                                        if (snapshot.data.documents[index].data["flag_checkout"] == "Y" &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "selesai"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "status_batal"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "ada_problem"] ==
                                                                "Y" &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "flag_lama_jt"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "flag_plafon"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "flag_stock_kurang"] ==
                                                                null) {
                                                          var firestore =
                                                              Firestore
                                                                  .instance;

                                                          await firestore
                                                              .collection(
                                                                  "transaksi")
                                                              .document(snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID)
                                                              .setData({
                                                            'sudah_sync': null,
                                                            'sudah_proses':
                                                                null,
                                                            'ada_problem': null,
                                                            'ket_problem': null,
                                                          }, merge: true);
                                                        } else {}
                                                      } catch (_) {
                                                        print("Err");
                                                        throw Exception("Err.");
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Refresh",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .blue[300])),
                                                  color: Colors.blue[300]),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.hsl2 == "3" &&
                                                    roleRefreshKhusus == "Y" &&
                                                    snapshot.data.documents[index].data["flag_checkout"] ==
                                                        "Y" &&
                                                    snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["selesai"] ==
                                                        null &&
                                                    snapshot.data.documents[index].data[
                                                            "status_batal"] ==
                                                        null &&
                                                    snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            "ada_problem"] ==
                                                        "Y" &&
                                                    snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            "flag_lama_jt"] ==
                                                        null &&
                                                    snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["flag_plafon"] ==
                                                        null
                                                ? true
                                                : false,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: double.infinity,
                                              height: 40,
                                              child: RaisedButton(
                                                  elevation: 0,
                                                  onPressed: () {
                                                    setState(() async {
                                                      try {
                                                        if (snapshot.data.documents[index].data["flag_checkout"] == "Y" &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "selesai"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "status_batal"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "ada_problem"] ==
                                                                "Y" &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "flag_lama_jt"] ==
                                                                null &&
                                                            snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    "flag_plafon"] ==
                                                                null) {
                                                          var firestore =
                                                              Firestore
                                                                  .instance;

                                                          await firestore
                                                              .collection(
                                                                  "transaksi")
                                                              .document(snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID)
                                                              .setData({
                                                            'sudah_sync': null,
                                                            'sudah_proses':
                                                                null,
                                                            'ada_problem': null,
                                                            'ket_problem': null,
                                                          }, merge: true);
                                                        } else {}
                                                      } catch (_) {
                                                        print("Err");
                                                        throw Exception("Err.");
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Refresh Khusus",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.red[300])),
                                                  color: Colors.red[300]),
                                            ),
                                          )

                                          ///////////////////////////////////////////////////
                                        ],
                                      ),
                                    ));
                              },
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
      ),
    );

    /*scaffold
        Container(
        child: FutureBuilder(
          future: _getRekap(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length > 0
                  ?
      */
  }
}
