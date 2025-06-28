enum CState {
  animating,
  changing,
  deleting,
  error,
  expiredToken,
  idle,
  init,
  loading,
  navigating,
  processing,
  saving,
  searching,
  updating,
}

abstract class JCubit {
  void changeState(CState newState);
  Future<void> init();
}
