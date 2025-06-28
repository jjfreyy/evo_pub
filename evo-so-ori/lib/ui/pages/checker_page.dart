part of 'pages.dart';
/*
class Checker {
  final String kodeArea;
  final String kodeMeja;
  final String namaBarang;
  final String qty;
  final String keterangan;
  final String jamOrder;
  final String tglOrder;
  final String id;

  Checker({
    this.kodeArea,
    this.kodeMeja,
    this.namaBarang,
    this.qty,
    this.keterangan,
    this.jamOrder,
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
      jamOrder: json['jam'],
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
    throw Exception('Failed to load!');
  }
}

class CheckerPage extends StatefulWidget {
  @override
  _CheckerPageState createState() => _CheckerPageState();
}

class _CheckerPageState extends State<CheckerPage> {
  List<bool> inputs = new List<bool>();
  String pilihan = "0";

/*
  @override
  void initState() {
    super.initState();

    setState(() {
      for (int i = 0; i < 20; i++) {
        inputs.add(false);
      }
    });
  }

  void itemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checker'),
        backgroundColor: appbarColor,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Checker>>(
        future: _getChecker(lokasi, pilihan),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Checker> data = snapshot.data;

            for (int i = 0; i < data.length; i++) {
              inputs.add(false);
            }

            return Container(
                child: ListView(
                    //padding: 10,
                    children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: RaisedButton(
                          onPressed: () {
                            pilihan = "0";
                            inputs.clear();

                            setState(() {});
                          },
                          child: Text(
                            "Di Order",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: RaisedButton(
                          onPressed: () {
                            pilihan = "1";
                            inputs.clear();
                            setState(() {});
                          },
                          child: Text(
                            "Sebagian",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        child: new Container(
                          padding: new EdgeInsets.all(3.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new CheckboxListTile(
                                  value: inputs[index],
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(data[index].qty +
                                      " X " +
                                      data[index].namaBarang),
                                  subtitle: Text(
                                      data[index].keterangan +
                                          "\n Area : " +
                                          data[index].kodeArea +
                                          " / Meja : " +
                                          data[index].kodeMeja,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      )),
                                  onChanged: (bool value) {
                                    /*
                                    setState(() {
                                      inputs[index] = value;
                                    });
                                    */
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Text("Pilih : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      )),
                  RaisedButton(
                    child: Text("Simpan"),
                    onPressed: () {},
                  )
                ]));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
*/
