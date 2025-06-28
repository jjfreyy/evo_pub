part of 'pages.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CheckoutCubit cubit = CheckoutCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<CheckoutCubit, BlocState>(
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
          } else if ([
            BlocState.animating,
            BlocState.idle,
            BlocState.saving,
            BlocState.updating,
            BlocState.deleting
          ].contains(state)) {
            body = buildCheckout(state);
          }

          return body;
        },
      ),
    );
  }

  void _showEditDialog(int cartIndex) {
    TextEditingController tecQty = TextEditingController();
    tecQty.text = cubit.cartList[cartIndex].qty.toString();
    const radius = 7.5;
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                  side: const BorderSide(color: Colors.white, width: 1.5),
                ),
                child: buildDialogWidget(
                  context: context,
                  radius: radius,
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubit.cartList[cartIndex].namaBarang,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      SizedBox(
                        height: 30.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: tecQty,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black54,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 0),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: 'Qty',
                                ),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            ElevatedButton(
                              child: const Text('Ubah'),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(color: Colors.white),
                                primary: appbarColor,
                              ),
                              onPressed: () {
                                cubit.updateQty(
                                    cartIndex, int.tryParse(tecQty.text));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget buildCheckout(BlocState state) {
    return Stack(
      children: [
        cubit.cartList.isEmpty
            ? tidakAdaData()
            : Container(
                padding: const EdgeInsets.all(0.0),
                margin: const EdgeInsets.only(
                    left: 0, right: 0, top: 10, bottom: 0),
                child: ListView(
                  children: <Widget>[
                    buildCustomerOptions(),
                    Container(
                      color: Colors.grey[200],
                      child: const SizedBox(
                        height: 10,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: state == BlocState.animating ? 0.0 : 1.0,
                      duration: Duration(milliseconds: animationDuration),
                      child: Column(
                        children: [
                          buildCartList(),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            color: Colors.grey[200],
                            child: const SizedBox(
                              height: 7,
                            ),
                          ),
                          buildGrandTotal(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        [BlocState.saving, BlocState.updating, BlocState.deleting]
                .contains(state)
            ? showLoader(true)
            : const SizedBox(),
      ],
    );
  }

  Widget buildCustomerOptions() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /** CUSTOMER DETAIL */
          GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /** ICON */
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                      border: Border.all(
                        width: 1,
                        color: Colors.red,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  /** CUSTOMER NAME */
                  cubit.customer == null
                      ? Container(
                          padding: const EdgeInsets.only(left: 5.0),
                          height: 40.0,
                          child: const Center(
                              child: Text('Pilih Customer',
                                  style: TextStyle(color: Colors.grey))),
                        )
                      : Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black38,
                                ),
                              ),
                              Text(
                                cubit.customer!.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomersPage()),
                );
                if (result != null) cubit.updateCustomer(result);
              }),
          const SizedBox(height: 5.0),
          /** DROPDOWN */
          IgnorePointer(
            ignoring: cubit.customer?.jenisTrans == 'T' ? true : false,
            child: Container(
              padding: const EdgeInsets.only(left: 6),
              margin: const EdgeInsets.only(top: 4),
              height: 30,
              width: MediaQuery.of(context).size.width * 0.55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.grey.withOpacity(0.4)),
              ),
              child: DropdownButton(
                style: const TextStyle(color: Colors.black54),
                value: cubit.currentTrx,
                items: cubit.jnsTrx
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  cubit.changeTrx(value.toString());
                },
                underline: const SizedBox(),
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cubit.cartList.length,
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
                      cubit.cartList[i].namaBarang,
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
                visible: cubit.cartList[i].flagPaket == 'T' ? false : true,
                child: Text(
                  cubit.cartList[i].flagPaket == 'T'
                      ? ''
                      : cubit.cartList[i].kodePaket,
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
                  /** BUILD HARGA */
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
                  SizedBox(
                    width: 65,
                    child: Text(
                      formatDouble(
                        cubit.cartList[i].harga,
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
                  /** Build QTY */
                  SizedBox(
                    width: 60,
                    child: Text(
                      formatInteger(cubit.cartList[i].qty, context),
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
                  SizedBox(
                    width: 55,
                    child: Text(
                      cubit.cartList[i].satuan,
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
                  /** BUILD DISC */
                  Visibility(
                    visible: cubit.cartList[i].disc == 0 ? false : true,
                    child: SizedBox(
                      width: 75,
                      child: Text(
                        'Disc ${formatDouble(cubit.cartList[i].disc * 1.0, 1, context)}%',
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
                          cubit.cartList[i].kodeSatuanBesar,
                          cubit.cartList[i].isiSatuanBesar,
                          cubit.cartList[i].satuan,
                          cubit.cartList[i].qty * 1.0),
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
              /** BOTTOM */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /** TOTAL RP */
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
                          double.parse(
                            hitungSubtotalPerBarang(
                              cubit.cartList[i].disc * 1.0,
                              0,
                              cubit.cartList[i].qty * 1.0,
                              cubit.cartList[i].harga,
                            ).round().toString(),
                          ),
                          0,
                          context),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  /** BUTTONS */
                  Row(
                    children: [
                      /** EDIT BUTTON */
                      Visibility(
                        visible:
                            cubit.cartList[i].flagPaket == 'Y' ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SizedBox(
                            height: 35,
                            width: 30,
                            child: IconButton(
                              icon: const Icon(
                                Icons.mode_edit,
                                color: Colors.black45,
                              ),
                              onPressed: () async => _showEditDialog(i),
                            ),
                          ),
                        ),
                      ),
                      /** DELETE BUTTON */
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                            height: 35,
                            width: 30,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: appbarColor,
                              ),
                              onPressed: () async {
                                final kodePaket = cubit.cartList[i].kodePaket;
                                final dialogTitle = isEmpty(kodePaket)
                                    ? 'Hapus barang ${cubit.cartList[i].namaBarang}?'
                                    : 'Hapus paketan ${cubit.cartList[i].kodePaket}?';
                                final result = await showConfirmDialog(
                                    context: context, dialogTitle: dialogTitle);
                                if (result != null) {
                                  cubit.deleteCartItem(cubit.cartList[i]);
                                }
                              },
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget buildGrandTotal() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /** SUBTOTAL */
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
          /** PPN */
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
                    (cubit.subTotal * 10 / 100).round() * 1.0,
                    0,
                    context,
                  ),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          /** GRAND TOTAL */
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
                      (cubit.subTotal + (cubit.subTotal * 10 / 100).round()),
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
          const SizedBox(
            height: 10,
          ),
          /** BUTTON */
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
                onPressed: () => cubit.savePermintaanKeluar(),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: btnAddToCart,
                  textStyle: const TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: btnAddToCart),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
