part of 'pages.dart';

class BrgDetailPage extends StatefulWidget {
  final DocumentSnapshot hasil;

  BrgDetailPage({Key key, @required this.hasil}) : super(key: key);

  @override
  _BrgDetailPageState createState() => _BrgDetailPageState();
}

class _BrgDetailPageState extends State<BrgDetailPage> {
  TextEditingController jmlController = TextEditingController();
  int jml = 1;
  bool cekAdaGa;
  bool hasil = false;

  Future _simpanCart() async {
    hasil = false;
    int jmlLama;

    var firestore = Firestore.instance;
    await firestore
        .collection("transaksi_detail")
        .document(kodeUnik)
        .collection("brg")
        .document(lokasi + pemisah + widget.hasil["kode_barang"])
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists == true)
              {
                jmlLama = docSnapshot.data["jumlah"],
                cekAdaGa = true,
              }
            else
              {
                cekAdaGa = false,
              }
          },
        );

    if (cekAdaGa == false) {
      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(lokasi + pemisah + widget.hasil["kode_barang"])
          .setData(
        {
          'kode_transaksi': kodeUnik,
          'kode_barang': widget.hasil["kode_barang"],
          'nama_barang': widget.hasil["nama_barang"],
          'jumlah': int.parse(jmlController.text),
          'kode_customer': "",
          'nama_customer': "",
          'flag_paket': "T",
          'kode_paket': null,
          'kode_paket2': null
        },
      ).then((docSnapshot) => {hasil = true});
    } else {
      await firestore
          .collection("transaksi_detail")
          .document(kodeUnik)
          .collection("brg")
          .document(lokasi + pemisah + widget.hasil["kode_barang"])
          .setData({
        'jumlah': jmlLama + int.parse(jmlController.text),
      }, merge: true).then((docSnapshot) => {hasil = true});
    }

    return _simpanCart;
  }

  @override
  void initState() {
    super.initState();

    jmlController.text = jml.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/top.jpg"),
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 50, left: defaultMargin),
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.04)),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 8, right: 5, top: 25, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.hasil.data["nama_barang"],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Stock : " +
                      NumberFormat.currency(
                        locale: "en",
                        symbol: "",
                        decimalDigits: 0,
                      ).format(widget.hasil.data["stock"]),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      child: Text(
                        "-",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      textColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          if (jml > 1) {
                            jml--;
                            jmlController.text = jml.toString();
                          }
                          FocusScope.of(context)
                              .requestFocus(new FocusNode()); //remove focus
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          side: BorderSide(color: btnPlusMin)),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 120,
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: jmlController,
                      enabled: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          contentPadding: EdgeInsets.only(top: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          hintText: "Qty"),
                      onChanged: (String value) {
                        setState(() {
                          jml = int.parse(value);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      child: Text(
                        "+",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      textColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          jml++;
                          jmlController.text = jml.toString();
                        });
                        FocusScope.of(context)
                            .requestFocus(new FocusNode()); //remove focus
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          side: BorderSide(color: btnPlusMin)),
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(defaultMargin),
            width: double.infinity,
            height: 40,
            child: RaisedButton(
                elevation: 0,
                onPressed: () {
                  setState(() async {
                    try {
                      await _simpanCart();
                      String hasilString;

                      if (hasil == true) {
                        hasilString = "Item Berhasil Ditambahkan";

                        Navigator.pop(context, hasilString);
                      } else {
                        hasilString = "Gagal";

                        SnackBar(
                          content: Text("Item Gagal Ditambahkan!"),
                          duration: Duration(seconds: 2),
                        );
                      }
                    } catch (_) {
                      print("Err");
                      throw Exception("Err.");
                    }
                  });
                },
                child: Text(
                  "Tambah",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: btnAddToCart)),
                color: btnAddToCart),
          ),
        ],
      ),
    ));
  }
}
