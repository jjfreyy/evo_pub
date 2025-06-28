part of 'pages.dart';

class PaketDetailRangePage extends StatefulWidget {
  final String kodePaket;

  const PaketDetailRangePage({Key? key, required this.kodePaket})
      : super(key: key);

  @override
  _PaketDetailRangePageState createState() => _PaketDetailRangePageState();
}

class _PaketDetailRangePageState extends State<PaketDetailRangePage> {
  late PaketDetailRangeCubit cubit = PaketDetailRangeCubit(widget.kodePaket);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<PaketDetailRangeCubit, BlocState>(
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
          } else if ([BlocState.idle, BlocState.saving].contains(state)) {
            body = buildPaketDetailRange(state);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.kodePaket),
              backgroundColor: appbarColor,
            ),
            body: body,
          );
        },
      ),
    );
  }

  Widget buildPaketDetailRange(BlocState state) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: cubit.paketDetailRangeList.isEmpty
              ? tidakAdaData()
              : ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPaketDetailRangeList(),
                        buildButton(),
                      ],
                    ),
                  ],
                ),
        ),
        state == BlocState.saving ? showLoader(true) : const SizedBox(),
      ],
    );
  }

  ListView buildPaketDetailRangeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cubit.paketDetailRangeList.length,
      itemBuilder: (context, i) {
        return Card(
            color: cubit.paketDetailRangeList[i].bonus == 'Y'
                ? Colors.blue[50]
                : Colors.white,
            child: Container(
              padding: const EdgeInsets.all(3.0),
              margin:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          cubit.paketDetailRangeList[i].bonus == 'Y'
                              ? '*Free\n${cubit.paketDetailRangeList[i].nama}'
                              : cubit.paketDetailRangeList[i].nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            // color: diorder,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Group : ${cubit.paketDetailRangeList[i].kategori}\n'
                    'range : ${cubit.paketDetailRangeList[i].pakaiRange}\n'
                    'Max Qty : ${getNumberFormat().format(cubit.paketDetailRangeList[i].dari)} sd ${getNumberFormat().format(cubit.paketDetailRangeList[i].sampai)}',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: TextField(
                          controller: cubit.tecQtys[i],
                          keyboardType: TextInputType.number,
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
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0),
                              ),
                              hintText: 'Qty'),
                          onChanged: (String value) {},
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Container buildButton() {
    return Container(
      margin: const EdgeInsets.all(defaultMargin),
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        ),
        child: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
        onPressed: () => cubit.saveCart(),
        // or
      ),
    );
  }
}
