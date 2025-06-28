part of 'blocs.dart';

class CheckoutCubit extends Cubit<BlocState> implements IBloc {
  CheckoutCubit() : super(BlocState.init);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  final jnsTrx = ['Tunai', 'Kredit'];
  Customer? customer;
  late List<Cart> cartList;
  late String currentTrx;
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

    final response = await fetchPost2('fetch', {
      'type': 'cart',
    });

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    if (!response.success) {
      fSuccess = false;
      fMsg = response.msg!;
    }

    cartList = [];
    currentTrx = jnsTrx[0];

    try {
      cartList = Cart.fromJsonList(response.value);
      _calculateSubtotal();
    } catch (_) {
      if (debug) dd(_);
    }

    changeState(BlocState.animating);
    await Future.delayed(Duration(milliseconds: animationDuration));
    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fMsg = '';
  }

  void _calculateSubtotal() {
    subTotal = 0;
    for (final item in cartList) {
      subTotal += hitungSubtotalPerBarang(
          item.disc * 1.0, 0, item.qty * 1.0, item.harga);
    }
  }

  void changeTrx(String val) {
    changeState(BlocState.changing);
    currentTrx = val;
    changeState(BlocState.idle);
  }

  void deleteCartItem(Cart cart) async {
    changeState(BlocState.deleting);

    final response = await fetchPost2('delete', {
      'type': 'deleteCartItem',
      'kodeBarang': cart.kodeBarang,
      'kodePaket': cart.kodePaket,
    });

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    fMsg = response.msg!;
    if (!response.success) {
      fSuccess = false;
      return changeState(BlocState.idle);
    }

    fSuccess = true;
    if (cart.kodePaket.isEmpty) {
      cartList.remove(cart);
    } else {
      cartList.removeWhere((cart1) => cart1.kodePaket == cart.kodePaket);
    }

    _calculateSubtotal();
    changeState(BlocState.animating);
    await Future.delayed(Duration(milliseconds: animationDuration));
    changeState(BlocState.idle);
  }

  void savePermintaanKeluar() async {
    changeState(BlocState.saving);

    if (customer == null) {
      fSuccess = false;
      fMsg = 'Customer harus diisi!';
      return changeState(BlocState.idle);
    }

    List<Map<String, dynamic>> jsonCartList = [];
    int totalJml = 0;
    for (var cart in cartList) {
      jsonCartList.add({
        'kodeBarang': cart.kodeBarang,
        'qty': cart.qty,
        'kodePaket': cart.kodePaket,
        'disc': cart.disc,
        'kodePaket2': cart.kodePaket2,
      });
      totalJml += cart.qty;
    }

    final response = await fetchPost2(
      'put',
      {
        'type': 'savePermintaanKeluar',
        'kodeCustomer': customer!.kode,
        'totalJml': totalJml,
        'jenisTrans': currentTrx == jnsTrx[0] ? 'T' : 'N',
        'detailPermintaanKeluar': jsonEncode(jsonCartList),
      },
    );

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    fMsg = response.msg!;
    if (!response.success) {
      fSuccess = false;
      return changeState(BlocState.idle);
    }

    fSuccess = true;
    cartList.clear();
    changeState(BlocState.idle);
  }

  void updateCustomer(Customer customer) {
    changeState(BlocState.updating);
    this.customer = customer;
    currentTrx = customer.jenisTrans == 'T' ? jnsTrx[0] : jnsTrx[1];
    changeState(BlocState.idle);
  }

  void updateQty(int cartIndex, int? qty) async {
    changeState(BlocState.updating);

    if (isEmpty(qty, false) || qty! <= 0) {
      fSuccess = false;
      fMsg = 'Qty harus berupa angka/lebih dari 0!';
      return changeState(BlocState.idle);
    }

    final response = await fetchPost2('put', {
      'type': 'updateCartQty',
      'kodeBarang': cartList[cartIndex].kodeBarang,
      'qty': qty,
    });

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    fMsg = response.msg!;
    if (!response.success) {
      fSuccess = false;
      return changeState(BlocState.idle);
    }

    fSuccess = true;
    cartList[cartIndex] = cartList[cartIndex].copyWith(qty: qty);
    _calculateSubtotal();
    return changeState(BlocState.idle);
  }
}
