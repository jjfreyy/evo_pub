part of 'pages.dart';

class KatBrgPage extends StatefulWidget {
  @override
  _KatBrgPageState createState() => _KatBrgPageState();
}

class _KatBrgPageState extends State<KatBrgPage> {
  //Future _data;

  Future _getKat() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("kategori_barang")
        //.where("kode_kategori", isEqualTo: "xx")
        .orderBy("nama")
        .getDocuments();

    return qn.documents;
  }

/*
  void initState() {
    super.initState();

    _data = _getKat();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: _getKat(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: new EdgeInsets.all(0.0),
                height: 360,
                margin:
                    new EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
                child: snapshot.data.length > 0
                    ? ListView(
                        children: <Widget>[
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            children:
                                List.generate(snapshot.data.length, (index) {
                              return FlatButton(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        shape: BoxShape.rectangle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                            snapshot.data[index]
                                                        .data["image"] !=
                                                    null
                                                ? snapshot
                                                    .data[index].data["image"]
                                                : noImageUrl,
                                          ),
                                        ),
                                      ),
/*
                                child: Image.network(
                                  snapshot.data[index].data["image"] != null
                                      ? snapshot.data[index].data["image"]
                                      : "https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg",
                                ),*/
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(snapshot.data[index].data["nama"]),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BarangPage(
                                          hasil: snapshot.data[index]),
                                    ),
                                  );
                                },
                              );
                            }),
                          )
                        ],
                      )
                    : tidakAdaData());
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
    ));
  }
}
