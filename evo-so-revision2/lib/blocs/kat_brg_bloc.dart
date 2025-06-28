part of 'blocs.dart';

class KatBrgCubit extends Cubit<BlocState> implements IBloc {
  KatBrgCubit() : super(BlocState.init);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  List<KatBrg> katBrgList = [];

  @override
  void changeState(BlocState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  void dispose() {}

  @override
  Future<void> init() async {
    changeState(BlocState.loading);

    await Future.delayed(Duration(milliseconds: initDelay));

    final response = await fetchPost2(
      'fetch',
      {'type': 'kategoriBarang'},
      // debug: true,
    );

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    if (!response.success) {
      fMsg = getInternalServerMsg();
      return changeState(BlocState.idle);
    }

    try {
      katBrgList = [];
      katBrgList = KatBrg.fromJsonList(response.value);
    } catch (_) {
      if (debug) dd(_);
    }

    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fMsg = '';
  }
}
