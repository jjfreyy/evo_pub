part of 'blocs.dart';

class PaketCubit extends Cubit<BlocState> implements IBloc {
  PaketCubit() : super(BlocState.init);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  late List<Paket> paketList;
  late TextEditingController tecSearch;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void changeState(BlocState newState) {
    if (isClosed) return dispose();
    emit(newState);
  }

  @override
  void dispose() {
    tecSearch.dispose();
  }

  @override
  Future<void> init() async {
    changeState(BlocState.loading);

    await Future.delayed(Duration(milliseconds: initDelay));
    paketList = [];
    tecSearch = TextEditingController();

    final result = await _fetchPaket();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fMsg = '';
  }

  Future<bool> _fetchPaket() async {
    final response = await fetchPost2(
        'fetch', {'type': 'paket', 'kodePaket': tecSearch.text});

    if (response.isTokenExpired) {
      changeState(BlocState.expiredToken);
      return false;
    }

    if (!response.success) return false;

    try {
      paketList = [];
      paketList = Paket.fromJsonList(response.value);
    } catch (_) {
      if (debug) dd(_);
    }

    return true;
  }

  Future<void> searchPaket() async {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    await Future.delayed(Duration(milliseconds: fetchDelay));
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - timestamp < fetchDelay) return;

    changeState(BlocState.searching);
    final result = await _fetchPaket();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    changeState(BlocState.idle);
  }
}
