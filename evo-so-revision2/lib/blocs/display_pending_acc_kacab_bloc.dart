part of 'blocs.dart';

class DisplayPendingAccKacabCubit extends Cubit<BlocState> implements IBloc {
  DisplayPendingAccKacabCubit(this.hsl) : super(BlocState.init);

  final int hsl;

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  final dateformatter = DateFormat('dd MMM yyyy');
  late List<DisplayPendingAccKacab> displayPendingAccKacabList;

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

    displayPendingAccKacabList = [];
    final result = await _fetchPermintaanKeluar();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    changeState(BlocState.animating);
    await Future.delayed(Duration(milliseconds: animationDuration));
    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fMsg = '';
  }

  Future<bool> _fetchPermintaanKeluar() async {
    final response = await fetchPost2(
      'fetch',
      {
        'type': 'permintaanKeluar',
        'hsl': hsl,
      },
    );

    if (response.isTokenExpired) {
      changeState(BlocState.expiredToken);
      return false;
    }

    if (!response.success) return false;

    try {
      displayPendingAccKacabList =
          DisplayPendingAccKacab.fromJsonList(response.value);
      return true;
    } catch (_) {
      if (debug) dd(_);
      return false;
    }
  }

  void refresh() async {
    changeState(BlocState.animating);
    await Future.delayed(Duration(milliseconds: animationDuration));

    final result = await _fetchPermintaanKeluar();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }
    changeState(BlocState.idle);
  }
}
