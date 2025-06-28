part of 'pages.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hasil;
  String ketHasil;

  Future _cekLogin() async {
    hasil = false;
    ketHasil = "";

    var firestore = Firestore.instance;
    await firestore
        .collection("users")
        .where("userid", isEqualTo: emailController.text.trim().toUpperCase())
        .where("pass", isEqualTo: passwordController.text)
        .getDocuments()
        .then(
          (docSnapshot) => {
            if (docSnapshot.documents.length > 0)
              {
                if (docSnapshot.documents[0].data["vrs"] == versi)
                  {
                    hasil = true,
                    roleACC = docSnapshot.documents[0].data["acc_kacab"],
                    roleSpcReq = docSnapshot.documents[0].data["acc_kacab"],
                    roleNaikPlafon = docSnapshot.documents[0].data["acc_kacab"],
                    roleTambahLamaJT =
                        docSnapshot.documents[0].data["acc_kacab"],
                    roleACCStock = docSnapshot.documents[0].data["acc_kacab"],
                    roleGantiLokasi =
                        docSnapshot.documents[0].data["ganti_lokasi"],
                    roleRefresh =
                        docSnapshot.documents[0].data["refresh_transaksi"],
                    roleRefreshKhusus =
                        docSnapshot.documents[0].data["refresh_khusus"],
                    roleBatal = docSnapshot.documents[0].data["batal"],
                    roleBatalSdgProses =
                        docSnapshot.documents[0].data["batal_sdg_proses"],
                    lokasi = docSnapshot.documents[0].data["lokasi"],
                    userID = docSnapshot.documents[0].data["userid"],
                  }
                else
                  {
                    hasil = false,
                    ketHasil = "Ada versi terbaru! Apps harus diupdate!",
                  }
              }
            else
              {
                hasil = false,
                ketHasil = "User/Password tidak ditemukan!",
              }
          },
        );

    return _cekLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                SizedBox(
                  height: 80,
                  child: Image.asset("assets/logo.png"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(
                    "Login",
                    style: blackTextFont.copyWith(fontSize: 20),
                  ),
                ),
                Container(
                  height: 40,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10, top: 10.0, right: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: "UserID",
                        hintText: "UserID"),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 45,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10, top: 10.0, right: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: "Password",
                        hintText: "Password"),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),

                /*Row(
                    children: <Widget>[
                      Text(
                        "Forgot Password? ",
                        style: greyTextFont.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Get Now",
                        style: purpleTextFont.copyWith(fontSize: 12),
                      )
                    ],
                  ),*/

                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: 30, bottom: 19),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      "Login",
                      style: whiteTextFont.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.red, //Color(0xFF107570), ,//107570
                    onPressed: () async {
                      try {
                        if (emailController.text == "" ||
                            emailController.text.length == 0) {
                          Flushbar(
                              duration: Duration(seconds: 2),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              message: "UserID belum diisi!")
                            ..show(context);
                          return false;
                        } else if (passwordController.text == "" ||
                            passwordController.text.trim().length == 0) {
                          Flushbar(
                              duration: Duration(seconds: 2),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              message: "Password belum diisi!")
                            ..show(context);
                          return false;
                        } else {
                          await _cekLogin();
                          if (hasil == true) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainPage2()));
                          } else {
                            Flushbar(
                                duration: Duration(seconds: 2),
                                flushbarPosition: FlushbarPosition.BOTTOM,
                                message: ketHasil)
                              ..show(context);
                            return false;
                          }
                        }
                      } catch (_) {
                        print("Err");
                        throw Exception("Err.");
                      }
                      /* 
                          /*
                          xxx(
                              emailController.text.toString(),
                              emailController.text.toString(),
                              passwordController.text.toString(),
                              context);
                              */

                        }*/
                    },
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Center(
                  child: Text(
                    "Ver. " + versi,
                  ),
                ),
                /*Row(
                    children: <Widget>[
                      Text(
                        "Start Fresh Now? ",
                        style:
                            greyTextFont.copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Sign Up",
                        style: purpleTextFont,
                      )
                    ],
                  )*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
