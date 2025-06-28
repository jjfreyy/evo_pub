part of 'pages.dart';

class PaketPage extends StatefulWidget {
  @override
  _PaketPageState createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  PaketCubit _cubit = PaketCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<PaketCubit, String>(
        listener: (context, state) {
          if (state == "tokenExpired") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
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
                    children: [
                      _buildSearchBox(),
                      _buildPaketList(),
                    ],
                  ),
                  ["searching", "savingToCard"].contains(state)
                      ? Container(
                          margin: EdgeInsets.only(
                              top: state == "searching" ? 50 : 0),
                          color: Colors.black.withOpacity(0.55),
                          child: showLoader())
                      : SizedBox(),
                ],
              ),
            );
          }

          return body;
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
          _cubit.searchPaket();
        },
      ),
    );
  }

  Widget _buildPaketList() {
    return _cubit.paketList.isEmpty
        ? Expanded(child: tidakAdaData())
        : Expanded(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: _cubit.paketList.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    child: Card(
                      child: ListTile(
                        title: Text(_cubit.paketList[i].kodePaket,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            )),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => _cubit.paketList[i].pakaiRange == "Y" 
                            ? PaketDetailRangePage(kodePaket: _cubit.paketList[i].kodePaket)
                            : PaketDetailPage(kodePaket: _cubit.paketList[i].kodePaket)));
                        // dd(result);
                    },
                  );
                },
              ),
            ),
          );

    //                             if (result != null) {
    //                               Scaffold.of(context)
    //                                 ..removeCurrentSnackBar()
    //                                 ..showSnackBar(
    //                                   SnackBar(
    //                                     content: Text("$result"),
    //                                     duration: Duration(seconds: 2),
    //                                   ),
    //                                 );
    //                             }
    //                           } else {
    //                             final result = await Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                 builder: (context) => PaketDetailPage(
    //                                     hasil: snapshot.data[index]),
    //                               ),
    //                             );

    //                             if (result != null) {
    //                               Scaffold.of(context)
    //                                 ..removeCurrentSnackBar()
    //                                 ..showSnackBar(
    //                                   SnackBar(
    //                                     content: Text("$result"),
    //                                     duration: Duration(seconds: 2),
    //                                   ),
    //                                 );
    //                             }
    //                           }
    //                         },
    //                       ));
    //                     }),
    //               )
    //             : tidakAdaData();
    //       } else if (snapshot.hasError) {
    //         return Text("${snapshot.error}");
    //       }
    //       return Center(
    //         child: ColorLoader3(
    //           radius: 15.0,
    //           dotRadius: 6.0,
    //         ),
    //       );
    //     },
    //   ),
    // ])
    //       ),
    // );
  }
}
