part of 'pages.dart';

class PaketDetailPage extends StatefulWidget {
  final String kodePaket;

  PaketDetailPage({Key? key, required this.kodePaket}) : super(key: key);

  @override
  _PaketDetailPageState createState() => _PaketDetailPageState();
}

class _PaketDetailPageState extends State<PaketDetailPage> {
  late PaketDetailCubit cubit = PaketDetailCubit(widget.kodePaket);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<PaketDetailCubit, String>(
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
          else if (["idle", "changeJumlahPaket", "savingToCart"]
              .contains(state)) {
            body = buildPaketDetail(state);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Paket Detail"),
              backgroundColor: appbarColor,
            ),
            body: body,
          );
        },
      ),
    );
  }

  Widget buildPaketDetail(String state) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
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
                          child: SizedBox(
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
        state == "savingToCart"
            ? Container(
                color: Colors.black.withOpacity(0.55), child: showLoader())
            : SizedBox(),
      ],
    );
  }

  Container buildJmlPaket() {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 4),
            child: Text(
              "Jml Paket : ",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 30,
            child: TextFormField(
              controller: cubit.tecJmlPaket,
              keyboardType: TextInputType.number,
              enabled: true,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                contentPadding: EdgeInsets.only(top: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
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
      physics: NeverScrollableScrollPhysics(),
      itemCount: cubit.paketDetailList.length,
      itemBuilder: (context, i) {
        return Card(
            color: cubit.paketDetailList[i].bonus == "Y"
                ? Colors.blue[50]
                : Colors.white,
            child: Container(
              padding: EdgeInsets.all(3.0),
              margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          cubit.paketDetailList[i].bonus == "Y"
                              ? "*Free\n${cubit.paketDetailList[i].nama}"
                              : cubit.paketDetailList[i].nama,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Group : ${cubit.paketDetailList[i].kategori}\n" +
                        "range : ${cubit.paketDetailList[i].pakaiRange}\n" +
                        "Max Qty : ${getNumberFormat().format(cubit.paketDetailList[i].jml * cubit.getJumlahPaket())}",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: cubit.tecQtys[i],
                          enabled: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              contentPadding: EdgeInsets.only(top: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              hintText: "Qty"),
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
      margin: EdgeInsets.all(defaultMargin),
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        ),
        onPressed: () => cubit.saveCart(),
        child: Text(
          "Tambah",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
    );
  }
}
