part of 'cubits.dart';

class ComplaintsCubit extends Cubit<CState> implements JCubit {
  ComplaintsCubit() : super(CState.init);

  late List<Complaint> complaints;
  late int currentSt;
  late DateFormat dateFormatter;
  late final List<int> stList;
  late DateTime tgl1;
  late DateTime tgl2;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    complaints = [];
    currentSt = 0;
    dateFormatter = DateFormat('dd MMM yyyy');
    stList = [0, 1, 2, 3, 4];
    tgl1 = DateTime.now();
    tgl2 = DateTime.now();

    await _fetchComplaints();

    changeState(CState.idle);
  }

  Future<void> _fetchComplaints() async {
    final response = await fetchPost2(
        'fetch',
        {
          'type': 'complaints',
          'tgl1': DateFormat('yyyy-MM-dd').format(tgl1),
          'tgl2': DateFormat('yyyy-MM-dd').format(tgl2),
          'st': currentSt,
        },
        debugging: false);

    if (response.isTokenExpired) {
      return changeState(CState.expiredToken);
    }

    if (!response.success) {
      return showToast('Terjadi kesalahan internal server!');
    }

    complaints = Complaint.fromJsonList(response.value);
  }

  void updateTgl(BuildContext context, String label) async {
    changeState(CState.changing);
    final result = await showDatePicker(
      context: context,
      initialDate: label == 'Dari' ? tgl1 : tgl2,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (result == null) {
      return changeState(CState.idle);
    }

    if (label == 'Dari') {
      tgl1 = result;
    } else if (label == 'Sampai') {
      tgl2 = result;
    }

    await _fetchComplaints();

    changeState(CState.idle);
  }

  void updateStatus(int newSt) async {
    changeState(CState.changing);

    currentSt = newSt;

    await _fetchComplaints();

    changeState(CState.idle);
  }

  void updateComplaintStatus(int i, int newSt) async {
    changeState(CState.updating);

    final response = await fetchPost2(
      'put',
      {
        'type': 'updateComplaintStatus',
        'id': complaints[i].id,
        'st': newSt,
      },
      debugging: false,
    );

    if (response.isTokenExpired) return changeState(CState.expiredToken);

    if (!response.success) {
      showToast(response.msg!);
      return changeState(CState.idle);
    }

    complaints[i] = complaints[i].copyWith(st: newSt);
    showToast(response.msg!, Colors.green);
    changeState(CState.idle);
  }
}
