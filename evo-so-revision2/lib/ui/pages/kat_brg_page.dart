part of 'pages.dart';

class KatBrgPage extends StatefulWidget {
  const KatBrgPage({Key? key}) : super(key: key);

  @override
  _KatBrgPageState createState() => _KatBrgPageState();
}

class _KatBrgPageState extends State<KatBrgPage> {
  final KatBrgCubit cubit = KatBrgCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<KatBrgCubit, BlocState>(
        listener: (context, state) {
          if (state == BlocState.expiredToken) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false);
          } else if (cubit.fMsg.isNotEmpty) {
            showFlushbar(
                msg: cubit.fMsg, context: context, backgroundColor: Colors.red);
            cubit.resetFlushbar();
          }
        },
        builder: (context, state) {
          Widget page = showLoader();

          if (state == BlocState.init) {
            cubit.init();
          } else if (state == BlocState.idle) {
            page = buildKatBrgMenus();
          }

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
        child: cubit.katBrgList.isEmpty
            ? tidakAdaData()
            : ListView(
                children: <Widget>[
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    scrollDirection: Axis.vertical,
                    primary: false,
                    children: List.generate(cubit.katBrgList.length, (i) {
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    cubit.katBrgList[i].image ?? noImageUrl,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(cubit.katBrgList[i].nama),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarangPage(
                                  kodeKategoriApps: cubit.katBrgList[i].nama),
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
