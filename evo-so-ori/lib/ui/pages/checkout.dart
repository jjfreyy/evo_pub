part of 'pages.dart';

class Checkout {
  final String idCart;
  final String kodeBarang;
  final String nama;
  final String keterangan;
  final String qty;
  final String kodeArea;
  final String kodeMeja;
  final String namaCust;

  Checkout({
    this.idCart,
    this.kodeBarang,
    this.nama,
    this.keterangan,
    this.qty,
    this.kodeArea,
    this.kodeMeja,
    this.namaCust,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(
      idCart: json['id_cart'],
      kodeBarang: json['kode_kategori'],
      nama: json['nama'],
      keterangan: json['keterangan'],
      qty: json['qty'],
      kodeArea: json['kode_area'],
      kodeMeja: json['kode_meja'],
      namaCust: json['nama_customer'],
    );
  }
}

Future<List<Checkout>> _getCheckout(lokasi, kdunik) async {
  final apiUrl = myUrl;
  final response =
      await http.get(apiUrl + 'getcart.php?lok=' + lokasi + '&unik=' + kdunik);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    //return jsonResponse.map((job) => new Job.fromJson(job)).toList();

    List<dynamic> isi = (jsonResponse as Map<String, dynamic>)["data"];

    List<Checkout> _isi = [];
    for (int i = 0; i < isi.length; i++) _isi.add(Checkout.fromJson(isi[i]));

    return _isi;
  } else {
    //throw Exception('Failed to load!');
    return null;
  }
}

/*ini untuk kurang tambah delete */

class EditCart {
  final String xkodeUnik;
  final String idCart;

  EditCart({this.xkodeUnik, this.idCart});

  factory EditCart.createPostResult(Map<String, dynamic> json) {
    return EditCart(
      xkodeUnik: lokasi,
      idCart: json['id_cart'],
    );
  }

  static Future<EditCart> editCart(
    _kdUnik,
    _idCart,
    _jenis,
  ) async {
    String apiUrl = myUrl + 'editcart.php';

    var apiResult = await http.post(apiUrl, body: {
      "kode_unik": _kdUnik,
      "id_cart": _idCart,
      "jenis": _jenis,
    });
    var jsonObject = json.decode(apiResult.body);

    return EditCart.createPostResult(jsonObject);
  }
}

/*simpan cart*/

class SimpanCart {
  final String xhasil;

  SimpanCart({this.xhasil});

  factory SimpanCart.createPostResult(Map<String, dynamic> json) {
    return SimpanCart(
      xhasil: json['hasil'],
    );
  }

  static Future<SimpanCart> simpanCart(_kdUnik) async {
    String apiUrl = myUrl + 'simpancheckout.php';

    var apiResult = await http.post(apiUrl, body: {
      "lokasi": lokasi,
      "kode_unik": _kdUnik,
    });
    var jsonObject = json.decode(apiResult.body);

    return SimpanCart.createPostResult(jsonObject);
  }
}

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController jmlController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  List<TextEditingController> _controllers = new List();
  SimpanCart postResult;

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<List<Checkout>>(
            future: _getCheckout(lokasi, kodeUnik),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Checkout> data = snapshot.data;
                return Container(
                  child: ListView(
                      //padding: 10,
                      children: <Widget>[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            _controllers.add(new TextEditingController());

                            return Container(
                              margin: new EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index].nama,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      )),
                                  Text(data[index].keterangan,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      )),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 40,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                try {
                                                  // /_kdUnik, _idCart, _qty, _jenis
                                                  EditCart.editCart(
                                                      kodeUnik,
                                                      data[index]
                                                          .idCart
                                                          .toString(),
                                                      "hapus");
                                                } catch (_) {
                                                  print("Err");
                                                  throw Exception("Err.");
                                                }
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 25,
                                        width: 40,
                                        child: RaisedButton(
                                            onPressed: () {
                                              if (int.parse(data[index].qty) >
                                                  1) {
                                                setState(() {
                                                  try {
                                                    // /_kdUnik, _idCart, _qty, _jenis
                                                    EditCart.editCart(
                                                        kodeUnik,
                                                        data[index]
                                                            .idCart
                                                            .toString(),
                                                        "kurang");
                                                  } catch (_) {
                                                    print("Err");
                                                    throw Exception("Err.");
                                                  }
                                                });
                                              }
                                            },
                                            child: Text("-")),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 50,
                                        height: 31,
                                        child: TextField(
                                          controller: _controllers[index]
                                            ..text = data[index].qty,
                                          enabled: false,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 25,
                                        width: 40,
                                        child: RaisedButton(
                                            onPressed: () {
                                              setState(() {
                                                try {
                                                  // /_kdUnik, _idCart, _qty, _jenis
                                                  EditCart.editCart(
                                                      kodeUnik,
                                                      data[index]
                                                          .idCart
                                                          .toString(),
                                                      "tambah");
                                                } catch (_) {
                                                  print("Err");
                                                  throw Exception("Err.");
                                                }
                                              });
                                            },
                                            child: Text("+")),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
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
                          separatorBuilder: (context, index) => Divider(),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Text("Area : " + data[0].kodeArea,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                        Text("Meja : " + data[0].kodeMeja,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                        Text("Cust : " + data[0].namaCust,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                        RaisedButton(
                          child: Text("Simpan"),
                          onPressed: () async {
                            try {
                              // /_kdUnik, _idCart, _qty, _jenis
                              await SimpanCart.simpanCart(
                                kodeUnik,
                              ).then((value) => postResult = value);

                              if (postResult.xhasil.toString() == "ok" ||
                                  postResult != null) {
                                /*  
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AreaPage()),
                                );
  */

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => AreaPage()),
                                    (Route<dynamic> route) => false);
                              }
                            } catch (_) {
                              print("Err");
                              throw Exception("Err.");
                            }
                          },
                        )
                      ]),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.data == null) {
                return Center(
                    child: Text(
                  "Data tidak ada!",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ));
              }
              return CircularProgressIndicator();
            }));

    /*
    return Container(
        child:  
      FutureBuilder<List<Checkout>>(
        future: _getCheckout(lokasi, kodeUnik),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Checkout> data = snapshot.data;
            return _checkoutListView(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
    */
  }
}
