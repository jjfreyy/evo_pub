part of "pages.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginCubit _cubit = LoginCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocBuilder<LoginCubit, String>(
        builder: (context, state) {
          return FlutterLogin(
            title: "PT. EVO",
            logo: const AssetImage("assets/logo.png"),
            messages: LoginMessages(
              userHint: "UserID",
            ),
            userValidator: (value) {
              if (isEmpty(value)) return "UserID harus diisi!";
              return null;
            },
            passwordValidator: (value) {
              if (isEmpty(value)) return "Password harus diisi!";
              return null;
            },
            onLogin: (LoginData data) {
              return _cubit.login(data.name, data.password);
            },
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainPage()));
            },
            onSignup: null,
            onRecoverPassword: (String name) {},
            hideForgotPasswordButton: true,
          );
        },
      ),
    );
  }
}
