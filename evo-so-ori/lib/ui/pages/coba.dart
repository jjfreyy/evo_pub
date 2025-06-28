part of 'pages.dart';

class MyAPPx extends StatefulWidget {
  @override
  _MyAPPxState createState() => _MyAPPxState();
}

class _MyAPPxState extends State<MyAPPx> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Coba Listviews")),
        body: Column(
          children: [
            RaisedButton(
                child: Text("backup transaksi detail"),
                onPressed: () async {
                  var firestore = Firestore.instance;

                  await firestore
                      .collection("transaksi_detail")
                      .getDocuments()
                      .then((QuerySnapshot snapShot) async {
                    snapShot.documents.forEach((element) async {
                      await firestore
                          .collection("transaksi_detail_old2")
                          .document(element.documentID)
                          .setData(element.data);
                    });
                  });
                }),
            RaisedButton(
                child: Text("update users"),
                onPressed: () async {
                  var firestore = Firestore.instance;

                  await firestore
                      .collection("users")
                      // .where("userid", isEqualTo: "HENDRY")
                      .getDocuments()
                      .then((QuerySnapshot snapShot) async {
                    snapShot.documents.forEach((element) async {
                      await firestore
                          .collection("users")
                          .document(element.documentID)
                          .setData({
                        'batal': 'T',
                        'batal_sdg_proses': 'T',
                        //'vrs': '1.0.0.4',
                      }, merge: true);
                    });
                  });
                }),
            RaisedButton(
                child: Text("update kolom transaksi"),
                onPressed: () async {
                  var firestore = Firestore.instance;

                  await firestore
                      .collection("transaksi")
                      // .where("userid", isEqualTo: "HENDRY")
                      .getDocuments()
                      .then((QuerySnapshot snapShot) async {
                    snapShot.documents.forEach((element) async {
                      await firestore
                          .collection("transaksi")
                          .document(element.documentID)
                          .setData({
                        'kode_transaksi': element.documentID,
                        //'vrs': '1.0.0.4',
                      }, merge: true);
                    });
                  });
                }),
            RaisedButton(
                child: Text("Delete barang"),
                onPressed: () async {
                  var firestore = Firestore.instance;

                  await firestore
                      .collection("barang")
                      .where("kode_barang", whereIn: [
                        '0710535448411',
                        '0710535448451',
                        '0710535448518',
                        '0710535448641',
                        '0745114272454',
                        '0745114272508',
                        '6901619090120',
                      ])
                      .getDocuments()
                      .then((QuerySnapshot snapShot) async {
                        snapShot.documents.forEach((element) async {
                          await firestore
                              .collection("barang")
                              .document(element.documentID)
                              .delete();
                        });
                      });
                }),
            RaisedButton(
                child: Text("Delete detail paket"),
                onPressed: () async {
                  var firestore = Firestore.instance;

                  await firestore
                      .collection("paket_detail")
                      .where("kode_so", isEqualTo: "DIST PEKANBARU")
                      .where("kode_paket", isEqualTo: "PAKET_MIX_5")
                      .getDocuments()
                      .then((QuerySnapshot snapShot) async {
                    snapShot.documents.forEach((element) async {
                      await firestore
                          .collection("paket_detail")
                          .document(element.documentID)
                          .delete();
                    });
                  });
                }),
            RaisedButton(
                child: Text("Delete paket"),
                onPressed: () async {
                  var firestore = Firestore.instance;

                  await firestore
                      .collection("paket")
                      .where("kode_so", isEqualTo: "DIST PEKANBARU")
                      .where("kode_paket", isEqualTo: "PAKET_MIX_5")
                      .getDocuments()
                      .then((QuerySnapshot snapShot) async {
                    snapShot.documents.forEach((element) async {
                      await firestore
                          .collection("paket")
                          .document(element.documentID)
                          .delete();
                    });
                  });
                }),
            RaisedButton(
              child: Text("Cupertino Dialog"),
              onPressed: () {
                _showDialog();
              },
            ),
            RaisedButton(
              child: Text("Simpan Batch"),
              onPressed: () async {
                var firestore = Firestore.instance;
                WriteBatch batch = firestore.batch();

                DocumentReference documentReference = firestore
                    .collection("trans_detail")
                    .document(kodeUnik)
                    .collection("brg")
                    .document("a");

                DocumentReference documentReference2 = firestore
                    .collection("trans")
                    .document(kodeUnik)
                    .collection("brg")
                    .document("a");

                batch.setData(documentReference, {
                  'kode_transaksi': kodeUnik,
                  'kode_customer': "PT1",
                  'nama_customer': "PT 123",
                });

                batch.setData(documentReference2, {
                  'kode_transaksi': kodeUnik,
                  'flag_paket': "Y",
                });
                batch.delete(
                  documentReference2,
                );
                await batch.commit();
              },
            ),
            RaisedButton(
              child: Text("Simpan Transaction"),
              onPressed: () async {
                var firestore = Firestore.instance;
                WriteBatch batch = firestore.batch();

                await firestore.runTransaction((transaction) async {
                  CollectionReference accountsRef =
                      firestore.collection('trans');
                  DocumentReference acc1Ref = accountsRef.document('R451');
                  DocumentReference acc2Ref = accountsRef.document('account2');

                  //DocumentSnapshot acc1snap = await transaction.get(acc1Ref);
                  //DocumentSnapshot acc2snap = await transaction.get(acc2Ref);
/*
                  batch.setData(acc1Ref, {
                    'kode_transaksi': kodeUnik,
                    'flag_paket': "Y",
                  });

                  await batch.commit();
*/
                  await transaction.update(acc1Ref, {'statusx': 'adaxxx8'});
                  await transaction.update(acc2Ref, {'statusxd': 'adaxxx2'});
//INI GA BS DIPAKE. KRN KALO YG PERTAMA SUKSES, YG KE DUA GA SUKSES, MAKA YG PERTAMA KE UPDATE, SEDANGKAN KE 2 GA KE UPDATE

                  /*  if (acc1snap.exists) {
                    await transaction.update(acc1Ref, {'status': 'ada'});
                  } else {
                    await transaction.update(acc1Ref, {'status': 'baru'});
                  }*/
                }, timeout: Duration(seconds: 60));
              },
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Full Name', hintText: 'eg. John Smith'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('OPEN'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
/*
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
*/
