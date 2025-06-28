part of 'pages.dart';

class GantiPasswordPage extends StatefulWidget {
  const GantiPasswordPage({Key? key}) : super(key: key);

  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  final GantiPasswordCubit cubit = GantiPasswordCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<GantiPasswordCubit, BlocState>(
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
          } else if (state == BlocState.error) {
            body = const ErrorPage500();
          } else if ([BlocState.idle, BlocState.changing, BlocState.updating]
              .contains(state)) {
            body = Stack(
              children: [
                Center(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTextFormField(
                              'Password Lama', cubit.tecPasswordLama, 0),
                          const SizedBox(
                            height: 8,
                          ),
                          _buildTextFormField(
                              'Password Baru', cubit.tecPasswordBaru, 1),
                          const SizedBox(
                            height: 8,
                          ),
                          _buildTextFormField('Konfirmasi Password',
                              cubit.tecKonfirmasiPassword, 2),
                          _buildButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                state != BlocState.updating
                    ? const SizedBox()
                    : showLoader(true)
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Ganti Password'),
              backgroundColor: appbarColor,
            ),
            body: body,
          );
        },
      ),
    );
  }

  Widget _buildTextFormField(
      String hintText, TextEditingController tec, int i) {
    return TextFormField(
      style: GoogleFonts.openSans().copyWith(fontSize: 12.0),
      controller: tec,
      obscureText: cubit.obscuredPassword[i],
      decoration: InputDecoration(
          errorText: cubit.errorMsgs[i],
          filled: true,
          suffixIcon: GestureDetector(
              child: Icon(cubit.obscuredPassword[i]
                  ? Icons.visibility
                  : Icons.visibility_off),
              onTap: () {
                cubit.togglePasswordVisibility(i);
              }),
          contentPadding:
              const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
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
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        child: const Text(
          'Ganti',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        onPressed: () => cubit.gantiPassword(),
      ),
    );
  }
}
