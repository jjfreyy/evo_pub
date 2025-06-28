part of 'pages.dart';

class BarangPage extends StatefulWidget {
  final String kodeKategoriApps;

  const BarangPage({Key? key, required this.kodeKategoriApps})
      : super(key: key);

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  late final BarangCubit cubit = BarangCubit(widget.kodeKategoriApps);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<BarangCubit, BlocState>(
        listener: (context, state) {
          if (state == BlocState.expiredToken) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false);
          } else if (cubit.fMsg.isNotEmpty) {
            showFlushbar(
                msg: cubit.fMsg,
                context: context,
                backgroundColor: cubit.fSuccess ? Colors.green : Colors.red);
            cubit.resetFlushbar();
          }
        },
        builder: (context, state) {
          Widget body = showLoader();

          if (state == BlocState.init) {
            cubit.init();
          } else if ([BlocState.idle, BlocState.searching, BlocState.saving].contains(state)) {
            body = Stack(
              children: [
                Column(
                  children: <Widget>[
                    buildSearchBar(cubit.tecSearch, cubit.searchBarang),
                    buildBarangList(),
                  ],
                ),
                [BlocState.searching, BlocState.saving].contains(state)
                    ? showLoader(true, state == BlocState.searching? 50 : 0)
                    : const SizedBox(),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
                title: const Text('Barang'),
                backgroundColor: appbarColor,
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Icon(
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

  Widget buildBarangList() {
    return cubit.barangList.isEmpty
        ? Expanded(child: tidakAdaData())
        : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: cubit.barangList.length,
                itemBuilder: (context, i) {
                  return Card(
                      child: ListTile(
                    leading: cubit.barangList[i].image == null
                        ? const Icon(Icons.image)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                cubit.barangList[i].image as String)),
                    title: Text(cubit.barangList[i].nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        )),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock ${getNumberFormat().format(cubit.barangList[i].stock)} ${cubit.barangList[i].satuan}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Rp. ${getNumberFormat().format(cubit.barangList[i].fHrgResellStd)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: cubit.tecQtys[i],
                                enabled: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0),
                                  ),
                                  hintText: 'Qty',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 70,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                ),
                                child: const Text(
                                  'Simpan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                onPressed: () async {
                                  cubit.saveCart(i);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
                }),
          );
  }
}
