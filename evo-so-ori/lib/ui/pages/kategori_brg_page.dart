part of 'pages.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(2.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        /*child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),*/
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class KategoriBrgPage extends StatefulWidget {
  @override
  _KategoriBrgPageState createState() => _KategoriBrgPageState();
}

class _KategoriBrgPageState extends State<KategoriBrgPage> {
  Future _data;

  Future _getKat() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("kategori_barang")
        .orderBy("nama")
        .getDocuments();

    return qn.documents;
  }

  void initState() {
    super.initState();

    _data = _getKat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding: new EdgeInsets.all(3.0),
                  color: Color(0xFFF1F1F1),
                  /*margin:
                  new EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              */
                  child: Container(
                    padding: new EdgeInsets.only(top: 8.0),
                    margin: new EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 0),
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          height: 200,
                          color: Color(0xFFF1F1F1),
                          child: GridView.count(
                            crossAxisCount: 2,
                            scrollDirection: Axis.horizontal,
                            primary: false,
                            children:
                                List.generate(snapshot.data.length, (index) {
                              return FlatButton(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 500,
                                      height: 50,
                                      child: Image.network(
                                        snapshot.data[index].data["image"] !=
                                                null
                                            ? snapshot.data[index].data["image"]
                                            : "https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(snapshot.data[index].data["nama"]),
                                  ],
                                ),
                                onPressed: () {},
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
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
        ));
  }
}
