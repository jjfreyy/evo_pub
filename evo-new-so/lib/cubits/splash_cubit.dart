part of 'cubits.dart';

class SplashCubit extends Cubit<CState> implements JCubit {
  SplashCubit() : super(CState.init);

  late String appVersion;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    appVersion = await getAppVersion();
    changeState(CState.idle);
  }

  void checkSession() async {
    changeState(CState.processing);
    await Future.delayed(Duration(milliseconds: splashScreenDelay));

    final prefs = await getSharedPreferences();
    final token = prefs.getString('token');
    if (!(isEmpty(token) || Jwt.isExpired(token!))) {
      user = User.fromJson(Jwt.parseJwt(token));
      isAuthorized = true;
    } 

    changeState(CState.navigating);
  }
}
