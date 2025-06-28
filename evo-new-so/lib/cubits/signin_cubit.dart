part of 'cubits.dart';

class SigninCubit extends Cubit<CState> implements JCubit {
  SigninCubit() : super(CState.init);

  final Color color1 = const Color(0xFFB226B2);
  final Color color2 = const Color(0xFFFF4891);
  final Color color3 = Colors.amber.shade400;
  final Color color4 = const Color.fromRGBO(255, 82, 82, 0.131);
  bool isAuthorized = false;
  late bool obscureText;
  late TextEditingController tecUsername;
  late TextEditingController tecPassword;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    obscureText = true;
    tecUsername = TextEditingController();
    tecPassword = TextEditingController();

    changeState(CState.idle);
  }

  double getSmallDiameter(BuildContext context) {
    return getScreenSize(context).width * 2 / 3;
  }

  double getBigDiameter(BuildContext context) {
    return getScreenSize(context).width * 7 / 8;
  }

  void signin() async {
    changeState(CState.processing);

    final response = await fetchPost2(
      'auth',
      {
        'type': 'signin',
        'username': tecUsername.text,
        'pass': tecPassword.text,
      },
      withToken: false,
      debugging: false,
    );

    if (!response.success) {
      showToast(response.msg!);
      return changeState(CState.idle);
    }

    final token = response.value['token'];
    final prefs = await getSharedPreferences();
    prefs.setString('token', token);
    user = User.fromJson(Jwt.parseJwt(token));

    isAuthorized = true;
    changeState(CState.idle);
  }

  void toggleObscureText() {
    changeState(CState.changing);
    obscureText = !obscureText;
    changeState(CState.idle);
  }
}
