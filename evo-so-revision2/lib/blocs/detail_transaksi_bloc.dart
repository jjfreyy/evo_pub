part of 'blocs.dart';

class DetailTransaksiCubit extends Cubit<BlocState> implements IBloc {
  DetailTransaksiCubit(this.data) : super(BlocState.init);

  final DisplayPendingAccKacab data;

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  late List<DetailTransaksi> detailTransaksiList;
  late double subTotal;

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
      {
        'type': 'detailPermintaanKeluar',
        'noFaktur': data.noFaktur,
      },
    );

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    if (!response.success) {
      fSuccess = false;
      fMsg = response.msg!;
    }

    detailTransaksiList = [];

    try {
      detailTransaksiList = DetailTransaksi.fromJsonList(response.value);
      _calculateSubtotal();
    } catch (_) {
      if (debug) dd(_);
    }

    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fMsg = '';
  }

  void _calculateSubtotal() {
    subTotal = 0;
    for (final transaksi in detailTransaksiList) {
      subTotal += hitungSubtotalPerBarang(transaksi.discPersen * 1.0, 0,
          transaksi.jumlah, transaksi.harga * 1.0);
    }
  }

  void updatePermintaanKeluar(String jenis) async {
    changeState(BlocState.updating);

    final response = await fetchPost2(
      'put',
      {
        'type': 'updatePermintaanKeluar',
        'noFaktur': data.noFaktur,
        'jenis': jenis,
      },
      debug: true,
    );

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    fMsg = response.msg!;
    if (!response.success) {
      fSuccess = false;
      return changeState(BlocState.idle);
    }

    fSuccess = true;
    changeState(BlocState.idle);
  }
}
