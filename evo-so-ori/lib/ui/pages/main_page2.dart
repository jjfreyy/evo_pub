part of 'pages.dart';

void main() => runApp(MainPage2());

/// This is the main application widget.
class MainPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "",
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    new KatBrgPage(),
    new PaketPage(),
    new Checkout2Page(),
    new DisplayPage(),
    new ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hi " + userID + "!"),
          backgroundColor: appbarColor,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_special),
              title: Text(
                "Kategori",
                style: TextStyle(fontSize: 12),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text(
                "Paket",
                style: TextStyle(fontSize: 12),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text(
                "Cart",
                style: TextStyle(fontSize: 12),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text(
                "Display",
                style: TextStyle(fontSize: 12),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: bottomtabColor,
          selectedItemColor: bottomtabSelectedTextColor,
          unselectedItemColor: bottomtabUnSelectedTextColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
