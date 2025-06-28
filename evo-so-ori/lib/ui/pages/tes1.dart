part of 'pages.dart';

class Tes1Page extends StatefulWidget {
  @override
  _Tes1PageState createState() => _Tes1PageState();
}

class _Tes1PageState extends State<Tes1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(32),
      child: ListView(shrinkWrap: true, children: <Widget>[
        //DetailTransaksiPage(dokumenID: "SO1136553043383737"),
      ]),
    ));
  }
}
