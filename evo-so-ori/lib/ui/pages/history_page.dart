part of 'pages.dart';

class HistoryPage extends StatefulWidget {
  final String hsl2;

  HistoryPage({Key key, @required this.hsl2}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final dateformatter = new DateFormat("dd MMM yyyy HH:mm:ss");
  final dateformatter2 = new DateFormat("dd MMM yyyy");
  final dateformatterUntukVariable = new DateFormat("yyyy-MM-dd");

  TextEditingController dariController = TextEditingController();
  TextEditingController sampaiController = TextEditingController();

  bool hasilExecute = false;
  bool dariDiProses = false;
  String _selectedDate1 = "";
  String _selectedDate2 = "";

  String _tempselectedDate1 = "";
  String _tempselectedDate2 = "";

  @override
  void initState() {
    super.initState();

    _tempselectedDate1 = dateformatterUntukVariable.format(DateTime.now());
    _tempselectedDate2 = dateformatterUntukVariable.format(DateTime.now());

    //_selectedDate1 = dateformatterUntukVariable.format(DateTime.now());
    //_selectedDate2 = dateformatterUntukVariable.format(DateTime.now());
    _selectedDate1 = "2021-01-01";
    _selectedDate2 = "2021-01-01";

    dariController..text = dateformatter2.format(DateTime.now());
    sampaiController..text = dateformatter2.format(DateTime.now());
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
                        .where("status_batal", isNull: true)
                        .where("tanggal",
                            isGreaterThanOrEqualTo:
                                DateTime.parse(_selectedDate1))
                        .where("tanggal",
                            isLessThanOrEqualTo:
                                DateTime.parse(_selectedDate2 + ' 23:59:59'))
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
                        Container(
                          margin: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black38,
                            ),
                          ),
                          width: (MediaQuery.of(context).size.width / 2),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width:
                                        (MediaQuery.of(context).size.width / 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    child: Text(
                                      "Dari",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    child: Text(
                                      "Sampai",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                              2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: dariController,
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2021),
                                        lastDate: DateTime(2025),
                                      ).then((value) {
                                        setState(() {
                                          _selectedDate1 =
                                              dateformatterUntukVariable
                                                  .format(value);
                                          // _selectedDate2 = dateformatter2.format(value);
                                          dariController
                                            ..text =
                                                dateformatter2.format(value);
                                          //sampaiController..text = _selectedDate2;
                                        });
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              15,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: sampaiController,
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2021),
                                        lastDate: DateTime(2025),
                                      ).then((value) {
                                        setState(() {
                                          // _selectedDate1 =
                                          //dateformatter2.format(value);
                                          _selectedDate2 =
                                              dateformatterUntukVariable
                                                  .format(value);
                                          //dariController..text = _selectedDate1;
                                          sampaiController
                                            ..text =
                                                dateformatter2.format(value);
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
