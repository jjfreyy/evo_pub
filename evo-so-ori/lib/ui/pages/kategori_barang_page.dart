part of 'pages.dart';

ListView _kategoriBrgListview(data) {
  return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              data[index].data["image"] != null
                  ? data[index].data["image"]
                  : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
            ),
          ),
          title: Text(data[index].data["kode_kategori"],
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
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SubKategoriBarangPage(kategoriBarang: data[index]),
              ),
             
            ); */
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: data.length);
}

class KategoriBarangPage extends StatefulWidget {
  @override
  _KategoriBarangPageState createState() => _KategoriBarangPageState();
}

class _KategoriBarangPageState extends State<KategoriBarangPage> {
  Future _data;

  Future _getKat() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("kategori_barang").getDocuments();

    return qn.documents;
  }

  void initState() {
    super.initState();

    _data = _getKat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Area'),
          backgroundColor: appbarColor,
        ),
        body: Container(
          child: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _kategoriBrgListview(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
