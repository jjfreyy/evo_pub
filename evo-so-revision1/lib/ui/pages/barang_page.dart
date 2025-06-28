part of 'pages.dart';

class BarangPage extends StatefulWidget {
  final String kodeKategoriApps;

  BarangPage({Key? key, required this.kodeKategoriApps}) : super(key: key);

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  late BarangCubit _cubit = BarangCubit(widget.kodeKategoriApps);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<BarangCubit, String>(
        listener: (context, state) {
          if (state == "tokenExpired") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          } else if (_cubit.fMsg.isNotEmpty) {
            showFlushbar(
                msg: _cubit.fMsg,
                context: context,
                backgroundColor: _cubit.fSuccess ? Colors.green : Colors.red);
            _cubit.resetFlushbar();
          }
        },
        builder: (context, state) {
          Widget body = showLoader();

          if (state == "init")
            _cubit.init();
          else if (state == "error")
            body = ErrorPage500();
          else if (["idle", "searching", "savingToCart"].contains(state)) {
            body = Container(
                child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    _buildSearchBox(),
                    _buildBarangList(),
                  ],
                ),
                ["searching", "savingToCart"].contains(state)
                    ? Container(
                        margin:
                            EdgeInsets.only(top: state == "searching" ? 50 : 0),
                        color: Colors.black.withOpacity(0.55),
                        child: showLoader())
                    : SizedBox(),
              ],
            ));
          }

          return Scaffold(
            appBar: AppBar(
                title: Text("Barang"),
                backgroundColor: appbarColor,
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Icon(
                          Icons.home,
                          size: 26.0,
                        ),
                      )),
                ]),
            body: body,
          );
        },
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 35,
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 8),
      child: TextFormField(
        style: GoogleFonts.openSans().copyWith(fontSize: 14.0),
        controller: _cubit.tecSearch,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(2.0),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            prefixIcon: Icon(Icons.search),
            hintText: "Search"),
        onChanged: (value) {
          _cubit.searchBarang();
        },
      ),
    );
  }

  Widget _buildBarangList() {
    return _cubit.barangList.isEmpty
        ? Expanded(child: tidakAdaData())
        : Expanded(
            child: Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: _cubit.barangList.length,
                  itemBuilder: (context, i) {
                    return Card(
                        child: ListTile(
                      leading: _cubit.barangList[i].image == null
                          ? Icon(Icons.image)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  _cubit.barangList[i].image as String)),
                      title: Text(_cubit.barangList[i].namaBarang,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stock ${getNumberFormat().format(_cubit.barangList[i].stock)} ${_cubit.barangList[i].satuan}",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Rp. ${getNumberFormat().format(_cubit.barangList[i].fHrgResellStd)}",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                height: 30,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _cubit.tecQtys[i],
                                  enabled: true,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    contentPadding: EdgeInsets.only(top: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0),
                                    ),
                                    hintText: "Qty",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 70,
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    textStyle: TextStyle(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0)),
                                  ),
                                  child: Text(
                                    "Simpan",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  onPressed: () async {
                                    _cubit.saveCart(i);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
                  }),
            ),
          );
  }
}
