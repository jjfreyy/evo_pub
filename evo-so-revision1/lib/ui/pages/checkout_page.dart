part of 'pages.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutCubit cubit = CheckoutCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<CheckoutCubit, String>(
        listener: (context, state) {
          if (state == "tokenExpired") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
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
          if (state == "init")
            cubit.init();
          else if (["idle"].contains(state)) {
            body = buildCheckout();
          }

          return body;
        },
      ),
    );
  }

  Widget buildCheckout() {
    return Container(
      padding: new EdgeInsets.all(0.0),
      margin: new EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () async {},
            child: Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          namaCust,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        IgnorePointer(
                          ignoring: cubit.masterTrx == "Tunai" ? true : false,
                          child: Container(
                            padding: EdgeInsets.only(left: 6),
                            margin: EdgeInsets.only(top: 4),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              border: Border.all(),
                            ),
                            child: DropdownButton(
                              value: cubit.currentTrx,
                              items: cubit.jnsTrx
                                  .map((e) => DropdownMenuItem<String>(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                cubit.changeTrx(value.toString());
                              },
                              underline: SizedBox(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: SizedBox(
              height: 10,
            ),
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: snapshot.data.documents.length,
          //   itemBuilder: (context, index) {
          //     _jumlahController.add(new TextEditingController());
          //     if (index == 0) {
          //       subTotal = 0;
          //     }

          //     subTotal += double.parse(
          //       hitungSubtotalPerBarang(
          //         double.parse(snapshot
          //             .data.documents[index].data["disc_persen"]
          //             .toString()),
          //         0,
          //         double.parse(
          //             snapshot.data.documents[index].data["jumlah"].toString()),
          //         double.parse(
          //             snapshot.data.documents[index].data["harga"].toString()),
          //       ).round().toString(),
          //     );

          //     return Card(
          //         child: Container(
          //       padding: new EdgeInsets.all(3.0),
          //       margin:
          //           new EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 4),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             children: [
          //               Flexible(
          //                 child: Text(
          //                   snapshot.data.documents[index].data["nama_barang"],
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w400,
          //                     fontSize: 15,
          //                     // color: diorder,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Visibility(
          //             visible:
          //                 snapshot.data.documents[index].data["flag_paket"] ==
          //                         "T"
          //                     ? false
          //                     : true,
          //             child: Text(
          //               snapshot.data.documents[index].data["flag_paket"] == "T"
          //                   ? ""
          //                   : snapshot.data.documents[index].data["kode_paket"],
          //               style: TextStyle(
          //                 fontSize: 8,
          //                 color: Colors.grey,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 5,
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 20,
          //                 child: Text(
          //                   "Rp. ",
          //                   textAlign: TextAlign.left,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 13,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Container(
          //                 width: 65,
          //                 child: Text(
          //                   formatDouble(
          //                       double.parse(snapshot
          //                           .data.documents[index].data["harga"]
          //                           .toString()),
          //                       0,
          //                       context),
          //                   textAlign: TextAlign.right,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 13,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Container(
          //                 width: 3,
          //                 child: Text(
          //                   "X",
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w700,
          //                     fontSize: 13,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Container(
          //                 width: 60,
          //                 child: Text(
          //                   formatInteger(
          //                       snapshot.data.documents[index].data["jumlah"],
          //                       context),
          //                   textAlign: TextAlign.right,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 13,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Container(
          //                 width: 55,
          //                 child: Text(
          //                   snapshot.data.documents[index].data["satuan"],
          //                   textAlign: TextAlign.left,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 13,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Visibility(
          //                 visible: snapshot.data.documents[index]
          //                             .data["disc_persen"] ==
          //                         0
          //                     ? false
          //                     : true,
          //                 child: Container(
          //                   width: 75,
          //                   child: Text(
          //                     "Disc " +
          //                         formatDouble(
          //                             double.parse(snapshot.data
          //                                 .documents[index].data["disc_persen"]
          //                                 .toString()),
          //                             1,
          //                             context) +
          //                         "%",
          //                     textAlign: TextAlign.right,
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.w600,
          //                       fontSize: 13,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: 3,
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 163,
          //                 child: Text(
          //                   convertKeSatuanBesar(
          //                       snapshot.data.documents[index]
          //                           .data["kode_satuan_besar"],
          //                       snapshot.data.documents[index]
          //                           .data["isi_satuan_besar"],
          //                       snapshot.data.documents[index].data["satuan"],
          //                       double.parse(snapshot
          //                           .data.documents[index].data["jumlah"]
          //                           .toString())),
          //                   textAlign: TextAlign.right,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w400,
          //                     fontSize: 9,
          //                     color: Colors.black87,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: 5,
          //           ),
          //           Row(
          //             children: [
          //               Container(
          //                 width: 60,
          //                 child: Text(
          //                   "Total Rp. ",
          //                   textAlign: TextAlign.left,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 15,
          //                   ),
          //                 ),
          //               ),
          //               Container(
          //                 width: 100,
          //                 child: Text(
          //                   formatDouble(
          //                       double.parse(
          //                         hitungSubtotalPerBarang(
          //                           double.parse(snapshot.data.documents[index]
          //                               .data["disc_persen"]
          //                               .toString()),
          //                           0,
          //                           double.parse(snapshot
          //                               .data.documents[index].data["jumlah"]
          //                               .toString()),
          //                           double.parse(snapshot
          //                               .data.documents[index].data["harga"]
          //                               .toString()),
          //                         ).round().toString(),
          //                       ),
          //                       0,
          //                       context),
          //                   textAlign: TextAlign.right,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 15,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Visibility(
          //                 visible: snapshot.data.documents[index]
          //                             .data["flag_paket"] ==
          //                         "Y"
          //                     ? false
          //                     : true,
          //                 child: Container(
          //                   height: 35,
          //                   width: 30,
          //                   child: IconButton(
          //                       icon: Icon(
          //                         Icons.mode_edit,
          //                         color: Colors.black45,
          //                       ),
          //                       onPressed: () async {
          //                         await _showDialog(
          //                           snapshot.data.documents[index].documentID,
          //                           snapshot.data.documents[index]
          //                               .data["nama_barang"],
          //                           snapshot
          //                               .data.documents[index].data["jumlah"],
          //                         );

          //                         setState(() {});
          //                       }),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 15,
          //               ),
          //               Container(
          //                 height: 35,
          //                 width: 40,
          //                 child: IconButton(
          //                     icon: Icon(
          //                       Icons.delete_forever,
          //                       color: Colors.red,
          //                     ),
          //                     onPressed: () async {
          //                       try {
          //                         await _deleteCart(
          //                           snapshot.data.documents[index].documentID,
          //                           snapshot.data.documents[index]
          //                               .data["flag_paket"],
          //                           snapshot.data.documents[index]
          //                               .data["kode_paket"],
          //                           snapshot.data.documents[index]
          //                               .data["kode_paket2"],
          //                         );

          //                         await setState(() {});
          //                       } catch (_) {
          //                         print("Err");
          //                         throw Exception("Err.");
          //                       }
          //                     }),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ));
          //   },
          // ),
          SizedBox(
            height: 2,
          ),
          Container(
            color: Colors.grey[200],
            child: SizedBox(
              height: 7,
            ),
          ),
          // Container(
          //   margin: new EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 14),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           Container(
          //             width: 90,
          //             child: Text(
          //               "Subtotal ",
          //               textAlign: TextAlign.right,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Container(
          //             width: 40,
          //             child: Text(
          //               ": Rp.",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Container(
          //             width: 110,
          //             child: Text(
          //               formatDouble(subTotal, 0, context),
          //               textAlign: TextAlign.right,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Container(
          //             width: 90,
          //             child: Text(
          //               "PPN ",
          //               textAlign: TextAlign.right,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Container(
          //             width: 40,
          //             child: Text(
          //               ": Rp.",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Container(
          //             width: 110,
          //             child: Text(
          //               formatDouble(
          //                   double.parse(
          //                       (subTotal * 10 / 100).round().toString()),
          //                   0,
          //                   context),
          //               textAlign: TextAlign.right,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Container(
          //             width: 90,
          //             child: Text(
          //               "Grand Total ",
          //               textAlign: TextAlign.right,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Container(
          //             width: 40,
          //             child: Text(
          //               ": Rp.",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Container(
          //             width: 110,
          //             child: Text(
          //               formatDouble(
          //                   subTotal +
          //                       double.parse(
          //                           (subTotal * 10 / 100).round().toString()),
          //                   0,
          //                   context),
          //               textAlign: TextAlign.right,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          //         width: double.infinity,
          //         height: 40,
          //         child: RaisedButton(
          //             elevation: 0,
          //             onPressed: () {
          //               setState(() async {
          //                 try {
          //                   if (kodeCust == "") {
          //                     Scaffold.of(context)
          //                       ..removeCurrentSnackBar()
          //                       ..showSnackBar(
          //                         SnackBar(
          //                           content: Text("Customer belum diisi!"),
          //                           duration: Duration(seconds: 4),
          //                         ),
          //                       );
          //                     return false;
          //                   }
          //                   await _checkout();

          //                   if (hasilCheckout == true) {
          //                     refreshChekcout();

          //                     Navigator.of(context).pushAndRemoveUntil(
          //                         MaterialPageRoute(
          //                             builder: (context) => MainPage2()),
          //                         (Route<dynamic> route) => false);
          //                   } else {
          //                     Scaffold.of(context)
          //                       ..removeCurrentSnackBar()
          //                       ..showSnackBar(
          //                         SnackBar(
          //                           content: Text(ketCheckout),
          //                           duration: Duration(seconds: 4),
          //                         ),
          //                       );
          //                     return false;
          //                   }
          //                 } catch (_) {
          //                   print("Err");
          //                   throw Exception("Err.");
          //                 }
          //               });
          //             },
          //             child: Text(
          //               "Simpan",
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 side: BorderSide(color: btnAddToCart)),
          //             color: btnAddToCart),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
