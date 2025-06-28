part of 'pages.dart';

class DetailTransaksiPage extends StatefulWidget {
  final DisplayPendingAccKacab data;

  const DetailTransaksiPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _DetailTransaksiPageState createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  late DetailTransaksiCubit cubit = DetailTransaksiCubit(widget.data);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<DetailTransaksiCubit, BlocState>(
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
            } else if ([BlocState.idle, BlocState.updating].contains(state)) {
              body = buildDetailTransaksi(state);
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Detail Transaksi'),
                backgroundColor: appbarColor,
              ),
              body: body,
            );
          },
        ));
  }

  Widget buildDetailTransaksi(BlocState state) {
    return cubit.detailTransaksiList.isEmpty
        ? tidakAdaData()
        : Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                margin: const EdgeInsets.only(
                    left: 0, right: 0, top: 10, bottom: 0),
                child: ListView(
                  children: <Widget>[
                    buildDetailTransaksiList(),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      color: Colors.grey[200],
                      child: const SizedBox(
                        height: 7,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildGrandTotal(),
                          const SizedBox(
                            height: 10,
                          ),
                          buildAccButton(),
                          buildSpecialRequestButton(),
                          buildNaikPlafonButton(),
                          buildTambahLamaJthTempoButton(),
                          buildAccStockKurangButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              [BlocState.updating].contains(state)
                  ? showLoader(true)
                  : const SizedBox(),
            ],
          );
  }

  ListView buildDetailTransaksiList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cubit.detailTransaksiList.length,
      itemBuilder: (context, i) {
        return Card(
            child: Container(
          padding: const EdgeInsets.all(3.0),
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /** TOP */
              /** NAMA BARANG */
              Row(
                children: [
                  Flexible(
                    child: Text(
                      cubit.detailTransaksiList[i].namaBarang,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        // color: diorder,
                      ),
                    ),
                  ),
                ],
              ),
              /** KODE PAKET */
              Visibility(
                visible: isEmpty(cubit.detailTransaksiList[i].kodePaket)
                    ? false
                    : true,
                child: Text(
                  isEmpty(cubit.detailTransaksiList[i].kodePaket)
                      ? ''
                      : cubit.detailTransaksiList[i].kodePaket,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              /** MIDDLE */
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /** RP */
                  const SizedBox(
                    width: 20,
                    child: Text(
                      'Rp. ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  /** HARGA */
                  SizedBox(
                    width: 65,
                    child: Text(
                      formatDouble(
                        cubit.detailTransaksiList[i].harga * 1.0,
                        0,
                        context,
                      ),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const SizedBox(
                    width: 3,
                    child: Text(
                      'X',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  /** QTY */
                  SizedBox(
                    width: 60,
                    child: Text(
                      formatInteger(
                          cubit.detailTransaksiList[i].jumlah.toInt(), context),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  /** SATUAN */
                  SizedBox(
                    width: 55,
                    child: Text(
                      cubit.detailTransaksiList[i].satuan,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  /** DISC PERSEN */
                  Visibility(
                    visible: cubit.detailTransaksiList[i].discPersen == 0
                        ? false
                        : true,
                    child: SizedBox(
                      width: 75,
                      child: Text(
                        'Disc ${formatDouble(cubit.detailTransaksiList[i].discPersen * 1.0, 1, context)}%',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              /** SATUAN BESAR */
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    // width: 163,
                    child: Text(
                      convertKeSatuanBesar(
                        cubit.detailTransaksiList[i].kodeSatuanBesar,
                        cubit.detailTransaksiList[i].isiSatuanBesar * 1.0,
                        cubit.detailTransaksiList[i].satuan,
                        cubit.detailTransaksiList[i].jumlah,
                      ),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 9,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              /** TOTAL RP */
              Row(
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      'Total Rp. ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      formatDouble(
                        hitungSubtotalPerBarang(
                          cubit.detailTransaksiList[i].discPersen * 1.0,
                          0,
                          cubit.detailTransaksiList[i].jumlah,
                          cubit.detailTransaksiList[i].harga * 1.0,
                        ),
                        0,
                        context,
                      ),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
      },
    );
  }

  Column buildGrandTotal() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 90,
              child: Text(
                'Subtotal ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const SizedBox(
              width: 40,
              child: Text(
                ': Rp.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 110,
              child: Text(
                formatDouble(cubit.subTotal, 0, context),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 90,
              child: Text(
                'PPN ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const SizedBox(
              width: 40,
              child: Text(
                ': Rp.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 110,
              child: Text(
                formatDouble(
                    double.parse(
                        (cubit.subTotal * 10 / 100).round().toString()),
                    0,
                    context),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 90,
              child: Text(
                'Grand Total ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const SizedBox(
              width: 40,
              child: Text(
                ': Rp.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 110,
              child: Text(
                formatDouble(
                    cubit.subTotal +
                        double.parse(
                            (cubit.subTotal * 10 / 100).round().toString()),
                    0,
                    context),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Visibility buildAccButton() {
    return Visibility(
      visible: (bolehACC == 'Y' && roleACC == 'Y') ? true : false,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () => cubit.updatePermintaanKeluar('ACC'),
          child: const Text(
            'ACC',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: btnAddToCart)),
            primary: btnAddToCart,
          ),
        ),
      ),
    );
  }

  Visibility buildSpecialRequestButton() {
    return Visibility(
      visible: (bolehSpcReq == 'Y' && roleSpcReq == 'Y') ? true : false,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () async {},
          child: const Text(
            'Special Request',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: const BorderSide(color: Colors.blue)),
              primary: Colors.blue),
        ),
      ),
    );
  }

  Visibility buildNaikPlafonButton() {
    return Visibility(
      visible: (bolehNaikPlafon == 'Y' && roleNaikPlafon == 'Y') ? true : false,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Naik Plafon',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: const BorderSide(color: Colors.blue)),
              primary: Colors.blue),
        ),
      ),
    );
  }

  Visibility buildTambahLamaJthTempoButton() {
    return Visibility(
      visible:
          (bolehTambahLamaJT == 'Y' && roleTambahLamaJT == 'Y') ? true : false,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Tambah Lama Jth Tempo',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: const BorderSide(color: Colors.blue)),
              primary: Colors.blue),
        ),
      ),
    );
  }

  Visibility buildAccStockKurangButton() {
    return Visibility(
      visible: (bolehACCStock == 'Y' && roleACCStock == 'Y') ? true : false,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'ACC Stock Kurang',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: btnAddToCart)),
              primary: btnAddToCart),
        ),
      ),
    );
  }
}
