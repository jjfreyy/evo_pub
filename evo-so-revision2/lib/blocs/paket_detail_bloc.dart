part of 'blocs.dart';

class PaketDetailCubit extends Cubit<BlocState> implements IBloc {
  PaketDetailCubit(this.kodePaket) : super(BlocState.init);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  final String kodePaket;

  late TextEditingController tecJmlPaket;
  late List<PaketDetail> paketDetailList;
  late List<TextEditingController> tecQtys;

  @override
  void changeState(BlocState newState) {
    if (isClosed) return dispose();
    emit(newState);
  }

  @override
  void dispose() {
    tecJmlPaket.dispose();
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
      fMsg = getInternalServerMsg();
      return changeState(BlocState.idle);
    }

    paketDetailList = [];
    tecJmlPaket = TextEditingController();
    tecQtys = [];

    try {
      paketDetailList = PaketDetail.fromJsonList(response.value);
      for (var _ in paketDetailList) {
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

  void changeJumlahPaket() {
    changeState(BlocState.changing);
    changeState(BlocState.idle);
  }

  int get getJumlahPaket {
    return int.tryParse(tecJmlPaket.text) ?? 1;
  }

  Future<void> saveCart() async {
    changeState(BlocState.saving);

    List paketan = [];
    for (int i = 0; i < paketDetailList.length; i++) {
      if (tecQtys[i].text.isEmpty) continue;

      if (int.parse(tecQtys[i].text) >
          paketDetailList[i].jml * getJumlahPaket) {
        fSuccess = false;
        fMsg = 'Jumlah ${paketDetailList[i].nama} melebihi Max Qty!';
        return changeState(BlocState.idle);
      }

      paketan.add({
        'kodeBarang': paketDetailList[i].kodeBarang,
        'jumlah': tecQtys[i].text,
        'kodePaket': paketDetailList[i].kodePaket,
        'disc': paketDetailList[i].discPersen,
        'pkt2': paketDetailList[i].pkt2,
        'bonus': paketDetailList[i].bonus,
      });
    }

    if (paketan.isEmpty) {
      fSuccess = false;
      fMsg = 'Silakan isi data paketan yang ingin ditambah minimal 1.';
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
