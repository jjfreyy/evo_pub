part of 'pages.dart';

class KatBrgPage extends StatefulWidget {
  @override
  _KatBrgPageState createState() => _KatBrgPageState();
}

class _KatBrgPageState extends State<KatBrgPage> {
  KatBrgCubit _cubit = KatBrgCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<KatBrgCubit, String>(
        listener: (context, state) {
          if (state == "tokenExpired") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          } else if (_cubit.fMsg.isNotEmpty) {
            showFlushbar(msg: _cubit.fMsg, context: context, backgroundColor: Colors.red);
            _cubit.resetFlushbar();
          }
        },
        builder: (context, state) {
          Widget page = showLoader();

          if (state == "init") _cubit.init();
          else if (state == "error") page = ErrorPage500();
          else if (state == "idle") page = buildKatBrgMenus();

          return page;
        },
      ),
    );
  }

  Widget buildKatBrgMenus() {
    return Container(
        padding: const EdgeInsets.all(0.0),
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        child: _cubit.katBrgList.isEmpty
            ? tidakAdaData()
            : ListView(
                children: <Widget>[
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    scrollDirection: Axis.vertical,
                    primary: false,
                    children: List.generate(_cubit.katBrgList.length, (i) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                    _cubit.katBrgList[i].image != null
                                        ? _cubit.katBrgList[i].image
                                        : noImageUrl,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(_cubit.katBrgList[i].nama),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarangPage(
                                  kodeKategoriApps: _cubit.katBrgList[i].nama),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ));
  }
}
