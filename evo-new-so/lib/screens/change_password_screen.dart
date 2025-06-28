part of 'screens.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final cubit = ChangePasswordCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ChangePasswordCubit, CState>(
        listener: (context, state) {
          if (state != CState.expiredToken) return;
          navigateTo(context, const SigninScreen(), true);
        },
        builder: (context, state) {
          Widget body = buildLoader();
          
          if (state == CState.init) {
            cubit.init();
          } else if ([CState.idle, CState.updating, CState.expiredToken, CState.changing]
              .contains(state)) {
            body = buildChangePasswordScreen(state);
          }

          return Scaffold(
            appBar: buildAppBar('Ubah Password'),
            body: body,
          );
        },
      ),
    );
  }

  Widget buildChangePasswordScreen(CState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView(
            children: [
              buildTextField(cubit.tecPass, 'Password', cubit.errPass, cubit.obscurePass),
              const SizedBox(
                height: 5.0,
              ),
              buildTextField(
                  cubit.tecNewPass, 'Password Baru', cubit.errNewPass, cubit.obscureNewPass),
              const SizedBox(
                height: 5.0,
              ),
              buildTextField(cubit.tecConfirmPass, 'Konfirmasi Password', null, cubit.obscureConfirmPass),
              const SizedBox(
                height: 5.0,
              ),
              buildUbahButton(),
            ],
          ),
        ),
        [CState.updating].contains(state) ? buildLoader() : const SizedBox(),
      ],
    );
  }

  TextFormField buildTextField(
      TextEditingController tec, String labelText, String? errorText, bool obscureText) {
    return TextFormField(
      controller: tec,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber.shade400)),
        labelText: labelText,
        contentPadding: const EdgeInsets.all(0),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        errorText: errorText,
        suffixIcon: IconButton(
            icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[700],
                size: 20),
            onPressed: () {
              cubit.toggleObscureText(labelText);
            }),
      ),
    );
  }

  Widget buildUbahButton() {
    return ElevatedButton(
      child: const Text(
        'Ubah',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => cubit.changePassword(),
    );
  }
}
