part of 'pages.dart';

class Email extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(20.0),
            ),
            new Padding(
              padding: new EdgeInsets.all(20.0),
            ),
            new Icon(
              Icons.home,
              size: 90.0,
              color: Colors.lightBlueAccent,
            ),
            new Text(
              "HOME",
              style: new TextStyle(fontSize: 30.0, color: Colors.lightGreen),
            )
          ],
        ),
      ),
    );
  }
}
