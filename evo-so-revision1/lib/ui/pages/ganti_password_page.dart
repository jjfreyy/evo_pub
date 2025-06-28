part of 'pages.dart';

class GantiPasswordPage extends StatefulWidget {
  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  GantiPasswordCubit _cubit = GantiPasswordCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<GantiPasswordCubit, String>(
        listener: (context, state) {
          if (state == "tokenExpired") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          } else if (_cubit.fMsg.isNotEmpty) {
            showFlushbar(msg: _cubit.fMsg, context: context, backgroundColor: _cubit.fSuccess ? Colors.green : Colors.red);
            _cubit.resetFlushbar();
          }
        },
        builder: (context, state) {
          Widget body = showLoader();

          if (state == "init") _cubit.init();
          else if (state == "error") body = ErrorPage500();
          else if (["idle", "showLoader", "togglePassword"].contains(state)) {
            body = Stack(
              children: [
                Center(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                    // height: MediaQuery.of(context).size.height * .3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTextFormField("Password Lama", _cubit.tecPasswordLama, 0),
                          SizedBox(
                            height: 8,
                          ),
                          _buildTextFormField("Password Baru", _cubit.tecPasswordBaru, 1),
                          SizedBox(
                            height: 8,
                          ),
                          _buildTextFormField("Konfirmasi Password", _cubit.tecKonfirmasiPassword, 2),
                          _buildButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                state != "showLoader" ? SizedBox() : Container(
                  color: Colors.black.withOpacity(0.55),
                  child: showLoader(),
                )
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Ganti Password"),
              backgroundColor: appbarColor,
            ),
            body: body,
          );
        },
      ),
    );
  }

  Widget _buildTextFormField(String hintText, TextEditingController tec, int i) {
    return TextFormField(
      style: GoogleFonts.openSans().copyWith(fontSize: 12.0),
      controller: tec,
      obscureText: _cubit.obscuredPassword[i],
      decoration: InputDecoration(
        errorText: _cubit.errorMsgs[i],
        filled: true,
        suffixIcon: GestureDetector(child: Icon(_cubit.obscuredPassword[i] ? Icons.visibility : Icons.visibility_off), onTap: () {
          _cubit.togglePasswordVisibility(i);
        }),
        contentPadding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hintText),
    );
  }

  Container _buildButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 40,
      margin: EdgeInsets.only(top: 20, bottom: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0)),
        ),
        child: Text(
          "Ganti",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        onPressed: () => _cubit.gantiPassword(),
      ),
    );
  }
}
