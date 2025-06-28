part of 'pages.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String judul = "Kategori Menu";

  final List<Widget> _children = [
    new KategoriBarangPage(),
    new CheckoutPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        judul = "Kategori Menu";
      } else {
        judul = "Cart";
      }
    });
  }

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AreaPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
            title: Text(judul),
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

        body: _children[_currentIndex], // new
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: bottomtabColor,
          selectedItemColor: bottomtabSelectedTextColor,
          unselectedItemColor: bottomtabUnSelectedTextColor,

          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(
                Icons.restaurant_menu,
              ),
              title: Text('Menu'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Cart'),
            ),
          ],
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
      ),
    );
  }
}
