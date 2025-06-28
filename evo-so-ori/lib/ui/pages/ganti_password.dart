part of 'pages.dart';

class GantiPasswordPage extends StatefulWidget {
  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  List _jnsTrx = [
    "Pilihan 1",
    "Pilihan 2",
    "Pilihan 3",
    "Pilihan 4",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String trx in _jnsTrx) {
      items.add(new DropdownMenuItem(value: trx, child: new Text(trx)));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    //getListKebaktian(dateformatter.format(DateTime.now()));
    _dropDownMenuItems = getDropDownMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 22),
                  height: 56,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Ganti Password",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 38,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 10, top: 10.0, right: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: "Password Lama",
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 38,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 10, top: 10.0, right: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: "Password Baru",
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(top: 20, bottom: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  "Ganti",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
