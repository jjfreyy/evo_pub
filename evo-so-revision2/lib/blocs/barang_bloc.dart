part of 'blocs.dart';

class BarangCubit extends Cubit<BlocState> implements IBloc {
  BarangCubit(this.kodeKategoriApps) : super(BlocState.init);

  final String kodeKategoriApps;

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  late List<Barang> barangList;
  late TextEditingController tecSearch;
  late List<TextEditingController> tecQtys;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void changeState(BlocState newState) {
    if (isClosed) return dispose();
    emit(newState);
  }

  @override
  void dispose() {
    tecSearch.dispose();
    for (var tec in tecQtys) {
      tec.dispose();
    }
  }

  @override
  Future<void> init() async {
    changeState(BlocState.loading);

    await Future.delayed(Duration(milliseconds: initDelay));
    barangList = [];
    tecSearch = TextEditingController();
    tecQtys = [];
    final result = await _fetchBarang();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fTitle = '';
    fMsg = '';
  }

  Future<bool> _fetchBarang() async {
    final response = await fetchPost2('fetch', {
      'type': 'barang',
      'kodeKategoriApps': kodeKategoriApps,
      'nama': tecSearch.text,
    });

    if (response.isTokenExpired) {
      changeState(BlocState.expiredToken);
      return false;
    }

    if (!response.success) return false;

    try {
      barangList = [];
      barangList = Barang.fromJsonList(response.value);
      tecQtys.clear();
      for (var _ in barangList) {
        tecQtys.add(TextEditingController());
      }
    } catch (_) {
      if (debug) dd(_);
    }

    return true;
  }

  Future<void> searchBarang() async {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    await Future.delayed(Duration(milliseconds: fetchDelay));
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - timestamp < fetchDelay) return;

    changeState(BlocState.searching);

    final result = await _fetchBarang();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    changeState(BlocState.idle);
  }

  Future<void> saveCart(int i) async {
    changeState(BlocState.saving);

    if (tecQtys[i].text.isEmpty) {
      fSuccess = false;
      fTitle = barangList[i].nama;
      fMsg = 'Qty harus diisi!';
      return changeState(BlocState.idle);
    }

    final response = await fetchPost2('put', {
      'type': 'saveKategori',
      'kodeBarang': barangList[i].kode,
      'qty': tecQtys[i].text,
    });

    if (!response.success) {
      fSuccess = false;
      fMsg = response.msg!;
      return changeState(BlocState.idle);
    }

    fSuccess = true;
    fMsg = 'Berhasil menyimpan ${barangList[i].nama} ke daftar keranjang!';
    tecQtys[i].text = '';

    changeState(BlocState.idle);
  }
}
