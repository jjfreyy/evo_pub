part of 'pages.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key}) : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: Colors.red,
        unselectedLabelColor: Colors.black54,
        labelColor: Colors.black,
        controller: controller,
        tabs: const [
          Tab(
            text: 'Acc Kacab',
          ),
          Tab(
            text: 'Special Req',
          ),
          Tab(
            text: 'Di Proses',
          ),
          Tab(
            text: 'Selesai',
          ),
        ],
      ),
      body: TabBarView(
        //controller untuk tab bar
        controller: controller,
        children: const [
          DisplayPendingAccKacabPage(hsl: 1),
          Center(
            child: Text('2'),
          ),
          Center(
            child: Text('3'),
          ),
          Center(
            child: Text('4'),
          ),
          //kemudian panggil halaman sesuai tab yang sudah dibuat
          // DisplayPendingAccKacabPage(
          //   hsl2: '1',
          // ),
          // DisplayPendingAccKacabPage(
          //   hsl2: '2',
          // ),
          // DisplayPendingAccKacabPage(
          //   hsl2: '3',
          // ),
          // HistoryPage(
          //   hsl2: '4',
          // ),
        ],
      ),
    );
  }
}
