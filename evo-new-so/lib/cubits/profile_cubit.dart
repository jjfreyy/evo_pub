part of 'cubits.dart';

class ProfileCubit extends Cubit<CState> implements JCubit {
  ProfileCubit() : super(CState.init);

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    changeState(CState.idle);
  }

  void signout() async {
    changeState(CState.processing);

    final prefs = await getSharedPreferences();
    prefs.clear();

    changeState(CState.expiredToken);
  }
}
