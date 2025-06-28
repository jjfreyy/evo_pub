part of 'pages.dart';

class CobaChecker extends StatefulWidget {
  @override
  _CobaCheckerState createState() => _CobaCheckerState();
}

class _CobaCheckerState extends State<CobaChecker> {
  List<bool> inputs = new List<bool>();
  @override
  void initState() {
    super.initState();

    setState(() {
      for (int i = 0; i < 20; i++) {
        inputs.add(true);
      }
    });
  }

  void itemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Checked Listview'),
        backgroundColor: appbarColor,
      ),
      body: new ListView.builder(
          itemCount: inputs.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Container(
                padding: new EdgeInsets.all(1.0),
                child: new Column(
                  children: <Widget>[
                    new CheckboxListTile(
                        value: inputs[index],
                        title: new Text('item ' + inputs[index].toString()),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool val) {
                          itemChange(val, index);
                        }),
                    Text("dddd"),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
