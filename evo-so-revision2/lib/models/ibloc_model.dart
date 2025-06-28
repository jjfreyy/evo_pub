enum BlocState {
  animating,
  changing,
  deleting,
  error,
  expiredToken,
  idle,
  init,
  loading,
  saving,
  searching,
  updating,
}

abstract class IBloc {
  bool fSuccess = true;
  String fTitle = '';
  String fMsg = '';

  void changeState(BlocState newState);
  void dispose();
  Future<void> init();
  void resetFlushbar();
}
