part of 'pages.dart';

class Meja {
  final String kodeArea;
  final String kodeMeja;
  final String keterangan;
  final String cust;

  Meja({this.kodeArea, this.kodeMeja, this.keterangan, this.cust});

  factory Meja.fromJson(Map<String, dynamic> json) {
    return Meja(
      kodeArea: json['lantai'],
      kodeMeja: json['no_meja'],
      keterangan: json['keterangan'],
      cust: json['cust'],
    );
  }
}

Future<List<Meja>> _getMeja(lokasi, kodeArea) async {
  final apiUrl = myUrl;
  final response = await http
      .get(apiUrl + 'getmeja.php?lok=' + lokasi + '&area=' + kodeArea);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    //return jsonResponse.map((job) => new Job.fromJson(job)).toList();

    List<dynamic> isi = (jsonResponse as Map<String, dynamic>)["data"];

    List<Meja> _isi = [];
    for (int i = 0; i < isi.length; i++) _isi.add(Meja.fromJson(isi[i]));

    return _isi;
  } else {
    throw Exception('Failed to load!');
  }
}

/* untuk simpan meja */

class SimpanMeja {
  final String xkodeUnik;

  SimpanMeja({this.xkodeUnik});

  factory SimpanMeja.createPostResult(Map<String, dynamic> json) {
    return SimpanMeja(
      xkodeUnik: json['hasil'],
    );
  }

  static Future<SimpanMeja> simpanMeja(_kdUnik, _kodeArea, _kodeMeja) async {
    String apiUrl = myUrl + 'simpanmeja.php';

    var apiResult = await http.post(apiUrl, body: {
      "lokasi": lokasi,
      "kode_unik": _kdUnik,
      "kode_area": _kodeArea,
      "kode_meja": _kodeMeja,
    });
    var jsonObject = json.decode(apiResult.body);

    return SimpanMeja.createPostResult(jsonObject);
  }
}

ListView _mejaListView(data) {
  SimpanMeja postResult;

  return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index].keterangan,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              )),
          subtitle: Text(
            data[index].cust,
            style: TextStyle(color: Colors.black),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.blue[500],
          ),
          onTap: () async {
            var randomGenerator = Random();
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('kkmmssd').format(now);

            kodeUnik = formattedDate +
                randomGenerator.nextInt(10000).toString() +
                randomGenerator.nextInt(10000).toString();
            try {
              // /_kdUnik, _idCart, _qty, _jenis
              await SimpanMeja.simpanMeja(
                kodeUnik,
                data[index].kodeArea,
                data[index].kodeMeja,
              ).then((value) => postResult = value);

              if (postResult != null) {
                /*
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerPage(
                      meja: data[index],
                    ),
                  ),
                );
                */
              }
            } catch (_) {
              print("Err");
              throw Exception("Err.");
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: data.length);
}

class MejaPage extends StatelessWidget {
  final Area area;

  MejaPage({Key key, @required this.area}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Meja'),
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
        child: FutureBuilder<List<Meja>>(
          future: _getMeja(lokasi, area.kodeArea),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Meja> data = snapshot.data;
              return _mejaListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Align(
          alignment: Alignment.bottomCenter,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
