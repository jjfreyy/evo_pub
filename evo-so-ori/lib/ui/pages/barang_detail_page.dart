part of 'pages.dart';

class SimpanSementara {
  final String xhasil;
  //final String kodeBarang;
  //final String keterangan;
  //final String qty;
  //final String xlokasi;

  SimpanSementara({
    this.xhasil,
    //this.kodeBarang,
    //this.keterangan,
    //this.qty,
    //this.xlokasi
  });

  factory SimpanSementara.createPostResult(Map<String, dynamic> json) {
    return SimpanSementara(
      //xlokasi: lokasi,
      xhasil: json['hasil'],
      //keterangan: json['keterangan'],
      //qty: json['jumlah']
    );
  }

  static Future<SimpanSementara> simpanSementara(
      _kdUnik, _kodeBarang, _keterangan, _qty) async {
    String apiUrl = myUrl + 'simpansementara.php';

    var apiResult = await http.post(apiUrl, body: {
      "kode_unik": _kdUnik,
      "lokasi": lokasi,
      "kode_barang": _kodeBarang,
      "keterangan": _keterangan,
      "qty": _qty
    });
    var jsonObject = json.decode(apiResult.body);

    return SimpanSementara.createPostResult(jsonObject);
  }
}

class BarangDetailPage extends StatefulWidget {
  //final Brg brgData;

  //BarangDetailPage({Key key, @required this.brgData});

  @override
  _BarangDetailPageState createState() => _BarangDetailPageState();
}

class _BarangDetailPageState extends State<BarangDetailPage> {
  TextEditingController kbController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jmlController = TextEditingController();
  TextEditingController ketController = TextEditingController();

  int jml = 1;
  SimpanSementara postResult;

  @override
  void initState() {
    super.initState();

    kbController.text = "";
    /*widget.brgData.kodeBarang;*/
    namaController.text = ""; /*widget.brgData.namaBarang;*/
    jmlController.text = jml.toString();
    ketController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Detail Menu"),
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
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          margin: EdgeInsets.symmetric(vertical: 24),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: kbController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      labelText: "Kode Menu",
                      hintText: "Kode Menu"),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: namaController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      labelText: "Nama",
                      hintText: "Nama"),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: ketController,
                  enabled: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      labelText: "Keterangan",
                      hintText: "Keterangan"),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: RaisedButton(
                            child: Text("-"),
                            onPressed: () {
                              setState(() {
                                if (jml > 1) {
                                  jml--;
                                  jmlController.text = jml.toString();
                                }
                              });
                            }),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: jmlController,
                          enabled: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              labelText: "Qty",
                              hintText: "Qty"),
                          onChanged: (String value) {
                            setState(() {
                              jml = int.parse(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: 50,
                        child: RaisedButton(
                            child: Text("+"),
                            onPressed: () {
                              setState(() {
                                jml++;
                                jmlController.text = jml.toString();
                              });
                            }),
                      ),
                    ]),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                      child: Text("Add Cart"),
                      color: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      onPressed: () async {
                        if (jmlController.text == "" ||
                            jmlController.text == "0") {
                          Flushbar(
                            title: "Peringatan!",
                            message: "Qty harus diisi!",
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else {
                          try {
                            String hasilKet;
                            if (ketController.text == "") {
                              hasilKet = "";
                            } else {
                              hasilKet = ketController.text;
                            }
                            await SimpanSementara.simpanSementara(
                                    kodeUnik,
                                    kbController.text,
                                    hasilKet,
                                    jmlController.text)
                                .then((value) => postResult = value);

                            if (postResult.xhasil.toString() == "ok" ||
                                postResult != null) {
                              /*
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                ),
                              );
                              */

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                  (Route<dynamic> route) => false);
                            }
                          } catch (_) {
                            print("Err");
                            throw Exception("Err.");
                          }
                        }
                      }),
                )
              ],
            ),
          ])),
    );
  }
}
