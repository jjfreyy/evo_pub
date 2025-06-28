part of 'pages.dart';

class DisplayPendingAccKacabPage extends StatefulWidget {
  final int hsl;

  const DisplayPendingAccKacabPage({Key? key, required this.hsl})
      : super(key: key);

  @override
  _DisplayPendingAccKacabPageState createState() =>
      _DisplayPendingAccKacabPageState();
}

class _DisplayPendingAccKacabPageState
    extends State<DisplayPendingAccKacabPage> {
  late Socket socket;
  late DisplayPendingAccKacabCubit cubit =
      DisplayPendingAccKacabCubit(widget.hsl);

  @override
  void initState() {
    super.initState();
    socket = io(socketUrl(), OptionBuilder().setTransports(['websocket']).enableForceNew().build());
    socket.onConnect((data) {
      if (debug) dd('connected to socket server at ${socketUrl()}');
    });
    socket.on('displayPendingAccKacab', (data) {
      if (debug) dd('receive event: $data');
      if (data == 'refresh') cubit.refresh();
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<DisplayPendingAccKacabCubit, BlocState>(
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
          } else if ([BlocState.idle, BlocState.animating].contains(state)) {
            body = buildDisplayPendingAccKacab();
          }

          return Scaffold(
            body: body,
          );
        },
      ),
    );
  }

  Widget buildDisplayPendingAccKacab() {
    return cubit.displayPendingAccKacabList.isEmpty
        ? tidakAdaData()
        : Container(
            padding: const EdgeInsets.all(0.0),
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDisplayPendingAccKacabList(),
                  ],
                ),
              ],
            ),
          );
  }

  Widget buildDisplayPendingAccKacabList() {
    return AnimatedOpacity(
      opacity: cubit.state == BlocState.animating ? 0 : 1,
      duration: Duration(milliseconds: animationDuration),
      child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.displayPendingAccKacabList.length,
                      itemBuilder: (context, i) {
                        return Card(
                            color: Colors.blue[50],
                            child: Container(
                              padding: const EdgeInsets.all(3.0),
                              margin: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildNamaCustomer(i),
                                  const Divider(),
                                  buildNoFaktur(i),
                                  buildLokasi(i),
                                  buildTanggalJam(i),
                                  buildUserID(i),
                                  builJT(i),
                                  buildKetProblem(i),
                                  const Divider(),
                                  buildDetailButton(i, context),
                                  buildBatalButton(i),
                                  buildRefreshButton(i),
                                  buildRefreshKhususButton(i)
                                ],
                              ),
                            ));
                      },
                    ),
    );
  }

  Text buildNamaCustomer(int i) {
    return Text(
      cubit.displayPendingAccKacabList[i].namaCustomer,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13,
        // color: diorder,
      ),
    );
  }

  Text buildNoFaktur(int i) {
    return Text(
      cubit.displayPendingAccKacabList[i].noFaktur,
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }

  Text buildLokasi(int i) {
    return Text(
      cubit.displayPendingAccKacabList[i].lokasi,
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }

  Text buildTanggalJam(int i) {
    return Text(
      '${cubit.dateformatter.format(cubit.displayPendingAccKacabList[i].tanggal)} ${cubit.displayPendingAccKacabList[i].jam}',
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }

  Text buildUserID(int i) {
    return Text(
      cubit.displayPendingAccKacabList[i].userId,
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }

  Text builJT(int i) {
    return Text(
      cubit.displayPendingAccKacabList[i].jt == 'T' ? 'Tunai' : 'Non Tunai',
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }

  Visibility buildKetProblem(int i) {
    return Visibility(
      visible: (cubit.displayPendingAccKacabList[i].ketProblem == null)
          ? false
          : true,
      child: (cubit.displayPendingAccKacabList[i].ketProblem == null)
          ? const Text('')
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  cubit.displayPendingAccKacabList[i].ketProblem!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
    );
  }

  Container buildDetailButton(int i, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].sudahAccKacab == null) {
            bolehACC = 'Y';
          } else {
            bolehACC = 'T';
          }

          if (cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].sudahAccKacab == null &&
              cubit.displayPendingAccKacabList[i].sudahSpcRequest == null &&
              cubit.displayPendingAccKacabList[i].sudahSync == null) {
            bolehSpcReq = 'Y';
          } else {
            bolehSpcReq = 'T';
          }

          if (cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].sudahAccKacab == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahSync == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahProses == 'Y' &&
              cubit.displayPendingAccKacabList[i].flagPlafon == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahPlafon == null) {
            bolehNaikPlafon = 'Y';
          } else {
            bolehNaikPlafon = 'T';
          }

          if (cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].sudahAccKacab == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahSync == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahProses == 'Y' &&
              cubit.displayPendingAccKacabList[i].flagLamaJT == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahLamaJT == null) {
            bolehTambahLamaJT = 'Y';
          } else {
            bolehTambahLamaJT = 'T';
          }

          if (cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].sudahAccKacab == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahSync == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahProses == 'Y' &&
              cubit.displayPendingAccKacabList[i].flagStockKurang == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahStockKurang == null) {
            bolehACCStock = 'Y';
          } else {
            bolehACCStock = 'T';
          }

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.hsl == 2
                    ? Container()
                    : DetailTransaksiPage(
                        data: cubit.displayPendingAccKacabList[i])),
          );
        },
        child: const Text(
          'Detail',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Colors.green[300]!)),
            primary: Colors.green[300]),
      ),
    );
  }

  Visibility buildBatalButton(int i) {
    return Visibility(
      visible: widget.hsl == 1 &&
              roleBatal == 'Y' &&
              cubit.displayPendingAccKacabList[i].sudahAccKacab == null &&
              cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null
          ? true
          : false,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: const BorderSide(color: Colors.redAccent)),
              primary: Colors.redAccent),
        ),
      ),
    );
  }

  Visibility buildRefreshButton(int i) {
    return Visibility(
      visible: widget.hsl == 3 &&
              roleRefresh == 'Y' &&
              cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].adaProblem == 'Y' &&
              cubit.displayPendingAccKacabList[i].flagLamaJT == null &&
              cubit.displayPendingAccKacabList[i].flagPlafon == null &&
              cubit.displayPendingAccKacabList[i].flagStockKurang == null
          ? true
          : false,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Refresh',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Colors.blue[300]!)),
              primary: Colors.blue[300]),
        ),
      ),
    );
  }

  Visibility buildRefreshKhususButton(int i) {
    return Visibility(
      visible: widget.hsl == 3 &&
              roleRefreshKhusus == 'Y' &&
              cubit.displayPendingAccKacabList[i].selesai == null &&
              cubit.displayPendingAccKacabList[i].status == null &&
              cubit.displayPendingAccKacabList[i].adaProblem == 'Y' &&
              cubit.displayPendingAccKacabList[i].flagLamaJT == null &&
              cubit.displayPendingAccKacabList[i].flagPlafon == null
          ? true
          : false,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Refresh Khusus',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Colors.red[300]!)),
              primary: Colors.red[300]),
        ),
      ),
    );
  }
}
