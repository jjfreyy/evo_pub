part of 'blocs.dart';

class CustomersCubit extends Cubit<BlocState> implements IBloc {
  CustomersCubit() : super(BlocState.init);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  late List<Customer> customers;
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
    customers = [];
    tecSearch = TextEditingController();
    final result = await _fetchCustomers();
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

  Future<bool> _fetchCustomers() async {
    final response = await fetchPost2('fetch', {
      'type': 'customers',
      'kodeCustomer': tecSearch.text,
    });

    if (response.isTokenExpired) {
      changeState(BlocState.expiredToken);
      return false;
    }

    if (!response.success) return false;

    customers = [];

    try {
      customers = Customer.fromJsonList(response.value);
    } catch (_) {
      if (debug) dd(_);
    }

    return true;
  }

  Future<void> searchCustomers() async {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    await Future.delayed(Duration(milliseconds: fetchDelay));
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - timestamp < fetchDelay) return;

    changeState(BlocState.searching);

    final result = await _fetchCustomers();
    if (!result) {
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    changeState(BlocState.idle);
  }
}
