part of 'pages.dart';

class Area {
  final String kodeArea;
  final String keterangan;

  Area({this.kodeArea, this.keterangan});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      kodeArea: json['lantai'],
      keterangan: json['keterangan'],
    );
  }
}

Future<List<Area>> _getArea(lokasi) async {
  final apiUrl = myUrl;
  final response = await http.get(apiUrl + 'getarea.php?lok=' + lokasi);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    //return jsonResponse.map((job) => new Job.fromJson(job)).toList();

    List<dynamic> isi = (jsonResponse as Map<String, dynamic>)["data"];

    List<Area> _isi = [];
    for (int i = 0; i < isi.length; i++) _isi.add(Area.fromJson(isi[i]));

    return _isi;
  } else {
    throw Exception('Failed to load!');
  }
}

ListView _areaListView(data) {}

class AreaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Area'),
        backgroundColor: appbarColor,
      ),
      body: FutureBuilder<List<Area>>(
        future: _getArea(lokasi),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Area> data = snapshot.data;
            return ListView(
              children: <Widget>[
                Text("xxx"),
                ListView.separated(
                    shrinkWrap: true,
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

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MejaPage(area: data[index]),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: data.length),
                Text("Grand total"),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            onPressed: () {
              /*
              Navigator.push(context,
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
