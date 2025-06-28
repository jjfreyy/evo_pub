part of 'pages.dart';

class SubKategoriBrg {
  final String kodeKategori;
  final String kodeSubKategori;
  final String keterangan;

  SubKategoriBrg({this.kodeKategori, this.kodeSubKategori, this.keterangan});

  factory SubKategoriBrg.fromJson(Map<String, dynamic> json) {
    return SubKategoriBrg(
      kodeKategori: json['kode_kategori'],
      kodeSubKategori: json['kode_sub_kategori'],
      keterangan: json['keterangan'],
    );
  }
}

Future<List<SubKategoriBrg>> _getSubKategoriBrg(lokasi, kodeKategori) async {
  final apiUrl = myUrl;
  final response = await http.get(
      apiUrl + 'getsubkategori.php?lok=' + lokasi + '&kat=' + kodeKategori);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    //return jsonResponse.map((job) => new Job.fromJson(job)).toList();

    List<dynamic> isi = (jsonResponse as Map<String, dynamic>)["data"];

    List<SubKategoriBrg> _isi = [];
    for (int i = 0; i < isi.length; i++)
      _isi.add(SubKategoriBrg.fromJson(isi[i]));

    return _isi;
  } else {
    throw Exception('Failed to load!');
  }
}

ListView _subKategoriListView(data) {
  return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index].keterangan,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              )),
          //subtitle: Text(data[index].company),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.blue[500],
          ),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: data.length);
}

class SubKategoriBarangPage extends StatelessWidget {
  //final KategoriBrg kategoriBarang;

  //SubKategoriBarangPage({Key key, @required this.kategoriBarang})
  //  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Sub Kategori'),
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
          /* child: FutureBuilder<List<SubKategoriBrg>>(
          future: _getSubKategoriBrg(lokasi, kategoriBarang.kodeKategori),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SubKategoriBrg> data = snapshot.data;
              return _subKategoriListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),*/
          ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton.extended(
            onPressed: () {
              /*
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (contex) => CheckerPage()));

                  */

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => CheckerPage()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.check_box),
            label: Text("Checker"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
