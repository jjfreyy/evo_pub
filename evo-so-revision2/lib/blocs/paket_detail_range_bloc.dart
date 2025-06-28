part of 'blocs.dart';

class PaketDetailRangeCubit extends Cubit<BlocState> implements IBloc {
  PaketDetailRangeCubit(this.kodePaket) : super(BlocState.init);

  final String kodePaket;

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  late List<PaketDetail> paketDetailRangeList;
  late List<TextEditingController> tecQtys;

  @override
  void changeState(BlocState newState) {
    if (isClosed) return dispose();
    emit(newState);
  }

  @override
  void dispose() {
    for (var tec in tecQtys) {
      tec.dispose();
    }
  }

  @override
  Future<void> init() async {
    changeState(BlocState.loading);

    await Future.delayed(Duration(milliseconds: initDelay));

    final response = await fetchPost2('fetch', {
      'type': 'detailPaket',
      'kodePaket': kodePaket,
    });

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    if (!response.success) {
      fSuccess = false;
      fMsg = response.msg!;
      return changeState(BlocState.idle);
    }

    paketDetailRangeList = [];
    tecQtys = [];

    try {
      paketDetailRangeList = PaketDetail.fromJsonList(response.value);
      for (var _ in paketDetailRangeList) {
        tecQtys.add(TextEditingController());
      }
    } catch (_) {
      if (debug) dd(_);
    }

    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fTitle = '';
    fMsg = '';
  }

  Future<void> saveCart() async {
    changeState(BlocState.saving);

    List paketan = [];
    final dari = paketDetailRangeList[0].dari;
    final sampai = paketDetailRangeList[0].sampai;
    int total = 0;
    for (int i = 0; i < paketDetailRangeList.length; i++) {
      if (tecQtys[i].text.isEmpty) continue;

      final qty = int.parse(tecQtys[i].text);
      total += qty;

      paketan.add({
        'kodeBarang': paketDetailRangeList[i].kodeBarang,
        'jumlah': qty,
        'kodePaket': paketDetailRangeList[i].kodePaket,
        'disc': paketDetailRangeList[i].discPersen,
        'pkt2': paketDetailRangeList[i].pkt2,
        'bonus': paketDetailRangeList[i].bonus,
      });
    }

    if (paketan.isEmpty) {
      fSuccess = false;
      fMsg = 'Silakan isi data paketan yang ingin ditambah minimal 1.';
      return changeState(BlocState.idle);
    }

    if (total < dari || total > sampai) {
      fSuccess = false;
      fMsg =
          'Total paketan harus diantara ${getNumberFormat().format(dari)} dan ${getNumberFormat().format(sampai)}!';
      return changeState(BlocState.idle);
    }

    final response = await fetchPost2('put', {
      'type': 'savePaket',
      'paketan': jsonEncode(paketan),
    });

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    if (!response.success) {
      fSuccess = false;
      fMsg = response.msg!;
      return changeState(BlocState.idle);
    }

    fSuccess = true;
    fMsg = 'Berhasil menambah ${paketan.length} paket ke daftar keranjang!';
    for (var tec in tecQtys) {
      tec.clear();
    }

    changeState(BlocState.idle);
  }
}
