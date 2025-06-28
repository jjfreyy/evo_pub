part of 'pages.dart';

void main() => runApp(MainPage());

/// This is the main application widget.
class MainPage extends StatelessWidget {
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
  MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  // final List<IndexedStackChild> _widgetOptions = [
  //   IndexedStackChild(child: KatBrgPage()),
  //   IndexedStackChild(child: PaketPage()),
  //   IndexedStackChild(child: CheckoutPage()),
  //   // DisplayPage(),
  //   IndexedStackChild(
  //       child: Container(
  //     child: Center(
  //       child: Text("Page4"),
  //     ),
  //   )),
  //   IndexedStackChild(child: ProfilePage()),
  // ];

  final List<Widget> _widgetOptions = [
    KatBrgPage(),
    PaketPage(),
    CheckoutPage(),
    // DisplayPage(),
    Container(
      child: Center(
        child: Text("Page4"),
      ),
    ),
    ProfilePage(),
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
          // child: ProsteIndexedStack(
          //   index: _selectedIndex,
          //   children: _widgetOptions,
          // ),
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: buildBottomNavBar(),
      ),
    );
  }

  Widget buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_special),
          label: "Kategori",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: "Paket",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "Display",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: bottomtabColor,
      selectedItemColor: bottomtabSelectedTextColor,
      unselectedItemColor: bottomtabUnSelectedTextColor,
      onTap: _onItemTapped,
    );
  }
}
