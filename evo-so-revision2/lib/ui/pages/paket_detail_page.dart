part of 'pages.dart';

class PaketDetailPage extends StatefulWidget {
  final String kodePaket;

  const PaketDetailPage({Key? key, required this.kodePaket}) : super(key: key);

  @override
  _PaketDetailPageState createState() => _PaketDetailPageState();
}

class _PaketDetailPageState extends State<PaketDetailPage> {
  late PaketDetailCubit cubit = PaketDetailCubit(widget.kodePaket);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<PaketDetailCubit, BlocState>(
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
          } else if ([BlocState.idle, BlocState.changing, BlocState.saving]
              .contains(state)) {
            body = buildPaketDetail(state);
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

  Widget buildPaketDetail(BlocState state) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: cubit.paketDetailList.isEmpty
              ? tidakAdaData()
              : ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildJmlPaket(),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const SizedBox(
                            height: 8,
                          ),
                        ),
                        buildPaketList(),
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

  Container buildJmlPaket() {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 4),
            child: const Text(
              'Jml Paket : ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 30,
            child: TextFormField(
              controller: cubit.tecJmlPaket,
              keyboardType: TextInputType.number,
              enabled: true,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                contentPadding: const EdgeInsets.only(top: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
              onChanged: (String value) => cubit.changeJumlahPaket(),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildPaketList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cubit.paketDetailList.length,
      itemBuilder: (context, i) {
        return Card(
            color: cubit.paketDetailList[i].bonus == 'Y'
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
                      /** NAMA BARANG */
                      Flexible(
                        child: Text(
                          cubit.paketDetailList[i].bonus == 'Y'
                              ? '*Free\n${cubit.paketDetailList[i].nama}'
                              : cubit.paketDetailList[i].nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  /** GROUP, RANGE, MAX QTY */
                  Text(
                    'Group : ${cubit.paketDetailList[i].kategori}\n'
                    'range : ${cubit.paketDetailList[i].pakaiRange}\n'
                    'Max Qty : ${getNumberFormat().format(cubit.paketDetailList[i].jml * cubit.getJumlahPaket)}',
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
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              hintText: 'Qty'),
                          onChanged: (String value) {},
                        ),
                      ),
                    ],
                  )
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
        onPressed: () => cubit.saveCart(),
        child: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
    );
  }
}
