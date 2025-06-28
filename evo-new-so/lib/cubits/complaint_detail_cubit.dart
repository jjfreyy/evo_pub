part of 'cubits.dart';

class ComplaintDetailCubit extends Cubit<CState> implements JCubit {
  ComplaintDetailCubit(this.complaint) : super(CState.init);

  final Complaint complaint;
  late final List<int> stList;
  late TextEditingController tecHasil;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    stList = [1, 2, 3, 4];
    tecHasil = TextEditingController();

    changeState(CState.idle);
  }

  void tandaiSelesai(BuildContext context) async {
    changeState(CState.updating);

    const radius = 7.5;
    final result = await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: const BorderSide(color: Colors.white, width: 1.5),
              ),
              child: buildDialog(
                context: context,
                title: '',
                widget: Column(
                  children: [
                    TextFormField(
                      controller: tecHasil,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.amber.shade400)),
                        labelText: 'Hasil',
                        contentPadding: const EdgeInsets.all(0),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        errorText: null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildConfirmButton(
                            Icons.close,
                            () => Navigator.pop(context),
                            Colors.red,
                          ),
                          const SizedBox(width: 5.0),
                          buildConfirmButton(
                              Icons.check,
                              () => Navigator.pop(context, tecHasil.text),
                              Colors.green.shade500),
                        ],
                      ),
                    ),
                  ],
                ),
                radius: radius,
              ),
            ),
          ),
        );
      },
    );

    if (result == null) {
      return changeState(CState.idle);
    }

    if (result.toString().isEmpty) {
      showToast('Hasil wajib diisi.');
      return changeState(CState.idle);
    }

    final response = await fetchPost2('put', {
      'type': 'updateComplaintSelesai',
      'id': complaint.id,
      'hasil': result.toString(),
    }, debugging: false);

    if (response.isTokenExpired) return changeState(CState.expiredToken);

    if (!response.success) {
      showToast(response.msg!);
      return changeState(CState.idle);
    }

    showToast(response.msg!, Colors.green);
    changeState(CState.navigating);
  }
}
