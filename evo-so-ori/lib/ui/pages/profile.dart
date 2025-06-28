part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 70, bottom: 10),
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: Text(
                          userID.substring(0, 1),
                          style: TextStyle(
                            fontSize: 45,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 2 * 5,
                  child: Text(
                    userID,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 2 * 5,
                  child: Text(
                    lokasi,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: roleGantiLokasi == "Y" ? true : false,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GantiLokasiPage(),
                          ),
                        );

                        setState(() {});

                        if (result != null) {
                          Scaffold.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text("$result"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                        }

/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GantiLokasiPage(),
                          ),
                        );
                        */
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(
                              Icons.location_city,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Ganti Lokasi",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () {
                      /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GantiPasswordPage(),
                        ),
                      );
                      */
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(Icons.vpn_key, color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Ganti Password (Under Maintenance)",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage2()),
                          (Route<dynamic> route) => false);
                    },
                    child: Center(
                        child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
