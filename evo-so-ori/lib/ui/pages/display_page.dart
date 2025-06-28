part of 'pages.dart';

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: Colors.red,
        unselectedLabelColor: Colors.black54,
        labelColor: Colors.black,
        controller: controller,
        tabs: <Widget>[
          Tab(
            text: "Acc Kacab",
          ),
          Tab(
            text: "Special Req",
          ),
          Tab(
            text: "Di Proses",
          ),
          Tab(
            text: "Selesai",
          ),
        ],
      ),
      body: new TabBarView(
        //controller untuk tab bar
        controller: controller,

        children: <Widget>[
          //kemudian panggil halaman sesuai tab yang sudah dibuat
          DisplayPendingAccKacabPage(
            hsl2: "1",
          ),
          DisplayPendingAccKacabPage(
            hsl2: "2",
          ),
          DisplayPendingAccKacabPage(
            hsl2: "3",
          ),
          HistoryPage(
            hsl2: "4",
          ),
        ],
      ),
    );
  }
}
